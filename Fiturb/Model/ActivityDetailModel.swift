//
//  ActivityDetailModel.swift
//  Fiturb
//
//  Created by Admin on 08/05/17.
//  Copyright © 2017 Fiturb.DATAPPS. All rights reserved.
//

import UIKit
import ObjectMapper
import Foundation

class ActivityDetailModel:Mappable{
    
    var messageText: String?
    
    var title: String?
    
    var startDateAndTime: Dictionary<String, String>?
    
    var endDateAndTime: Dictionary<String, String>?
    
    var latitude: String?
    
    var longitude: String?
    
    var description: String?
    
    var capacity: String?
    
    var regisiteredMembersCount: String?
    
    var waitingCount: String?
    
    var entryFees: String?
    
    var likesCount: String?
    
    var sharesCount: String?
    
    var organiserPicture: String?
    
    var userId: String?
    
    var organisedBy: String?
    
    var adress: String?
    
    var interestId: String?
    
    var interestName: String?
    
    var colour: String?
    
    var isJoined: Bool?
    
    var isLiked: Bool?
    
    var isTimeUp: Bool?
    
    //For comments model
    var commentsCollection: [commentsModel]?
    
    //for memebers model
    var membersCollection: [membersModel]?
    
    //for ratings model
    var ratingsCollection: [ratingsModel]?
    
    
    required init?(map: Map) {
        
        
    }
    
    func mapping(map: Map) {
        
        messageText <- map["message"]
        
        title <- map["output.title"]
        
        latitude <- map["output.latitude"]
        
        longitude <- map["output.longitude"]
        
        description <- map["output.description"]
        
        capacity <- map["output.capacity"]
        
        regisiteredMembersCount <- map["output.registered_members"]
        
        waitingCount <- map["output.waiting"]
        
        entryFees <- map["output.entry_fees"]
        
        likesCount <- map["output.likes"]
        
        sharesCount <- map["output.shares"]
        
        organiserPicture <- map["output.organiser_pic"]
        
        userId <- map["output.user_id"]
        
        organisedBy <- map["output.organised_by"]
        
        adress <- map["output.address"]
        
        interestId <- map["output.interest_id"]
        
        interestName <- map["output.interest_name"]
        
        colour <- map["output.color"]
        
        //IsJoined or not
        var joinedStringValue:String?
        joinedStringValue <- map["output.joined"]
        isJoined = ((joinedStringValue == "1") ? true : false)
        
        //IsLiked Or not
        var likeStringValue:String?
        likeStringValue <- map["output.liked"]
        isLiked = ((likeStringValue == "1") ? true : false)
        
        //IsTimeUp or not
        var timeUpStringValue: String?
        timeUpStringValue <- map["output.time_up"]
        isTimeUp = ((timeUpStringValue == "1") ? true : false)
        
        //Start date and time
        var startDateString:String? = String()
        startDateString <- map["output.start_time"]
        startDateAndTime = (singleTon.sharedInstance.convertStringToDate(dateString:startDateString ?? "0000-00-00 00:00:00"))
        
        //End Date and Time
        var endDateString:String? = String()
        endDateString <- map["output.end_time"]
        endDateAndTime = (singleTon.sharedInstance.convertStringToDate(dateString:endDateString ?? "0000-00-00 00:00:00"))
        
        
        //Comments model
        commentsCollection <- map["output.comments"]
        
        //members model
        membersCollection <- map["output.members"]
        
        //ratings model
        ratingsCollection <- map["output.ratings"]
        
    }
}

class commentsModel: Mappable {
    
    var userId: String?
    
    var firstName: String?
    
    var thumbUrl: String?
    
    var commentId: String?
    
    var commentsText: String?
    
    var reviewsCount: String?
    
    
    required init?(map: Map) {
        
        
    }
    
     func mapping(map: Map) {
        
        userId <- map["user_id"]
        
        firstName <- map["first_name"]
        
        thumbUrl <- map["thumb_url"]
        
        commentId <- map["comment_id"]
        
        commentsText <- map["comment_text"]
        
        reviewsCount <- map["reviews_count"]
    }
}

class membersModel: Mappable {
    
    var userId: String?
    
    var firstName: String?
    
    var thumbUrl: String?
    
    var averageRating: String?
    
    var memberStatus: String?
    
    var memberRole: String?
    
    
    required init?(map: Map) {
        
        
    }
    
     func mapping(map: Map) {
        
        userId <- map["user_id"]
        
        firstName <- map["first_name"]
        
        thumbUrl <- map["thumb_url"]
        
        averageRating <- map["avg_rating"]
        
        memberStatus <- map["member_status"]
        
        memberRole <- map["role"]
        
    }
}

class ratingsModel: Mappable {
    
    var ratingId: String?
    
    var ratingTotal: String?
    
    var reviewsText: String?
    
    var createdDataAndTime: Dictionary<String, String>?
    
    var reviewerId: String?
    
    var reviewedBy: String?
    
    var reviewerImageUrl: String?
    
    var reviewerAvergeRating: String?
    
    var reviewerRatingsCount: String?
    
    var reviewesByThisUser: String?
    
    
    required init?(map: Map) {
        
        
    }
    
     func mapping(map: Map) {
        
        ratingId <- map["ratings_id"]
        
        ratingTotal <- map["rating"]
        
        reviewsText <- map["review"]
        
        //Created date and time
        var dateString:String? = String()
        dateString <- map["created_at"]
        createdDataAndTime = (singleTon.sharedInstance.convertStringToDate(dateString:dateString ?? "0000-00-00 00:00:00"))
        
        //reviewer ID
        reviewerId <- map["reviewer_id"]
        
        reviewedBy <- map["reviewed_by"]
        
        reviewerImageUrl <- map["reviewer"]
        
        reviewerAvergeRating <- map["reviewer_avg_rating"]
        
        reviewerRatingsCount <- map["reviewer_ratings_count"]
        
        reviewesByThisUser <- map["reviews_by_this_user"]
    }
    
}



//BY USING INHERITANCE CONCEPT
//class ActivityDetailModel:NSObject,Mappable{
//
//    var messageText: String?
//    
//    var commentsCollection: [commentsModel]?
//    
//    var membersCollection: [membersModel]?
//    
//    var ratingsCollection: [ratingsModel]?
//    
//    //Common Keys for ActivityDetail Model,Comments model and Members model
//    var userId: String?
//    
//    var firstName: String?
//    
//    var thumbUrl: String?
//    
//    required init?(map: Map) {
//        
//        
//    }
//    
//    func mapping(map: Map) {
//        
//        messageText <- map["message"]
//        
//        commentsCollection <- map["output.comments"]
//        
//        membersCollection <- map["output.members"]
//        
//        ratingsCollection <- map["output.ratings"]
//        
//    }
//}
//
//class commentsModel: ActivityDetailModel {
//    
////    var userId: String?
////    
////    var firstName: String?
////    
////    var thumbUrl: String?
//    
//    var commentId: String?
//    
//    var commentsText: String?
//    
//    var reviewsCount: String?
//    
//    
//        required init?(map: Map) {
//        
//            super.init(map: map)
//            
//        }
//
//     override func mapping(map: Map) {
//        
//        userId <- map["user_id"]
//        
//        firstName <- map["first_name"]
//        
//        thumbUrl <- map["thumb_url"]
//        
//        commentId <- map["comment_id"]
//        
//        commentsText <- map["comment_text"]
//        
//        reviewsCount <- map["reviews_count"]
//    }
//}
//
//class membersModel: ActivityDetailModel {
//    
//    
////    var userId: String?
////    
////    var firstName: String?
////    
////    var thumbUrl: String?
//    
//    var averageRating: String?
//    
//    var memberStatus: String?
//    
//    var memberRole: String?
//    
//    
//    required init?(map: Map) {
//        
//        super.init(map: map)
//        
//    }
//
//     override func mapping(map: Map) {
//        
//        userId <- map["user_id"]
//        
//        firstName <- map["first_name"]
//        
//        thumbUrl <- map["thumb_url"]
//        
//        averageRating <- map["avg_rating"]
//        
//        memberStatus <- map["member_status"]
//        
//        memberRole <- map["role"]
//        
//    }
//}
//
//class ratingsModel: ActivityDetailModel {
//    
//    var ratingId: String?
//    
//    var ratingTotal: String?
//    
//    var reviewsText: String?
//    
//    var createdDataAndTime: Dictionary<String, String>?
//    
//    var reviewerId: String?
//    
//    var reviewedBy: String?
//    
//    var reviewerImageUrl: String?
//    
//    var reviewerAvergeRating: String?
//    
//    var reviewerRatingsCount: String?
//    
//    var reviewesByThisUser: String?
//    
//    
//    required init?(map: Map) {
//        
//        super.init(map: map)
//        
//        
//    }
//
//    override func mapping(map: Map) {
//        
//        ratingId <- map["ratings_id"]
//        
//        ratingTotal <- map["rating"]
//        
//        reviewsText <- map["review"]
//        
//        //Created date and time
//        var dateString:String? = String()
//        dateString <- map["created_at"]
//        createdDataAndTime = (singleTon.sharedInstance.convertStringToDate(dateString:dateString ?? "0000-00-00 00:00:00"))
//
//        //reviewer ID
//        reviewerId <- map["reviewer_id"]
//        
//        reviewedBy <- map["reviewed_by"]
//
//        reviewerImageUrl <- map["reviewer"]
//        
//        reviewerAvergeRating <- map["reviewer_avg_rating"]
//        
//        reviewerRatingsCount <- map["reviewer_ratings_count"]
//        
//        reviewesByThisUser <- map["reviews_by_this_user"]
//    }
//    
//}
