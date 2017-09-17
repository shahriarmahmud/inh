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
    
    @IBOutlet weak var wholeView: UIView!
    @IBOutlet weak var SectionTitleLabel: UILabel!
    
    //1st
    @IBOutlet weak var postingTimeLabel: UILabel!
    @IBOutlet weak var thumbnailLabel: UILabel!
    @IBOutlet weak var thumbnailImage: UIImageView!
    
    //2nd
    @IBOutlet weak var postingTime2ndLabel: UILabel!
    @IBOutlet weak var thumbnail2ndLabel: UILabel!
    @IBOutlet weak var thumbnail2ndImage: UIImageView!
    
    //3rd
    @IBOutlet weak var postingTime3rdLabel: UILabel!
    @IBOutlet weak var thumbnail3rdLabel: UILabel!
    @IBOutlet weak var thumbnail3rdImage: UIImageView!
    
    //4th
    @IBOutlet weak var postingTime4thLabel: UILabel!
    @IBOutlet weak var thumbnail4thLabel: UILabel!
    @IBOutlet weak var thumbnail4thImage: UIImageView!
    
    //5th
    @IBOutlet weak var postingTime5thLabel: UILabel!
    @IBOutlet weak var thumbnail5thLabel: UILabel!
    @IBOutlet weak var thumbnail5thImage: UIImageView!
    
    @IBOutlet weak var videoSection: UIView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var videoSliderList = [[String: String]]()
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func passValue(VideoSliderList:[[String: String]]){
        videoSliderList = VideoSliderList
    }
    
    

}

extension SectionNewsTableViewCell : UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return videoSliderList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let row = indexPath.row
        print("Row: \(row)")
        
        //            print(meetingArray[row] as! String)
        
//        let sb: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
//        
//        let frontVC = sb.instantiateViewController(withIdentifier: "VideoViewController")
//        let frontNav = UINavigationController(rootViewController: frontVC)
//        let rearVC = sb.instantiateViewController(withIdentifier: "TopStoriesViewController")
//        
//        self.window?.rootViewController = frontVC
        
//        let navigationViewController = self.storyboard?.instantiateViewController(withIdentifier: "VideoViewController") as! VideoViewController
//        let photoStory = photoStories[row]
//        navigationViewController.albumId = photoStory["palbum_id"]!
        
//        self.parent?.navigationController?.pushViewController(navigationViewController, animated: true)
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
                    cell.videoImage.image = image
                }
            }
        }
        return cell
    }
    
}

extension SectionNewsTableViewCell : UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemsPerRow:CGFloat = 4
        let hardCodedPadding:CGFloat = 5
        let itemWidth = (collectionView.bounds.width / itemsPerRow) - hardCodedPadding
        let itemHeight = collectionView.bounds.height - (2 * hardCodedPadding)
        return CGSize(width: itemWidth, height: itemHeight)
    }
    
}
