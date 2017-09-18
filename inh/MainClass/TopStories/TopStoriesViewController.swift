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

class TopStoriesViewController: UIViewController , UITableViewDelegate, UITableViewDataSource,UICollectionViewDelegate,UICollectionViewDataSource{
    
    open override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
    @IBOutlet weak var scrollview: UIScrollView!
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var topBanner: ImageSlideshow!
    
    var petitions = [[String: String]]()
    var imageUrlList = [[String: String]]()
    var downloadImageUrlList = [AlamofireSource]()
    
    //latest news
    @IBOutlet weak var talestNewsTable: UITableView!
    
    var latestNewsList = [[String: String]]()
    
    //photostories
    @IBOutlet weak var photoStoriesCollection: UICollectionView!
    
    var photoStories = [[String: String]]()
    
    //sectionData
    var sectionList = [[String: String]]()
    
    //sectionNewsData
    @IBOutlet weak var sectionNewsTable: UITableView!
    
    var sectionNewsList = [[String: String]]()
    
    //video Slider
    var videoSliderList = [[String: String]]()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.automaticallyAdjustsScrollViewInsets = false
        talestNewsTable.dataSource = self
        talestNewsTable.delegate = self
        scrollview.contentSize = CGSize(width: 400, height: 2000)
        GEtServerDate()
        //latestNews
        GetLatestNewsData()
        
        // photoStories
        GetPhotoStoriesDate()
        
        //sectionData
        GetSectionData()
        
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(TopStoriesViewController.didTap))
        topBanner.addGestureRecognizer(recognizer)

    }
    
    func didTap() {
//        let fullScreenController = topBanner.presentFullScreenController(from: self)
//        // set the activity indicator for full screen controller (skipping the line will show no activity indicator)
//        fullScreenController.slideshow.activityIndicator = DefaultActivityIndicator(style: .white, color: nil)
        
        let petition = petitions[topBanner.currentPage]
        
        let navigationViewController = self.storyboard?.instantiateViewController(withIdentifier: "OnClickViewController") as! OnClickViewController
        navigationViewController.ap_image = petition["ap_image"]!
        navigationViewController.mobile_news_url = petition["mobile_news_url"]!
        navigationViewController.share_url = petition["share_url"]!
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
        if(tableView == talestNewsTable){
            return latestNewsList.count
        }else{
            return sectionList.count
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if(tableView == talestNewsTable){
            let row = indexPath.row
            print("Row: \(row)")
            let petition = latestNewsList[indexPath.row]
            
            let navigationViewController = self.storyboard?.instantiateViewController(withIdentifier: "OnClickViewController") as! OnClickViewController
            navigationViewController.ap_image = petition["ap_image"]!
            navigationViewController.mobile_news_url = petition["mobile_news_url"]!
            navigationViewController.share_url = petition["share_url"]!
            self.navigationController?.pushViewController(navigationViewController, animated: true)
        }else{
            let row = indexPath.row
            print("Row: \(row)")
            let petition = sectionNewsList[indexPath.row]
            print(petition)
            
            let navigationViewController = self.storyboard?.instantiateViewController(withIdentifier: "OnClickViewController") as! OnClickViewController
            navigationViewController.ap_image = petition["ap_image"]!
            navigationViewController.mobile_news_url = petition["mobile_news_url"]!
            navigationViewController.share_url = petition["share_url"]!
            self.navigationController?.pushViewController(navigationViewController, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if(tableView == talestNewsTable){
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
        }else{
            let cell:SectionNewsTableViewCell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! SectionNewsTableViewCell
            
            let sectionData = sectionList[indexPath.row]
            print(sectionData)
            
            cell.videoSection.isHidden=true
            cell.collectionView.isHidden=true
            cell.authorLabelHeight.constant = -180; //Hide
//            sectionNewsTable.rowHeight = 400
//            cell.wholeView.frame = CGRect(origin: CGPoint(x: 8, y :8), size: CGSize(width: cell.wholeView.frame.size.width, height: 460))
            
            if(indexPath.row==1){
                cell.videoSection.isHidden=false
                cell.collectionView.isHidden=false
                
                cell.authorLabelHeight.constant = 0; //Show
//                sectionNewsTable.rowHeight = 570
                
//                cell.wholeView.frame = CGRect(origin: CGPoint(x: 8, y :8), size: CGSize(width: cell.wholeView.frame.size.width, height: cell.wholeView.frame.size.height))

                Alamofire.request(RequestString.videoSlider, method: .get, encoding: JSONEncoding.default).responseJSON { responce in
                    switch responce.result{
                    case.success(let data):
                        
                        let Response = JSON(data)
                        print("TopStories",Response)
                        print(RequestString.videoSlider)
                        
                        self.sectionNewsList.removeAll()
                        for result in Response.arrayValue {
                            let vblog_id = result["vblog_id"].stringValue
                            let vblog_title = result["vblog_title"].stringValue
                            let player = result["player"].stringValue
                            
                            let thumb = result["thumb"].stringValue
                            let vblog_youtube = result["vblog_youtube"].stringValue
                            
                            let obj = ["vblog_id": vblog_id, "vblog_title": vblog_title, "player": player, "thumb": thumb, "vblog_youtube": vblog_youtube]
                            self.videoSliderList.append(obj)
                            
                            cell.passValue(VideoSliderList: self.videoSliderList)
                            cell.collectionView.reloadData()
                        }
                    case.failure(let error):
                        print("failed\(error)")
                    }
                }
            }
            
            Alamofire.request(RequestString.topSection+sectionData["category_id"]!, method: .get, encoding: JSONEncoding.default).responseJSON { responce in
                switch responce.result{
                case.success(let data):
                    
                    let Response = JSON(data)
                    print(Response)
                    print(RequestString.topSection+sectionData["category_id"]!)
                    
                    self.sectionNewsList.removeAll()
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
                        self.sectionNewsList.append(obj)
                    }

//                    let sectionNewsData = self.sectionNewsList[indexPath.row]
//                    
                    print(self.sectionNewsList)
                    
                    if(self.sectionNewsList[0]["art_title"]?.isEmpty)!{
                        cell.titleLabel.text = ""
                    }else{
                        cell.titleLabel.text = self.sectionNewsList[0]["art_title"]!
                    }
                    
                    if(self.sectionNewsList[0]["ap_thumb_image"]?.isEmpty)!{
                        cell.titleImage.image = nil
                    }else{
                        Alamofire.request(self.sectionNewsList[0]["ap_thumb_image"]!).responseImage { response in
                            debugPrint(response)
                            debugPrint(response.result)
                            
                            if let image = response.result.value {
                                print("image downloaded: \(image)")
                                cell.titleImage.image = image
                            }
                        }
                    }
                    
                    if(sectionData["category_name"]?.isEmpty)!{
                        cell.SectionTitleLabel.text = ""
                    }else{
                        cell.SectionTitleLabel.text = sectionData["category_name"]!
                    }
                    
                    //1st
                    if(self.sectionNewsList[1]["X_hours_ago"]?.isEmpty)!{
                        cell.postingTimeLabel.text = ""
                    }else{
                        cell.postingTimeLabel.text = self.sectionNewsList[1]["X_hours_ago"]!
                    }
                    
                    if(self.sectionNewsList[1]["art_title"]?.isEmpty)!{
                        cell.thumbnailLabel.text = ""
                    }else{
                        cell.thumbnailLabel.text = self.sectionNewsList[1]["art_title"]!
                    }
                    
                    if(self.sectionNewsList[1]["ap_thumb_image"]?.isEmpty)!{
                        cell.thumbnailImage.image = nil
                    }else{
                        Alamofire.request(self.sectionNewsList[1]["ap_thumb_image"]!).responseImage { response in
                            debugPrint(response)
                            debugPrint(response.result)
                            
                            if let image = response.result.value {
                                print("image downloaded: \(image)")
                                cell.thumbnailImage.image = image
                            }
                        }
                    }

                    //2nd
                    if(self.sectionNewsList[2]["X_hours_ago"]?.isEmpty)!{
                        cell.postingTime2ndLabel.text = ""
                    }else{
                        cell.postingTime2ndLabel.text = self.sectionNewsList[2]["X_hours_ago"]!
                    }
                    
                    if(self.sectionNewsList[2]["art_title"]?.isEmpty)!{
                        cell.thumbnail2ndLabel.text = ""
                    }else{
                        cell.thumbnail2ndLabel.text = self.sectionNewsList[2]["art_title"]!
                    }
                    
                    if(self.sectionNewsList[2]["ap_thumb_image"]?.isEmpty)!{
                        cell.thumbnail2ndImage.image = nil
                    }else{
                        Alamofire.request(self.sectionNewsList[2]["ap_thumb_image"]!).responseImage { response in
                            debugPrint(response)
                            debugPrint(response.result)
                            
                            if let image = response.result.value {
                                print("image downloaded: \(image)")
                                cell.thumbnail2ndImage.image = image
                            }
                        }
                    }
                    
                    //3rd
                    if(self.sectionNewsList[3]["X_hours_ago"]?.isEmpty)!{
                        cell.postingTime3rdLabel.text = ""
                    }else{
                        cell.postingTime3rdLabel.text = self.sectionNewsList[3]["X_hours_ago"]!
                    }
                    
                    if(self.sectionNewsList[3]["art_title"]?.isEmpty)!{
                        cell.thumbnail3rdLabel.text = ""
                    }else{
                        cell.thumbnail3rdLabel.text = self.sectionNewsList[3]["art_title"]!
                    }
                    
                    if(self.sectionNewsList[3]["ap_thumb_image"]?.isEmpty)!{
                        cell.thumbnail3rdImage.image = nil
                    }else{
                        Alamofire.request(self.sectionNewsList[3]["ap_thumb_image"]!).responseImage { response in
                            debugPrint(response)
                            debugPrint(response.result)
                            
                            if let image = response.result.value {
                                print("image downloaded: \(image)")
                                cell.thumbnail3rdImage.image = image
                            }
                        }
                    }
                    
                    //4th
                    if(self.sectionNewsList[4]["X_hours_ago"]?.isEmpty)!{
                        cell.postingTime4thLabel.text = ""
                    }else{
                        cell.postingTime4thLabel.text = self.sectionNewsList[4]["X_hours_ago"]!
                    }
                    
                    if(self.sectionNewsList[4]["art_title"]?.isEmpty)!{
                        cell.thumbnail4thLabel.text = ""
                    }else{
                        cell.thumbnail4thLabel.text = self.sectionNewsList[4]["art_title"]!
                    }
                    
                    if(self.sectionNewsList[4]["ap_thumb_image"]?.isEmpty)!{
                        cell.thumbnail4thImage.image = nil
                    }else{
                        Alamofire.request(self.sectionNewsList[4]["ap_thumb_image"]!).responseImage { response in
                            debugPrint(response)
                            debugPrint(response.result)
                            
                            if let image = response.result.value {
                                print("image downloaded: \(image)")
                                cell.thumbnail4thImage.image = image
                            }
                        }
                    }
                    
                    //5th
                    if(self.sectionNewsList[5]["X_hours_ago"]?.isEmpty)!{
                        cell.postingTime5thLabel.text = ""
                    }else{
                        cell.postingTime5thLabel.text = self.sectionNewsList[5]["X_hours_ago"]!
                    }
                    
                    if(self.sectionNewsList[5]["art_title"]?.isEmpty)!{
                        cell.thumbnail5thLabel.text = ""
                    }else{
                        cell.thumbnail5thLabel.text = self.sectionNewsList[5]["art_title"]!
                    }
                    
                    if(self.sectionNewsList[5]["ap_thumb_image"]?.isEmpty)!{
                        cell.thumbnail5thImage.image = nil
                    }else{
                        Alamofire.request(self.sectionNewsList[5]["ap_thumb_image"]!).responseImage { response in
                            debugPrint(response)
                            debugPrint(response.result)
                            
                            if let image = response.result.value {
                                print("image downloaded: \(image)")
                                cell.thumbnail5thImage.image = image
                            }
                        }
                    }
                    
                case.failure(let error):
                    print("failed\(error)")
                }
            }
            
            return cell
        }
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
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photoStories.count
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let row = indexPath.row
        print("Row: \(row)")
        
        //            print(meetingArray[row] as! String)
        
        let navigationViewController = self.storyboard?.instantiateViewController(withIdentifier: "PhotoGalleryViewController") as! PhotoGalleryViewController
        let photoStory = photoStories[row]
        navigationViewController.albumId = photoStory["palbum_id"]!
        self.navigationController?.pushViewController(navigationViewController, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "photoStories", for: indexPath) as! PhotoStoriesCollectionViewCell
        
        print(photoStories)
        print(indexPath.row)
        
        if(photoStories.count>0){
            let photoStory = photoStories[indexPath.row]
            
            print("ghum",photoStory)
            
            cell.photoStoriesLabel.text = photoStory["palbum_title"]
            
            Alamofire.request(photoStory["pai_image"]!).responseImage { response in
                debugPrint(response)
                debugPrint(response.result)
                
                if let image = response.result.value {
                    print("image downloaded: \(image)")
                    cell.photoStoriesImage.image = image
                }
            }
        }
        return cell
    }

    
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
                    self.photoStories.append(obj)
                }
                
                self.photoStoriesCollection.reloadData()

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
    
    //////////////////////////////////   Section News /////////////////////////////
    
    func GetSectionData(){
        SVProgressHUD.show()
        
        Alamofire.request(RequestString.section, method: .get, encoding: JSONEncoding.default).responseJSON { responce in
            switch responce.result{
            case.success(let data):
                SVProgressHUD.dismiss()
                
                let Response = JSON(data)
                print(Response)
                print("aaaaaaaaaaaaaaa@@##aaaaaaaaaa",RequestString.section)
                
                
                for result in Response.arrayValue {
                    let category_name = result["category_name"].stringValue
                    let category_id = result["category_id"].stringValue
                    
                    let obj = ["category_name": category_name, "category_id": category_id]
                    self.sectionList.append(obj)
                }
                
                self.sectionNewsTable.reloadData()
                
            case.failure(let error):
                print("failed\(error)")
            }
        }
    }

}
