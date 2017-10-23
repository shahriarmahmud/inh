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
    
    var share_url = ""
    var ap_image = ""
    var mobile_news_url = ""
    
    var utilityViewController = UtilityViewController()
    var alertDialogViewController = AlertDialogViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        webView.scrollView.isScrollEnabled = false
        webView.scrollView.bounces = false
//        webView.scalesPageToFit = true
//        webView.delegate = self

        Alamofire.request(ap_image).responseImage { response in
            debugPrint(response)
            debugPrint(response.result)
            
            if let image = response.result.value {
                print("image downloaded: \(image)")
                self.titaleImage.image = image
            }
        }
        SVProgressHUD.show()
        webView.load(URLRequest(url: URL(string: mobile_news_url)!))
        webView.navigationDelegate = self
        webView.allowsBackForwardNavigationGestures = true
        
//        webView.allowsInlineMediaPlayback = true
//        webView.mediaPlaybackRequiresUserAction=true

//        webView.loadRequest(URLRequest(url: URL(string: mobile_news_url)!))
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        print(webView.url?.absoluteString)
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        SVProgressHUD.dismiss()

//        var frame: CGRect = webView.frame
//        let heightStrig: String? = webView.stringByEvaluatingJavaScript(from: "(document.height !== undefined) ? document.height : document.body.offsetHeight;")
//        let height = Float(heightStrig!) ?? 0.0 + 10.0
//        frame.size.height = CGFloat(height)
//        webView.frame = frame
        
        let javascriptString = "" +
            "var body = document.body;" +
            "var html = document.documentElement;" +
            "Math.max(" +
            "   body.scrollHeight," +
            "   body.offsetHeight," +
            "   html.clientHeight," +
            "   html.offsetHeight" +
        ");"
        
        webView.evaluateJavaScript(javascriptString) { (result, error) in
            if error == nil {
                if let result = result, let height = JSON(result).int {
                    print(CGFloat(height))
//                    self.htmlContentHeight = CGFloat(height)
//                    self.resetContentCell()
                }
            }
        }
        
        print(heightStrig)

        self.scrollview.contentSize = CGSize(width: self.scrollview.frame.size.width, height: self.webView.frame.size.height+300)

    }
    
//    func webViewDidStartLoad(_ webView: UIWebView) {
//
//        SVProgressHUD.show()
//    }
//
//    func webViewDidFinishLoad(_ webView: UIWebView) {
//
//        SVProgressHUD.dismiss()
//
//        var frame: CGRect = webView.frame
//        let heightStrig: String? = webView.stringByEvaluatingJavaScript(from: "(document.height !== undefined) ? document.height : document.body.offsetHeight;")
//        let height = Float(heightStrig!) ?? 0.0 + 10.0
//        frame.size.height = CGFloat(height)
//        webView.frame = frame
//
//        self.scrollview.contentSize = CGSize(width: self.scrollview.frame.size.width, height: self.webView.frame.size.height+300)
//    }
//
//    func webView(_ webView: UIWebView, didFailLoadWithError error: Error) {
////        alertDialogViewController.alertDialoge(title: "Alert", message: "Internet Problem, Please Try Again", uiViewController: self)
//    }

    @IBAction func shareButton(_ sender: Any) {
        //Set the default sharing message.
        let message = ""
        //Set the link to share.
        if let link = NSURL(string: share_url)
        {
            let objectsToShare = [message,link] as [Any]
            let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
            activityVC.excludedActivityTypes = [UIActivityType.airDrop, UIActivityType.addToReadingList]
            self.present(activityVC, animated: true, completion: nil)
        }
    }
}
