//
//  SectionDataTableViewCell.swift
//  inh
//
//  Created by Priom on 9/22/17.
//  Copyright © 2017 BizTech. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage
import SwiftyJSON

class SectionDataTableViewCell: UITableViewCell , UITableViewDataSource{

    @IBOutlet weak var sectionNewsDataTable: UITableView!
    
    var SELF:UIViewController? = nil
    
    var sectionNewsList = [[String: String]]()
    
    var sectionList = [[String: String]]()
    
    var count = ""
    
    var sectionDataTitle:String = ""
    
     var videoSliderList = [[String: String]]()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func passValue(SectionNewsList:[[String: String]]){
        sectionNewsList = SectionNewsList
    }
    
    func passCentrIndex(Count:String){
        count = Count
    }
    
    func passValueSectionData(SectionDataTitle:String){
        sectionDataTitle = SectionDataTitle
    }
    
    func initializeView(ui:UIViewController){
        SELF = ui
    }

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sectionNewsList.count
    }
    
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        tableView.deselectRow(at: indexPath, animated: true)
//        
//        let row = indexPath.row
//        print("Row: \(row)")
//        let petition = petitions[indexPath.row]
//        
//        let navigationViewController = self.storyboard?.instantiateViewController(withIdentifier: "VideoViewController") as! VideoViewController
//        navigationViewController.videoId = petition["videoId"]!
//        self.navigationController?.pushViewController(navigationViewController, animated: true)
//        
//    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell:SectionNewsTableViewCell = tableView.dequeueReusableCell(withIdentifier: "cell_body", for: indexPath) as! SectionNewsTableViewCell
        
        let sectionNews = sectionNewsList[indexPath.row]
        cell.videoSection.isHidden=true
        cell.collectionView.isHidden=true
        
//         self.sectionNewsDataTable.frame = CGRect(x: self.sectionNewsDataTable.frame.origin.x, y: self.sectionNewsDataTable.frame.origin.y, width: self.sectionNewsDataTable.frame.size.width, height: (self.sectionNewsDataTable.rowHeight * CGFloat(self.sectionNewsList.count)))
        
        if(indexPath.row==0){
            
            let cellHeader:SectionNewsTableViewCell = tableView.dequeueReusableCell(withIdentifier: "cell_header", for: indexPath) as! SectionNewsTableViewCell
            
            
            if(sectionNews["art_title"]?.isEmpty)!{
                cellHeader.titleLabel.text = ""
            }else{
                cellHeader.titleLabel.text = sectionNews["art_title"]!
            }
            
            if(sectionNews["ap_thumb_image"]?.isEmpty)!{
                cellHeader.titleImage.image = nil
            }else{
                Alamofire.request(sectionNews["ap_thumb_image"]!).responseImage { response in
                    debugPrint(response)
                    debugPrint(response.result)
                    
                    if let image = response.result.value {
                        print("image downloaded: \(image)")
                        cellHeader.titleImage.image = image
                    }
                }
            }
            
            if(sectionDataTitle.isEmpty){
                cellHeader.SectionTitleLabel.text = ""
            }else{
                cellHeader.SectionTitleLabel.text = sectionDataTitle
            }
        }
        
        if(count=="1"){
            cell.videoSection.isHidden=false
            cell.collectionView.isHidden=false
            
            //                cell.authorLabelHeight.constant = 0; //Show
            
            
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
                        cell.initializeView(ui: self.SELF!)
                        cell.collectionView.reloadData()
                    }
                case.failure(let error):
                    print("failed\(error)")
                }
                
                
            }
        }
        
        
        //1st
        if(sectionNews["X_hours_ago"]?.isEmpty)!{
            cell.postingTimeLabel.text = ""
        }else{
            cell.postingTimeLabel.text = sectionNews["X_hours_ago"]!
        }
        
        if(sectionNews["art_title"]?.isEmpty)!{
            cell.thumbnailLabel.text = ""
        }else{
            cell.thumbnailLabel.text = sectionNews["art_title"]!
        }
        
        if(sectionNews["ap_thumb_image"]?.isEmpty)!{
            cell.thumbnailImage.image = nil
        }else{
            Alamofire.request(sectionNews["ap_thumb_image"]!).responseImage { response in
                debugPrint(response)
                debugPrint(response.result)
                
                if let image = response.result.value {
                    print("image downloaded: \(image)")
                    cell.thumbnailImage.image = image
                }
            }
        }
        

        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath:IndexPath) -> CGFloat {
        var height:CGFloat = CGFloat()
        if indexPath.row == 0 {
            height = 205
        }
        else{
            height = 275
            print(height)
        }
        return height
    }
}
