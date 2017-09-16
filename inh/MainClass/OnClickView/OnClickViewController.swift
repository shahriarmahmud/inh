//
//  OnClickViewController.swift
//  inh
//
//  Created by Priom on 9/16/17.
//  Copyright © 2017 BizTech. All rights reserved.
//

import UIKit

class OnClickViewController: UIViewController {
    @IBOutlet weak var shareButton: UIButton!

    @IBOutlet weak var webView: UIWebView!
    @IBOutlet weak var titaleImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        shareButton.layer.cornerRadius = 30
        shareButton.clipsToBounds = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    @IBAction func shareButton(_ sender: Any) {
        //Set the default sharing message.
        let message = "Message goes here."
        //Set the link to share.
        if let link = NSURL(string: "http://yoururl.com")
        {
            let objectsToShare = [message,link] as [Any]
            let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
            activityVC.excludedActivityTypes = [UIActivityType.airDrop, UIActivityType.addToReadingList]
            self.present(activityVC, animated: true, completion: nil)
        }
    }
}
