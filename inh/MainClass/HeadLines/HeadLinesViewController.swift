//
//  HeadLinesViewController.swift
//  inh
//
//  Created by Shahriar Mahmud on 9/12/17.
//  Copyright © 2017 BizTech. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import SVProgressHUD

class HeadLinesViewController: UIViewController , UITableViewDelegate, UITableViewDataSource{

    @IBOutlet weak var newsTable: UITableView!
    @IBOutlet weak var headLineImage: UIImageView!
    
    var petitions = [[String: String]]()
    
    var utilityViewController = UtilityViewController()
    var alertDialogViewController = AlertDialogViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        newsTable.dataSource = self
        newsTable.delegate = self
        GEtReportDate()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return petitions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell:HeadLinesTableViewCell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! HeadLinesTableViewCell
        
        let petition = petitions[indexPath.row]
        print(petition)
        
//        if(petition["id"]?.isEmpty)!{
//            cell.transactionId.text = "Transaction Id : "
//        }else{
//            cell.transactionId.text = "Transaction Id : "+petition["id"]!
//        }
//        
//        
//        if(petition["date"]?.isEmpty)!{
//            cell.transectionDate.text = "Transaction Date : "
//        }else{
//            cell.transectionDate.text = "Transaction Date : "+petition["date"]!
//        }
//        
//        
//        if(petition["amount"]?.isEmpty)!{
//            cell.transectionAmount.text = "Transaction Amount : "
//        }else{
//            cell.transectionAmount.text = "Transaction Amount : "+petition["amount"]!
//        }
//        
//        
//        if(petition["name"]?.isEmpty)!{
//            cell.customerName.text = "Customer Name : "
//        }else{
//            cell.customerName.text = "Customer Name : "+petition["name"]!
//        }
//        
//        
//        if(petition["phone"]?.isEmpty)!{
//            cell.customerMobileNumber.text = "Customer Mobile Number : "
//        }else{
//            cell.customerMobileNumber.text = "Customer Mobile Number : "+petition["phone"]!
//        }
//        
//        
//        if(petition["type"]?.isEmpty)!{
//            cell.transectionType.text = "Transaction Type : "
//        }else{
//            cell.transectionType.text = "Transaction Type : "+petition["type"]!
//        }
//        
//        
//        if(petition["status"]?.isEmpty)!{
//            cell.transectionStatus.text = "Transaction Status : "
//        }else{
//            cell.transectionStatus.text = "Transaction Status : "+petition["status"]!
//        }
//        
//        cell.serialNumber.text = "Serial Number: "+String(indexPath.row+1)
        
        
        return cell
    }
    
    func GEtReportDate(){
        SVProgressHUD.show()
        
        let merchantSecurityKey = UserDefaultsManager.merchantSecurityKey
        let UTCTimeId = UserDefaultsManager.UTCTimeId
        let CountryShortCode = UserDefaultsManager.CountryShortCode
        
        let parameters  = [
            "MerchantSecurityKey": merchantSecurityKey,
            "UTCTimeId": UTCTimeId,
            "CountryShortCode" : CountryShortCode
            ] as [String : Any]
        
        
        
        Alamofire.request(RequestString.TransactionReport, method: .post, parameters: parameters, encoding: JSONEncoding.default).responseJSON { responce in
            switch responce.result{
            case.success(let data):
                SVProgressHUD.dismiss()
                
                let Response = JSON(data)
                print(Response)
                

                for result in Response.arrayValue {
                    let id = result["TransactionId"].stringValue
                    let date = result["StrTransactionDate"].stringValue
                    let amount = result["TransactionAmount"].stringValue
                    
                    let name = result["CustomerName"].stringValue
                    let phone = result["CustomerMobileNumber"].stringValue
                    let type = result["TransactionType"].stringValue
                    let status = result["TransactionStatus"].stringValue
                    
                    let obj = ["id": id, "date": date, "amount": amount, "name": name, "phone": phone, "type": type, "status": status]
                    self.petitions.append(obj)
                }
                
                self.newsTable.reloadData()
                
                
            case.failure(let error):
                print("failed\(error)")
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}
