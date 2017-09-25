//
//  SectionNewsTableViewCell.swift
//  inh
//
//  Created by Priom on 9/13/17.
//  Copyright © 2017 BizTech. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage

class SectionNewsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var titleImage: UIImageView!
    
    @IBOutlet weak var titleLabel: UILabel!

    @IBOutlet weak var SectionTitleLabel: UILabel!

    
    var SELF:UIViewController? = nil
    
    var appImage = ""
    var mobileNewsUrl = ""
    var shareUrl = ""
    
    //1st
    @IBOutlet weak var postingTimeLabel: UILabel!
    @IBOutlet weak var thumbnailLabel: UILabel!
    @IBOutlet weak var thumbnailImage: UIImageView!

    
    @IBOutlet weak var videoImage_body: UIImageView!
    @IBOutlet weak var videoImage: UIImageView!
    @IBOutlet weak var videoSection: UIView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var videoSliderList = [[String: String]]()

    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func forHeaderValue(Ap_image:String,Mobile_news_url:String,Share_url:String,ui:UIViewController){
        appImage = Ap_image
        mobileNewsUrl = Mobile_news_url
        shareUrl = Share_url
        SELF = ui
    }
    
    @IBAction func headerButtonClick(_ sender: Any) {
        let navigationViewController = SELF?.storyboard?.instantiateViewController(withIdentifier: "OnClickViewController") as! OnClickViewController
        navigationViewController.ap_image = appImage
        navigationViewController.mobile_news_url = mobileNewsUrl
        navigationViewController.share_url = shareUrl
        SELF?.navigationController?.pushViewController(navigationViewController, animated: true)
    }
    func passValue(VideoSliderList:[[String: String]]){
        videoSliderList = VideoSliderList
    }
    
    func initializeView(ui:UIViewController){
        SELF = ui
    }

}

extension SectionNewsTableViewCell : UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return videoSliderList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let row = indexPath.row
        print("Row: \(row)")
        let videoSlider = videoSliderList[row]
       let navigationViewController = SELF?.storyboard?.instantiateViewController(withIdentifier: "VideoViewController") as! VideoViewController
        
        navigationViewController.videoId = videoSlider["vblog_youtube"]!
        SELF?.navigationController?.pushViewController(navigationViewController, animated: true)

    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "videoCell", for: indexPath) as! VideoSliderCollectionViewCell
        
        print(videoSliderList)
        print(indexPath.row)
        
        if(videoSliderList.count>0){
            let videoSlider = videoSliderList[indexPath.row]
            
            print("ghum",videoSlider)
            
            cell.videoTitleLabel.text = videoSlider["vblog_title"]
            
            Alamofire.request(videoSlider["thumb"]!).responseImage { response in
                debugPrint(response)
                debugPrint(response.result)
                
                if let image = response.result.value {
                    print("image downloaded: \(image)")
                    let size = CGSize(width: cell.videoImage.frame.size.width, height: cell.videoImage.frame.size.height)
                    
                    // Scale image to fit within specified size while maintaining aspect ratio
                    let aspectScaledToFitImage = image.af_imageAspectScaled(toFit: size)

                    cell.videoImage.image = aspectScaledToFitImage
                }
            }
        }
        return cell
    }
    
}

extension SectionNewsTableViewCell : UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemsPerRow:CGFloat = 1
        let hardCodedPadding:CGFloat = 0
        let itemWidth = (collectionView.bounds.width / itemsPerRow) - hardCodedPadding
        let itemHeight = collectionView.bounds.height - (2 * hardCodedPadding)
        return CGSize(width: itemWidth, height: itemHeight)
    }
    
}
