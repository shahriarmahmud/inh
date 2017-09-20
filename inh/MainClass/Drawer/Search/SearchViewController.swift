//
//  SearchViewController.swift
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

class SearchViewController: BaseViewController , UITableViewDelegate, UITableViewDataSource{
    
    var petitions = [[String: String]]()
    
    
    @IBOutlet weak var searchFeild: UITextField!
    
    @IBOutlet weak var newsTable: UITableView!
    var utilityViewController = UtilityViewController()
    var alertDialogViewController = AlertDialogViewController()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        newsTable.dataSource = self
        newsTable.delegate = self

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return petitions.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let row = indexPath.row
        print("Row: \(row)")
        let petition = petitions[indexPath.row]
        
        let navigationViewController = self.storyboard?.instantiateViewController(withIdentifier: "OnClickViewController") as! OnClickViewController
        navigationViewController.ap_image = petition["ap_image"]!
        navigationViewController.mobile_news_url = petition["mobile_news_url"]!
        navigationViewController.share_url = petition["share_url"]!
        self.navigationController?.pushViewController(navigationViewController, animated: true)
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell:SearchTableViewCell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! SearchTableViewCell
        
        let petition = petitions[indexPath.row]
        print(indexPath.row)
        print(petition)
        
        if(petition["art_title"]?.isEmpty)!{
            cell.titleLabel.text = ""
        }else{
            cell.titleLabel.text = petition["art_title"]!
        }
        
        
        if(petition["X_hours_ago"]?.isEmpty)!{
            cell.timeLabel.text = ""
        }else{
            cell.timeLabel.text = petition["X_hours_ago"]!
        }
        
        
        if(petition["ap_thumb_image"]?.isEmpty)!{
            cell.headImage.image = nil
        }else{
            Alamofire.request(petition["ap_thumb_image"]!).responseImage { response in
                debugPrint(response)
                debugPrint(response.result)
                
                if let image = response.result.value {
                    print("image downloaded: \(image)")
                    cell.headImage.image = image
                }
            }
        }
        
//        self.petitions.removeAll()
        return cell
    }
    
    
    @IBAction func searchFeild(_ sender: UITextField) {
        reload(text: sender.text!)
//        NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(self.reload), object: nil)
//        self.perform(#selector(self.reload), with: nil, afterDelay: 0.5)
    }

    
    
    func reload(text:String) {
        print(text)
        print("Doing things")
        GEtServerDate(text: text)
    }
    
    
    func GEtServerDate(text:String){
        SVProgressHUD.show()
        
        Alamofire.request(RequestString.search+text, method: .get, encoding: JSONEncoding.default).responseJSON { responce in
            switch responce.result{
            case.success(let data):
                SVProgressHUD.dismiss()
                
                let Response = JSON(data)
                print(Response)
                print(RequestString.search+text)
                
                self.petitions.removeAll()

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
                    self.petitions.append(obj)
                }
                
                self.newsTable.reloadData()
 
            case.failure(let error):
                print("failed\(error)")
            }
        }
    }
    
}
