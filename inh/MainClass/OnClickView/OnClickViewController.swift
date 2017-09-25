//
//  OnClickViewController.swift
//  inh
//
//  Created by Priom on 9/16/17.
//  Copyright © 2017 BizTech. All rights reserved.
//

import UIKit
import AlamofireImage
import Alamofire
import SVProgressHUD

class OnClickViewController: UIViewController , UIWebViewDelegate {
    
    @IBOutlet weak var scrollview: UIScrollView!
    @IBOutlet weak var shareButton: UIButton!
    @IBOutlet var parentview: UIView!
    @IBOutlet weak var webView: UIWebView!
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
        webView.scalesPageToFit = true
        webView.delegate = self
        let currentThmeme = UserDefaults.standard.string(forKey: "theme") ?? ""
        if(!currentThmeme.isEmpty){
            if(currentThmeme == "light"){
                parentview.backgroundColor = UIColor(red: (255/255.0), green: (255/255.0), blue: (255/255.0), alpha: 1)
            }else{
                parentview.backgroundColor = UIColor(red: (85/255.0), green: (85/255.0), blue: (85/255.0), alpha: 1)
            }
        }else{
            self.parentview.backgroundColor = UIColor(red: (255/255.0), green: (255/255.0), blue: (255/255.0), alpha: 1)
        }
        
        shareButton.layer.cornerRadius = 30
        shareButton.clipsToBounds = true
        
        Alamofire.request(ap_image).responseImage { response in
            debugPrint(response)
            debugPrint(response.result)
            
            if let image = response.result.value {
                print("image downloaded: \(image)")
                self.titaleImage.image = image
            }
        }
        
        webView.loadRequest(URLRequest(url: URL(string: mobile_news_url)!))
        
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let currentThmeme = UserDefaults.standard.string(forKey: "theme") ?? ""
        if(!currentThmeme.isEmpty){
            if(currentThmeme == "light"){
                parentview.backgroundColor = UIColor(red: (255/255.0), green: (255/255.0), blue: (255/255.0), alpha: 1)
            }else{
                parentview.backgroundColor = UIColor(red: (85/255.0), green: (85/255.0), blue: (85/255.0), alpha: 1)
            }
        }else{
            self.parentview.backgroundColor = UIColor(red: (255/255.0), green: (255/255.0), blue: (255/255.0), alpha: 1)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func webViewDidStartLoad(_ webView: UIWebView) {
        
        SVProgressHUD.show()
    }
    
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        
        SVProgressHUD.dismiss()
        
        var frame: CGRect = webView.frame
        var heightStrig: String? = webView.stringByEvaluatingJavaScript(from: "(document.height !== undefined) ? document.height : document.body.offsetHeight;")
        var height = Float(heightStrig!) ?? 0.0 + 10.0
        frame.size.height = CGFloat(height)
        webView.frame = frame
        
        self.scrollview.contentSize = CGSize(width: self.scrollview.frame.size.width, height: self.webView.frame.size.height+300)
    }
    
    func webView(_ webView: UIWebView, didFailLoadWithError error: Error) {
        alertDialogViewController.alertDialoge(title: "Alert", message: "Internet Problem, Please Try Again", uiViewController: self)
    }

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
