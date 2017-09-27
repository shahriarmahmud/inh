//
//  PhotoGalleryViewController.swift
//  inh
//
//  Created by Priom on 9/16/17.
//  Copyright © 2017 BizTech. All rights reserved.
//

import UIKit
import ImageSlideshow
import Alamofire
import AlamofireImage
import SwiftyJSON
import SVProgressHUD

class PhotoGalleryViewController: UIViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var topBanner: ImageSlideshow!
    
    @IBOutlet weak var photoDescription: UILabel!
    
    var petitions = [[String: String]]()
    var imageUrlList = [[String: String]]()
    var downloadImageUrlList = [AlamofireSource]()
    var albumId = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        GEtServerDate()
        
//        let recognizer = UITapGestureRecognizer(target: self, action: #selector(TopStoriesViewController.didTap))
//        topBanner.addGestureRecognizer(recognizer)

    }
    
    func didTap() {
        //        let fullScreenController = topBanner.presentFullScreenController(from: self)
        //        // set the activity indicator for full screen controller (skipping the line will show no activity indicator)
        //        fullScreenController.slideshow.activityIndicator = DefaultActivityIndicator(style: .white, color: nil)
        
        let navigationViewController = self.storyboard?.instantiateViewController(withIdentifier: "SportsViewController") as! SportsViewController
        self.navigationController?.pushViewController(navigationViewController, animated: true)
    }
    
    func GEtServerDate(){
        SVProgressHUD.show()
        
        Alamofire.request(RequestString.photoSlider+"="+albumId, method: .get, encoding: JSONEncoding.default).responseJSON { responce in
            switch responce.result{
            case.success(let data):
                SVProgressHUD.dismiss()
                
                let Response = JSON(data)
                print(Response)
                print(RequestString.topnews)
                
                
                for result in Response.arrayValue {
                    let pai_id = result["pai_id"].stringValue
                    let pai_caption = result["pai_caption"].stringValue
                    let pai_description = result["pai_description"].stringValue
                    let pai_image = result["pai_image"].stringValue
                    let pai_image_thumb = result["pai_image_thumb"].stringValue
                    
                    let obj = ["pai_id": pai_id, "pai_caption": pai_caption, "pai_description": pai_description, "pai_image": pai_image, "pai_image_thumb": pai_image_thumb]
                    let obj2 = ["pai_image": pai_image]
                    self.petitions.append(obj)
                    self.imageUrlList.append(obj2)
                }
                
                let titleText = self.petitions[0]
                self.titleLabel.text=titleText["pai_caption"]
                if(titleText["pai_description"]?.isEmpty)!{
                    self.photoDescription.text = ""
                }else{
                    self.photoDescription.text = titleText["pai_description"]
                }
                
                self.topBanner.backgroundColor = UIColor.black
                self.topBanner.slideshowInterval = 5.0
                self.topBanner.pageControlPosition = PageControlPosition.underScrollView
                self.topBanner.pageControl.currentPageIndicatorTintColor = UIColor.lightGray
                self.topBanner.pageControl.pageIndicatorTintColor = UIColor.black
                self.topBanner.contentScaleMode = UIViewContentMode.scaleAspectFit
                
                self.topBanner.activityIndicator = DefaultActivityIndicator()
                self.topBanner.currentPageChanged = { page in
                    let titleText = self.petitions[page]
                    self.titleLabel.text=titleText["pai_caption"]
                    if(titleText["pai_description"]?.isEmpty)!{
                        self.photoDescription.text = ""
                    }else{
                        self.photoDescription.text = titleText["pai_description"]
                    }
                }
                for imageUrl in self.imageUrlList {
                    self.downloadImageUrlList.append(AlamofireSource(urlString:  imageUrl["pai_image"]!)!)
                }
                
                self.topBanner.setImageInputs(self.downloadImageUrlList)
                
                
                
                
            case.failure(let error):
                print("failed\(error)")
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}
