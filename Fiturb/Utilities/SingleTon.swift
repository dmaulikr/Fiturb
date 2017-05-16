
//
//  SingleTon.swift
//  Fiturb
//
//  Created by Admin on 07/03/17.
//  Copyright © 2017 Fiturb.DATAPPS. All rights reserved.
//

import Foundation
import UIKit

class singleTon{
    
    //SingleTon Object
    static let sharedInstance = singleTon()
    
    private init() {
    
    }
    
    
    //MARK:- Common Helper Methods
    
    //Method to check wheather value is null
    func checkValueIsNull(value : AnyObject?) -> Bool {
        
        if value is NSNull {
            
            return true
            
        }
        else {
            
            return false
            
        }
    }
    
    //method to check wheather value is Nil
    func checkValueIsNilOrNot(value: AnyObject?) -> Bool {
        
        if let _:AnyObject = value
        {
            return true
        }
        
        return false
    }

    //Method to Convert image data into base64 encoding format
    func convertImageToBase64EncodingFormat(image:UIImage) -> String {
        
        let imageData = UIImagePNGRepresentation(image)
        
        let base64String = imageData?.base64EncodedString(options: .lineLength64Characters)

        return base64String!
    }

    //Method to check eneterd email adress is valid or not
    func isValidEmail(testStr:String) -> Bool {
        
        let emailRegEx = "^(?:(?:(?:(?: )*(?:(?:(?:\\t| )*\\r\\n)?(?:\\t| )+))+(?: )*)|(?: )+)?(?:(?:(?:[-A-Za-z0-9!#$%&’*+/=?^_'{|}~]+(?:\\.[-A-Za-z0-9!#$%&’*+/=?^_'{|}~]+)*)|(?:\"(?:(?:(?:(?: )*(?:(?:[!#-Z^-~]|\\[|\\])|(?:\\\\(?:\\t|[ -~]))))+(?: )*)|(?: )+)\"))(?:@)(?:(?:(?:[A-Za-z0-9](?:[-A-Za-z0-9]{0,61}[A-Za-z0-9])?)(?:\\.[A-Za-z0-9](?:[-A-Za-z0-9]{0,61}[A-Za-z0-9])?)*)|(?:\\[(?:(?:(?:(?:(?:[0-9]|(?:[1-9][0-9])|(?:1[0-9][0-9])|(?:2[0-4][0-9])|(?:25[0-5]))\\.){3}(?:[0-9]|(?:[1-9][0-9])|(?:1[0-9][0-9])|(?:2[0-4][0-9])|(?:25[0-5]))))|(?:(?:(?: )*[!-Z^-~])*(?: )*)|(?:[Vv][0-9A-Fa-f]+\\.[-A-Za-z0-9._~!$&'()*+,;=:]+))\\])))(?:(?:(?:(?: )*(?:(?:(?:\\t| )*\\r\\n)?(?:\\t| )+))+(?: )*)|(?: )+)?$"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        
        let result = emailTest.evaluate(with: testStr)
        
        return result
    }
    
    
//    func validateEmail(enteredEmail:String) -> Bool {
//        
//        let emailFormat = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
//        
//        let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailFormat)
//        
//        let result = emailPredicate.evaluate(with: enteredEmail)
//        
//        return result
//        
//    }
    
    //Current Device OS version
    static var TheCurrentDeviceVersion: String {
        
        struct Singleton {
            
            static let version = UIDevice.current.systemVersion
        }
        
        return Singleton.version
    }
    
    //Display alert message Method
    func displayAlert(message:String, title:String) -> UIAlertController {
        
        let alert = UIAlertController(title: title,
                                      message: message,
                                      preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Ok", style: .default,handler:nil))
        
        return alert
        
    }
    
    //Get User token
    func getUserAuthenticationToken() -> String? {
        
        guard let theUserAuthenticationToken =  UserDefaults.standard.value(forKey: "userAuthenticationToken") as? String else{
            
            return nil
            
        }
    
        return theUserAuthenticationToken
        
    }
    
    //Get User ID
    func getUserID() -> String? {
        
        guard let registereduserId = UserDefaults.standard.value(forKey: "UserID") as? String else {
            
            return nil
        }
        
        return registereduserId
    }
    
    //Check user interests are added or not
    func isUserInterestsAdded() -> Bool? {
    
        guard let userInterests = UserDefaults.standard.value(forKey:"isUserInterestsAdded") as? Bool else {
            
            return false
        }
        
        return userInterests
    }
    
    //Check user location updated or not
    func isLocationUpdated() -> Bool? {
        
        guard let userLocation = UserDefaults.standard.value(forKey: "isUserLocationUpdated") as? Bool else {
            
            return false
        }
        
        return userLocation
    }
    
    //Convert array to String
    func convertArrayToString(arrayObj:[String?]) -> String? {
        
        let convertedString = (arrayObj as? Array)?.joined(separator: ",")
        
        print("Converted string is:\(String(describing: convertedString))")
        
        return convertedString
    }
    
    //Get date from string
    func convertStringToDate(dateString: String?) -> Dictionary<String, String>? {
        
        //Date dictionary
        let dateDictinary = NSMutableDictionary()
        
        print("date string is:\(String(describing: dateString))")
        
        //String date format
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd H:mm:ss"
        dateFormatter.locale = Locale.init(identifier: "en_GB")
        
        //convert string into date format
        let dateObjOfTypeDate = dateFormatter.date(from: (dateString)!)

        if dateObjOfTypeDate != nil {
            
            //Date
            dateFormatter.dateFormat = "dd"
            let date = dateFormatter.string(from: dateObjOfTypeDate!)
            dateDictinary.setValue(date, forKey: "date")
            
            //Month name
            dateFormatter.dateFormat = "MMM"
            let monthName = dateFormatter.string(from: dateObjOfTypeDate!)
            dateDictinary.setValue(monthName, forKey: "monthName")
            
            //Year
            dateFormatter.dateFormat = "yyyy"
            let year = dateFormatter.string(from: dateObjOfTypeDate!)
            dateDictinary.setValue(year, forKey: "year")
            
            //Time
            dateFormatter.dateFormat = "H:mm a"
            let time = dateFormatter.string(from: dateObjOfTypeDate!)
            dateDictinary.setValue(time, forKey: "time")
            
            //Day name
            dateFormatter.dateFormat = "EEEE"
            let dayName = dateFormatter.string(from: dateObjOfTypeDate!)
            dateDictinary.setValue(dayName, forKey: "dayName")
            
        }
        else{
    
            //Date
            dateDictinary.setValue("0", forKey: "date")
            
            //Month name
            dateDictinary.setValue("0", forKey: "monthName")
            
            //Year
            dateDictinary.setValue("0", forKey: "year")
            
            //Time
            dateDictinary.setValue("0", forKey: "time")
            
            //Day name
            dateDictinary.setValue("0", forKey: "dayName")

        }
    
        return dateDictinary as? Dictionary<String, String>
    }
    
}

