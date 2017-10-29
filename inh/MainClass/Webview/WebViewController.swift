//
//  WebViewController.swift
//  inh
//
//  Created by Priom on 10/28/17.
//  Copyright © 2017 BizTech. All rights reserved.
//

import WebKit
import UIKit
import AlamofireImage
import Alamofire
import SVProgressHUD
import SwiftyJSON

class WebViewController: UIViewController , WKNavigationDelegate {
    
    @IBOutlet weak var webView: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        SVProgressHUD.show()
        webView.load(URLRequest(url: URL(string: "https://m.inhnews.in")!))
        webView.navigationDelegate = self
        webView.allowsBackForwardNavigationGestures = true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        if(!(webView.url?.absoluteString.isEmpty)!){
            if(webView.url?.absoluteString == "https://m.inhnews.in/settings"){
                let navigationViewController = self.storyboard?.instantiateViewController(withIdentifier: "SettingViewController") as! SettingViewController
               self.navigationController?.present(navigationViewController, animated: true, completion: nil)//(navigationViewController, animated: true)
            }
        }
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        SVProgressHUD.dismiss()
        
        print(webView.url?.absoluteString)
//        if(!(webView.url?.absoluteString.isEmpty)!){
//            if(webView.url?.absoluteString == "https://m.inhnews.in/settings"){
//                let navigationViewController = self.storyboard?.instantiateViewController(withIdentifier: "SettingViewController") as! SettingViewController
//                self.navigationController?.present(navigationViewController, animated: true, completion: nil)//(navigationViewController, animated: true)
//            }
//        }
        
        if(!(webView.url?.absoluteString.isEmpty)!){
            let navigationViewController = self.storyboard?.instantiateViewController(withIdentifier: "OnClickViewController") as! OnClickViewController
            navigationViewController.type = "2"
            navigationViewController.mobile_news_url = (webView.url?.absoluteString)!
            self.navigationController?.pushViewController(navigationViewController, animated: true)
        }
    }
    
    func webView(_ webView: WKWebView, didReceiveServerRedirectForProvisionalNavigation navigation: WKNavigation!) {
        if(!(webView.url?.absoluteString.isEmpty)!){
            if(webView.url?.absoluteString == "https://m.inhnews.in/settings"){
                let navigationViewController = self.storyboard?.instantiateViewController(withIdentifier: "SettingViewController") as! SettingViewController
                self.navigationController?.pushViewController(navigationViewController, animated: true)
            }
        }

    }
    
//    func webView(_ webView: WKWebView, didReceiveServerRedirectForProvisionalNavigation navigation: WKNavigation!) {
//        if(!(webView.url?.absoluteString.isEmpty)!){
//            if(webView.url?.absoluteString == "https://m.inhnews.in/settings"){
//                let navigationViewController = self.storyboard?.instantiateViewController(withIdentifier: "SettingViewController") as! SettingViewController
//                self.navigationController?.pushViewController(navigationViewController, animated: true)
//            }
//        }
//    }
}
