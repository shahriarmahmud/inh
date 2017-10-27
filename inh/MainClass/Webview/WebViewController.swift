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
        self.webView.load(URLRequest(url: URL(string: "https://m.inhnews.in")!))
        self.webView.navigationDelegate = self
        self.webView.allowsBackForwardNavigationGestures = true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        SVProgressHUD.dismiss()
    }
}
