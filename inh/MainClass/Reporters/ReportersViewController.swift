//
//  ReportersViewController.swift
//  inh
//
//  Created by Shahriar Mahmud on 9/12/17.
//  Copyright © 2017 BizTech. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import SVProgressHUD

class ReportersViewController: BaseViewController , UITableViewDelegate, UITableViewDataSource{
    
        @IBOutlet weak var scrollview: UIScrollView!
    
    @IBOutlet weak var HeadLineTitle: UILabel!
    @IBOutlet weak var newsTable: UITableView!
    @IBOutlet weak var headLineImage: UIImageView!
    
    var petitions = [[String: String]]()
    
    var utilityViewController = UtilityViewController()
    var alertDialogViewController = AlertDialogViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.automaticallyAdjustsScrollViewInsets = false
        scrollview.contentSize = CGSize(width: 400, height: 1200)
        newsTable.dataSource = self
        newsTable.delegate = self
        GEtReportDate()
    }
    @IBAction func videoClcik(_ sender: Any) {
        let navigationViewController = self.storyboard?.instantiateViewController(withIdentifier: "VideoViewController") as! VideoViewController
        navigationViewController.videoId = petitions[0]["videoId"]!
        self.navigationController?.pushViewController(navigationViewController, animated: true)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return petitions.count-1
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let row = indexPath.row
        print("Row: \(row)")
        let petition = petitions[indexPath.row]
        
        let navigationViewController = self.storyboard?.instantiateViewController(withIdentifier: "VideoViewController") as! VideoViewController
        navigationViewController.videoId = petition["videoId"]!
        self.navigationController?.pushViewController(navigationViewController, animated: true)
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell:ReportersTableViewCell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ReportersTableViewCell
        
        let headLine = petitions[indexPath.row+1]
        
        if(headLine["title"]?.isEmpty)!{
            cell.titleLabel.text = ""
        }else{
            cell.titleLabel.text = headLine["title"]!
        }
        
        
        //        if(headLine["date"]?.isEmpty)!{
        //            cell.transectionDate.text = "Transaction Date : "
        //        }else{
        //            cell.transectionDate.text = "Transaction Date : "+headLine["date"]!
        //        }
        
        
        if(headLine["url"]?.isEmpty)!{
            cell.headImage.image = nil
        }else{
            Alamofire.request(headLine["url"]!).responseImage { response in
                debugPrint(response)
                debugPrint(response.result)
                
                if let image = response.result.value {
                    print("image downloaded: \(image)")
                    cell.headImage.image = image
                }
            }
        }
        
        return cell
    }
    
    func GEtReportDate(){
        SVProgressHUD.show()
        
        Alamofire.request(RequestString.reporters, method: .get, encoding: JSONEncoding.default).responseJSON { responce in
            switch responce.result{
            case.success(let data):
                SVProgressHUD.dismiss()
                let json = JSON(data)
                print(json["items"][0]["snippet"]["thumbnails"]["medium"]["url"].stringValue)
                print(json["items"])
                print("Head Lines",json)
                print("Head Lines",RequestString.headLines)
                
                
                
                
                for result in json["items"].arrayValue {
                    let title = result["snippet"]["title"].stringValue
                    let url = result["snippet"]["thumbnails"]["medium"]["url"].stringValue
                    let videoId = result["snippet"]["resourceId"]["videoId"].stringValue
                    
                    let obj = ["title": title, "url": url, "videoId": videoId]
                    self.petitions.append(obj)
                }
                
                print("petitions : ", self.petitions)
                
                Alamofire.request(self.petitions[0]["url"]!).responseImage { response in
                    debugPrint(response)
                    debugPrint(response.result)
                    
                    if let image = response.result.value {
                        print("image downloaded: \(image)")
                        self.headLineImage.image = image
                    }
                }
                
                self.HeadLineTitle.text = self.petitions[0]["title"]!
                
                self.newsTable.reloadData()
                
            case.failure(let error):
                print("failed\(error)")
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func convertStringToDictionary(text: String) -> [String:AnyObject]? {
        if let data = text.data(using: String.Encoding.utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? [String:AnyObject]
            } catch let error as NSError {
                print(error)
            }
        }
        return nil
    }
    
}
