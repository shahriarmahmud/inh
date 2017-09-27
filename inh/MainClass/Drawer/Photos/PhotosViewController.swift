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
    
    var refreshControl: UIRefreshControl!

    @IBOutlet weak var newsTable: UITableView!

    
    var photoStories = [[String: String]]()
    var count = 1
    
    var utilityViewController = UtilityViewController()
    var alertDialogViewController = AlertDialogViewController()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.automaticallyAdjustsScrollViewInsets = false
        newsTable.dataSource = self
        newsTable.delegate = self
        
//        let currentThmeme = UserDefaults.standard.string(forKey: "theme") ?? ""
//        if(!currentThmeme.isEmpty){
//            if(currentThmeme == "light"){
//                newsTable.backgroundColor = UIColor(red: (255/255.0), green: (255/255.0), blue: (255/255.0), alpha: 1)
//            }else{
//                newsTable.backgroundColor = UIColor(red: (85/255.0), green: (85/255.0), blue: (85/255.0), alpha: 1)
//            }
//        }else{
//            self.newsTable.backgroundColor = UIColor(red: (255/255.0), green: (255/255.0), blue: (255/255.0), alpha: 1)
//        }
        
        refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: Selector(("refresh:")), for: UIControlEvents.valueChanged)
        newsTable.addSubview(refreshControl)
        GEtServerDate()
    }
    
//    override func viewWillAppear(_ animated: Bool) {
//        let currentThmeme = UserDefaults.standard.string(forKey: "theme") ?? ""
//        if(!currentThmeme.isEmpty){
//            if(currentThmeme == "light"){
//                newsTable.backgroundColor = UIColor(red: (255/255.0), green: (255/255.0), blue: (255/255.0), alpha: 1)
//            }else{
//                newsTable.backgroundColor = UIColor(red: (51/255.0), green: (51/255.0), blue: (51/255.0), alpha: 1)
//            }
//        }else{
//            self.newsTable.backgroundColor = UIColor(red: (255/255.0), green: (255/255.0), blue: (255/255.0), alpha: 1)
//        }
//    }
//    
    func refresh(_ sender:AnyObject) {
        // Code to refresh table view
        GEtServerDate()
        self.refreshControl.endRefreshing()
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return photoStories.count
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
 
        if(indexPath.row==0){
            
            let cellHeader:PhotosTableViewCell = tableView.dequeueReusableCell(withIdentifier: "cell_header", for: indexPath) as! PhotosTableViewCell
            
            let photoStory = photoStories[indexPath.row]
            print(indexPath.row)
            print(photoStory)
            
            
            Alamofire.request(photoStory["pai_image_original"]!).responseImage { response in
                debugPrint(response)
                debugPrint(response.result)
                
                if let image = response.result.value {
                    print("image downloaded: \(image)")
                    
                    
                    let size = CGSize(width: cellHeader.titleHeadImage.frame.size.width, height: cellHeader.titleHeadImage.frame.size.height)
                    
                    // Scale image to fit within specified size while maintaining aspect ratio
                    
                    let scaledImage = image.af_imageScaled(to: size)
                    
                    // Scale image to fit within specified size while maintaining aspect ratio
                    let aspectScaledToFitImage = image.af_imageAspectScaled(toFit: size)
                    
                    // Scale image to fill specified size while maintaining aspect ratio
                    let aspectScaledToFillImage = image.af_imageAspectScaled(toFill: size)

                    cellHeader.titleHeadImage.clipsToBounds = true
 
                    cellHeader.titleHeadImage.image = scaledImage

                }
            }
            
            cellHeader.headTitleLabel.text = photoStory["palbum_title"]!
            
            return cellHeader
            
        }else{
            let cell:PhotosTableViewCell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! PhotosTableViewCell
            
            let photoStory = photoStories[indexPath.row]
            print(indexPath.row)
            print(photoStory)
            
            if(photoStory["palbum_title"]?.isEmpty)!{
                cell.titleLabel.text = ""
            }else{
                cell.titleLabel.text = photoStory["palbum_title"]!
            }
            
            if(photoStory["pai_image_original"]?.isEmpty)!{
                cell.headImage.image = nil
            }else{
                Alamofire.request(photoStory["pai_image_original"]!).responseImage { response in
                    debugPrint(response)
                    debugPrint(response.result)
                    
                    if let image = response.result.value {
                        print("image downloaded: \(image)")
                        
                        
                        let size = CGSize(width: cell.headImage.frame.size.width, height: cell.headImage.frame.size.height)

                        let scaledImage = image.af_imageScaled(to: size)
                        
                        // Scale image to fit within specified size while maintaining aspect ratio
                        let aspectScaledToFitImage = image.af_imageAspectScaled(toFit: size)
                        
                        // Scale image to fill specified size while maintaining aspect ratio
                        let aspectScaledToFillImage = image.af_imageAspectScaled(toFill: size)
                        cell.headImage.clipsToBounds = true
                        cell.headImage.image = scaledImage

                    }
                }
            }
            
            return cell
        }
        
        
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
                    let pai_image_original = result["pai_image_original"].stringValue
                    
                    let obj = ["palbum_id": palbum_id, "palbum_title": palbum_title, "pai_image": pai_image,"pai_image_original": pai_image_original]
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
                    let pai_image_original = result["pai_image_original"].stringValue
                    
                    let obj = ["palbum_id": palbum_id, "palbum_title": palbum_title, "pai_image": pai_image, "pai_image_original": pai_image_original]
                    self.photoStories.append(obj)
                }

                self.newsTable.reloadData()
                
                
            case.failure(let error):
                print("failed\(error)")
            }
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

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}
