//
//  SettingViewController.swift
//  inh
//
//  Created by Priom on 9/22/17.
//  Copyright © 2017 BizTech. All rights reserved.
//

import UIKit
import OneSignal
import MessageUI

class SettingViewController: UIViewController , MFMailComposeViewControllerDelegate{
    
    @IBOutlet weak var settingSeague: UISegmentedControl!
    @IBOutlet var parentView: UIView!
    @IBOutlet weak var scrollview: UIScrollView!
    @IBOutlet var themeView: UIView!
    
    @IBOutlet weak var themeChangeSeage: UISegmentedControl!
    var tempView: UIView!
    var viewtag = 0
    
    var mailBody = "\n\n-----------------------------\n Please don't remove this information\n Device OS:\n Android Device\n OS version:\n App Version:\n Device Brand:\n Device Model:\n Device Manufacturer:\n"
    
    var alertDialog = AlertDialogViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let currentnotification = UserDefaults.standard.string(forKey: "notification") ?? ""
        print(currentnotification)
        if(!currentnotification.isEmpty){
            if(currentnotification == "on"){
                OneSignal.setSubscription(true)
                themeChangeSeage.selectedSegmentIndex = 0
                // turn off the current selection
                themeChangeSeage.selectedSegmentIndex = UISegmentedControlNoSegment;
                themeChangeSeage.sendActions(for: UIControlEvents.valueChanged)
            }else{
                OneSignal.setSubscription(false)
                themeChangeSeage.selectedSegmentIndex = 0
                // turn off the current selection
                themeChangeSeage.selectedSegmentIndex = UISegmentedControlNoSegment;
                themeChangeSeage.sendActions(for: UIControlEvents.valueChanged)
            }
        }else{
            OneSignal.setSubscription(true)
            themeChangeSeage.selectedSegmentIndex = 0
        }
        
        let currentThmeme = UserDefaults.standard.string(forKey: "theme") ?? ""
        if(!currentThmeme.isEmpty){
            if(currentThmeme == "light"){
                parentView.backgroundColor = UIColor(red: (255/255.0), green: (255/255.0), blue: (255/255.0), alpha: 1)
                themeChangeSeage.selectedSegmentIndex = 0
            }else{
                parentView.backgroundColor = UIColor(red: (85/255.0), green: (85/255.0), blue: (85/255.0), alpha: 1)
                themeChangeSeage.selectedSegmentIndex = 1
            }
        }else{
            self.parentView.backgroundColor = UIColor(red: (255/255.0), green: (255/255.0), blue: (255/255.0), alpha: 1)
        }
        
        self.scrollview.contentSize = CGSize(width: self.scrollview.frame.size.width, height: 900)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let currentnotification = UserDefaults.standard.string(forKey: "notification") ?? ""
        print(currentnotification)
        if(!currentnotification.isEmpty){
            if(currentnotification == "on"){
                OneSignal.setSubscription(true)
                themeChangeSeage.selectedSegmentIndex = 0
                // turn off the current selection
                themeChangeSeage.selectedSegmentIndex = UISegmentedControlNoSegment;
                themeChangeSeage.sendActions(for: UIControlEvents.valueChanged)
            }else{
                OneSignal.setSubscription(false)
                themeChangeSeage.selectedSegmentIndex = 1
                // turn off the current selection
                themeChangeSeage.selectedSegmentIndex = UISegmentedControlNoSegment;
                themeChangeSeage.sendActions(for: UIControlEvents.valueChanged)
            }
        }else{
            OneSignal.setSubscription(true)
            themeChangeSeage.selectedSegmentIndex = 0
        }
    }
    
    @IBAction func notificationTougle(_ sender: UISegmentedControl) {
        switch settingSeague.selectedSegmentIndex
        {
        case 0:
            storeVlueNotification(value: "on")
            OneSignal.setSubscription(true)
        case 1:
            storeVlueNotification(value: "off")
            OneSignal.setSubscription(false)
        default:
            break;
        }
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        dismiss(animated: true, completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    @IBAction func cancel(_ sender: Any) {
        let aSelector : Selector = #selector(SettingViewController.closeSubView)
        let tapGesture = UITapGestureRecognizer(target:self, action: aSelector)
        tempView.addGestureRecognizer(tapGesture)
    }

    @IBAction func ok(_ sender: Any) {
        if(themeChangeSeage.selectedSegmentIndex==0){
            storeVlue(color: "light")
            parentView.backgroundColor = UIColor(red: (255/255.0), green: (255/255.0), blue: (255/255.0), alpha: 1)
            let aSelector : Selector = #selector(SettingViewController.closeSubView)
            let tapGesture = UITapGestureRecognizer(target:self, action: aSelector)
            tempView.addGestureRecognizer(tapGesture)
        }else{
            storeVlue(color: "dark")
            parentView.backgroundColor = UIColor(red: (85/255.0), green: (85/255.0), blue: (85/255.0), alpha: 1)
            let aSelector : Selector = #selector(SettingViewController.closeSubView)
            let tapGesture = UITapGestureRecognizer(target:self, action: aSelector)
            tempView.addGestureRecognizer(tapGesture)
        }
    }
    @IBAction func themeChange(_ sender: UISegmentedControl) {
        switch themeChangeSeage.selectedSegmentIndex
        {
        case 0:
            storeVlue(color: "light")
            parentView.backgroundColor = UIColor(red: (255/255.0), green: (255/255.0), blue: (255/255.0), alpha: 1)
            let aSelector : Selector = #selector(SettingViewController.closeSubView)
            let tapGesture = UITapGestureRecognizer(target:self, action: aSelector)
            tempView.addGestureRecognizer(tapGesture)
        case 1:
            storeVlue(color: "dark")
            parentView.backgroundColor = UIColor(red: (85/255.0), green: (85/255.0), blue: (85/255.0), alpha: 1)
            let aSelector : Selector = #selector(SettingViewController.closeSubView)
            let tapGesture = UITapGestureRecognizer(target:self, action: aSelector)
            tempView.addGestureRecognizer(tapGesture)
        default:
            break; 
        }
    }

    @IBAction func theme(_ sender: Any) {
        if viewtag == 1 {
            UIView.animate(withDuration: 0.5, delay: 0.1, options: .curveEaseOut, animations: {() -> Void in
                self.themeView.frame = CGRect(origin: CGPoint(x: 0, y :self.view.frame.size.height), size: CGSize(width: self.view.frame.size.width, height: self.themeView.frame.size.height))
            }, completion: {(finished: Bool) -> Void in
                self.tempView.removeFromSuperview()
            })
            viewtag = 0
        }
        else
        {
            tempView = UIView(frame: CGRect(origin: CGPoint(x:0, y:0), size: CGSize(width: self.view.frame.size.width, height:self.view.frame.size.height)))
            
            tempView.backgroundColor = UIColor(white: 0, alpha: 0.3)
            tempView.isOpaque = false
            tempView.isUserInteractionEnabled = true
            self.view.addSubview(tempView)
            themeView.frame = CGRect(origin: CGPoint(x: 0, y :(self.view.frame.size.height-themeView.frame.size.height)), size: CGSize(width: self.view.frame.size.width, height: themeView.frame.size.height))
            
            let transition = CATransition()
            transition.duration = 0.2
            transition.type = kCATransitionMoveIn
            transition.subtype = kCATransitionFromTop
            themeView.layer.add(transition, forKey: kCATransition)
            tempView.addSubview(themeView)
            viewtag = 1
            let aSelector : Selector = #selector(SettingViewController.closeSubView)
            let tapGesture = UITapGestureRecognizer(target:self, action: aSelector)
            tempView.addGestureRecognizer(tapGesture)
        }
    }
    
    func closeSubView()
    {
        if viewtag == 1 {
            UIView.animate(withDuration: 0.2, delay: 0.1, options: .curveEaseOut, animations: {() -> Void in
                self.themeView.frame = CGRect(origin: CGPoint(x: 0, y :self.view.frame.size.height), size: CGSize(width: self.view.frame.size.width, height: self.themeView.frame.size.height))
            }, completion: {(finished: Bool) -> Void in
                self.tempView.removeFromSuperview()
            })
            viewtag = 0
        }
    }
    
    func storeVlue(color:String){
        UserDefaults.standard.set(color, forKey: "theme")
        UserDefaults.standard.synchronize()
    }
    
    func storeVlueNotification(value:String){
        UserDefaults.standard.set(value, forKey: "notification")
        UserDefaults.standard.synchronize()
    }
    
    
    @IBAction func clearCache(_ sender: Any) {
        allertDialogWithHandeler(title: "", message: "This will clear all cache data.Continue ?")
    }
    @IBAction func rateUs(_ sender: Any) {
        let googleURL = NSURL(string: "https://mobile.twitter.com/inhnewsindia")! as URL
        UIApplication.shared.open(googleURL, options: [:], completionHandler: nil)
    }
    @IBAction func share(_ sender: Any) {
        let share_url = "www.inhnews.in"
        //Set the default sharing message.
        let message = "Hi, I am using Indian News Hope iOS app.Why don`t you check it out on your iOS phone."
        //Set the link to share.
        if let link = NSURL(string: share_url)
        {
            let objectsToShare = [message,link] as [Any]
            let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
            activityVC.excludedActivityTypes = [UIActivityType.airDrop, UIActivityType.addToReadingList]
            self.present(activityVC, animated: true, completion: nil)
        }
    }
    @IBAction func sendFeedBack(_ sender: Any) {
        print(MFMailComposeViewController.canSendMail())
        if(MFMailComposeViewController.canSendMail()){
            let mail = MFMailComposeViewController()
            mail.mailComposeDelegate = self
            mail.setSubject("Query From INH")
            mail.setMessageBody(mailBody, isHTML: true)
            mail.setToRecipients(["Info@inhnews.in"])
            present(mail, animated: true, completion: nil)
        }else{
            alertDialog.alertDialoge(title: "Alert", message: "You have no mail apps to send the mail", uiViewController: self)
        }
    }
    @IBAction func privacyPolicy(_ sender: Any) {
        let googleURL = NSURL(string: "https://m.inhnews.in")! as URL
        UIApplication.shared.open(googleURL, options: [:], completionHandler: nil)
    }
    @IBAction func termsCondition(_ sender: Any) {
        let googleURL = NSURL(string: "https://m.inhnews.in")! as URL
        UIApplication.shared.open(googleURL, options: [:], completionHandler: nil)
    }
    @IBAction func about(_ sender: Any) {
        let googleURL = NSURL(string: "https://m.inhnews.in/content/about-inh")! as URL
        UIApplication.shared.open(googleURL, options: [:], completionHandler: nil)
    }
    
    func allertDialogWithHandeler(title :  String, message : String){
        let refreshAlert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        
        refreshAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
            URLCache.shared.removeAllCachedResponses()
            URLCache.shared.diskCapacity = 0
            URLCache.shared.memoryCapacity = 0
            UserDefaults.standard.removeObject(forKey: "theme")
        }))
        
        refreshAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction!) in
            self.dismiss(animated: true, completion: nil)
        }))
        
        present(refreshAlert, animated: true, completion: nil)
    }
}
