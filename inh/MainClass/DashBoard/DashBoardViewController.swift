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
        segmentedPager.parallaxHeader.minimumHeight = 20
        
        // Segmented Control customization
        segmentedPager.segmentedControl.selectionIndicatorLocation = .down
        segmentedPager.segmentedControl.backgroundColor = UIColor(red: (39/255.0), green: (42/255.0), blue: (102/255.0), alpha: 1)
        segmentedPager.segmentedControl.titleTextAttributes = [NSForegroundColorAttributeName : UIColor.gray]
        segmentedPager.segmentedControl.selectedTitleTextAttributes = [NSForegroundColorAttributeName : UIColor.white]
        segmentedPager.segmentedControl.selectionStyle = .fullWidthStripe
        segmentedPager.segmentedControl.selectionIndicatorColor = .red
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }
    
    override func segmentedPager(_ segmentedPager: MXSegmentedPager, titleForSectionAt index: Int) -> String {
        return ["TOP STORIES", "HEADLINES", "FAST NEWS", "REPORTERS", "INH SPECIAL", "BOLLYWOOD EXPRESS", "CHHATTISGARHI NEWS"][index]
    }
    
    override func segmentedPager(_ segmentedPager: MXSegmentedPager, didScrollWith parallaxHeader: MXParallaxHeader) {
        print("progress \(parallaxHeader.progress)")
    }


}
