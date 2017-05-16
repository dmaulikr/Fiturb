//
//  MutualFriendsModel.swift
//  Fiturb
//
//  Created by Admin on 15/04/17.
//  Copyright © 2017 Fiturb.DATAPPS. All rights reserved.
//

import Foundation

class MutualFriendsModel {
    
    var message: String!
    
    var userID: String!
    
    var firstName: String!
    
    var lastName: String!
    
    var imageUrl: String!
    
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
        
        return self
    }
    
}
