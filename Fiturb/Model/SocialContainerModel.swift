//
//  SocialContainerModel.swift
//  Fiturb
//
//  Created by Admin on 13/03/17.
//  Copyright © 2017 Fiturb.DATAPPS. All rights reserved.
//

import Foundation

class SocialContainerModel{
    
    var registrationMessage:String!
    
    var userEmail:String!
    
    var userMobileNumber:String!
    
    var userFirstName: String!
    
    var userAuthenticationToken: String!
    
    var userID: String!
    
    var interestCount: String!
    
    var cityName: String!
    
    var isCityNameUpdated: Bool!

    //Json parsing Method
    func initWithJsonData(message registrationMsg:String?, registeredEmail email:String?, mobileNumber number:String?, firstName name:String?, userAuthenticationToken token:String?, iDUser userID:String?, interestCount count:String?, cityNameText: String?) -> AnyObject? {
        
        //Registration message
        self.registrationMessage = registrationMsg ?? "No data"
        
        //Email
        self.userEmail = email ?? "No data"
        
        //user mobile number
        self.userMobileNumber = number ?? "No data"
        
        //User first name
        self.userFirstName = name ?? "No data"
        
        //User Authentication token
        self.userAuthenticationToken = token ?? "No data"
        
        //User ID
        self.userID = userID ?? "No data"
        
        //User Interest Count
        self.interestCount = count ?? "0"
        
        //City name
        self.cityName = cityNameText ?? "No data"
        
        //Own variable to check city name updated or not
        self.isCityNameUpdated = ((cityNameText != nil) ? true : false)
        
        return self
    }
    
}
