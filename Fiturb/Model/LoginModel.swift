//
//  LoginModel.swift
//  Fiturb
//
//  Created by Admin on 10/03/17.
//  Copyright © 2017 Fiturb.DATAPPS. All rights reserved.
//

import Foundation

class LoginModel{
    
    var email: String!
    
    var mobileNumber: String!
    
    var token: String!
    
    var userID: String!
    
    var message: String!
    
    var firstName: String!
    
    var lastName: String!
    
    var mobileVerified: Bool!
    
    var emailVerfied: Bool!
    
    var interestCount: String!
    
    var cityName: String!
    
    var isCityNameUpdated: Bool!
    
    //Json parsing Method
    func initWithJsonData(loginMsg:String?, userEmail:String?, userMobileNumber:String?,tokenID:String?,userID:String?,userFirstName:String?,userLastName:String?,mobileVerifedValue:AnyObject?,emailVerfiedvalue:AnyObject?, totalInterestCount: String?, cityNameText: String?) -> AnyObject? {
        
        //Login msg
         self.message = loginMsg ?? "No data"
        
        //Email
        self.email = userEmail ?? "No data"
        
        //mobile Number
        self.mobileNumber = userMobileNumber ?? "No data"
        
        //token id
        self.token = tokenID ?? "No data"
        
        //userId
        self.userID = userID  ?? "No data"
        
        //firstName
        self.firstName = userFirstName ?? "No data"
        
        //LastName
        self.lastName = userLastName ?? "No data"
        
        //Interest Count
        self.interestCount = totalInterestCount ?? "0"
        
        //City name
        self.cityName = cityNameText ?? "No data"
        
        //Own variable to check city name updated or not
        self.isCityNameUpdated = ((cityNameText != nil) ? true : false)
        
        //email Verfied
        if (((emailVerfiedvalue != nil) && !(emailVerfiedvalue is NSNull)) && (emailVerfiedvalue?.isEqual("1"))!)  {
            
            self.emailVerfied = true
        }
        else{
            
            self.emailVerfied = false
        }
        
        //Mobile verifed
        if (((mobileVerifedValue != nil) && !(mobileVerifedValue is NSNull)) && (mobileVerifedValue?.isEqual("1"))!)  {
            
            self.mobileVerified = true
        }
        else{
            
            self.mobileVerified = false
        }
        
        return self
        
    }
    
}
