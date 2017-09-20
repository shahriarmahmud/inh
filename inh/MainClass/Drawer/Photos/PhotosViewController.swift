//
//  PhotosViewController.swift
//  inh
//
//  Created by Shahriar Mahmud on 9/19/17.
//  Copyright © 2017 BizTech. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import SVProgressHUD
import AlamofireImage

class PhotosViewController: BaseViewController , UITableViewDelegate, UITableViewDataSource{
    
    @IBOutlet weak var scrollview: UIScrollView!
    @IBOutlet weak var headerView: UIView!
    var refreshControl: UIRefreshControl!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var newsTable: UITableView!
    @IBOutlet weak var headLineImage: UIImageView!
    
    var photoStories = [[String: String]]()
    var count = 1
    
    var utilityViewController = UtilityViewController()
    var alertDialogViewController = AlertDialogViewController()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.automaticallyAdjustsScrollViewInsets = false
        scrollview.contentSize = CGSize(width: 400, height: 1200)
        newsTable.dataSource = self
        newsTable.delegate = self
        refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: Selector(("refresh:")), for: UIControlEvents.valueChanged)
        newsTable.addSubview(refreshControl) // not required when using UITableViewController
        //        headerView.addSubview(refreshControl)
        GEtServerDate()
    }
    
    func refresh(sender:AnyObject) {
        // Code to refresh table view
        GEtServerDate()
        self.refreshControl.endRefreshing()
    }
    
    @IBAction func fristTitemClcik(_ sender: Any) {
        let navigationViewController = self.storyboard?.instantiateViewController(withIdentifier: "PhotoGalleryViewController") as! PhotoGalleryViewController
        let photoStory = photoStories[0]
        navigationViewController.albumId = photoStory["palbum_id"]!
        self.navigationController?.pushViewController(navigationViewController, animated: true)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return photoStories.count-1
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let row = indexPath.row
        print("Row: \(row)")

        let navigationViewController = self.storyboard?.instantiateViewController(withIdentifier: "PhotoGalleryViewController") as! PhotoGalleryViewController
        let photoStory = photoStories[row]
        navigationViewController.albumId = photoStory["palbum_id"]!
        self.navigationController?.pushViewController(navigationViewController, animated: true)
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell:PhotosTableViewCell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! PhotosTableViewCell
        
        let photoStory = photoStories[indexPath.row+1]
        print(indexPath.row)
        print(photoStory)
        
        if(photoStory["palbum_title"]?.isEmpty)!{
            cell.titleLabel.text = ""
        }else{
            cell.titleLabel.text = photoStory["palbum_title"]!
        }
        
        if(photoStory["pai_image"]?.isEmpty)!{
            cell.headImage.image = nil
        }else{
            Alamofire.request(photoStory["pai_image"]!).responseImage { response in
                debugPrint(response)
                debugPrint(response.result)
                
                if let image = response.result.value {
                    print("image downloaded: \(image)")
                    cell.headImage.image = image
                }
            }
        }
        
//        let lastElement = photoStory.count - 1
//        if indexPath.row == lastElement {
//            // handle your logic here to get more items, add it to dataSource and reload tableview
//            var count = 1
//            self.loadMoreData(count: String(count))
//            count += 1
//        }
        return cell
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
        
        Alamofire.request(RequestString.photoSliderLoadMore+count, method: .get, encoding: JSONEncoding.default).responseJSON { responce in
            switch responce.result{
            case.success(let data):
                SVProgressHUD.dismiss()
                self.refreshControl.endRefreshing()
                
                let Response = JSON(data)
                print(Response)
                print(RequestString.photoSliderLoadMore+count)
                
                
                for result in Response.arrayValue {
                    let palbum_id = result["palbum_id"].stringValue
                    let palbum_title = result["palbum_title"].stringValue
                    let pai_image = result["pai_image"].stringValue
                    
                    let obj = ["palbum_id": palbum_id, "palbum_title": palbum_title, "pai_image": pai_image]
                    self.photoStories.append(obj)
                }
                
                self.newsTable.reloadData()
                
                
            case.failure(let error):
                print("failed\(error)")
            }
        }
    }
    
    func GEtServerDate(){
        SVProgressHUD.show()
        
        Alamofire.request(RequestString.photoSlider, method: .get, encoding: JSONEncoding.default).responseJSON { responce in
            switch responce.result{
            case.success(let data):
                SVProgressHUD.dismiss()
                self.refreshControl.endRefreshing()
                
                let Response = JSON(data)
                print(Response)
                print(RequestString.photoSlider)
                
                
                for result in Response.arrayValue {
                    let palbum_id = result["palbum_id"].stringValue
                    let palbum_title = result["palbum_title"].stringValue
                    let pai_image = result["pai_image"].stringValue
                    
                    let obj = ["palbum_id": palbum_id, "palbum_title": palbum_title, "pai_image": pai_image]
                    self.photoStories.append(obj)
                }
                
                
                Alamofire.request(self.photoStories[0]["pai_image"]!).responseImage { response in
                    debugPrint(response)
                    debugPrint(response.result)
                    
                    if let image = response.result.value {
                        print("image downloaded: \(image)")
                        self.headLineImage.image = image
                    }
                }
                
                self.titleLabel.text = self.photoStories[0]["palbum_title"]!
                
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
