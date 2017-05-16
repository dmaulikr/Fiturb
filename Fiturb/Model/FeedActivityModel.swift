//
//  FeedActivityModel.swift
//  Fiturb
//
//  Created by Admin on 06/04/17.
//  Copyright © 2017 Fiturb.DATAPPS. All rights reserved.
//

import Foundation

class FeedActivityModel {
    
    var activityId: String!
    
    var activityName: String!
    
    var activityTime: Dictionary<String, String>?
    
    var capacity: String!
    
    var status: String!
    
    var longitude: String!
    
    var latitude: String!
    
    var entryFees: String!
    
    var organisedBy: String!
    
    var userId: String!
    
    var registeredMembers: String!
    
    var averageRating: String!
    
    var reviewCounting: String!
    
    var age: String!
    
    var userThumb: String!
    
    var activityThumb: String!
    
    var joined: String!
    
    var messgeText: String!
    
    //NEW
    var cityName: String!
    
    var likeCount: String!
    
    var isLiked: Bool?
    
    var sharesCount: String!
    
    var commentsCount: String!
    
    var distance: Int!
    
    var descriptionText: String!
    
    var hexColourString : String!
    
    var joinedMembersImageUrls = [Any?]()
    
    func initWithJsonData(actitvityFeedDictionary: Dictionary<String, AnyObject>?, message: String?) -> Any?{
        
        //Message
        self.messgeText = message ?? "No data"
        
        //Activity Id
        self.activityId = actitvityFeedDictionary?["activity_id"] as? String ?? "No data"
        
        //Activity name
        self.activityName = actitvityFeedDictionary?["activity_name"] as? String ?? "No data"
        
        //Capacity
        self.capacity = actitvityFeedDictionary?["capacity"] as? String ?? "No data"
        
        //status
        self.status = actitvityFeedDictionary?["status"] as? String ?? "No data"
        
        //longitude
        self.longitude = actitvityFeedDictionary?["longitude"] as? String ?? "No data"
        
        //latitude
        self.latitude = actitvityFeedDictionary?["latitude"] as? String ?? "No data"
        
        //Entry fees
        self.entryFees = actitvityFeedDictionary?["entry_fees"] as? String ?? "No data"
        
        //Activity organiser name
        self.organisedBy = actitvityFeedDictionary?["organised_by"] as? String ?? "No data"
        
        //User Id
        self.userId = actitvityFeedDictionary?["user_id"] as? String ?? "No data"
        
        //registered members
        self.registeredMembers = actitvityFeedDictionary?["registered_members"] as? String ?? "No data"
        
        //average rating
        self.averageRating = actitvityFeedDictionary?["avg_rating"] as? String ?? "No data"
        
        //reviews count
        self.reviewCounting = actitvityFeedDictionary?["review_count"] as? String ?? "No data"
        
        //age
        self.age = actitvityFeedDictionary?["age"] as? String ?? "No data"
        
        //User thumb image
//        self.userThumb = actitvityFeedDictionary?["user_thumb"] as? String ?? "No data"
        self.userThumb = actitvityFeedDictionary?["user_thumb"] as? String ?? "http://designrfix.com/wp-content/uploads/2009/11/apple-wallpaper-for-iphone-33.jpg"

        
        //Activity thumb
        self.activityThumb = actitvityFeedDictionary?["activity_thumb"] as? String ?? "No data"
        
        //Joined
        self.joined = actitvityFeedDictionary?["joined"] as? String ?? "No data"
        
        //Activity Time
        let dateString = actitvityFeedDictionary?["activity_time"] as? String ?? "0000-00-00 00:00:00"
        
        //Convert string to datefomate
        self.activityTime = (singleTon.sharedInstance.convertStringToDate(dateString:dateString))
        
        print("feed activty time  object is:\(String(describing: self.activityTime))")
        
        
        //NEW
        
        //City name
        self.cityName = actitvityFeedDictionary?["city"] as? String ?? "No data"
        
        //Lke count
        self.likeCount = actitvityFeedDictionary?["likes"] as? String ?? "0"
        
        self.isLiked = ((actitvityFeedDictionary?["liked"] as? String == "1") ? true : false)
            
        //Shares count
        self.sharesCount = actitvityFeedDictionary?["shares"] as? String ?? "0"
        
        //Comments count
        self.commentsCount = actitvityFeedDictionary?["comments"] as? String ?? "0"
        
        //Distance
        let theStringDisance = actitvityFeedDictionary?["distance"] as? String ?? "0.0"
        self.distance = Int(Float(theStringDisance)!)
        
        //Description
        self.descriptionText = actitvityFeedDictionary?["description"] as? String ?? "No data"
        
        //Hex colour
        self.hexColourString = actitvityFeedDictionary?["color"] as? String ?? "#3CB80F"
        
        //Joined memmbers images collection
        var imagesNamesCollectionArray = Array<String?>()
        imagesNamesCollectionArray = (actitvityFeedDictionary?["urls"])! as! Array<String?>
        for index in 0...1 {
         
            self.joinedMembersImageUrls.append(imagesNamesCollectionArray[index] ?? "https://s-media-cache-ak0.pinimg.com/236x/82/25/4e/82254ea37d939bb7c2f4bdddc843b7b4.jpg")
            
        }
        
        return self
    }
}


//class FeedActivityModel {
//    
//    var activityId: String!
//    
//    var activityName: String!
//    
//    var activityTime: Dictionary<String, String>?
//    
//    var capacity: String!
//    
//    var status: String!
//    
//    var longitude: String!
//    
//    var latitude: String!
//    
//    var entryFees: String!
//    
//    var organisedBy: String!
//    
//    var userId: String!
//    
//    var registeredMembers: String!
//    
//    var averageRating: String!
//    
//    var reviewCounting: String!
//    
//    var age: String!
//    
//    var userThumb: String!
//    
//    var activityThumb: String!
//    
//    var joined: String!
//    
//    var messgeText: String!
//    
//    func initWithJsonData(actitvityFeedDictionary: Dictionary<String, AnyObject>?, message: String?) -> Any?{
//        
//        //Message
//        self.messgeText = message ?? "No data"
//        
//        //Activity Id
//        self.activityId = actitvityFeedDictionary?["activity_id"] as? String ?? "No data"
//        
//        //Activity name
//        self.activityName = actitvityFeedDictionary?["activity_name"] as? String ?? "No data"
//        
//        //Capacity
//        self.capacity = actitvityFeedDictionary?["capacity"] as? String ?? "No data"
//        
//        //status
//        self.status = actitvityFeedDictionary?["status"] as? String ?? "No data"
//        
//        //longitude
//        self.longitude = actitvityFeedDictionary?["longitude"] as? String ?? "No data"
//        
//        //latitude
//        self.latitude = actitvityFeedDictionary?["latitude"] as? String ?? "No data"
//        
//        //Entry fees
//        self.entryFees = actitvityFeedDictionary?["entry_fees"] as? String ?? "No data"
//        
//        //Activity organiser name
//        self.organisedBy = actitvityFeedDictionary?["organised_by"] as? String ?? "No data"
//        
//        //User Id
//        self.userId = actitvityFeedDictionary?["user_id"] as? String ?? "No data"
//        
//        //registered members
//        self.registeredMembers = actitvityFeedDictionary?["registered_members"] as? String ?? "No data"
//        
//        //average rating
//        self.averageRating = actitvityFeedDictionary?["avg_rating"] as? String ?? "No data"
//        
//        //reviews count
//        self.reviewCounting = actitvityFeedDictionary?["review_count"] as? String ?? "No data"
//        
//        //age
//        self.age = actitvityFeedDictionary?["age"] as? String ?? "No data"
//        
//        //User thumb image
//        self.userThumb = actitvityFeedDictionary?["user_thumb"] as? String ?? "No data"
//        
//        //Activity thumb
//        self.activityThumb = actitvityFeedDictionary?["activity_thumb"] as? String ?? "No data"
//        
//        //Joined
//        self.joined = actitvityFeedDictionary?["joined"] as? String ?? "No data"
//        
//        //Activity name
//        let dateString = actitvityFeedDictionary?["activity_time"] as? String ?? "0000-00-00 00:00:00"
//        
//        //Convert string to datefomate
//        self.activityTime = (singleTon.sharedInstance.convertStringToDate(dateString:dateString))
//        
//        print("feed activty time  object is:\(String(describing: self.activityTime))")
//    
//        return self
//    }
//}



