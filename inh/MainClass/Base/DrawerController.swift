//
//  DrawerController.swift
//  inh
//
//  Created by Shahriar Mahmud on 9/12/17.
//  Copyright © 2017 BizTech. All rights reserved.
//

import UIKit
import MXSegmentedPager

class DrawerController: MXSegmentedPagerController, SlideMenuDelegate{
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func slideMenuItemSelectedAtIndex(_ index: Int32) {
        let topViewController : UIViewController = self.navigationController!.topViewController!
        print("View Controller is : \(topViewController) \n", terminator: "")
        switch(index){
        case 0:
            print("Home\n", terminator: "")
            
            self.openViewControllerBasedOnIdentifier("Home")
            
            break
        case 1:
            print("SearchViewController\n", terminator: "")
            
            self.openViewControllerBasedOnIdentifier("SearchViewController")
            
        case 2:
            print("HeadLinesViewController\n", terminator: "")
            
            self.openViewControllerBasedOnIdentifier("HeadLinesViewController")
            
        case 3:
            print("FastNewsViewController\n", terminator: "")
            
            self.openViewControllerBasedOnIdentifier("FastNewsViewController")
            
        case 4:
            print("ReportersViewController\n", terminator: "")
            
            self.openViewControllerBasedOnIdentifier("ReportersViewController")
            
        case 5:
            print("InhSpecialViewController\n", terminator: "")
            
            self.openViewControllerBasedOnIdentifier("InhSpecialViewController")
            
        case 6:
            print("BollywoodExpressViewController\n", terminator: "")
            
            self.openViewControllerBasedOnIdentifier("BollywoodExpressViewController")
            
        case 7:
            print("ChhattisgarhiNewsViewController\n", terminator: "")
            
            self.openViewControllerBasedOnIdentifier("ChhattisgarhiNewsViewController")
            
            break
        case 8:
            print("InhNewsViewController\n", terminator: "")
            
            self.openViewControllerBasedOnIdentifier("InhNewsViewController")
            
        case 9:
            print("ChhattisgarhDrawerViewController\n", terminator: "")
            
            self.openViewControllerBasedOnIdentifier("ChhattisgarhDrawerViewController")
            
        case 10:
            print("IndiaNewsViewController\n", terminator: "")
            
            self.openViewControllerBasedOnIdentifier("IndiaNewsViewController")
            
        case 11:
            print("EntertainmentViewController\n", terminator: "")
            
            self.openViewControllerBasedOnIdentifier("EntertainmentViewController")
            
        case 12:
            print("LifeStyleViewController\n", terminator: "")
            
            self.openViewControllerBasedOnIdentifier("LifeStyleViewController")
            
        case 13:
            print("SportsViewController\n", terminator: "")
            
            self.openViewControllerBasedOnIdentifier("SportsViewController")
            
        case 14:
            print("PhotosViewController\n", terminator: "")
            
            self.openViewControllerBasedOnIdentifier("PhotosViewController")
            
        case 15:
            print("VideosViewController\n", terminator: "")
            
            self.openViewControllerBasedOnIdentifier("VideosViewController")
            
            break
        default:
            print("default\n", terminator: "")
        }
    }
    
    func openViewControllerBasedOnIdentifier(_ strIdentifier:String){
        let destViewController : UIViewController = self.storyboard!.instantiateViewController(withIdentifier: strIdentifier)
        
        let topViewController : UIViewController = self.navigationController!.topViewController!
        
        if (topViewController.restorationIdentifier! == destViewController.restorationIdentifier!){
            print("Same VC")
        } else {
            self.navigationController!.pushViewController(destViewController, animated: true)
        }
    }
    
    func addSlideMenuButton(){
        let btnShowMenu = UIButton(type: UIButtonType.system)
        btnShowMenu.setImage(self.defaultMenuImage(), for: UIControlState())
        btnShowMenu.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        btnShowMenu.addTarget(self, action: #selector(BaseViewController.onSlideMenuButtonPressed(_:)), for: UIControlEvents.touchUpInside)
        let customBarItem = UIBarButtonItem(customView: btnShowMenu)
        self.navigationItem.leftBarButtonItem = customBarItem;
    }
    
    func defaultMenuImage() -> UIImage {
        var defaultMenuImage = UIImage()
        
        UIGraphicsBeginImageContextWithOptions(CGSize(width: 30, height: 22), false, 0.0)
        
        UIColor.black.setFill()
        UIBezierPath(rect: CGRect(x: 0, y: 3, width: 30, height: 1)).fill()
        UIBezierPath(rect: CGRect(x: 0, y: 10, width: 30, height: 1)).fill()
        UIBezierPath(rect: CGRect(x: 0, y: 17, width: 30, height: 1)).fill()
        
        UIColor.white.setFill()
        UIBezierPath(rect: CGRect(x: 0, y: 4, width: 30, height: 1)).fill()
        UIBezierPath(rect: CGRect(x: 0, y: 11,  width: 30, height: 1)).fill()
        UIBezierPath(rect: CGRect(x: 0, y: 18, width: 30, height: 1)).fill()
        
        defaultMenuImage = UIGraphicsGetImageFromCurrentImageContext()!
        
        UIGraphicsEndImageContext()
        
        return defaultMenuImage;
    }
    
    @objc func onSlideMenuButtonPressed(_ sender : UIButton){
        if (sender.tag == 10)
        {
            // To Hide Menu If it already there
            self.slideMenuItemSelectedAtIndex(-1);
            
            sender.tag = 0;
            
            let viewMenuBack : UIView = view.subviews.last!
            
            UIView.animate(withDuration: 0.3, animations: { () -> Void in
                var frameMenu : CGRect = viewMenuBack.frame
                frameMenu.origin.x = -1 * UIScreen.main.bounds.size.width
                viewMenuBack.frame = frameMenu
                viewMenuBack.layoutIfNeeded()
                viewMenuBack.backgroundColor = UIColor.clear
            }, completion: { (finished) -> Void in
                viewMenuBack.removeFromSuperview()
            })
            
            return
        }
        
        sender.isEnabled = false
        sender.tag = 10
        
        let menuVC : MenuViewController = self.storyboard!.instantiateViewController(withIdentifier: "MenuViewController") as! MenuViewController
        menuVC.btnMenu = sender
        menuVC.delegate = self
        self.view.addSubview(menuVC.view)
        self.addChildViewController(menuVC)
        menuVC.view.layoutIfNeeded()
        
        
        menuVC.view.frame=CGRect(x: 0 - UIScreen.main.bounds.size.width, y: 0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height);
        
        UIView.animate(withDuration: 0.3, animations: { () -> Void in
            menuVC.view.frame=CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height);
            sender.isEnabled = true
        }, completion:nil)
    }
}
