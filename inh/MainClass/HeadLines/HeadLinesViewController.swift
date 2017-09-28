//
//  HeadLinesViewController.swift
//  inh
//
//  Created by Shahriar Mahmud on 9/12/17.
//  Copyright © 2017 BizTech. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage
import SwiftyJSON
import SVProgressHUD

class HeadLinesViewController: BaseViewController , UITableViewDelegate, UITableViewDataSource{

    @IBOutlet weak var newsTable: UITableView!

    
    var refreshControl: UIRefreshControl!
    
    var petitions = [[String: String]]()
    var count = 1

    var utilityViewController = UtilityViewController()
    var alertDialogViewController = AlertDialogViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.automaticallyAdjustsScrollViewInsets = false
        
//        UIApplication.shared.statusBarOrientation = .portrait
//        var angle: Float = .pi / 2
//        //rotate 180°, or 1 π radians
//        view.layer.transform = CATransform3DMakeRotation(CGFloat(angle), 0, 0.0, 1.0)
        
//        let currentThmeme = UserDefaults.standard.string(forKey: "theme") ?? ""
//        if(!currentThmeme.isEmpty){
//            if(currentThmeme == "light"){
//                newsTable.backgroundColor = UIColor(red: (255/255.0), green: (255/255.0), blue: (255/255.0), alpha: 1)
//            }else{
//                newsTable.backgroundColor = UIColor(red: (85/255.0), green: (85/255.0), blue: (85/255.0), alpha: 1)
//            }
//        }else{
//            self.newsTable.backgroundColor = UIColor(red: (255/255.0), green: (255/255.0), blue: (255/255.0), alpha: 1)
//        }
        
        newsTable.dataSource = self
        newsTable.delegate = self
        
        refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: Selector(("refresh:")), for: UIControlEvents.valueChanged)
                newsTable.addSubview(refreshControl)
        GEtReportDate()
    }
    
//    override func viewWillAppear(_ animated: Bool) {
//        let currentThmeme = UserDefaults.standard.string(forKey: "theme") ?? ""
//        if(!currentThmeme.isEmpty){
//            if(currentThmeme == "light"){
//                newsTable.backgroundColor = UIColor(red: (255/255.0), green: (255/255.0), blue: (255/255.0), alpha: 1)
//            }else{
//                newsTable.backgroundColor = UIColor(red: (51/255.0), green: (51/255.0), blue: (51/255.0), alpha: 1)
//            }
//        }else{
//            self.newsTable.backgroundColor = UIColor(red: (255/255.0), green: (255/255.0), blue: (255/255.0), alpha: 1)
//        }
//    }
    
    func refresh(_ sender:AnyObject) {
        // Code to refresh table view
        GEtReportDate()
        self.refreshControl.endRefreshing()
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return petitions.count
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
        
        
        
        if(indexPath.row==0){
            
            let cellHeader:HeadLinesTableViewCell = tableView.dequeueReusableCell(withIdentifier: "cell_header", for: indexPath) as! HeadLinesTableViewCell
            
            let headLine = petitions[indexPath.row]
            
            self.imageLoder(url: headLine["url"]!, imageView: cellHeader.headLineImage)
            
//            Alamofire.request(headLine["url"]!).responseImage { response in
//                debugPrint(response)
//                debugPrint(response.result)
//                
//                if let image = response.result.value {
//                    print("image downloaded: \(image)")
//
//                    let size = CGSize(width: cellHeader.headLineImage.frame.size.width, height: cellHeader.headLineImage.frame.size.height)
//                    
//                    // Scale image to fit within specified size while maintaining aspect ratio
//                    
//                    let scaledImage = image.af_imageScaled(to: size)
//                    
//                    // Scale image to fit within specified size while maintaining aspect ratio
//                    let aspectScaledToFitImage = image.af_imageAspectScaled(toFit: size)
//                    
//                    // Scale image to fill specified size while maintaining aspect ratio
//                    let aspectScaledToFillImage = image.af_imageAspectScaled(toFill: size)
//                    
//                    
////                    cellHeader.headLineImage.contentMode = UIViewContentMode.scaleAspectFill
//                    cellHeader.headLineImage.clipsToBounds = true
////
////                    cellHeader.headLineImage.image = image
//
//                    
//                    cellHeader.headLineImage.image = scaledImage
//                    
////                    let cropRegion = CGRect(x: 50, y: 200, width: 100, height: 100)
////                    //                        var image = UIImage(named: "beach.jpg")
////                    let subImage = image.cgImage?.cropping(to: cropRegion)
////                    let croppedImage = UIImage(cgImage: subImage!)
////                    let newView = UIImageView(image: croppedImage)
//                    
////                    cellHeader.headLineImage = newView
//                    
//                 }
//            }
            
            cellHeader.HeadLineTitle.text = headLine["title"]!
            
            return cellHeader
            
        }else{
            let cell:HeadLinesTableViewCell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! HeadLinesTableViewCell
            
            let headLine = petitions[indexPath.row]
            
            if(headLine["title"]?.isEmpty)!{
                cell.titleLabel.text = ""
            }else{
                cell.titleLabel.text = headLine["title"]!
            }
            
            if(headLine["url"]?.isEmpty)!{
                cell.headImage.image = nil
            }else{
                
                self.imageLoder(url: headLine["url"]!, imageView: cell.headImage)
//                Alamofire.request(headLine["url"]!).responseImage { response in
//                    debugPrint(response)
//                    debugPrint(response.result)
//                    
//                    if let image = response.result.value {
//                        print("image downloaded: \(image)")
//                        
//                        let size = CGSize(width: cell.headImage.frame.size.width, height: cell.headImage.frame.size.height)
//                        
//                        // Scale image to fit within specified size while maintaining aspect ratio
//                        
//                        
//                        
//                        
//                        let scaledImage = image.af_imageScaled(to: size)
//                        
//                        // Scale image to fit within specified size while maintaining aspect ratio
//                        let aspectScaledToFitImage = image.af_imageAspectScaled(toFit: size)
//                        
//                        // Scale image to fill specified size while maintaining aspect ratio
//                        let aspectScaledToFillImage = image.af_imageAspectScaled(toFill: size)
//                         cell.headImage.clipsToBounds = true
//                        cell.headImage.image = scaledImage
//                        
//                        
////                        cell.headImage.contentMode = UIViewContentMode.scaleAspectFill
////                        cell.headImage.clipsToBounds = true
//                        
////                        let cropRegion = CGRect(x: 50, y: 200, width: 100, height: 100)
//////                        var image = UIImage(named: "beach.jpg")
////                        let subImage = image.cgImage?.cropping(to: cropRegion)
////                        let croppedImage = UIImage(cgImage: subImage!)
////                        let newView = UIImageView(image: croppedImage)
////                        
////                        cell.headImage = newView
//                    }
//                }
            }
            
            let lastElement = petitions.count - 1
            if indexPath.row == lastElement {
                // handle your logic here to get more items, add it to dataSource and reload tableview
                var count = 1
                self.loadMoreData(count: String(count))
                count += 1
            }
            
            return cell
        }
        
       
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        // UITableView only moves in one direction, y axis
        let currentOffset = scrollView.contentOffset.y
        let maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height
        
        // Change 10.0 to adjust the distance from bottom
        if maximumOffset - currentOffset <= 10.0 {
            
            self.loadMoreData(count: String(count))
            count += 1
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath:IndexPath) -> CGFloat {
        var height:CGFloat = CGFloat()
        if indexPath.row == 0 {
            height = 294
        }
        else{
            height = 92
            print(height)
        }
        return height
    }
    
    func loadMoreData(count:String){
        SVProgressHUD.show()
        
        Alamofire.request(RequestString.headLinesLoadMore+count, method: .get, encoding: JSONEncoding.default).responseJSON { responce in
            switch responce.result{
            case.success(let data):
                SVProgressHUD.dismiss()
                self.refreshControl.endRefreshing()
                
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
                print(self.petitions)
                print(self.petitions.count)
                
                self.newsTable.reloadData()
                
                
            case.failure(let error):
                print("failed\(error)")
            }
        }
    }
    
    func GEtReportDate(){
        SVProgressHUD.show()
        
        Alamofire.request(RequestString.headLines, method: .get, encoding: JSONEncoding.default).responseJSON { responce in
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
    
    func imageLoder(url:String,imageView:UIImageView){
        let url = URL(string: url)!
        let placeholderImage = UIImage(named: "placeholder")!
        
        let filter = AspectScaledToFillSizeFilter(
            size: imageView.frame.size
        )
        
        imageView.af_setImage(
            withURL: url,
            placeholderImage: placeholderImage,
            filter: filter
        )
    }

}
