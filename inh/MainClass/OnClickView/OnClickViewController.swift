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
    @IBOutlet weak var shareButton: UIButton!

    @IBOutlet weak var webView: UIWebView!
    @IBOutlet weak var titaleImage: UIImageView!
    
    var share_url = ""
    var ap_image = ""
    var mobile_news_url = ""
    
    var utilityViewController = UtilityViewController()
    var alertDialogViewController = AlertDialogViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
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

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func webViewDidStartLoad(_ webView: UIWebView) {
        
        SVProgressHUD.show()
    }
    
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        
        SVProgressHUD.dismiss()
    }
    
    func webView(_ webView: UIWebView, didFailLoadWithError error: Error) {
        alertDialogViewController.alertDialoge(title: "Alert", message: "Internet Problem, Please Try Again", uiViewController: self)
    }

    @IBAction func shareButton(_ sender: Any) {
        //Set the default sharing message.
        let message = "Message goes here."
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
