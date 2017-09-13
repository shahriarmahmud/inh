//
//  TopStoriesViewController.swift
//  inh
//
//  Created by Shahriar Mahmud on 9/12/17.
//  Copyright © 2017 BizTech. All rights reserved.
//

import UIKit
import ImageSlideshow
import Alamofire
import AlamofireImage
import SwiftyJSON
import SVProgressHUD

class TopStoriesViewController: UIViewController , UITableViewDelegate, UITableViewDataSource{
    
    open override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var topBanner: ImageSlideshow!
    @IBOutlet weak var talestNewsTable: UITableView!
    
    var petitions = [[String: String]]()
    var imageUrlList = [[String: String]]()
    var downloadImageUrlList = [AlamofireSource]()
    
    //latest news
    var latestNewsList = [[String: String]]()
    
    //photostories
    @IBOutlet weak var photoStoriesTitleLabel: UILabel!
    @IBOutlet weak var photoStoriesBanner: ImageSlideshow!
    var photoStories = [[String: String]]()
    var photoStoriesImageUrlList = [[String: String]]()
    var photoStoriesDownloadImageUrlList = [AlamofireSource]()

    override func viewDidLoad() {
        super.viewDidLoad()
        talestNewsTable.dataSource = self
        talestNewsTable.delegate = self
        GEtServerDate()
        //latestNews
        GetLatestNewsData()
        
        // photoStories
        GetPhotoStoriesDate()
        
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(TopStoriesViewController.didTap))
        topBanner.addGestureRecognizer(recognizer)
        
        let photoStoriesRecognizer = UITapGestureRecognizer(target: self, action: #selector(TopStoriesViewController.photoStoriesTap))
        photoStoriesBanner.addGestureRecognizer(photoStoriesRecognizer)

    }
    
    func didTap() {
//        let fullScreenController = topBanner.presentFullScreenController(from: self)
//        // set the activity indicator for full screen controller (skipping the line will show no activity indicator)
//        fullScreenController.slideshow.activityIndicator = DefaultActivityIndicator(style: .white, color: nil)
        
        let navigationViewController = self.storyboard?.instantiateViewController(withIdentifier: "SportsViewController") as! SportsViewController
        self.navigationController?.pushViewController(navigationViewController, animated: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    func GEtServerDate(){
        SVProgressHUD.show()
        
        Alamofire.request(RequestString.topnews, method: .get, encoding: JSONEncoding.default).responseJSON { responce in
            switch responce.result{
            case.success(let data):
                SVProgressHUD.dismiss()
                
                let Response = JSON(data)
                print(Response)
                print(RequestString.topnews)
                
                
                for result in Response.arrayValue {
                    let share_url = result["share_url"].stringValue
                    let mobile_news_url = result["mobile_news_url"].stringValue
                    let art_id = result["art_id"].stringValue
                    let art_title = result["art_title"].stringValue
                    let category_name = result["category_name"].stringValue
                    let art_has_video = result["art_has_video"].stringValue
                    let ap_image = result["ap_image"].stringValue
                    let art_created_on = result["art_created_on"].stringValue
                    let X_hours_ago = result["X_hours_ago"].stringValue
                    
                    let obj = ["share_url": share_url, "mobile_news_url": mobile_news_url, "art_id": art_id, "art_title": art_title, "category_name": category_name, "art_has_video": art_has_video, "ap_image": ap_image, "art_created_on": art_created_on, "X_hours_ago": X_hours_ago]
                    let obj2 = ["ap_image": ap_image]
                    self.petitions.append(obj)
                    self.imageUrlList.append(obj2)
                }
                
                let titleText = self.petitions[0]
                self.titleLabel.text=titleText["art_title"]
                
                self.topBanner.backgroundColor = UIColor.white
                self.topBanner.slideshowInterval = 5.0
                self.topBanner.pageControlPosition = PageControlPosition.underScrollView
                self.topBanner.pageControl.currentPageIndicatorTintColor = UIColor.lightGray
                self.topBanner.pageControl.pageIndicatorTintColor = UIColor.black
                self.topBanner.contentScaleMode = UIViewContentMode.scaleAspectFill

                self.topBanner.activityIndicator = DefaultActivityIndicator()
                self.topBanner.currentPageChanged = { page in
                    let titleText = self.petitions[page]
                    self.titleLabel.text=titleText["art_title"]
                }
                for imageUrl in self.imageUrlList {
                    self.downloadImageUrlList.append(AlamofireSource(urlString:  imageUrl["ap_image"]!)!)
                }
                
                self.topBanner.setImageInputs(self.downloadImageUrlList)

            case.failure(let error):
                print("failed\(error)")
            }
        }
    }
    
    /////////////////////////////////////// latest news //////////////////////////////////
    
    

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return latestNewsList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell:LatestTableViewCell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! LatestTableViewCell
        
        let latestNews = latestNewsList[indexPath.row]
        print(indexPath.row)
        print(latestNews)
        
        if(latestNews["art_title"]?.isEmpty)!{
            cell.titleLabel.text = ""
        }else{
            cell.titleLabel.text = latestNews["art_title"]!
        }
        
        
        if(latestNews["X_hours_ago"]?.isEmpty)!{
            cell.timeLabel.text = ""
        }else{
            cell.timeLabel.text = latestNews["X_hours_ago"]!
        }
        
        
        if(latestNews["ap_thumb_image"]?.isEmpty)!{
            cell.headerImage.image = nil
        }else{
            Alamofire.request(latestNews["ap_thumb_image"]!).responseImage { response in
                debugPrint(response)
                debugPrint(response.result)
                
                if let image = response.result.value {
                    print("image downloaded: \(image)")
                    cell.headerImage.image = image
                }
            }
        }
        return cell
    }
    
    func GetLatestNewsData(){
        SVProgressHUD.show()
        
        Alamofire.request(RequestString.latest, method: .get, encoding: JSONEncoding.default).responseJSON { responce in
            switch responce.result{
            case.success(let data):
                SVProgressHUD.dismiss()
                
                let Response = JSON(data)
                print(Response)
                print(RequestString.latest)
                
                
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
                    self.latestNewsList.append(obj)
                }

                self.talestNewsTable.reloadData()
                
                
            case.failure(let error):
                print("failed\(error)")
            }
        }
    }
    
    //////////////////////////////////   photo stories /////////////////////////////
    
    func GetPhotoStoriesDate(){
        SVProgressHUD.show()
        
        Alamofire.request(RequestString.photoSlider, method: .get, encoding: JSONEncoding.default).responseJSON { responce in
            switch responce.result{
            case.success(let data):
                SVProgressHUD.dismiss()
                
                let Response = JSON(data)
                print(Response)
                print(RequestString.photoSlider)
                
                
                for result in Response.arrayValue {
                    let palbum_id = result["palbum_id"].stringValue
                    let palbum_title = result["palbum_title"].stringValue
                    let pai_image = result["pai_image"].stringValue
                    
                    let obj = ["palbum_id": palbum_id, "palbum_title": palbum_title, "pai_image": pai_image]
                    let obj2 = ["pai_image": pai_image]
                    self.photoStories.append(obj)
                    self.photoStoriesImageUrlList.append(obj2)
                }
                
                let photoStoriesTitle = self.photoStories[0]
                self.photoStoriesTitleLabel.text=photoStoriesTitle["palbum_title"]
                
                self.photoStoriesBanner.backgroundColor = UIColor.white
                self.photoStoriesBanner.slideshowInterval = 5.0
                self.photoStoriesBanner.pageControlPosition = PageControlPosition.underScrollView
                self.photoStoriesBanner.pageControl.currentPageIndicatorTintColor = UIColor.lightGray
                self.photoStoriesBanner.pageControl.pageIndicatorTintColor = UIColor.black
                self.photoStoriesBanner.contentScaleMode = UIViewContentMode.scaleAspectFill
                
                self.photoStoriesBanner.activityIndicator = DefaultActivityIndicator()
                self.photoStoriesBanner.currentPageChanged = { page in
                    let photoStoriesTitle = self.petitions[0]
                    self.photoStoriesTitleLabel.text=photoStoriesTitle["palbum_title"]
                }
                for imageUrl in self.photoStoriesImageUrlList {
                    self.photoStoriesDownloadImageUrlList.append(AlamofireSource(urlString:  imageUrl["pai_image"]!)!)
                }
                
                self.photoStoriesBanner.setImageInputs(self.photoStoriesDownloadImageUrlList)
                
            case.failure(let error):
                print("failed\(error)")
            }
        }
    }
    
    func photoStoriesTap() {
                let fullScreenController = topBanner.presentFullScreenController(from: self)
                // set the activity indicator for full screen controller (skipping the line will show no activity indicator)
                fullScreenController.slideshow.activityIndicator = DefaultActivityIndicator(style: .white, color: nil)

    }
    
}
