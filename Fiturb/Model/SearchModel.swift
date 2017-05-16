//
//  SearchModel.swift
//  Fiturb
//
//  Created by Admin on 03/04/17.
//  Copyright © 2017 Fiturb.DATAPPS. All rights reserved.
//

import Foundation

class SearchModel {
    
    var userID: String!
    
    var mobilenumber: String!
    
    var firstName: String!
    
    var lastName: String!
    
    var thumbUrlImage: String!
    
    var mesgText: String!
    
    func initWithJsonData(message:String?, dictionaryObj:Dictionary<String,AnyObject>?) -> Any? {
        
        //user id
        self.userID = dictionaryObj?["user_id"] as? String ?? "No data"
        
        //Mobile number
        self.mobilenumber = dictionaryObj?["mobile"] as? String ?? "No data"
        
        //First name
        self.firstName = dictionaryObj?["first_name"] as? String ?? "No data"
        
        //last name
        self.lastName = dictionaryObj?["last_name"] as? String ?? "No data"

        //Image url
        self.thumbUrlImage = dictionaryObj?["thumb_url"] as? String ?? "No data"
        
        //mesage 
        self.mesgText = message
        
        return self
    }
    
}
