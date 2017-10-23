//
//  OnClickViewController.swift
//  inh
//
//  Created by Priom on 9/16/17.
//  Copyright © 2017 BizTech. All rights reserved.
//
import WebKit
import UIKit
import AlamofireImage
import Alamofire
import SVProgressHUD
import SwiftyJSON

class OnClickViewController: UIViewController , WKNavigationDelegate {
    
    @IBOutlet weak var scrollview: UIScrollView!
    @IBOutlet weak var shareButton: UIButton!
    @IBOutlet var parentview: UIView!
    @IBOutlet weak var webView: WKWebView!
    @IBOutlet weak var titaleImage: UIImageView!

    var mobile_news_url = ""
    var type = ""
    var petitions = [[String: String]]()
    
    var utilityViewController = UtilityViewController()
    var alertDialogViewController = AlertDialogViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        webView.scrollView.isScrollEnabled = false
        webView.scrollView.bounces = false
        if(!mobile_news_url.isEmpty){
            if(type == "1"){
                let id = mobile_news_url.components(separatedBy: "=").last
                print(id)
                GEtServerDate(id: id!)
            }else if (type == "2"){
                let id = String(self.mobile_news_url.characters.suffix(4))//.components(separatedBy: "/").last
                print(id)
                self.GEtServerDate(id: id)
            }else{
                SVProgressHUD.show()
                self.webView.load(URLRequest(url: URL(string: mobile_news_url)!))
                self.webView.navigationDelegate = self
                self.webView.allowsBackForwardNavigationGestures = true
            }
        }
        

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func webView(_ webView: WKWebView, didReceiveServerRedirectForProvisionalNavigation navigation: WKNavigation!) {
        print(webView.url?.absoluteString)
        if(!(webView.url?.absoluteString.isEmpty)!){
            let navigationViewController = self.storyboard?.instantiateViewController(withIdentifier: "OnClickViewController") as! OnClickViewController
            navigationViewController.type = "2"
            navigationViewController.mobile_news_url = (webView.url?.absoluteString)!
            self.navigationController?.pushViewController(navigationViewController, animated: true)
        }
        
        

    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        SVProgressHUD.dismiss()
        let javascriptString = "" +
            "var body = document.body;" +
            "var html = document.documentElement;" +
            "Math.max(" +
            "   body.scrollHeight," +
            "   body.offsetHeight," +
            "   html.clientHeight," +
            "   html.offsetHeight" +
        ");"
        
        var frame: CGRect = webView.frame

        webView.evaluateJavaScript(javascriptString) { (result, error) in
            if error == nil {
                if let result = result, let height = JSON(result).int {
                    print(CGFloat(height))
                    frame.size.height = CGFloat(height)
                    webView.frame = frame
                    
                    print(self.webView.frame.size.height)
                    
                    self.scrollview.contentSize = CGSize(width: self.scrollview.frame.size.width, height: self.webView.frame.size.height+300)
                    
                }
            }
        }

    }
    
    func GEtServerDate(id:String){
        SVProgressHUD.show()
        
        Alamofire.request(RequestString.detailsPage+id, method: .get, encoding: JSONEncoding.default).responseJSON { responce in
            switch responce.result{
            case.success(let data):
//                SVProgressHUD.dismiss()
                
                let Response = JSON(data)
                print(Response)
                print(RequestString.topSection)
                
                
                for result in Response.arrayValue {
                    let share_url = result["share_url"].stringValue
                    let mobile_news_url = result["mobile_news_url"].stringValue
                    let art_id = result["art_id"].stringValue
                    
                    let art_title = result["art_title"].stringValue
                    let category_name = result["category_name"].stringValue
                    let art_has_video = result["art_has_video"].stringValue
                    let ap_image = result["ap_image"].stringValue
                    
                    let ap_thumb_image = result["ap_thumb_image"].stringValue
                    let art_created_on = result["art_created_on"].stringValue
                    let X_hours_ago = result["X_hours_ago"].stringValue
                    
                    let obj = ["share_url": share_url, "mobile_news_url": mobile_news_url, "art_id": art_id, "art_title": art_title, "category_name": category_name, "art_has_video": art_has_video, "ap_image": ap_image, "ap_thumb_image": ap_thumb_image, "art_created_on": art_created_on, "X_hours_ago": X_hours_ago]
                    self.petitions.append(obj)
                }
                
                Alamofire.request(self.petitions[0]["ap_image"]!).responseImage { response in
                    debugPrint(response)
                    debugPrint(response.result)
                    
                    if let image = response.result.value {
                        print("image downloaded: \(image)")
                        self.titaleImage.image = image
                    }
                }
                SVProgressHUD.show()
                self.webView.load(URLRequest(url: URL(string: self.petitions[0]["mobile_news_url"]!)!))
                self.webView.navigationDelegate = self
                self.webView.allowsBackForwardNavigationGestures = true
  
            case.failure(let error):
                print("failed\(error)")
            }
        }
    }
    
    @IBAction func shareButton(_ sender: Any) {
        //Set the default sharing message.
        let message = ""
        //Set the link to share.
        if let link = NSURL(string: self.petitions[0]["share_url"]!)
        {
            let objectsToShare = [message,link] as [Any]
            let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
            activityVC.excludedActivityTypes = [UIActivityType.airDrop, UIActivityType.addToReadingList]
            self.present(activityVC, animated: true, completion: nil)
        }
    }
}
