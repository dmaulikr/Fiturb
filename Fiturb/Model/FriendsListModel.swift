//
//  FriendsList.swift
//  Fiturb
//
//  Created by Admin on 24/03/17.
//  Copyright © 2017 Fiturb.DATAPPS. All rights reserved.
//

import Foundation

class FriendsListModel{
    
    var userId : String!
    
    var firstName: String!
    
    var lastName: String!

    var friendshipStatus:String!
    
    var thumbUrl: String!
    
    var onlineStatus: String!
    
    var message: String!
    
    //Extra
    var friendsType: String!
    
    //Json parsing method
    func  initWithJsonData(dictinaryObj dict:Dictionary<String, AnyObject>?, responseMessage message:String?, friendsTypeName type:String!) -> Any? {
        
        //User ID
        self.userId = dict?["user_id"] as? String ?? "No data"
        
        //First name
        self.firstName = dict?["first_name"] as? String ?? "No data"
        
        //last name
        self.lastName = dict?["last_name"] as? String ?? "No data"
        
        //friendship status
        self.friendshipStatus = dict?["friendship_status"] as? String ?? "No data"
        
        //Thumb Url
        self.thumbUrl = dict?["thumb_url"] as? String ?? "No data"
        
        //Online Status
        self.onlineStatus = dict?["online_status"] as? String ?? "No data"
        
        //Message
        self.message = message ?? "No data"
        
        //Identify Friend is recieved,Sent or Already friend
        self.friendsType = type ?? "No data"
        
        return self
        
    }
    
}
