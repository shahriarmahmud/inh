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
    
    var count = 0
    
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
    
    override func viewWillAppear(_ animated: Bool) {
         count = 0
        self.navigationController?.navigationBar.isHidden = true
    }
    
//    func setCokee(){
//        let request = CkoHttpRequest()
//        request.SetFromUrl("http://www.chilkatsoft.com/echoPost.asp")
//        request.HttpVerb = "POST"
//
//        request.AddParam("param1", value: "value1")
//        request.AddParam("param2", value: "value2")
//
//        //  To add cookies to any HTTP request sent by a Chilkat HTTP method
//        //  that uses an HTTP request object, add the cookies to the
//        //  request object by calling AddHeader.
//
//        //  Add two cookies:
//        request.AddHeader("Cookie", value: "user=\"mary\"; city=\"Chicago\"")
//
//        //  Send the HTTP POST.
//        //  (The cookies are sent as part of the HTTP header.)
//    }

    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        SVProgressHUD.dismiss()
        
       
        if(!(webView.url?.absoluteString.isEmpty)!){
            if(webView.url?.absoluteString == "https://m.inhnews.in/settings" && count == 0){
                count = 1
                webView.goBack()
                let navigationViewController = self.storyboard?.instantiateViewController(withIdentifier: "SettingViewController") as! SettingViewController
                self.navigationController?.pushViewController(navigationViewController, animated: true)
            }
        }
    }
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        SVProgressHUD.show()
    }
    
    func webView(_ webView: WKWebView, didReceiveServerRedirectForProvisionalNavigation navigation: WKNavigation!) {
        SVProgressHUD.show()
        if(!(webView.url?.absoluteString.isEmpty)!){
            if(webView.url?.absoluteString == "https://m.inhnews.in/settings"){
                webView.goBack()
                let navigationViewController = self.storyboard?.instantiateViewController(withIdentifier: "SettingViewController") as! SettingViewController
                self.navigationController?.pushViewController(navigationViewController, animated: true)
            }
        }

    }
//
}
