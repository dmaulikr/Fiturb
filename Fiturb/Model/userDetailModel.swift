//
//  userDetailModel.swift
//  Fiturb
//
//  Created by Admin on 13/04/17.
//  Copyright © 2017 Fiturb.DATAPPS. All rights reserved.
//

import Foundation

class userDetailModel{
    
    var thumbUrl: String!
    
    var firstName: String!
    
    var friendsCount: String!
    
    var followersCount: String!
    
    var reviewsRatingCount: String!
    
    var averageRatingTotalCount: String!
    
    var cityName: String!
    
    var accountCreatedDateAndTime: Dictionary<String, String>?
    
    var userBirthdayDate:Dictionary<String, String>?
    
    var friendShipStatus: String!
    
    var isFollowing: Bool!
    
    var userID: String!
    
    var messageText: String!
    
    
    func initWithJsonData(dictinaryObj dict:Dictionary<String, AnyObject>?, responseMessage message:String?) -> Any? {
       
        //User image
        self.thumbUrl = dict?["thumb_url"] as? String ?? "No data"
        
        //First name
        self.firstName = dict?["first_name"] as? String ?? "No data"
        
        //FriendsTotal Count
        self.friendsCount = dict?["friends_count"] as? String ?? "No data"
        
        //Followers count
        self.followersCount = dict?["followers_count"] as? String ?? "No data"
        
        //reviews rating count
        self.reviewsRatingCount = dict?["reviews_count"] as? String ?? "0.0"
        
        //Average rating count
        self.averageRatingTotalCount = dict?["avg_rating"] as? String ?? "0.0"
        
        //City name
        self.cityName = dict?["city"] as? String ?? "No data"
        
        //FriendShip Status
        self.friendShipStatus = dict?["friendship_status"] as? String ?? "No data"
        
        //following or not
        self.isFollowing = ((dict?["following"]?.boolValue == true) ? true : false)
        
        //user ID
        self.userID = dict?["user_id"] as? String ?? "No data"
        
        //Account created date and time
        let dateAndTimeStringOfAccount = dict?["created_time"] as? String ?? "0000-00-00 00:00:00"
        //Convert string to datefomate
        self.accountCreatedDateAndTime = (singleTon.sharedInstance.convertStringToDate(dateString:dateAndTimeStringOfAccount))
        
        
        //User birthday date
        let dateAndTimeStringOfBirthday = dict?["birthday"] as? String ?? "0000-00-00 00:00:00"
        //Convert string to datefomate
        self.userBirthdayDate = (singleTon.sharedInstance.convertStringToDate(dateString:dateAndTimeStringOfBirthday))
        
        //Message
        self.messageText = message ?? "No data"
        
        return self
    }
}
