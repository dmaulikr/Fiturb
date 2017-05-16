//
//  InterestListModel.swift
//  Fiturb
//
//  Created by Admin on 16/04/17.
//  Copyright © 2017 Fiturb.DATAPPS. All rights reserved.
//

import Foundation

class InterestListModel {
    
    var message: String!
    
    var interestId: String!
    
    var interestName: String!
    
    var interestIcon: String!
    
    func initWithJsonData(messageText: String?, dictionary:Dictionary<String, AnyObject>?) -> Any? {
        
        //message
        self.message = messageText ?? "No data"
        
        //Interest ID
        self.interestId = dictionary?["interest_id"] as? String ?? "No data"
        
        //Interest name
        self.interestName = dictionary?["interest_name"] as? String ?? "No data"
        
        //Interest item image
        self.interestIcon = dictionary?["interest_icon"] as? String ?? "No data"
        
        return self
    }
}
