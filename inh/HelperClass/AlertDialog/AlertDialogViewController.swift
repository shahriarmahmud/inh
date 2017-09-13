//
//  AlertDialogViewController.swift
//  BlockChains.My
//
//  Created by Shahriar Mahmud on 7/4/17.
//  Copyright © 2017 Nuspay. All rights reserved.
//

import UIKit

class AlertDialogViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func alertDialoge( title :  String, message : String,uiViewController:UIViewController){
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: { (action: UIAlertAction!) in
            
//            uiViewController.navigationController?.popViewController(animated: true)
        }))

        uiViewController.present(alert, animated: true, completion: nil)
        
    }
    
    func alertDialogeWithFinishController( title :  String, message : String,uiViewController:UIViewController){
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: { (action: UIAlertAction!) in
            
                        uiViewController.navigationController?.popViewController(animated: true)
        }))
        
        uiViewController.present(alert, animated: true, completion: nil)
        
    }

}
