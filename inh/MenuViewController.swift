//
//  MenuViewController.swift
//  Nuspos
//
//  Created by Shahriar Mahmud on 9/11/17.
//  Copyright © 2017 Nuspay. All rights reserved.
//

import UIKit

protocol SlideMenuDelegate {
    func slideMenuItemSelectedAtIndex(_ index : Int32)
}

class MenuViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    /**
     *  Array to display menu options
     */
    @IBOutlet var tblMenuOptions : UITableView!
    
    /**
     *  Transparent button to hide menu
     */
    @IBOutlet var btnCloseMenuOverlay : UIButton!
    
    /**
     *  Array containing menu options
     */
    var arrayMenuOptions = [Dictionary<String,String>]()
    
    /**
     *  Menu button which was tapped to display the menu
     */
    var btnMenu : UIButton!
    
    /**
     *  Delegate of the MenuVC
     */
    var delegate : SlideMenuDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
//        let currentThmeme = UserDefaults.standard.string(forKey: "theme") ?? ""
//        print(currentThmeme)
//        if(!currentThmeme.isEmpty){
//            if(currentThmeme == "light"){
//                tblMenuOptions.backgroundColor = UIColor(red: (250/255.0), green: (250/255.0), blue: (250/255.0), alpha: 1)
//            }else{
//                tblMenuOptions.backgroundColor = UIColor(red: (51/255.0), green: (51/255.0), blue: (51/255.0), alpha: 1)
//            }
//        }else{
//            tblMenuOptions.backgroundColor = UIColor(red: (250/255.0), green: (250/255.0), blue: (250/255.0), alpha: 1)
//        }
        
        tblMenuOptions.tableFooterView = UIView()
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        btnMenu.backgroundColor = UIColor(red: (233/255.0), green: (30/255.0), blue: (99/255.0), alpha: 1)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateArrayMenuOptions()
    }
    
    func updateArrayMenuOptions(){
        arrayMenuOptions.append(["title":"Home", "icon":"news"])
        arrayMenuOptions.append(["title":"Search", "icon":"search"])
        
        arrayMenuOptions.append(["title":"Headlines", "icon":"video"])
        arrayMenuOptions.append(["title":"Fast News", "icon":"video"])
        arrayMenuOptions.append(["title":"Reporters", "icon":"video"])
        arrayMenuOptions.append(["title":"INH Special", "icon":"video"])
        arrayMenuOptions.append(["title":"Bollywood Express", "icon":"video"])
        arrayMenuOptions.append(["title":"Chhattisgarhi News", "icon":"video"])
        
        arrayMenuOptions.append(["title":"INH News", "icon":"news"])
        arrayMenuOptions.append(["title":"Chhattisgarh News", "icon":"news"])
        arrayMenuOptions.append(["title":"India News", "icon":"news"])
        arrayMenuOptions.append(["title":"Entertainment", "icon":"news"])
        arrayMenuOptions.append(["title":"Life Style", "icon":"news"])
        arrayMenuOptions.append(["title":"Sports", "icon":"news"])
        arrayMenuOptions.append(["title":"Photos", "icon":"photo"])
        arrayMenuOptions.append(["title":"Videos", "icon":"video"])
        
        tblMenuOptions.reloadData()
    }
    
    @IBAction func onCloseMenuClick(_ button:UIButton!){
        btnMenu.tag = 0
        
        if (self.delegate != nil) {
            var index = Int32(button.tag)
            if(button == self.btnCloseMenuOverlay){
                index = -1
            }
            delegate?.slideMenuItemSelectedAtIndex(index)
        }
        
        UIView.animate(withDuration: 0.3, animations: { () -> Void in
            self.view.frame = CGRect(x: -UIScreen.main.bounds.size.width, y: 0, width: UIScreen.main.bounds.size.width,height: UIScreen.main.bounds.size.height)
            self.view.layoutIfNeeded()
            self.view.backgroundColor = UIColor(red: (233/255.0), green: (30/255.0), blue: (99/255.0), alpha: 1)
        }, completion: { (finished) -> Void in
            self.view.removeFromSuperview()
            self.removeFromParentViewController()
        })
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "cellMenu")!
        
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        cell.layoutMargins = UIEdgeInsets.zero
        cell.preservesSuperviewLayoutMargins = false
        cell.backgroundColor = UIColor.clear
        
        let lblTitle : UILabel = cell.contentView.viewWithTag(101) as! UILabel
        let imgIcon : UIImageView = cell.contentView.viewWithTag(100) as! UIImageView
        
        imgIcon.image = UIImage(named: arrayMenuOptions[indexPath.row]["icon"]!)
        lblTitle.text = arrayMenuOptions[indexPath.row]["title"]!
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let btn = UIButton(type: UIButtonType.custom)
        btn.tag = indexPath.row
        self.onCloseMenuClick(btn)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayMenuOptions.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1;
    }
}
