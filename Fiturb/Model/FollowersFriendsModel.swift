//
//  FollowersFriendsModel.swift
//  Fiturb
//
//  Created by Admin on 16/04/17.
//  Copyright © 2017 Fiturb.DATAPPS. All rights reserved.
//

import Foundation

class FollowersFriendsModel{
    
    var message: String!
    
    var userID: String!
    
    var firstName: String!
    
    var lastName: String!
    
    var imageUrl: String!
    
    var sinceTime: Dictionary<String, String>?
    
    func initWithJsonData(messageText: String?, dictionary:Dictionary<String,AnyObject>?) -> Any? {
        
        //message text
        self.message = messageText ?? "No data"
        
        //userID
        self.userID = dictionary?["user_id"] as? String ?? "No data"
        
        //firstName
        self.firstName = dictionary?["first_name"] as? String ?? "No data"
        
        //Last name
        self.lastName = dictionary?["last_name"] as? String ?? "No data"
        
        //Image url
        self.imageUrl = dictionary?["thumb_url"] as? String ?? "No data"
        
        //Since time
        let dateString = dictionary?["since"] as? String ?? "0000-00-00 00:00:00"
        
        //Convert string to datefomate
        self.sinceTime = (singleTon.sharedInstance.convertStringToDate(dateString:dateString))
        
        return self
    }

}
