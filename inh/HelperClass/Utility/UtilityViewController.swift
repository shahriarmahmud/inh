//
//  UtilityViewController.swift
//  BlockChains.My
//
//  Created by Shahriar Mahmud on 7/9/17.
//  Copyright © 2017 Nuspay. All rights reserved.
//

import UIKit

class UtilityViewController: UIViewController {
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func scrollAdjustment(scrollView: UIScrollView, uiViewController: UIViewController){
        scrollView.contentSize = CGSize.init(width: uiViewController.view.frame.size.width, height: uiViewController.view.frame.size.height+100)
        //        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: uiViewController, action: #selector(UtilityViewController.dismissKeyboard(UIViewController: uiViewController)))
        //        uiViewController.view.addGestureRecognizer(tap)
    }
    
    func dismissKeyboard(UIViewController: UIViewController) {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        UIViewController.view.endEditing(true)
    }
    
    func noCamera(){
        let alertVC = UIAlertController(
            title: "No Camera",
            message: "Sorry, this device has no camera",
            preferredStyle: .alert)
        let okAction = UIAlertAction(
            title: "OK",
            style:.default,
            handler: nil)
        alertVC.addAction(okAction)
        present(
            alertVC,
            animated: true,
            completion: nil)
    }

    func exponential(value:String)->String{
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = NumberFormatter.Style.decimal
        let finalNumber = numberFormatter.number(from: value)
        print(finalNumber!)
        
        let s:String = String(format:"%f", finalNumber!.doubleValue) //formats the string to accept double/float
        print(s)
        return s
    }
    
    func validateNumeric(_ numericString: String) -> Bool {
        let regexExpression: String = "^[-+]?\\d{0,9}$"
        let matchTextPredicate = NSPredicate(format: "SELF MATCHES %@", regexExpression)
        return matchTextPredicate.evaluate(with: numericString)
    }
    
    func decimalDigitsInputFilter(textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String,maxNoOfDigitsBeforeDecimal: Int,maxNoOfDigitsAfterDecimal:Int) -> Bool{
        let nsString = textField.text as NSString?
        let newString = nsString?.replacingCharacters(in: range, with: string)
//        let maxNoOfDigitsBeforeDecimal: Int = 4
//        let maxNoOfDigitsAfterDecimal: Int = 2
        let arrayOfString: [Any] = newString!.components(separatedBy: ".")
        
        if ((arrayOfString.count == 1) && ((newString?.characters.count)! > maxNoOfDigitsBeforeDecimal)) {
            return false
        }
        if (arrayOfString.count > 2) {
            return false
        }
        
        
        if(maxNoOfDigitsAfterDecimal == 8){
        
        
        let newString2: String = (textField.text! as NSString).replacingCharacters(in: range, with: string)
        var sep: [Any] = newString2.components(separatedBy: ".")
        
        if(sep.count > 1){
            let abc : String = sep[1] as! String
            if(abc.characters.count > maxNoOfDigitsAfterDecimal){
                
                return false
            } 
        }
        
        if sep.count >= maxNoOfDigitsAfterDecimal {
            var sepStr: String = "\(sep[1] as? String ?? "")"
            if !((sepStr.characters.count) > maxNoOfDigitsAfterDecimal) {
                if (sepStr.characters.count) == maxNoOfDigitsAfterDecimal && (string == ".") {
                    return false
                }
                return true
            }
            else {
                return false
            }
        }
        }else if(maxNoOfDigitsAfterDecimal == 1){
            
            
            let newString2: String = (textField.text! as NSString).replacingCharacters(in: range, with: string)
            var sep: [Any] = newString2.components(separatedBy: ".")
            
            if(sep.count > 1){
                let abc : String = sep[1] as! String
                if(abc.characters.count > maxNoOfDigitsAfterDecimal){
                    
                    return false
                }
            }
            
            if sep.count >= maxNoOfDigitsAfterDecimal {
                var sepStr: String = "\(sep[1] as? String ?? "")"
                if !((sepStr.characters.count) > maxNoOfDigitsAfterDecimal) {
                    if (sepStr.characters.count) == maxNoOfDigitsAfterDecimal && (string == ".") {
                        return false
                    }
                    return true
                }
                else {
                    return false
                }
            }
        }else{
            let newString2: String = (textField.text! as NSString).replacingCharacters(in: range, with: string)
            var sep: [Any] = newString2.components(separatedBy: ".")
            if sep.count >= maxNoOfDigitsAfterDecimal {
                var sepStr: String = "\(sep[1] as? String ?? "")"
                if !((sepStr.characters.count) > maxNoOfDigitsAfterDecimal) {
                    if (sepStr.characters.count) == maxNoOfDigitsAfterDecimal && (string == ".") {
                        return false
                    }
                    return true
                }
                else {
                    return false
                }
            }
        }
        return true
 
    }
    
}

struct AppUtility {
    
    static func lockOrientation(_ orientation: UIInterfaceOrientationMask) {
        
        if let delegate = UIApplication.shared.delegate as? AppDelegate {
            delegate.orientationLock = orientation
        }
    }
    
    /// OPTIONAL Added method to adjust lock and rotate to the desired orientation
    static func lockOrientation(_ orientation: UIInterfaceOrientationMask, andRotateTo rotateOrientation:UIInterfaceOrientation) {
        
        self.lockOrientation(orientation)
        
        UIDevice.current.setValue(rotateOrientation.rawValue, forKey: "orientation")
    }
    
}

struct Style{

    // MARK: ToDo Table Section Headers
    static var sectionHeaderTitleFont = UIFont(name: "Helvetica-Bold", size: 20)
    static var sectionHeaderTitleColor = UIColor.white
    static var sectionHeaderBackgroundColor = UIColor.black
    static var sectionHeaderBackgroundColorHighlighted = UIColor.gray
    static var sectionHeaderAlpha: CGFloat = 1.0

}


extension Double {
    /// Rounds the double to decimal places value
    func roundTo(places:Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}
