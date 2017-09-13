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
        static let Api = "/v2/?"
    }
    
    private  static let Domain = Domains.Dev
    private  static let BaseURL = Domain + Routes.Api
    

    public static var section : String = BaseURL + "sections"
    public static var latest : String = BaseURL + "latest"
    public static var videoSlider : String = BaseURL + "VideoSlider"
    public static var photoSlider : String = BaseURL + "PhotoSlider"
    public static var sports : String = BaseURL + "topSection=13"
    public static var topnews : String = BaseURL + "topnews"
    
    
    
    
    public static var CashDeposit : String = BaseURL + "CashDeposit"
    public static var CashDepositVASubmission : String = BaseURL + "CashDepositVASubmission"
    public static var CashOut : String = BaseURL + "CashOut"
    public static var CashOutVASubmission : String = BaseURL + "CashOutVASubmission"
    public static var CashOutOTPSubmission : String = BaseURL + "CashOutOTPSubmission"
    public static var FundTransfer : String = BaseURL + "FundTransfer"
    public static var FundTransferVASubmission : String = BaseURL + "FundTransferVASubmissionFromSender"
    public static var FundTransferOTPSubmission : String = BaseURL + "FundTransferOTPSubmission"
    public static var CashReceive : String = BaseURL + "CashReceive"
    public static var TransactionReport : String = BaseURL + "MerchantTransactionReportForApps"
    public static var SaveAnonymousCustomerProfile : String = BaseURL + "SaveAnonymousCustomerProfile"
    public static var MobileVerificationForAnonymousCustomerProfile : String = BaseURL + "MobileVerificationForAnonymousCustomerProfile"
    public static var FundTransferVASubmissionFromReceiver : String = BaseURL + "FundTransferAnonymousVASubmissionFromReceiver"
    public static var FundTransferRequestForOTP : String = BaseURL + "FundTransferAnonymousRequestForOTP"
}
