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

class TopStoriesViewController: UIViewController {
    
    open override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var topBanner: ImageSlideshow!
    
    var petitions = [[String: String]]()
    var imageUrlList = [[String: String]]()
    
    var downloadImageUrlList = [AlamofireSource]()
    
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
       
        GEtServerDate()
        
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(TopStoriesViewController.didTap))
        topBanner.addGestureRecognizer(recognizer)

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
}
