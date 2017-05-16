//
//  Constants.swift
//  Fiturb
//
//  Created by Admin on 08/03/17.
//  Copyright © 2017 Fiturb.DATAPPS. All rights reserved.
//

import Foundation

struct MyAppConstants {
    
    //MARK:- Base url
    static let baseUrlString = "http://www.fiturber.info/fiturb/"
    
    //MARK:- Fiturb app api's
    static  let SignUpUrlString = "http://130.211.127.13/fiturb/Auth/user/registration"

    static let loginUrlString = "http://130.211.127.13/fiturb/Auth/user/login"
    
    //Feed activity Api
    static let feedActivityUrl = "http://www.fiturber.info/fiturb/Fiturb/activity/activity_feed/page/"
    
    static let socialAunthenticationUrl = "http://130.211.127.13/fiturb/Auth/user/social_authentication"
    
    static let thermaticListUrl  = "http://130.211.127.13/fiturb/Fiturb/thematics/thematics_list"
    
    static let interestlistOfThematicslistUrl = "http://130.211.127.13/fiturb/Fiturb/thematics/interests_list/theme/"
    
    //Verify Otp Api
    static let verifyOtpUrl = "http://130.211.127.13/fiturb/Auth/user/verify_otp/"
    
    //Send Otp Api
    static let sendOtpUrl = "http://130.211.127.13/fiturb/Auth/user/send_otp"
    
    //Forget password api
    static let forgetPasswordUrl = "http://www.fiturber.info/fiturb/Auth/user/forgot_password"
    
    //SignOut Api
    static let signOutUrl = "http://130.211.127.13/fiturb/Auth/user/logout"
    
    //Friends list api's
    static let friendsListUrl = "http://130.211.127.13/fiturb/Friend/friends/friends_list"
    
    //Accept friend request Api
    static let acceptFriendRquestUrl = "http://www.fiturber.info/fiturb/Friend/friends/accept_request"
    
    //Reject friend request Api
    static let rejectFriendRequestUrl = "http://www.fiturber.info/fiturb/Friend/friends/reject_request"
    
    //Cancel friend request Api
    static let cancelFriendRequestUrl = "http://www.fiturber.info/fiturb/Friend/friends/cancel_request"
    
    //Send friend request api
    static let sendFriendRequestUrl = "http://www.fiturber.info/fiturb/Friend/friends/send_request"
    
    //Search friends request api
    static let searchRequestUrl = "http://www.fiturber.info/fiturb/Friend/friends/search_friends"
    
    //MARK:- Groups segment control Api's
    //Add group member api
    static let addGroupUrl = "http://www.fiturber.info/fiturb/Friend/group/add_group"
    
    //Group list api
    static let groupListUrl = "http://www.fiturber.info/fiturb/Friend/group/groups_list"
    
    //Edit Group api
    static let editGroupUrl = "http://www.fiturber.info/fiturb/Friend/group/edit_group"
    
    //Delete group api
    static let deleteGroupUrl = "http://www.fiturber.info/fiturb/Friend/group/delete_group"
    
    //Group detail api
    static let groupDetailUrl = "http://www.fiturber.info/fiturb/Friend/group/group_details"
    
    //Delete group member api
    static let removeGroupMeberUrl = "http://www.fiturber.info/fiturb/Friend/group/remove_group_member"
    
    //Add group members api
    static let addGroupMemberUrl = "http://www.fiturber.info/fiturb/Friend/group/add_group_member"
    
    //Calender Activity Api
    static let calnederActivityUrl = "http://www.fiturber.info/fiturb/Fiturb/activity/activity_calender"
    
    //Crete activity Api
    static let createActivityUrl = "http://www.fiturber.info/fiturb/Fiturb/activity/create_activity"
    
    //User Detail api
    static let userDetailUrl = "http://www.fiturber.info/fiturb/Profile/user/view_profile"
    
    //MARK:- with baas url api's
    static let userCommentsUrl = "Fiturb/comments/user_comments"
    
    //Mutual friends Api
    static let mutualFriendsUrl = "Friend/friends/mutual_friends"
        
    //Followers friends Api
    static let followersFriendsUrl = "Friend/followers/followers_list"
    
    //User Interest list Api
    static let userInterestListUrl = "Fiturb/interest/user_interests_list"
    
    //Follow friend Api
    static let followFriendUrl = "Friend/followers/follow"
    
    //UnFollow friend Api
    static let unfollowFriendUrl = "Friend/followers/unfollow"
    
    //Like activity Api
    static let likeActivityUrl = "Fiturb/activity/like"
    
    //UnLike activity Api
    static let unLikeActivityUrl = "Fiturb/activity/unlike"
    
    //Delete user account Api
    static let deleteUserAccountUrl = "Profile/user/delete_account"
    
    //Edit user profile Api
    static let editUserProfileUrl = "Profile/user/edit_profile"
    
    //Add user interest list Api
    static let addUserInterestlistUrl = "Fiturb/interest/add_user_interest"
    
    //Update location Api
    static let updateLocationUrl = "Fiturb/live_activity/update_location"
    
    //Activity detail Api
    static let acitivityDetailUrl = "Fiturb/activity/activity_details"
    
    
    //MARK:- App Error messages
    static let jsonErrorMsg = "No Data Available, please try again later!"
    
    static let noResponseFromServerErrorMsg = "No response from server, please try again later!"
 
}

////Enum for Success and error handling
//public enum responseResult<Value> {
//    
//    case Success(Value?)
//    
//    case Failure(NSError?)
//
//}

//Enum for Success and error handling
public enum responseResult<Value> {
    
    case Success(Value?)
    
    case Failure(NSError?)
    
}

//Enum for Add and remov loader
public enum loaderAddOrRemove {
    
    case AddLoader
    
    case RemoveLoader

    
}
