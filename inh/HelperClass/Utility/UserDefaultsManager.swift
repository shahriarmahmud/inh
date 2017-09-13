//
//  UserDefaultsManager.swift
//  BlockChainsMyMerchant
//
//  Created by rifat ullah on 8/24/17.
//  Copyright © 2017 Shahriar Mahmud. All rights reserved.
//

import Foundation

class UserDefaultsManager {
    
    //login
    private static let companyEmailKey = "CompanyEmail"
    private static let merchantSecurityKeyKey = "MerchantSecurityKey"
    private static let UTCTimeIdKey = "UTCTimeId"
    private static let CountryShortCodeKey = "CountryShortCode"

    


    
    static var companyEmail: String {
        get {
            return UserDefaults.standard.string(forKey: companyEmailKey) ?? ""
        }
        set {
            
            UserDefaults.standard.setValue(newValue, forKey: companyEmailKey)
        }
    }
    
    
    static var merchantSecurityKey: String {
        get {
            return UserDefaults.standard.string(forKey: merchantSecurityKeyKey)  ?? ""
        }
        set {
            UserDefaults.standard.setValue(newValue, forKey: merchantSecurityKeyKey)
        }
    }
    
    
    
    static var UTCTimeId: String {
        get {
            return UserDefaults.standard.string(forKey: UTCTimeIdKey)  ?? ""
        }
        set {
            UserDefaults.standard.setValue(newValue, forKey: UTCTimeIdKey)
        }
    }
    
    
    static var CountryShortCode: String {
        get {
            return UserDefaults.standard.string(forKey: CountryShortCodeKey)  ?? ""
        }
        set {
            UserDefaults.standard.setValue(newValue, forKey: CountryShortCodeKey)
        }
    }
    
    
//    static var merchantKey: String {
//        get {
//            return UserDefaults.standard.string(forKey: merchantSecurityKey)  ?? ""
//        }
//        set {
//            UserDefaults.standard.setValue(newValue, forKey: merchantSecurityKey)
//        }
//    }
//    
//    
//    
//    static var merchantSession: String {
//        get {
//            return UserDefaults.standard.string(forKey: merchantSessionKey)  ?? ""
//        }
//        set {
//            UserDefaults.standard.setValue(newValue, forKey: merchantSessionKey)
//        }
//    }
    
}
