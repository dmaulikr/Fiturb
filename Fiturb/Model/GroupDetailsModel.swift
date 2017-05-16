//
//  GroupDetailsModel.swift
//  Fiturb
//
//  Created by Admin on 05/04/17.
//  Copyright © 2017 Fiturb.DATAPPS. All rights reserved.
//

import Foundation

class GroupDetailsModel {
    
    var message: String!
    
    var userId: String!
    
    var firstName: String!
    
    var lastName: String!
    
    var imageurl: String!
    
    
    func initWithJsonData(message:String?, dictionaryObj:Dictionary<String,AnyObject>?) -> Any? {

        //user id
        self.userId = dictionaryObj?["user_id"] as? String ?? "No data"
        
        //First name
        self.firstName = dictionaryObj?["first_name"] as? String ?? "No data"
        
        //Last name
        self.lastName = dictionaryObj?["last_name"] as? String ?? "No data"
        
        //image url
        self.imageurl = dictionaryObj?["thumb_url"] as? String ?? "No data"
        
        //Message
        self.message = message ?? "No data"
        
        return self
        
    }
}
