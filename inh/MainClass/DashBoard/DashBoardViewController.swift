//
//  DashBoardViewController.swift
//  inh
//
//  Created by Shahriar Mahmud on 9/12/17.
//  Copyright © 2017 BizTech. All rights reserved.
//

import UIKit
import MXSegmentedPager

class DashBoardViewController: DrawerController {
    
    @IBOutlet weak var headView: UIView!

    override func viewDidLoad() {
        super.viewDidLoad()
        addSlideMenuButton()
        
        segmentedPager.backgroundColor = UIColor(red: (33/255.0), green: (150/255.0), blue: (245/255.0), alpha: 1)
        
        // Parallax Header
        segmentedPager.parallaxHeader.view = headView
        segmentedPager.parallaxHeader.mode = .fill
        segmentedPager.parallaxHeader.height = 0
        segmentedPager.parallaxHeader.minimumHeight = 0
        
        // Segmented Control customization
        segmentedPager.segmentedControl.selectionIndicatorLocation = .down
        
        
//        let currentThmeme = UserDefaults.standard.string(forKey: "theme") ?? ""
//        print(currentThmeme)
//        if(!currentThmeme.isEmpty){
//            if(currentThmeme == "light"){
//                segmentedPager.segmentedControl.backgroundColor = UIColor(red: (33/255.0), green: (45/255.0), blue: (77/255.0), alpha: 1)
//            }else{
//                segmentedPager.segmentedControl.backgroundColor = UIColor(red: (51/255.0), green: (51/255.0), blue: (51/255.0), alpha: 1)
//            }
//        }else{
//            segmentedPager.segmentedControl.backgroundColor = UIColor(red: (33/255.0), green: (45/255.0), blue: (77/255.0), alpha: 1)
//        }

        segmentedPager.segmentedControl.backgroundColor = UIColor(red: (21/255.0), green: (38/255.0), blue: (55/255.0), alpha: 1)
        segmentedPager.segmentedControl.titleTextAttributes = [NSForegroundColorAttributeName : UIColor(red: (100/255.0), green: (204/255.0), blue: (227/255.0), alpha: 1),NSFontAttributeName : UIFont.systemFont(ofSize: 13)]
        segmentedPager.segmentedControl.selectedTitleTextAttributes = [NSForegroundColorAttributeName : UIColor(red: (100/255.0), green: (204/255.0), blue: (227/255.0), alpha: 1),NSFontAttributeName : UIFont.systemFont(ofSize: 13) ]
        segmentedPager.segmentedControl.selectionStyle = .fullWidthStripe
        segmentedPager.segmentedControl.selectionIndicatorColor = .red
        segmentedPager.segmentedControl.selectionIndicatorHeight=2
    }
    
//    override func viewWillAppear(_ animated: Bool) {
//        let currentThmeme = UserDefaults.standard.string(forKey: "theme") ?? ""
//        print(currentThmeme)
//        if(!currentThmeme.isEmpty){
//            if(currentThmeme == "light"){
//                segmentedPager.segmentedControl.backgroundColor = UIColor(red: (33/255.0), green: (45/255.0), blue: (77/255.0), alpha: 1)
//            }else{
//                segmentedPager.segmentedControl.backgroundColor = UIColor(red: (51/255.0), green: (51/255.0), blue: (51/255.0), alpha: 1)
//            }
//        }else{
//            segmentedPager.segmentedControl.backgroundColor = UIColor(red: (33/255.0), green: (45/255.0), blue: (77/255.0), alpha: 1)
//        }
//    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }
    
    override func segmentedPager(_ segmentedPager: MXSegmentedPager, titleForSectionAt index: Int) -> String {
        return ["Home", "INH NEWS", "CHHATTISGARH NEWS", "INDIA NEWS", "ENTERTAINMENT", "LIFE STYLE", "SPORTS","PHOTOS","VIDEOS"][index]
    }
    
    override func segmentedPager(_ segmentedPager: MXSegmentedPager, didScrollWith parallaxHeader: MXParallaxHeader) {
        print("progress \(parallaxHeader.progress)")
    }
    
    @IBAction func youtube(_ sender: Any) {
        let googleURL = NSURL(string: "https://www.youtube.com/channel/UCQFX8tqgED6hQQSKxJ8DuNg")! as URL
        UIApplication.shared.open(googleURL, options: [:], completionHandler: nil)
    }
    @IBAction func instagram(_ sender: Any) {
        let googleURL = NSURL(string: "https://instagram.com/inhnewsindia")! as URL
        UIApplication.shared.open(googleURL, options: [:], completionHandler: nil)
    }
    @IBAction func twitter(_ sender: Any) {
        let googleURL = NSURL(string: "https://mobile.twitter.com/inhnewsindia")! as URL
        UIApplication.shared.open(googleURL, options: [:], completionHandler: nil)
    }
    
    @IBAction func facebook(_ sender: Any) {
//        var googleURL:NSURL? = nil
//        if UIApplication.shared.canOpenURL(URL(string: "fb://profile/inhnewsindia")!) {
//            googleURL = NSURL(string: "fb://profile/inhnewsindia")
//            UIApplication.shared.open(googleURL! as URL, options: [:], completionHandler: nil)
//        }
//        else {
//            googleURL = NSURL(string: "http://www.facebook.com/inhnewsindia")
//            UIApplication.shared.open(googleURL! as URL, options: [:], completionHandler: nil)
//        }
//        
        
        let googleURL = NSURL(string: "http://www.facebook.com/inhnewsindia")! as URL
        UIApplication.shared.open(googleURL, options: [:], completionHandler: nil)
//        
//        let googleURL = NSURL(string: "https://m.facebook.com/inhnewsindia")! as URL
//        UIApplication.shared.open(googleURL, options: [:], completionHandler: nil)
    }
    


}
