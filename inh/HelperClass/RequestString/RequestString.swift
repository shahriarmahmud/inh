//
//  RequestString.swift
//  BlockChains.My
//
//  Created by Shahriar Mahmud on 6/21/17.
//  Copyright © 2017 Nuspay. All rights reserved.
//

import Foundation

class RequestString
{
    
    
    public static var contentType : String = "application/json"
    public static var developerId : String = "webmoneyAPI"
    
    private struct Domains {
        static let Dev = "http://api.inhnews.in"
   
    }
    
    private  struct Routes {
        static let Api = "/v2/"
    }
    
    private  static let Domain = Domains.Dev
    private  static let BaseURL = Domain + Routes.Api
    

    public static var section : String = BaseURL + "?sections"
    public static var latest : String = BaseURL + "?latest"
    public static var videoSlider : String = BaseURL + "?VideoSlider"
    public static var photoSlider : String = BaseURL + "?PhotoSlider"
    public static var topSection : String = BaseURL + "?topSection="
    public static var topnews : String = BaseURL + "?topnews"
    
    public static var headLines : String = "https://www.googleapis.com/youtube/v3/playlistItems?part=snippet%2CcontentDetails&maxResults=50&playlistId=PLxLTMLvUmOy5UJbfCAkp2q72Cs1KxbxaF&fields=items(snippet(resourceId%2FvideoId%2Cthumbnails%2Fmedium%2Furl%2Ctitle))%2CnextPageToken%2CpageInfo%2CnextPageToken&key=AIzaSyDwCTUVQj8DlNc3LW1tbSNblyqbqZCr2-I"
    
    public static var fastNews : String = "https://www.googleapis.com/youtube/v3/playlistItems?part=snippet%2CcontentDetails&maxResults=50&playlistId=PLxLTMLvUmOy60-taisPSqhv6bo9iE9qKl&fields=items(snippet(resourceId%2FvideoId%2Cthumbnails%2Fmedium%2Furl%2Ctitle))%2CnextPageToken%2CpageInfo%2CnextPageToken&key=AIzaSyDwCTUVQj8DlNc3LW1tbSNblyqbqZCr2-I"
    
    public static var reporters : String = "https://www.googleapis.com/youtube/v3/playlistItems?part=snippet%2CcontentDetails&maxResults=50&playlistId=PLxLTMLvUmOy6012F8JAg9SHI2ZS6Tgy4s&fields=items(snippet(resourceId%2FvideoId%2Cthumbnails%2Fmedium%2Furl%2Ctitle))%2CnextPageToken%2CpageInfo%2CnextPageToken&key=AIzaSyDwCTUVQj8DlNc3LW1tbSNblyqbqZCr2-I"
    
    public static var inhSpecial : String = "https://www.googleapis.com/youtube/v3/playlistItems?part=snippet%2CcontentDetails&maxResults=50&playlistId=PLxLTMLvUmOy7-Scp4U027xZnfH6WYjeNx&fields=items(snippet(resourceId%2FvideoId%2Cthumbnails%2Fmedium%2Furl%2Ctitle))%2CnextPageToken%2CpageInfo%2CnextPageToken&key=AIzaSyDwCTUVQj8DlNc3LW1tbSNblyqbqZCr2-I"
    
    public static var bollywoodExpress : String = "https://www.googleapis.com/youtube/v3/playlistItems?part=snippet%2CcontentDetails&maxResults=50&playlistId=PLxLTMLvUmOy6a29KiTc5oY-9OKm-92nAW&fields=items(snippet(resourceId%2FvideoId%2Cthumbnails%2Fmedium%2Furl%2Ctitle))%2CnextPageToken%2CpageInfo%2CnextPageToken&key=AIzaSyDwCTUVQj8DlNc3LW1tbSNblyqbqZCr2-I"
    
    public static var chatisgariNews : String = "https://www.googleapis.com/youtube/v3/playlistItems?part=snippet%2CcontentDetails&maxResults=50&playlistId=PLxLTMLvUmOy6wsx7o0bmmNS9Xq67Ccxoj&fields=items(snippet(resourceId%2FvideoId%2Cthumbnails%2Fmedium%2Furl%2Ctitle))%2CnextPageToken%2CpageInfo%2CnextPageToken&key=AIzaSyDwCTUVQj8DlNc3LW1tbSNblyqbqZCr2-I"
    
    
    public static var drawerSports : String = BaseURL + "section.php?section=sports"
    public static var drawerLifeStyle : String = BaseURL + "section.php?section=lifestyle"
    public static var drawerEntertainment : String = BaseURL + "section.php?section=entertainment"
    public static var drawerIndiaNews : String = BaseURL + "section.php?section=indianews"
    public static var drawerChhattisgarhNews : String = BaseURL + "section.php?section=chhattisgarh"
    public static var drawerInhNews : String = BaseURL + "section.php?section=inh-news"
    
    
    public static var CashReceive : String = BaseURL + "section.php?section="
    public static var TransactionReport : String = BaseURL + "MerchantTransactionReportForApps"
    public static var SaveAnonymousCustomerProfile : String = BaseURL + "SaveAnonymousCustomerProfile"
    public static var MobileVerificationForAnonymousCustomerProfile : String = BaseURL + "MobileVerificationForAnonymousCustomerProfile"
    public static var FundTransferVASubmissionFromReceiver : String = BaseURL + "FundTransferAnonymousVASubmissionFromReceiver"
    public static var FundTransferRequestForOTP : String = BaseURL + "FundTransferAnonymousRequestForOTP"
}
