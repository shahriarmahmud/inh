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

class TopStoriesViewController: BaseViewController , UITableViewDelegate, UITableViewDataSource,UICollectionViewDelegate,UICollectionViewDataSource,UIGestureRecognizerDelegate{
    
    open override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
    @IBOutlet weak var scrollview: UIScrollView!
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var topBanner: ImageSlideshow!
    
    @IBOutlet weak var headerView: UIView!
    var refreshControl: UIRefreshControl!
    
    var petitions = [[String: String]]()
    var imageUrlList = [[String: String]]()
    var downloadImageUrlList = [AlamofireSource]()

    var globalArray = [[String: Any]]()

    
    //latest news
    @IBOutlet weak var talestNewsTable: UITableView!
    
    var latestNewsList = [[String: String]]()
    
    //photostories
    @IBOutlet weak var photoStorieView: UIView!
    @IBOutlet weak var photoStoriesCollection: UICollectionView!
    
    var photoStories = [[String: String]]()
    
    //sectionData
    var sectionList = [[String: String]]()
    
    //sectionNewsData
    @IBOutlet weak var sectionNewsTable: UITableView!
    
//    var sectionNewsList = [[String: String]]()
    var sectionNewsList: [Int: [[String: String]]] = [:]

    //video Slider
    var videoSliderList = [[String: String]]()
    
//    var currentThmeme = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        self.automaticallyAdjustsScrollViewInsets = false
        talestNewsTable.dataSource = self
        talestNewsTable.delegate = self
        
        sectionNewsTable.delegate = self
        sectionNewsTable.delegate = self
        
//        currentThmeme = UserDefaults.standard.string(forKey: "theme") ?? ""
//        if(!currentThmeme.isEmpty){
//            if(currentThmeme == "light"){
//                headerView.backgroundColor = UIColor(red: (255/255.0), green: (255/255.0), blue: (255/255.0), alpha: 1)
//                photoStorieView.backgroundColor = UIColor(red: (17/255.0), green: (33/255.0), blue: (76/255.0), alpha: 1)
//            }else{
//                headerView.backgroundColor = UIColor(red: (85/255.0), green: (85/255.0), blue: (85/255.0), alpha: 1)
//                photoStorieView.backgroundColor = UIColor(red: (85/255.0), green: (85/255.0), blue: (85/255.0), alpha: 1)
//            }
//        }else{
//            self.headerView.backgroundColor = UIColor(red: (255/255.0), green: (255/255.0), blue: (255/255.0), alpha: 1)
//            photoStorieView.backgroundColor = UIColor(red: (17/255.0), green: (33/255.0), blue: (76/255.0), alpha: 1)
//        }
        
        refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: Selector(("refresh:")), for: UIControlEvents.valueChanged)
    //    topBanner.addSubview(refreshControl) // not required when using UITableViewController
     //   headerView.addSubview(refreshControl)
        
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
    
//    override func viewWillAppear(_ animated: Bool) {
//        let currentThmeme = UserDefaults.standard.string(forKey: "theme") ?? ""
//        if(!currentThmeme.isEmpty){
//            if(currentThmeme == "light"){
//                headerView.backgroundColor = UIColor(red: (255/255.0), green: (255/255.0), blue: (255/255.0), alpha: 1)
//            }else{
//                headerView.backgroundColor = UIColor(red: (85/255.0), green: (85/255.0), blue: (85/255.0), alpha: 1)
//            }
//        }else{
//            self.headerView.backgroundColor = UIColor(red: (255/255.0), green: (255/255.0), blue: (255/255.0), alpha: 1)
//        }
//    }
    
    func refresh(_ sender:AnyObject) {
        // Code to refresh table view
        GEtServerDate()
        GetLatestNewsData()
        GetPhotoStoriesDate()
        GetSectionData()
        self.refreshControl.endRefreshing()
    }
    
    func didTap() {
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
                self.refreshControl.endRefreshing()
                
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
                
//                self.changeTextColor(currentThmeme: self.currentThmeme, titleLabel: self.titleLabel)
                
                self.topBanner.backgroundColor = UIColor.white
                self.topBanner.slideshowInterval = 999999999999999
                self.topBanner.contentScaleMode = UIViewContentMode.scaleAspectFill
                
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
        
        if(tableView == talestNewsTable)
        {
            print(latestNewsList.count)
            return latestNewsList.count
        }
        else
        {
            if(section==1){
                return 7
            }else{
               return 6
            }
            
            //}
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        if(tableView == talestNewsTable){
        
        //Get the height required for the TableView to show all cells
        if indexPath.row == (tableView.indexPathsForVisibleRows?.last! as! NSIndexPath).row {
            //End of loading all Visible cells
            let height = tableView.contentSize.height
            
            
            self.photoStorieView.frame = CGRect(x: 0, y: self.talestNewsTable.frame.origin.y+height, width: self.photoStorieView.frame.size.width, height: self.photoStorieView.frame.size.height)
            
            let header_height : CGFloat = self.photoStorieView.frame.size.height //190,36
            print(header_height)
            
            self.photoStoriesCollection.frame = CGRect(x: 0, y: self.photoStorieView.frame.origin.y+header_height, width: self.photoStoriesCollection.frame.size.width, height: self.photoStoriesCollection.frame.size.height)
            
            
            self.sectionNewsTable.frame = CGRect(x: 0, y: self.photoStoriesCollection.frame.origin.y+self.photoStoriesCollection.frame.size.height, width: self.photoStoriesCollection.frame.size.width, height: self.photoStoriesCollection.frame.size.height)
            //If cell's are more than 10 or so that it could not fit on the tableView's visible area then you have to go for other way to check for last cell loaded
            }
        
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
        }
        else{
            let row = indexPath.row
            print("Row: \(row)")
            
            if(indexPath.section==1 && indexPath.row==6)
            {
                let cell:SectionNewsTableViewCell = tableView.dequeueReusableCell(withIdentifier: "cell_video", for: indexPath) as! SectionNewsTableViewCell
                
                cell.collectionView(cell.collectionView, didSelectItemAt: indexPath)
            }
            else
            {
                if(globalArray.count==6){
                    
                    print(globalArray)
                    let listData = globalArray[indexPath.section]
                    print(listData)
                    
                    let data  =  JSON(listData["rowValue"] ?? "")
                    let sectionData = data.arrayValue

                        print(sectionData)
                        print(sectionData[row]["art_title"])

                        let navigationViewController = self.storyboard?.instantiateViewController(withIdentifier: "OnClickViewController") as! OnClickViewController
                        navigationViewController.ap_image = sectionData[row]["ap_image"].stringValue
                        navigationViewController.mobile_news_url = sectionData[row]["mobile_news_url"].stringValue
                        navigationViewController.share_url = sectionData[row]["share_url"].stringValue
                        self.navigationController?.pushViewController(navigationViewController, animated: true)
                }
            }
            

            
        }
    }

    
    func numberOfSections(in tableView: UITableView) -> Int
    {
        if(tableView==sectionNewsTable){
            return 6
        }else{
           return 1
        }
    }

    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        if(tableView == sectionNewsTable)
        {
            print(globalArray)
            let header = tableView.dequeueReusableCell(withIdentifier: "cell_header") as! SectionNewsTableViewCell
         
            
            if(globalArray.count==6){
                print(globalArray.count)
                print(section)

                print(globalArray)
                let listData = globalArray[section]
                let HeadArray = listData["headValue"]
                print(HeadArray ?? "")
                

                
                header.SectionTitleLabel.text = HeadArray as? String
                
//                changeSectionTextColor(currentThmeme: currentThmeme, sectionView: header.sectionTableView, sectionText: header.SectionTitleLabel)

            }
            return header
            
        }
        else
        {
            return nil
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        if(tableView == sectionNewsTable){
            return 36
        }else{
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if(tableView == sectionNewsTable){
            if(indexPath.row==0){
                return 280
            }
            else if(indexPath.section==1 && indexPath.row==6){
               return 250
            }else{
                return 92
            }
            
        }else{
            return 76
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
            
            
            
//            if(!currentThmeme.isEmpty){
//                if(currentThmeme == "light"){
//                    cell.customSeparator.backgroundColor = UIColor(red: (236/255.0), green: (236/255.0), blue: (236/255.0), alpha: 1)
//                    cell.titleLabel.textColor = UIColor(red: (0), green: (0), blue: (0), alpha: 1)
//                    cell.timeLabel.textColor = UIColor(red: (0), green: (0), blue: (0), alpha: 1)
//                    talestNewsTable.separatorColor = UIColor(red: (236/255.0), green: (236/255.0), blue: (236/255.0), alpha: 1)
//                }else{
//                    cell.customSeparator.backgroundColor = UIColor(red: (24/255.0), green: (24/255.0), blue: (24/255.0), alpha: 1)
//                    cell.titleLabel.textColor = UIColor(red: (255/255.0), green: (255/255.0), blue: (255/255.0), alpha: 1)
//                    cell.timeLabel.textColor = UIColor(red: (255/255.0), green: (255/255.0), blue: (255/255.0), alpha: 1)
//                    talestNewsTable.separatorColor = UIColor(red: (24/255.0), green: (24/255.0), blue: (24/255.0), alpha: 1)
//                }
//            }else{
//                cell.customSeparator.backgroundColor = UIColor(red: (236/255.0), green: (236/255.0), blue: (236/255.0), alpha: 1)
//                cell.titleLabel.textColor = UIColor(red: (0), green: (0), blue: (0), alpha: 1)
//                cell.timeLabel.textColor = UIColor(red: (0), green: (0), blue: (0), alpha: 1)
//                talestNewsTable.separatorColor = UIColor(red: (236/255.0), green: (236/255.0), blue: (236/255.0), alpha: 1)
//            }
            
            
            if(latestNews["X_hours_ago"]?.isEmpty)!{
                cell.timeLabel.text = ""
            }else{
                cell.timeLabel.text = latestNews["X_hours_ago"]!
            }
            
            
            if(latestNews["ap_image"]?.isEmpty)!{
                cell.headerImage.image = nil
            }else{
                Alamofire.request(latestNews["ap_image"]!).responseImage { response in
                    debugPrint(response)
                    debugPrint(response.result)
                    
                    if let image = response.result.value {
                        print("image downloaded: \(image)")
                        cell.headerImage.image = image
                    }
                }
            }
            
            if(latestNews["art_has_video"]!=="1"){
               cell.videoImage.isHidden = false
            }else{
                cell.videoImage.isHidden = true
            }
            
            
            return cell
        }
        else
        {
            let row = indexPath.row
            print(row)
            
//            let currentThmeme = UserDefaults.standard.string(forKey: "theme") ?? ""

            if(indexPath.section==1){
                
                let cell:SectionNewsTableViewCell = tableView.dequeueReusableCell(withIdentifier: "cell_body", for: indexPath) as! SectionNewsTableViewCell
                
                
                if(globalArray.count==6){
                    print(globalArray.count)
                    print(row)
                    
                    print(globalArray)
                    let listData = globalArray[indexPath.section]
                    print(listData)
                    
                    let data  =  JSON(listData["rowValue"] ?? "")
                    let sectionData = data.arrayValue
                    
                    if(sectionData.count==6){
                        
                        if(row==6){
                            
                            let cell:SectionNewsTableViewCell = tableView.dequeueReusableCell(withIdentifier: "cell_video", for: indexPath) as! SectionNewsTableViewCell
                            
                            
                            cell.videoSection.isHidden=false
                            cell.collectionView.isHidden=false
                            
                            cell.collectionView.frame = CGRect(x: 0, y: cell.videoSection.frame.origin.y+cell.videoSection.frame.size.height, width: cell.collectionView.frame.size.width, height: cell.collectionView.frame.size.height)
                            
//                            if(!currentThmeme.isEmpty){
//                                if(currentThmeme == "light"){
//                                    cell.videoSection.backgroundColor = UIColor(red: (17/255.0), green: (33/255.0), blue: (76/255.0), alpha: 1)
//                                }else{
//                                    cell.videoSection.backgroundColor = UIColor(red: (85/255.0), green: (85/255.0), blue: (85/255.0), alpha: 1)
//                                }
//                            }else{
//                                cell.videoSection.backgroundColor = UIColor(red: (17/255.0), green: (33/255.0), blue: (76/255.0), alpha: 1)
//                            }

                            Alamofire.request(RequestString.videoSlider, method: .get, encoding: JSONEncoding.default).responseJSON { responce in
                                switch responce.result{
                                case.success(let data):
                                    
                                    let Response = JSON(data)
                                    print("TopStories",Response)
                                    print(RequestString.videoSlider)
                                    
                                    
                                    for result in Response.arrayValue {
                                        let vblog_id = result["vblog_id"].stringValue
                                        let vblog_title = result["vblog_title"].stringValue
                                        let player = result["player"].stringValue
                                        
                                        let thumb = result["thumb"].stringValue
                                        let vblog_youtube = result["vblog_youtube"].stringValue
                                        
                                        let obj = ["vblog_id": vblog_id, "vblog_title": vblog_title, "player": player, "thumb": thumb, "vblog_youtube": vblog_youtube]
                                        self.videoSliderList.append(obj)
                                        
                                        cell.passValue(VideoSliderList: self.videoSliderList)
                                        cell.initializeView(ui: self)
                                        cell.collectionView.reloadData()
                                    }
                                case.failure(let error):
                                    print("failed\(error)")
                                }
                            }
                        }
                        else if(row==0){
                            
                         let cell  = tableView.dequeueReusableCell(withIdentifier: "cell_title", for: indexPath) as! SectionNewsTableViewCell
                            
                            if(sectionData[row]["art_has_video"]=="1"){
                                cell.videoImage.isHidden = false
                            }else{
                                cell.videoImage.isHidden = true
                            }

                            
                            Alamofire.request((sectionData[row]["ap_image"].stringValue)).responseImage { response in
                                debugPrint(response)
                                debugPrint(response.result)
                                
                                if let image = response.result.value {
                                    print("image downloaded: \(image)")
                                    cell.titleImage.image = image
                                }
                            }
                            
                            cell.titleLabel.text = sectionData[row]["art_title"].stringValue
                            
//                            changeTextColor(currentThmeme: currentThmeme, titleLabel: cell.titleLabel)
                        }
                        else
                        {
                            print(row)
                            print(sectionData)
                            print(sectionData.count)
                            print(sectionData[row]["X_hours_ago"])
                            
                            if(sectionData[row]["art_has_video"]=="1"){
                                cell.videoImage_body.isHidden = false
                            }else{
                                cell.videoImage_body.isHidden = true
                            }

//                            changeTextColor(currentThmeme: currentThmeme, titleLabel: cell.thumbnailLabel,time: cell.postingTimeLabel)
                            
                            cell.postingTimeLabel.text = sectionData[row]["X_hours_ago"].stringValue
                            cell.thumbnailLabel.text = sectionData[row]["art_title"].stringValue
                            Alamofire.request(sectionData[row]["ap_image"].stringValue).responseImage { response in
                                debugPrint(response)
                                debugPrint(response.result)
                                
                                if let image = response.result.value {
                                    print("image downloaded: \(image)")
                                    cell.thumbnailImage.image = image
                                }
                            }
                        }

                    }
                }
                
                
                return cell
            }
            
            else if(row == 0)
            {
                let cell:SectionNewsTableViewCell = tableView.dequeueReusableCell(withIdentifier: "cell_title", for: indexPath) as! SectionNewsTableViewCell
                
                if(globalArray.count==6){
                    print(globalArray.count)
                    
                    
                    print(globalArray)
                    let listData = globalArray[indexPath.section]
                    let HeadArray = listData["headValue"]
                    print(HeadArray ?? "")
                
                                let data  =  JSON(listData["rowValue"] ?? "")
                                let sectionData = data.arrayValue
                
                                print(sectionData[row]["art_title"])
                    
                    if(sectionData[row]["art_has_video"]=="1"){
                        cell.videoImage.isHidden = false
                    }else{
                        cell.videoImage.isHidden = true
                    }

    
                
                                Alamofire.request((sectionData[row]["ap_image"].stringValue)).responseImage { response in
                                    debugPrint(response)
                                    debugPrint(response.result)
                
                                    if let image = response.result.value {
                                        print("image downloaded: \(image)")
                                        cell.titleImage.image = image
                                    }
                                }
                                
                                cell.titleLabel.text = sectionData[row]["art_title"].stringValue
//                    changeTextColor(currentThmeme: currentThmeme, titleLabel: cell.titleLabel)
                }
            
            
                return cell
            }
            
            else
            {
                let cell:SectionNewsTableViewCell = tableView.dequeueReusableCell(withIdentifier: "cell_body", for: indexPath) as! SectionNewsTableViewCell

            if(globalArray.count==6){
            print(globalArray.count)
            print(row)
            
            print(globalArray)
            let listData = globalArray[indexPath.section]
            print(listData)
            
            let data  =  JSON(listData["rowValue"] ?? "")
            let sectionData = data.arrayValue
            
                if(sectionData.count==6){
                    
                    
                    
                    print(sectionData)
                    print(sectionData[row]["art_title"])
                    
                    if(sectionData[row]["art_has_video"]=="1"){
                        cell.videoImage_body.isHidden = false
                    }else{
                        cell.videoImage_body.isHidden = true
                    }


                    cell.postingTimeLabel.text = sectionData[row]["X_hours_ago"].stringValue
                    cell.thumbnailLabel.text = sectionData[row]["art_title"].stringValue
                    Alamofire.request(sectionData[row]["ap_image"].stringValue).responseImage { response in
                        debugPrint(response)
                        debugPrint(response.result)
                        
                        if let image = response.result.value {
                            print("image downloaded: \(image)")
                            cell.thumbnailImage.image = image
                        }
                    }
//                    changeTextColor(currentThmeme: currentThmeme, titleLabel: cell.thumbnailLabel,time: cell.postingTimeLabel)
                }
                }
                
        
                return cell
            }
        }
    }
    
    func GetLatestNewsData(){
        SVProgressHUD.show()
        
        Alamofire.request(RequestString.latest, method: .get, encoding: JSONEncoding.default).responseJSON { responce in
            switch responce.result{
            case.success(let data):
                SVProgressHUD.dismiss()
                self.refreshControl.endRefreshing()
                
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
                
                self.talestNewsTable.frame = CGRect(x: self.talestNewsTable.frame.origin.x, y: self.talestNewsTable.frame.origin.y, width: self.talestNewsTable.frame.size.width, height: (self.talestNewsTable.rowHeight * CGFloat(self.latestNewsList.count)))
                
                
                var tableViewHeight: CGFloat {
                    self.talestNewsTable.layoutIfNeeded()
                    
                    return self.talestNewsTable.contentSize.height
                }
            
                
               
                
                
                
//                scrollView.contentSize = CGSize(width: view.frame.size.width, height: visaTransactionTable.frame.origin.y + visaTransactionTable.frame.size.height)
                
                
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
 
//            let currentThmeme = UserDefaults.standard.string(forKey: "theme") ?? ""
//            if(!currentThmeme.isEmpty){
//                if(currentThmeme == "light"){
//                    cell.photoStoryView.backgroundColor = UIColor(red: (17/255.0), green: (33/255.0), blue: (76/255.0), alpha: 1)
//                    cell.photoStoriesLabel.textColor = UIColor(red: (0), green: (0), blue: (0), alpha: 1)
//                }else{
//                    cell.photoStoryView.backgroundColor = UIColor(red: (85/255.0), green: (85/255.0), blue: (85/255.0), alpha: 1)
//                    cell.photoStoriesLabel.textColor = UIColor(red: (255/255.0), green: (255/255.0), blue: (255/255.0), alpha: 1)
//                }
//            }else{
//                cell.photoStoryView.backgroundColor = UIColor(red: (17/255.0), green: (33/255.0), blue: (76/255.0), alpha: 1)
//                cell.photoStoriesLabel.textColor = UIColor(red: (0), green: (0), blue: (0), alpha: 1)
//            }
            
            Alamofire.request(photoStory["pai_image_original"]!).responseImage { response in
                debugPrint(response)
                debugPrint(response.result)
                
                if let image = response.result.value {
                    print("image downloaded: \(image)")
                    let size = CGSize(width: cell.photoStoriesImage.frame.size.width, height: cell.photoStoriesImage.frame.size.height)
                    
                    // Scale image to fit within specified size while maintaining aspect ratio
                    let aspectScaledToFitImage = image.af_imageAspectScaled(toFit: size)

                    cell.photoStoriesImage.image = aspectScaledToFitImage
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
                self.refreshControl.endRefreshing()
                
                let Response = JSON(data)
                print(Response)
                print(RequestString.photoSlider)
                
                
                for result in Response.arrayValue {
                    let palbum_id = result["palbum_id"].stringValue
                    let palbum_title = result["palbum_title"].stringValue
                    let pai_image_original = result["pai_image_original"].stringValue
                    
                    let obj = ["palbum_id": palbum_id, "palbum_title": palbum_title, "pai_image_original": pai_image_original]
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
                self.refreshControl.endRefreshing()
                
                let Response = JSON(data)
                print(Response)
                print("aaaaaaaaaaaaaaa@@##aaaaaaaaaa",RequestString.section)
                
                
                for result in Response.arrayValue {
                    let category_name = result["category_name"].stringValue
                    let category_id = result["category_id"].stringValue
                    
                    let obj = ["category_name": category_name, "category_id": category_id]
                    self.sectionList.append(obj)
                }

                print(self.sectionList)
                print(self.sectionList.count)
                
                    for i in 0 ..< self.sectionList.count
                    {
                        
                        Alamofire.request(RequestString.topSection+self.sectionList[i]["category_id"]!, method: .get, encoding: JSONEncoding.default).responseJSON { responce in
                        switch responce.result{
                        case.success(let data):
                            
                            let Response = JSON(data)
                            print(Response)
                            print(RequestString.topSection+self.sectionList[i]["category_id"]!)
                            
                            let dictionary = ["headValue" : self.sectionList[i]["category_name"] ?? "","rowValue" :data] as [String : Any]
                            
                            print(dictionary)
                            self.globalArray.append(dictionary)
                            
                            if(i==5)
                            {
                                print(self.globalArray)
                                self.sectionNewsTable.reloadData()
                            }
                            self.scrollview.contentSize = CGSize(width: self.scrollview.frame.size.width, height: self.sectionNewsTable.frame.origin.y + self.sectionNewsTable.frame.size.height)
                            
                            self.sectionNewsTable.frame = CGRect(x: self.sectionNewsTable.frame.origin.x, y: self.sectionNewsTable.frame.origin.y, width: self.sectionNewsTable.frame.size.width, height: self.sectionNewsTable.rowHeight * 36)
 
                        case.failure(let error):
                            print("failed\(error)")
                            }
                        }
                        
                    }
 
                
            case.failure(let error):
                print("failed\(error)")
            }
        }
    }
    
    
//    func changeTextColor(currentThmeme:String,titleLabel:UILabel){
//        if(!currentThmeme.isEmpty){
//            if(currentThmeme == "light"){
//                titleLabel.textColor = UIColor(red: (0), green: (0), blue: (0), alpha: 1)
//            }else{
//                titleLabel.textColor = UIColor(red: (255/255.0), green: (255/255.0), blue: (255/255.0), alpha: 1)
//            }
//        }else{
//            titleLabel.textColor = UIColor(red: (0), green: (0), blue: (0), alpha: 1)
//        }
//    }
//    
//    func changeTextColor(currentThmeme:String,titleLabel:UILabel,time:UILabel){
//        if(!currentThmeme.isEmpty){
//            if(currentThmeme == "light"){
//                titleLabel.textColor = UIColor(red: (0), green: (0), blue: (0), alpha: 1)
//                time.textColor = UIColor(red: (0), green: (0), blue: (0), alpha: 1)
//            }else{
//                titleLabel.textColor = UIColor(red: (255/255.0), green: (255/255.0), blue: (255/255.0), alpha: 1)
//                time.textColor = UIColor(red: (255/255.0), green: (255/255.0), blue: (255/255.0), alpha: 1)
//            }
//        }else{
//            titleLabel.textColor = UIColor(red: (0), green: (0), blue: (0), alpha: 1)
//            time.textColor = UIColor(red: (0), green: (0), blue: (0), alpha: 1)
//        }
//    }
//    
//    func changeSectionTextColor(currentThmeme:String,sectionView:UIView,sectionText:UILabel){
//        if(!currentThmeme.isEmpty){
//            if(currentThmeme == "light"){
//                sectionText.textColor = UIColor(red: (255/255.0), green: (255/255.0), blue: (255/255.0), alpha: 1)
//                sectionView.backgroundColor = UIColor(red: (17/255.0), green: (33/255.0), blue: (76/255.0), alpha: 1)
//            }else{
//                sectionText.textColor = UIColor(red: (255/255.0), green: (255/255.0), blue: (255/255.0), alpha: 1)
//                sectionView.backgroundColor = UIColor(red: (85/255.0), green: (85/255.0), blue: (85/255.0), alpha: 1)
//            }
//        }else{
//            sectionText.textColor = UIColor(red: (255/255.0), green: (255/255.0), blue: (255/255.0), alpha: 1)
//            sectionView.backgroundColor = UIColor(red: (17/255.0), green: (33/255.0), blue: (76/255.0), alpha: 1)
//        }
//    }
    
    
}
