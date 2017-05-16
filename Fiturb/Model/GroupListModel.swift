//
//  GroupListModel.swift
//  Fiturb
//
//  Created by Admin on 04/04/17.
//  Copyright © 2017 Fiturb.DATAPPS. All rights reserved.
//

import Foundation

class GroupListModel {
    
    var groupId: String!
    
    var groupName: String!
    
    var message: String!
    
    func initWithJsonData(groupIdAndGroupNameDictionary:Dictionary<String,AnyObject>?,messageText:String?) -> AnyObject? {
        
        //group id
        self.groupId = groupIdAndGroupNameDictionary?["group_id"] as? String ?? "No data"
        
        //Group Name
        self.groupName = groupIdAndGroupNameDictionary?["group_name"] as? String ?? "No data"
        
        //message
        self.message = messageText ?? "No data"
        
        return  self
        
    }
    
}
