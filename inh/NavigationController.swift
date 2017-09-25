//
//  NavigationController.swift
//  BlockChainsMyMerchant
//
//  Created by Shahriar Mahmud on 8/27/17.
//  Copyright © 2017 Shahriar Mahmud. All rights reserved.
//

import UIKit

class NavigationController: UINavigationController, UIViewControllerTransitioningDelegate{

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Status bar white font
        self.navigationBar.barTintColor = UIColor(red: (33/255.0), green: (45/255.0), blue: (77/255.0), alpha: 1)        
        self.navigationBar.tintColor = UIColor.white
        UINavigationBar.appearance().isTranslucent = false
        self.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : UIColor.white]
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
