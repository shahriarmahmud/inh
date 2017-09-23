//
//  VideosViewController.swift
//  inh
//
//  Created by Shahriar Mahmud on 9/19/17.
//  Copyright © 2017 BizTech. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import SVProgressHUD

class VideosViewController: BaseViewController , UITableViewDelegate, UITableViewDataSource{
    
    
    @IBOutlet weak var newsTable: UITableView!
   
    var refreshControl: UIRefreshControl!
    
    var petitions = [[String: String]]()
    var count = 1
    
    var utilityViewController = UtilityViewController()
    var alertDialogViewController = AlertDialogViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.automaticallyAdjustsScrollViewInsets = false
        newsTable.dataSource = self
        newsTable.delegate = self
        
        let currentThmeme = UserDefaults.standard.string(forKey: "theme") ?? ""
        if(!currentThmeme.isEmpty){
            if(currentThmeme == "light"){
                newsTable.backgroundColor = UIColor(red: (255/255.0), green: (255/255.0), blue: (255/255.0), alpha: 1)
            }else{
                newsTable.backgroundColor = UIColor(red: (85/255.0), green: (85/255.0), blue: (85/255.0), alpha: 1)
            }
        }else{
            self.newsTable.backgroundColor = UIColor(red: (255/255.0), green: (255/255.0), blue: (255/255.0), alpha: 1)
        }
        
        refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: Selector(("refresh:")), for: UIControlEvents.valueChanged)
        newsTable.addSubview(refreshControl)
        GEtReportDate()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let currentThmeme = UserDefaults.standard.string(forKey: "theme") ?? ""
        if(!currentThmeme.isEmpty){
            if(currentThmeme == "light"){
                newsTable.backgroundColor = UIColor(red: (255/255.0), green: (255/255.0), blue: (255/255.0), alpha: 1)
            }else{
                newsTable.backgroundColor = UIColor(red: (85/255.0), green: (85/255.0), blue: (85/255.0), alpha: 1)
            }
        }else{
            self.newsTable.backgroundColor = UIColor(red: (255/255.0), green: (255/255.0), blue: (255/255.0), alpha: 1)
        }
    }
    
    func refresh(sender:AnyObject) {
        // Code to refresh table view
        GEtReportDate()
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
        
        let navigationViewController = self.storyboard?.instantiateViewController(withIdentifier: "VideoViewController") as! VideoViewController
        navigationViewController.videoId = petition["videoId"]!
        self.navigationController?.pushViewController(navigationViewController, animated: true)
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        if(indexPath.row==0){
            
            let cellHeader:VideosTableViewCell = tableView.dequeueReusableCell(withIdentifier: "cell_header", for: indexPath) as! VideosTableViewCell
            
             let headLine = petitions[indexPath.row]
            
            Alamofire.request(headLine["url"]!).responseImage { response in
                debugPrint(response)
                debugPrint(response.result)
                
                if let image = response.result.value {
                    print("image downloaded: \(image)")
                    cellHeader.headLineImage.image = image
                }
            }
            
            cellHeader.HeadLineTitle.text = headLine["title"]!
            
            return cellHeader
            
        }else{
            let cell:VideosTableViewCell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! VideosTableViewCell
            
            let headLine = petitions[indexPath.row]
            
            if(headLine["title"]?.isEmpty)!{
                cell.titleLabel.text = ""
            }else{
                cell.titleLabel.text = headLine["title"]!
            }
            
            
            if(headLine["url"]?.isEmpty)!{
                cell.headImage.image = nil
            }else{
                Alamofire.request(headLine["url"]!).responseImage { response in
                    debugPrint(response)
                    debugPrint(response.result)
                    
                    if let image = response.result.value {
                        print("image downloaded: \(image)")
                        cell.headImage.image = image
                    }
                }
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
            height = 294
        }
        else{
            height = 92
            print(height)
        }
        return height
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
        
        Alamofire.request(RequestString.videoLodeMore+count, method: .get, encoding: JSONEncoding.default).responseJSON { responce in
            switch responce.result{
            case.success(let data):
                SVProgressHUD.dismiss()
                self.refreshControl.endRefreshing()
                
                let json = JSON(data)
                print(json["items"][0]["snippet"]["thumbnails"]["medium"]["url"].stringValue)
                print(json["items"])
                print("Head Lines",json)
                print("Head Lines",RequestString.videoLodeMore+count)
                
                
                
                
                for result in json["items"].arrayValue {
                    let title = result["snippet"]["title"].stringValue
                    let url = result["snippet"]["thumbnails"]["medium"]["url"].stringValue
                    let videoId = result["id"]["videoId"].stringValue
                    
                    let obj = ["title": title, "url": url, "videoId": videoId]
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
    
    func GEtReportDate(){
        SVProgressHUD.show()
        
        Alamofire.request(RequestString.video, method: .get, encoding: JSONEncoding.default).responseJSON { responce in
            switch responce.result{
            case.success(let data):
                SVProgressHUD.dismiss()
                self.refreshControl.endRefreshing()
                
                let json = JSON(data)
                print(json["items"][0]["snippet"]["thumbnails"]["medium"]["url"].stringValue)
                print(json["items"])
                print("Head Lines",json)
                print("Head Lines",RequestString.video)

                for result in json["items"].arrayValue {
                    let title = result["snippet"]["title"].stringValue
                    let url = result["snippet"]["thumbnails"]["medium"]["url"].stringValue
                    let videoId = result["id"]["videoId"].stringValue
                    
                    let obj = ["title": title, "url": url, "videoId": videoId]
                    self.petitions.append(obj)
                }

                print("petitions : ", self.petitions)

                self.newsTable.reloadData()
                
            case.failure(let error):
                print("failed\(error)")
            }
        }
    }
}
