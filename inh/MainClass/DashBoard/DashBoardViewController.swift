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
        
        segmentedPager.backgroundColor = .white
        
        // Parallax Header
        segmentedPager.parallaxHeader.view = headView
        segmentedPager.parallaxHeader.mode = .fill
        segmentedPager.parallaxHeader.height = 60
        segmentedPager.parallaxHeader.minimumHeight = 0
        
        // Segmented Control customization
        segmentedPager.segmentedControl.selectionIndicatorLocation = .down
        segmentedPager.segmentedControl.backgroundColor = UIColor(red: (33/255.0), green: (45/255.0), blue: (77/255.0), alpha: 1)
        segmentedPager.segmentedControl.titleTextAttributes = [NSForegroundColorAttributeName : UIColor.gray,NSFontAttributeName : UIFont.systemFont(ofSize: 13)]
        segmentedPager.segmentedControl.selectedTitleTextAttributes = [NSForegroundColorAttributeName : UIColor.white,NSFontAttributeName : UIFont.systemFont(ofSize: 13) ]
        segmentedPager.segmentedControl.selectionStyle = .fullWidthStripe
        segmentedPager.segmentedControl.selectionIndicatorColor = .red
        segmentedPager.segmentedControl.selectionIndicatorHeight=2
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }
    
    override func segmentedPager(_ segmentedPager: MXSegmentedPager, titleForSectionAt index: Int) -> String {
        return ["TOP STORIES", "INH NEWS", "CHHATTISGARH NEWS", "INDIA NEWS", "ENTERTAINMENT", "LIFE STYLE", "SPORTS","PHOTOS","VIDEOS"][index]
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
        let googleURL = NSURL(string: "https://m.facebook.com/inhnewsindia")! as URL
        UIApplication.shared.open(googleURL, options: [:], completionHandler: nil)
    }
    


}
