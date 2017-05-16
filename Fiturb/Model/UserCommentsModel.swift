//
//  UserCommentsModel.swift
//  Fiturb
//
//  Created by Admin on 14/04/17.
//  Copyright © 2017 Fiturb.DATAPPS. All rights reserved.
//

import Foundation

class UserCommentsModel {
    
    var commentId: String!
    
    var commentText: String!
    
    var createdDateAndTime: Dictionary<String, String>?
    
    var userId: String!
    
    var firstName: String!
    
    var thumbUrl: String!
    
    var averageRating: String!
    
    var activityId: String!
    
    var role: String!
    
    var messageText: String!
    
    func initWithJsonData(message: String?, dictionary:Dictionary<String, AnyObject>?) -> Any? {
        
        //Comments ID
        self.commentId = dictionary?["comment_id"] as? String ?? "No data"
        
        //Comment text
        self.commentText = dictionary?["comment_text"] as? String ?? "No data"
        
        //Comment created time
        let dateAndTimeStringOfAccount = dictionary?["created_at"] as? String ?? "0000-00-00 00:00:00"
        //Convert string to datefomate
        self.createdDateAndTime = (singleTon.sharedInstance.convertStringToDate(dateString:dateAndTimeStringOfAccount))
        
        
        //User ID
        self.userId = dictionary?["user_id"] as? String ?? "No data"
        
        //First name
        self.firstName = dictionary?["first_name"] as? String ?? "No data"
        
        //Thumb url
        self.thumbUrl = dictionary?["thumb_url"] as? String ?? "No data"

        //Average Rating
        self.averageRating = dictionary?["avg_rating"] as? String ?? "No data"

        //Activity Id
        self.activityId = dictionary?["activity_id"] as? String ?? "No data"

        //Role
        self.role = dictionary?["role"] as? String ?? "No data"

        //Message
        self.messageText = message ?? "No data"
        
        return self
        
    }
    
}
