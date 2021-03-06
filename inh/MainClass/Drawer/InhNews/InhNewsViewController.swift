//
//  ViewController.swift
//  inh
//
//  Created by Shahriar Mahmud on 9/11/17.
//  Copyright © 2017 BizTech. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import SVProgressHUD
import AlamofireImage

class InhNewsViewController: BaseViewController , UITableViewDelegate, UITableViewDataSource{
    

    @IBOutlet weak var newsTable: UITableView!
    
    var petitions = [[String: String]]()
    var refreshControl: UIRefreshControl!
    var count = 1
    
    var utilityViewController = UtilityViewController()
    var alertDialogViewController = AlertDialogViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.automaticallyAdjustsScrollViewInsets = false
        newsTable.dataSource = self
        newsTable.delegate = self
        
//        let currentThmeme = UserDefaults.standard.string(forKey: "theme") ?? ""
//        print(currentThmeme)
//        if(!currentThmeme.isEmpty){
//            if(currentThmeme == "light"){
//                newsTable.backgroundColor = UIColor(red: (255/255.0), green: (255/255.0), blue: (255/255.0), alpha: 1)
//            }else{
//                newsTable.backgroundColor = UIColor(red: (51/255.0), green: (51/255.0), blue: (51/255.0), alpha: 1)
//            }
//        }else{
//            self.newsTable.backgroundColor = UIColor(red: (255/255.0), green: (255/255.0), blue: (255/255.0), alpha: 1)
//        }
        
        refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(InhNewsViewController.refresh(_:)), for: UIControlEvents.valueChanged)
        newsTable.addSubview(refreshControl)
        GEtServerDate()
    }
    
//    override func viewWillAppear(_ animated: Bool) {
//        let currentThmeme = UserDefaults.standard.string(forKey: "theme") ?? ""
//        print(currentThmeme)
//        if(!currentThmeme.isEmpty){
//            if(currentThmeme == "light"){
//                newsTable.backgroundColor = UIColor(red: (255/255.0), green: (255/255.0), blue: (255/255.0), alpha: 1)
//            }else{
//                newsTable.backgroundColor = UIColor(red: (85/255.0), green: (85/255.0), blue: (85/255.0), alpha: 1)
//            }
//        }else{
//            self.newsTable.backgroundColor = UIColor(red: (255/255.0), green: (255/255.0), blue: (255/255.0), alpha: 1)
//        }
//    }
 
    func refresh(_ sender:AnyObject) {
        // Code to refresh table view
        GEtServerDate()
        self.refreshControl.endRefreshing()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return petitions.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let row = indexPath.row
        print("Row: \(row)")
        let petition = petitions[indexPath.row]
        
        let navigationViewController = self.storyboard?.instantiateViewController(withIdentifier: "OnClickViewController") as! OnClickViewController
        navigationViewController.type = "1"
        navigationViewController.mobile_news_url = petition["mobile_news_url"]!
        self.navigationController?.pushViewController(navigationViewController, animated: true)
        
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        // UITableView only moves in one direction, y axis
        let currentOffset = scrollView.contentOffset.y
        let maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height
        
        // Change 10.0 to adjust the distance from bottom
        if maximumOffset - currentOffset <= 10.0 {
            
            self.loadMoreData(count: String(count))
            count += 1
        }
    }
    
    func loadMoreData(count:String){
        SVProgressHUD.show()
        
        Alamofire.request(RequestString.drawerInhNewsLoadMore+count, method: .get, encoding: JSONEncoding.default).responseJSON { responce in
            switch responce.result{
            case.success(let data):
                SVProgressHUD.dismiss()
                self.refreshControl.endRefreshing()
                let Response = JSON(data)
                print(Response)
                print(RequestString.drawerInhNewsLoadMore+count)
                
                
                for result in Response.arrayValue {
                    let share_url = result["share_url"].stringValue
                    let mobile_news_url = result["mobile_news_url"].stringValue
                    let art_id = result["art_id"].stringValue
                    
                    let art_title = result["art_title"].stringValue
                    let category_name = result["category_name"].stringValue
                    let art_has_video = result["art_has_video"].stringValue
                    let ap_image = result["ap_image"].stringValue
                    
                    let ap_thumb_image = result["ap_thumb_image"].stringValue
                    let art_created_on = result["art_created_on"].stringValue
                    let X_hours_ago = result["X_hours_ago"].stringValue
                    
                    let obj = ["share_url": share_url, "mobile_news_url": mobile_news_url, "art_id": art_id, "art_title": art_title, "category_name": category_name, "art_has_video": art_has_video, "ap_image": ap_image, "ap_thumb_image": ap_thumb_image, "art_created_on": art_created_on, "X_hours_ago": X_hours_ago]
                    self.petitions.append(obj)
                }
                print(self.petitions)
                print(self.petitions.count)
                
                self.newsTable.reloadData()
                
                
            case.failure(let error):
                print("failed\(error)")
            }
        }
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        if(indexPath.row==0){

            let cellIdentifier = "cell_header"
            let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! InhNewsTableViewCell

            let petition = petitions[indexPath.row]
            print(indexPath.row)
            print(petition)
            
            utilityViewController.imageLoder(url: petition["ap_image"]!, imageView: cell.titleHeadImage)

//            Alamofire.request(petition["ap_image"]!).responseImage { response in
//                debugPrint(response)
//                debugPrint(response.result)
//                
//                if let image = response.result.value {
//                    print("image downloaded: \(image)")
//                    cell.titleHeadImage.image = image
//                }
//            }
            print(petition["art_has_video"])
            if(petition["art_has_video"]=="1"){
                cell.videosImage_title.isHidden = false
            }else{
                cell.videosImage_title.isHidden = true
            }
            
            cell.headTitleLabel.text = petition["art_title"]!
            return cell
        }
        else
        {
            let cellIdentifier = "cell"
            let cell:InhNewsTableViewCell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! InhNewsTableViewCell
            
            let petition = petitions[indexPath.row]
            print(indexPath.row)
            print(petition)
            
            if(petition["art_title"]?.isEmpty)!{
                cell.titleLabel.text = ""
            }else{
                cell.titleLabel.text = petition["art_title"]!
            }
            
            if(petition["art_has_video"]=="1"){
                cell.videoImage.isHidden = false
            }else{
                cell.videoImage.isHidden = true
            }
            
            if(petition["X_hours_ago"]?.isEmpty)!{
                cell.timeLabel.text = ""
            }else{
                cell.timeLabel.text = petition["X_hours_ago"]!
            }
            
            
            if(petition["ap_thumb_image"]?.isEmpty)!{
                cell.headImage.image = nil
            }else{
                
                utilityViewController.imageLoder(url: petition["ap_thumb_image"]!, imageView: cell.headImage)
//                Alamofire.request(petition["ap_thumb_image"]!).responseImage { response in
//                    debugPrint(response)
//                    debugPrint(response.result)
//                    
//                    if let image = response.result.value {
//                        print("image downloaded: \(image)")
//                        cell.headImage.image = image
//                    }
//                }
            }
            
            let lastElement = petitions.count - 1
            if indexPath.row == lastElement {
                // handle your logic here to get more items, add it to dataSource and reload tableview
                var count = 1
                self.loadMoreData(count: String(count))
                count += 1
            }
            
            return cell
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath:IndexPath) -> CGFloat {
        var height:CGFloat = CGFloat()
        if indexPath.row == 0 {
            height = 300
        }
        else{
            height = 92
            print(height)
        }
        return height
    }
    
    func GEtServerDate(){
        SVProgressHUD.show()
        
        Alamofire.request(RequestString.drawerInhNews, method: .get, encoding: JSONEncoding.default).responseJSON { responce in
            switch responce.result{
            case.success(let data):
                SVProgressHUD.dismiss()
                self.refreshControl.endRefreshing()
                let Response = JSON(data)
                print(Response)
                print(RequestString.drawerInhNews)
                
                
                for result in Response.arrayValue {
                    let share_url = result["share_url"].stringValue
                    let mobile_news_url = result["mobile_news_url"].stringValue
                    let art_id = result["art_id"].stringValue
                    
                    let art_title = result["art_title"].stringValue
                    let category_name = result["category_name"].stringValue
                    let art_has_video = result["art_has_video"].stringValue
                    let ap_image = result["ap_image"].stringValue
                    
                    let ap_thumb_image = result["ap_thumb_image"].stringValue
                    let art_created_on = result["art_created_on"].stringValue
                    let X_hours_ago = result["X_hours_ago"].stringValue
                    
                    let obj = ["share_url": share_url, "mobile_news_url": mobile_news_url, "art_id": art_id, "art_title": art_title, "category_name": category_name, "art_has_video": art_has_video, "ap_image": ap_image, "ap_thumb_image": ap_thumb_image, "art_created_on": art_created_on, "X_hours_ago": X_hours_ago]
                    self.petitions.append(obj)
                }
                
                print(self.petitions)
                print(self.petitions.count)

                self.newsTable.reloadData()
                
                
            case.failure(let error):
                print("failed\(error)")
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}
