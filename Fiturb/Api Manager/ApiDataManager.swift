//
//  ApiDataManager.swift
//  Fiturb
//
//  Created by Admin on 06/03/17.
//  Copyright © 2017 Fiturb.DATAPPS. All rights reserved.
//

import UIKit

class ApiDataManager: NSObject {
    
    //MARK:- Api dataManager Single ton obejct
    static let singleTonObjectForApiManagerClass = ApiDataManager()
    
    private override init() {
        
    }

    //MARK:- Api service methods
    
    //Update location Api(Post method)
    public func updateLocationApiValuesWithUrlString(urlString url:String, withPostData postDataDictionary:Dictionary<String, Any>,callBackBlock completionHandler:@escaping (_ apiRecievedResponse:Array<AnyObject>?,_ error: NSError?) -> ()){
    
        //user Authetication token
        let autheticationToken = (singleTon.sharedInstance.getUserAuthenticationToken()) ?? ""

        self.commonPostServiceMethod(urlString: url, userAutheticationToken: autheticationToken, withPostData: postDataDictionary as Dictionary<String, AnyObject>, callBackBlock: { (jsonObject: Dictionary<String, AnyObject>?, error:NSError?) in
            
            print("Update location Api recived response is:\(jsonObject)")
            
            guard error == nil else{
                
                //Error handling
                let error = NSError(domain:"FiturbApp",
                                    code: 100,
                                    userInfo: [NSLocalizedFailureReasonErrorKey :error!.localizedFailureReason!])
                
                
                DispatchQueue.main.async(execute: {
                    
                    completionHandler(nil , error)
                });
                
                return
            }

            let message = jsonObject?["message"]
            
            //Create array to pass all json parsed data to classes
            var responseArray = [AnyObject]()
            
            //Update location model object
            let updateLocationModelObj = UpdateLocationModel().initWithJsonData(messageText: message as? String)  as? UpdateLocationModel
            
            if updateLocationModelObj != nil{
                
                responseArray.append(updateLocationModelObj!)
            }
            
            //Check array count
            if responseArray.count == 0{
                
                let error = NSError(domain:"FiturbApp",
                                    code: 100,
                                    userInfo: [NSLocalizedFailureReasonErrorKey : message ?? MyAppConstants.jsonErrorMsg])
                
                //Error(No data available)
                DispatchQueue.main.async(execute: {
                    completionHandler(nil , error)
                });
                
            }
            else{
                
                //Success
                DispatchQueue.main.async(execute: {
                    completionHandler(responseArray , error)
                });
            }
            
        })
        
    }
    
    //Add user Interest list(POST method)
    public func addUserInterestListApiValuesWithUrlString(urlString url:String,  withPostData postDataDictionary:Dictionary<String, String>, callBackBlock completionHandler:@escaping (_ apiRecievedResponse:Array<AnyObject>?,_ error: NSError?) -> ()) {
        
        //user Authetication token
        let autheticationToken = (singleTon.sharedInstance.getUserAuthenticationToken()) ?? ""
        
        self.commonPostServiceMethod(urlString: url, userAutheticationToken:autheticationToken, withPostData: postDataDictionary as Dictionary<String, AnyObject>) { (jSONObject: Dictionary<String, AnyObject>?, error:NSError?) in
            
            print("Add User Interest list api recieved response is:\(jSONObject)")
            
            guard error == nil else{
                
                //Error handling
                let error = NSError(domain:"FiturbApp",
                                    code: 100,
                                    userInfo: [NSLocalizedFailureReasonErrorKey :error!.localizedFailureReason!])
                
                
                DispatchQueue.main.async(execute: {
                    
                    completionHandler(nil , error)
                });
                
                return
            }
            
            let message =  jSONObject?["message"]
            
            //Add user interest list informationas? Array<AnyObject>
            let arrayCollection = jSONObject?["output"] as? Array<AnyObject>
            
            //Create array to pass all json parsed data to classes
            var responseArray = [AnyObject]()
            
            for obj in arrayCollection!{
                
                let userDataDict = obj as? Dictionary<String, AnyObject>
                
                //Add User interest list modal object
                let addUserInterestListModalObj = AddUserInterestsModel().initWithJsonData(messageText: message as? String, dictionary: userDataDict) as? AddUserInterestsModel
                
                if addUserInterestListModalObj != nil{
                    
                    responseArray.append(addUserInterestListModalObj!)
                    
                    print("Add user interest list model object is :\(addUserInterestListModalObj)")
                    
                }
                
            }
            
            //Check array count
            if responseArray.count == 0{
                
                let error = NSError(domain:"FiturbApp",
                                    code: 100,
                                    userInfo: [NSLocalizedFailureReasonErrorKey : message ?? MyAppConstants.jsonErrorMsg])
                
                //Error(No data available)
                DispatchQueue.main.async(execute: {
                    completionHandler(nil , error)
                });
                
            }
            else{
                
                //Success
                DispatchQueue.main.async(execute: {
                    completionHandler(responseArray , error)
                });
            }
            
        }
        
    }

    
    //Edit user profile Api
    public func editUserProfileApiValuesWithUrlString(urlString url:String,  withPostData postDataDictionary:Dictionary<String, String>, callBackBlock completionHandler:@escaping (_ apiRecievedResponse:Array<AnyObject>?,_ error: NSError?) -> ()) {
        
        //user Authetication token
        let autheticationToken = (singleTon.sharedInstance.getUserAuthenticationToken()) ?? ""
        
        self.commonPostServiceMethod(urlString: url, userAutheticationToken:autheticationToken, withPostData: postDataDictionary as Dictionary<String, AnyObject>) { (jSONObject: Dictionary<String, AnyObject>?, error:NSError?) in
            
            print("Edit User profile api recieved response is:\(jSONObject)")
            
            guard error == nil else{
                
                //Error handling
                let error = NSError(domain:"FiturbApp",
                                    code: 100,
                                    userInfo: [NSLocalizedFailureReasonErrorKey :error!.localizedFailureReason!])
                
                
                DispatchQueue.main.async(execute: {
                    
                    completionHandler(nil , error)
                });
                
                return
            }
            
            let message =  jSONObject?["message"]
            
            var responseArray = [AnyObject]()
            
            let modelObj = EditUserProfileModel().initWithJsonData(messageText: message as? String) as? EditUserProfileModel
            
            if modelObj != nil{
                
                responseArray.append(modelObj!)
                
            }
            
            //Check array count
            if(responseArray.count == 0){
                
                
                let error = NSError(domain:"FiturbApp",
                                    code: 100,
                                    userInfo: [NSLocalizedFailureReasonErrorKey : message ?? MyAppConstants.jsonErrorMsg])
                
                //Error(No data available)
                DispatchQueue.main.async(execute: {
                    completionHandler(nil , error)
                });
                
            }
            else{
                
                //Success
                DispatchQueue.main.async(execute: {
                    completionHandler(responseArray , error)
                });
            }
            
        }
        
    }

    
    //Delete user Account api
    public func deleteUserAccountApiValuesWithUrlString(urlString url:String,  withPostData postDataDictionary:Dictionary<String, String>, callBackBlock completionHandler:@escaping (_ apiRecievedResponse:Array<AnyObject>?,_ error: NSError?) -> ()) {
        
        //user Authetication token
        let autheticationToken = (singleTon.sharedInstance.getUserAuthenticationToken()) ?? ""
        
        self.commonPostServiceMethod(urlString: url, userAutheticationToken:autheticationToken, withPostData: postDataDictionary as Dictionary<String, AnyObject>) { (jSONObject: Dictionary<String, AnyObject>?, error:NSError?) in
            
            print("delete User account api recieved response is:\(jSONObject)")
            
            guard error == nil else{
                
                //Error handling
                let error = NSError(domain:"FiturbApp",
                                    code: 100,
                                    userInfo: [NSLocalizedFailureReasonErrorKey :error!.localizedFailureReason!])
                
                
                DispatchQueue.main.async(execute: {
                    
                    completionHandler(nil , error)
                });
                
                return
            }
            
            let message =  jSONObject?["message"]
            
            var responseArray = [AnyObject]()
            
            let modelObj = DeleteUserAccountModel().initWithJsonData(messageText: message as? String) as? DeleteUserAccountModel
            
            if modelObj != nil{
                
                responseArray.append(modelObj!)
                
            }
            
            //Check array count
            if(responseArray.count == 0){
                
                
                let error = NSError(domain:"FiturbApp",
                                    code: 100,
                                    userInfo: [NSLocalizedFailureReasonErrorKey : message ?? MyAppConstants.jsonErrorMsg])
                
                //Error(No data available)
                DispatchQueue.main.async(execute: {
                    completionHandler(nil , error)
                });
                
            }
            else{
                
                //Success
                DispatchQueue.main.async(execute: {
                    completionHandler(responseArray , error)
                });
            }
            
        }
        
    }

    
    //Like api(POST)
    public func likeApiValuesWithUrlString(urlString url:String,  withPostData postDataDictionary:Dictionary<String, String>, callBackBlock completionHandler:@escaping (_ apiRecievedResponse:Array<AnyObject>?,_ error: NSError?) -> ()) {
        
        //user Authetication token
        let autheticationToken = (singleTon.sharedInstance.getUserAuthenticationToken()) ?? ""
        
        self.commonPostServiceMethod(urlString: url, userAutheticationToken:autheticationToken, withPostData: postDataDictionary as Dictionary<String, AnyObject>) { (jSONObject: Dictionary<String, AnyObject>?, error:NSError?) in
            
            print("Like api recieved response is:\(jSONObject)")
            
            guard error == nil else{
                
                //Error handling
                let error = NSError(domain:"FiturbApp",
                                    code: 100,
                                    userInfo: [NSLocalizedFailureReasonErrorKey :error!.localizedFailureReason!])
                
                
                DispatchQueue.main.async(execute: {
                    
                    completionHandler(nil , error)
                });
                
                return
            }
            
            let message =  jSONObject?["message"]
            
            var responseArray = [AnyObject]()
            
            let modelObj = LikeModel().initWithJsonData(messageText: message as? String) as? LikeModel
            
            if modelObj != nil{
                
                responseArray.append(modelObj!)
                
            }
            
            //Check array count
            if(responseArray.count == 0){
                
                let error = NSError(domain:"FiturbApp",
                                    code: 100,
                                    userInfo: [NSLocalizedFailureReasonErrorKey: message ??  MyAppConstants.jsonErrorMsg])
                
                //Error(No data available)
                DispatchQueue.main.async(execute: {
                    completionHandler(nil , error)
                });
                
            }
            else{
                
                //Success
                DispatchQueue.main.async(execute: {
                    completionHandler(responseArray , error)
                });
            }
            
        }
        
    }

    //Unlike Activity Api(POST)
    public func unLikeApiValuesWithUrlString(urlString url:String,  withPostData postDataDictionary:Dictionary<String, String>, callBackBlock completionHandler:@escaping (_ apiRecievedResponse:Array<AnyObject>?,_ error: NSError?) -> ()) {
        
        //user Authetication token
        let autheticationToken = (singleTon.sharedInstance.getUserAuthenticationToken()) ?? ""
        
        self.commonPostServiceMethod(urlString: url, userAutheticationToken:autheticationToken, withPostData: postDataDictionary as Dictionary<String, AnyObject>) { (jSONObject: Dictionary<String, AnyObject>?, error:NSError?) in
            
            print("UNLike api recieved response is:\(jSONObject)")
            
            guard error == nil else{
                
                //Error handling
                let error = NSError(domain:"FiturbApp",
                                    code: 100,
                                    userInfo: [NSLocalizedFailureReasonErrorKey :error!.localizedFailureReason!])
                
                
                DispatchQueue.main.async(execute: {
                    
                    completionHandler(nil , error)
                });
                
                return
            }
            
            let message =  jSONObject?["message"]
            
            var responseArray = [AnyObject]()
            
            let modelObj = UnLikeModel().initWithJsonData(messageText: message as? String) as? UnLikeModel
            
            if modelObj != nil{
                
                responseArray.append(modelObj!)
                
            }
            
            //Check array count
            if(responseArray.count == 0){
                
                let error = NSError(domain:"FiturbApp",
                                    code: 100,
                                    userInfo: [NSLocalizedFailureReasonErrorKey: message ??  MyAppConstants.jsonErrorMsg])
                
                //Error(No data available)
                DispatchQueue.main.async(execute: {
                    completionHandler(nil , error)
                });
                
            }
            else{
                
                //Success
                DispatchQueue.main.async(execute: {
                    completionHandler(responseArray , error)
                });
            }
            
        }
        
    }
    
    
    //Follow Api(POST method)
    public func fallowApiValuesWithUrlString(urlString url:String,  withPostData postDataDictionary:Dictionary<String, String>, callBackBlock completionHandler:@escaping (_ apiRecievedResponse:Array<AnyObject>?,_ error: NSError?) -> ()) {
        
        //user Authetication token
        let autheticationToken = (singleTon.sharedInstance.getUserAuthenticationToken()) ?? ""
        
        self.commonPostServiceMethod(urlString: url, userAutheticationToken:autheticationToken, withPostData: postDataDictionary as Dictionary<String, AnyObject>) { (jSONObject: Dictionary<String, AnyObject>?, error:NSError?) in
            
            print("fallow api recieved response is:\(jSONObject)")
            
            guard error == nil else{
                
                //Error handling
                let error = NSError(domain:"FiturbApp",
                                    code: 100,
                                    userInfo: [NSLocalizedFailureReasonErrorKey :error!.localizedFailureReason!])
                
                
                DispatchQueue.main.async(execute: {
                    
                    completionHandler(nil , error)
                });
                
                return
            }
            
            let message =  jSONObject?["message"]
            
            var responseArray = [AnyObject]()
            
            //Fallow friends model object
            let modelObj = FollowFriendsModel().initWithJsonData(messageText: message as? String) as? FollowFriendsModel
            
            if modelObj != nil{
                
                responseArray.append(modelObj!)
                
            }
            
            //Check array count
            if(responseArray.count == 0){
                
                let error = NSError(domain:"FiturbApp",
                                    code: 100,
                                    userInfo: [NSLocalizedFailureReasonErrorKey: message ??  MyAppConstants.jsonErrorMsg])
                
                //Error(No data available)
                DispatchQueue.main.async(execute: {
                    completionHandler(nil , error)
                });
                
            }
            else{
                
                //Success
                DispatchQueue.main.async(execute: {
                    completionHandler(responseArray , error)
                });
            }
            
        }
        
    }

    //UnFallow Api(POST method)
    public func unFallowApiValuesWithUrlString(urlString url:String,  withPostData postDataDictionary:Dictionary<String, String>, callBackBlock completionHandler:@escaping (_ apiRecievedResponse:Array<AnyObject>?,_ error: NSError?) -> ()) {
        
        //user Authetication token
        let autheticationToken = (singleTon.sharedInstance.getUserAuthenticationToken()) ?? ""
        
        self.commonPostServiceMethod(urlString: url, userAutheticationToken:autheticationToken, withPostData: postDataDictionary as Dictionary<String, AnyObject>) { (jSONObject: Dictionary<String, AnyObject>?, error:NSError?) in
            
            print("unFallow api recieved response is:\(jSONObject)")
            
            guard error == nil else{
                
                //Error handling
                let error = NSError(domain:"FiturbApp",
                                    code: 100,
                                    userInfo: [NSLocalizedFailureReasonErrorKey :error!.localizedFailureReason!])
                
                
                DispatchQueue.main.async(execute: {
                    
                    completionHandler(nil , error)
                });
                
                return
            }
            
            let message =  jSONObject?["message"]
            
            var responseArray = [AnyObject]()
            
            //UnFallow friends model object
            let modelObj = UnFallowFriendsModel().initWithJsonData(messageText: message as? String) as? UnFallowFriendsModel
            
            if modelObj != nil{
                
                responseArray.append(modelObj!)
                
            }
            
            //Check array count
            if(responseArray.count == 0){
                
                let error = NSError(domain:"FiturbApp",
                                    code: 100,
                                    userInfo: [NSLocalizedFailureReasonErrorKey: message ??  MyAppConstants.jsonErrorMsg])
                
                //Error(No data available)
                DispatchQueue.main.async(execute: {
                    completionHandler(nil , error)
                });
                
            }
            else{
                
                //Success
                DispatchQueue.main.async(execute: {
                    completionHandler(responseArray , error)
                });
            }
            
        }
        
    }

    
    //user Interest list(POST method)
    public func getUserInterestListApiValuesWithUrlString(urlString url:String,  withPostData postDataDictionary:Dictionary<String, String>, callBackBlock completionHandler:@escaping (_ apiRecievedResponse:Array<AnyObject>?,_ error: NSError?) -> ()) {
        
        //user Authetication token
        let autheticationToken = (singleTon.sharedInstance.getUserAuthenticationToken()) ?? ""
        
        self.commonPostServiceMethod(urlString: url, userAutheticationToken:autheticationToken, withPostData: postDataDictionary as Dictionary<String, AnyObject>) { (jSONObject: Dictionary<String, AnyObject>?, error:NSError?) in
            
            print("User Interest list api recieved response is:\(jSONObject)")
            
            guard error == nil else{
                
                //Error handling
                let error = NSError(domain:"FiturbApp",
                                    code: 100,
                                    userInfo: [NSLocalizedFailureReasonErrorKey :error!.localizedFailureReason!])
                
                
                DispatchQueue.main.async(execute: {
                    
                    completionHandler(nil , error)
                });
                
                return
            }
            
            let message =  jSONObject?["message"]
            
            //user interest list informationas? Array<AnyObject>
            let arrayCollection = jSONObject?["output"] as? Array<AnyObject>
            
            //Create array to pass all json parsed data to classes
            var responseArray = [AnyObject]()
            
            for obj in arrayCollection!{
                
                let userDataDict = obj as? Dictionary<String, AnyObject>
                
                //User interest list modal object
                let userInterestListModalObj = InterestListModel().initWithJsonData(messageText: message as? String, dictionary: userDataDict) as? InterestListModel
                
                if userInterestListModalObj != nil{
                    
                    responseArray.append(userInterestListModalObj!)
                    
                    print("user interest list model object is :\(userInterestListModalObj)")
                    
                }
                
            }
            
            //Check array count
            if responseArray.count == 0{
                
                let error = NSError(domain:"FiturbApp",
                                    code: 100,
                                    userInfo: [NSLocalizedFailureReasonErrorKey : message ?? MyAppConstants.jsonErrorMsg])
                
                //Error(No data available)
                DispatchQueue.main.async(execute: {
                    completionHandler(nil , error)
                });
                
            }
            else{
                
                //Success
                DispatchQueue.main.async(execute: {
                    completionHandler(responseArray , error)
                });
            }
            
        }
        
    }

    
    //friends followers list(POST method)
    public func getFollowersFriendsListApiValuesWithUrlString(urlString url:String,  withPostData postDataDictionary:Dictionary<String, AnyObject>, callBackBlock completionHandler:@escaping (_ apiRecievedResponse:Array<AnyObject>?,_ error: NSError?) -> ()) {
        
        //user Authetication token
        let autheticationToken = (singleTon.sharedInstance.getUserAuthenticationToken()) ?? ""
        print("Authentication token in Followers friends list api:\(autheticationToken)")
        
        self.commonPostServiceMethod(urlString: url, userAutheticationToken: autheticationToken, withPostData: postDataDictionary) { (jSONObject:Dictionary<String,AnyObject>?, error:NSError?) in
            
            print("Follwers friends list apis recieved response is:\(jSONObject)")
            
            guard error == nil else{
                
                //Error handling
                let error = NSError(domain:"FiturbApp",
                                    code: 100,
                                    userInfo: [NSLocalizedFailureReasonErrorKey :MyAppConstants.jsonErrorMsg])
                
                
                DispatchQueue.main.async(execute: {
                    
                    completionHandler(nil , error)
                });
                
                return
            }
            
            //Response message key
            let message = jSONObject?["message"]
            
            //Followers friends informationas? Array<AnyObject>
            let arrayCollection = jSONObject?["output"] as? Array<AnyObject>
            
            //Create array to pass all json parsed data to classes
            var responseArray = [AnyObject]()
            
            for eachComment in arrayCollection!{
                
                let userDataDict = eachComment as? Dictionary<String, AnyObject>
                
                //Followers friends modal object
                let followersFriendsModalObj = FollowersFriendsModel().initWithJsonData(messageText: message as? String, dictionary: userDataDict) as? FollowersFriendsModel
                
                if followersFriendsModalObj != nil{
                    
                    responseArray.append(followersFriendsModalObj!)
                    
                    print("Followers friends model object is :\(followersFriendsModalObj)")
                    
                }
                
            }
            
            //Check array count
            if responseArray.count == 0{
                
                let error = NSError(domain:"FiturbApp",
                                    code: 100,
                                    userInfo: [NSLocalizedFailureReasonErrorKey :message ?? MyAppConstants.jsonErrorMsg])
                
                //Error(No data available)
                DispatchQueue.main.async(execute: {
                    completionHandler(nil , error)
                });
                
            }
            else{
                
                //Success
                DispatchQueue.main.async(execute: {
                    completionHandler(responseArray , error)
                });
            }
            
        }
        
    }
    
    
    //Mutual friends List Api(POST)
    public func getMutualFriendsApiValuesWithUrlString(urlString url:String,  withPostData postDataDictionary:Dictionary<String, AnyObject>, callBackBlock completionHandler:@escaping (_ apiRecievedResponse:Array<AnyObject>?,_ error: NSError?) -> ()) {
        
        //user Authetication token
        let autheticationToken = (singleTon.sharedInstance.getUserAuthenticationToken()) ?? ""
        print("Authentication token in Mutual friends list api:\(autheticationToken)")
        
        self.commonPostServiceMethod(urlString: url, userAutheticationToken: autheticationToken, withPostData: postDataDictionary) { (jSONObject:Dictionary<String,AnyObject>?, error:NSError?) in
            
            print("mutual friends list apis recieved response is:\(jSONObject)")
            
            guard error == nil else{
                
                //Error handling
                let error = NSError(domain:"FiturbApp",
                                    code: 100,
                                    userInfo: [NSLocalizedFailureReasonErrorKey :MyAppConstants.jsonErrorMsg])
                
                
                DispatchQueue.main.async(execute: {
                    
                    completionHandler(nil , error)
                });
                
                return
            }
            
            //Response message key
            let message = jSONObject?["message"]
            
            //mutual friends informationas? Array<AnyObject>
            let arrayCollection = jSONObject?["output"] as? Array<AnyObject>
            
            //Create array to pass all json parsed data to classes
            var responseArray = [AnyObject]()
            
            for eachComment in arrayCollection!{
                
                let userDataDict = eachComment as? Dictionary<String, AnyObject>
                
                //mutual friends modal object
                let mutualFriendsModalObj = MutualFriendsModel().initWithJsonData(messageText: message as? String, dictionary: userDataDict) as? MutualFriendsModel
                
                if mutualFriendsModalObj != nil{
                    
                    responseArray.append(mutualFriendsModalObj!)
                    
                    print("mutual friends model object is :\(mutualFriendsModalObj)")
                    
                }
                
            }
            
            //Check array count
            if responseArray.count == 0{
                
                let error = NSError(domain:"FiturbApp",
                                    code: 100,
                                    userInfo: [NSLocalizedFailureReasonErrorKey :message ?? MyAppConstants.jsonErrorMsg])
                
                //Error(No data available)
                DispatchQueue.main.async(execute: {
                    completionHandler(nil , error)
                });
                
            }
            else{
                
                //Success
                DispatchQueue.main.async(execute: {
                    completionHandler(responseArray , error)
                });
            }
            
        }
        
    }

    
    //User Comments service method(POST)
    public func getUserCommentsApiValuesWithUrlString(urlString url:String,  withPostData postDataDictionary:Dictionary<String, String>, callBackBlock completionHandler:@escaping (_ apiRecievedResponse:Array<AnyObject>?,_ error: NSError?) -> ()) {
        
        //user Authetication token
        let autheticationToken = (singleTon.sharedInstance.getUserAuthenticationToken()) ?? ""
        
        self.commonPostServiceMethod(urlString: url, userAutheticationToken:autheticationToken, withPostData: postDataDictionary as Dictionary<String, AnyObject>) { (jSONObject: Dictionary<String, AnyObject>?, error:NSError?) in
            
            print("User Comments api recieved response is:\(jSONObject)")
            
            guard error == nil else{
                
                //Error handling
                let error = NSError(domain:"FiturbApp",
                                    code: 100,
                                    userInfo: [NSLocalizedFailureReasonErrorKey :error!.localizedFailureReason!])
                
                
                DispatchQueue.main.async(execute: {
                    
                    completionHandler(nil , error)
                });
                
                return
            }
            
            let message =  jSONObject?["message"]
            
            //user comments informationas? Array<AnyObject>
            let arrayCollection = jSONObject?["output"] as? Array<AnyObject>
            
            //Create array to pass all json parsed data to classes
            var responseArray = [AnyObject]()
            
            for eachComment in arrayCollection!{
                
                let userDataDict = eachComment as? Dictionary<String, AnyObject>
                
                //User Comments modal object
                let userCommentsModalObj = UserCommentsModel().initWithJsonData(message: message as? String, dictionary: userDataDict) as? UserCommentsModel
                
                if userCommentsModalObj != nil{
                    
                    responseArray.append(userCommentsModalObj!)
                    
                    print("user comments model object is :\(userCommentsModalObj)")
                    
                }
                
            }
            
            //Check array count
            if responseArray.count == 0{
                
                let error = NSError(domain:"FiturbApp",
                                    code: 100,
                                    userInfo: [NSLocalizedFailureReasonErrorKey : message ?? MyAppConstants.jsonErrorMsg])
                
                //Error(No data available)
                DispatchQueue.main.async(execute: {
                    completionHandler(nil , error)
                });
                
            }
            else{
                
                //Success
                DispatchQueue.main.async(execute: {
                    completionHandler(responseArray , error)
                });
            }
            
        }
        
    }

    
    //User Detail service method(POST)
    public func getUserDetailApiValuesWithUrlString(urlString url:String,  withPostData postDataDictionary:Dictionary<String, String>, callBackBlock completionHandler:@escaping (_ apiRecievedResponse:Array<AnyObject>?,_ error: NSError?) -> ()) {
        
        //user Authetication token
        let autheticationToken = (singleTon.sharedInstance.getUserAuthenticationToken()) ?? ""
        
        self.commonPostServiceMethod(urlString: url, userAutheticationToken:autheticationToken, withPostData: postDataDictionary as Dictionary<String, AnyObject>) { (jSONObject: Dictionary<String, AnyObject>?, error:NSError?) in
            
            print("User detail api recieved response is:\(jSONObject)")
            
            guard error == nil else{
                
                //Error handling
                let error = NSError(domain:"FiturbApp",
                                    code: 100,
                                    userInfo: [NSLocalizedFailureReasonErrorKey :error!.localizedFailureReason!])
                
                
                DispatchQueue.main.async(execute: {
                    
                    completionHandler(nil , error)
                });
                
                return
            }
            
            let message =  jSONObject?["message"]
            
            //user detail information
            let userDataDict = jSONObject?["output"] as? Dictionary<String, AnyObject>
            
            //User detail modal class object
            let userDetailClassModalObj = userDetailModel().initWithJsonData(dictinaryObj: userDataDict, responseMessage: message as? String) as? userDetailModel
            
            //Create array to pass all json parsed data to classes
            var responseArray = [AnyObject]()
            
            if userDetailClassModalObj != nil{
                
                responseArray.append(userDetailClassModalObj!)
                
                print("user detail model object is :\(userDetailClassModalObj)")
                
            }
            
            //Check array count
            if responseArray.count == 0{
                
                let error = NSError(domain:"FiturbApp",
                                    code: 100,
                                    userInfo: [NSLocalizedFailureReasonErrorKey : message ?? MyAppConstants.jsonErrorMsg])
                
                //Error(No data available)
                DispatchQueue.main.async(execute: {
                    completionHandler(nil , error)
                });
                
            }
            else{
                
                //Success
                DispatchQueue.main.async(execute: {
                    completionHandler(responseArray , error)
                });
            }
            
        }
        
    }

    
    //Get Calender activity service method(GET)
    public func getCalenderActivityApiValuesWithUrlString(urlString url:String, callBackBlock completionHandler:@escaping (_ apiRecievedResponse:Array<AnyObject>?,_ error: NSError?) -> ()) {
        
        //user Authetication token
        let autheticationToken = (singleTon.sharedInstance.getUserAuthenticationToken()) ?? ""
        
        self.commonGetServiceMethod(urlString:url , userAutheticationToken: autheticationToken) { (jSONObject:Dictionary<String, AnyObject>?, error:NSError?) in
            
            print("Calender Activity api response is:\(jSONObject)")
            
            guard error == nil else{
                
                //Error handling
                let error = NSError(domain:"FiturbApp",
                                    code: 100,
                                    userInfo: [NSLocalizedFailureReasonErrorKey :MyAppConstants.jsonErrorMsg])
                
                
                DispatchQueue.main.async(execute: {
                    
                    completionHandler(nil , error)
                });
                
                return
            }
            
            
            let message = jSONObject?["message"]
            
            let outPutArrayObj = jSONObject?["output"] as? Array<AnyObject>
            
            //Create array to pass all json parsed data to classes
            var responseArray = [AnyObject]()
            
            for arrayElements in outPutArrayObj!{
                
                //Calender activity Model object
                let calnederActivityModelObj = CalenderActivityModel().initWithJsonData(calenderActivityDictionary: arrayElements as? Dictionary<String, AnyObject>, message: message as? String)  as? CalenderActivityModel
                
                if calnederActivityModelObj != nil{
                    
                    //Add model object to one array
                    responseArray.append(calnederActivityModelObj!)
                    
                }
                
            }
            
            //Check array count
            if responseArray.count == 0{
                
                let error = NSError(domain:"FiturbApp",
                                    code: 100,
                                    userInfo: [NSLocalizedFailureReasonErrorKey :message ?? MyAppConstants.jsonErrorMsg])
                
                //Error(No data available)
                DispatchQueue.main.async(execute: {
                    completionHandler(nil , error)
                });
                
            }
            else{
                
                //Success
                DispatchQueue.main.async(execute: {
                    completionHandler(responseArray , error)
                });
            }
        }
    }

    
    //Get Actitvity Feed api service method
    public func getActivityFeedApiValuesWithUrlString(urlString url:String, callBackBlock completionHandler:@escaping (_ apiRecievedResponse:Array<AnyObject>?,_ error: NSError?) -> ()) {
        
        //user Authetication token
        let autheticationToken = (singleTon.sharedInstance.getUserAuthenticationToken()) ?? ""
        
        self.commonGetServiceMethod(urlString:url , userAutheticationToken: autheticationToken) { (jSONObject:Dictionary<String, AnyObject>?, error:NSError?)  in
            
            print("Activity feed api response is:\(jSONObject)")
            
            guard error == nil else{
                
                //Error handling
                let error = NSError(domain:"FiturbApp",
                                    code: 100,
                                    userInfo: [NSLocalizedFailureReasonErrorKey :error?.localizedFailureReason ?? MyAppConstants.jsonErrorMsg])
                
                
                DispatchQueue.main.async(execute: {
                    
                    completionHandler(nil , error)
                });
                
                return
            }
            
            
            let message = jSONObject?["message"]
            
            let outPutArrayObj = jSONObject?["output"] as? Array<AnyObject>
            
            //Create array to pass all json parsed data to classes
            var responseArray = [AnyObject]()
            
            for arrayElements in outPutArrayObj!{
                
                //feed Activity model Model object
                let feedActivityModelObj = FeedActivityModel().initWithJsonData(actitvityFeedDictionary: arrayElements as? Dictionary<String, AnyObject>, message: message as? String)  as? FeedActivityModel
                
                if feedActivityModelObj != nil{
                    
                    //Add model object to one array
                    responseArray.append(feedActivityModelObj!)
                    
                }
                
            }
            
            //Check array count
            if responseArray.count == 0{
                
                let error = NSError(domain:"FiturbApp",
                                    code: 100,
                                    userInfo: [NSLocalizedFailureReasonErrorKey :message ?? MyAppConstants.jsonErrorMsg])
                
                //Error(No data available)
                DispatchQueue.main.async(execute: {
                    completionHandler(nil , error)
                });
                
            }
            else{
                
                //Success
                DispatchQueue.main.async(execute: {
                    completionHandler(responseArray , error)
                });
            }
        }
    }

    
    //Verify OTP api service method(GET)
    public func getVerifyOtpApiValuesWithUrlString(urlString url:String, callbackBlock completionHandler:@escaping (_ apiRecievedResponse:Array<AnyObject>?,_ error:NSError?) -> ()){
        
        //user Authetication token
        let autheticationToken:String? = nil
        
        self.commonGetServiceMethod(urlString: url, userAutheticationToken: autheticationToken) { (jSONObject:Dictionary<String,AnyObject>?, error:NSError?) in
            
            print("Verify otp  api response is:\(jSONObject)")
            
            guard error == nil else{
                
                //Error handling
                let error = NSError(domain:"FiturbApp",
                                    code: 100,
                                    userInfo: [NSLocalizedFailureReasonErrorKey :error!.localizedFailureReason!])
                
                
                DispatchQueue.main.async(execute: {
                    
                    completionHandler(nil , error)
                });
                
                return
            }
            
            
           let message = jSONObject?["message"]
            
           let mobileVerification = jSONObject?["output"]?["mobile_verified"]
        
            //verifcation OTP model class
            let verifcationOtpModel = VerifyOtpModel().initWithJsonData(messageText: message as! String?, mobileVerificationText: mobileVerification as! String?) as? VerifyOtpModel
            
            //Create array to pass all json parsed data to classes
            var responseArray = [AnyObject]()
            
                if verifcationOtpModel != nil{
                    
                    //Add model object to one array
                    responseArray.append(verifcationOtpModel!)
                    
                }
            
            //Check array count
            if responseArray.count == 0{
                
                let error = NSError(domain:"FiturbApp",
                                    code: 100,
                                    userInfo: [NSLocalizedFailureReasonErrorKey :message ?? MyAppConstants.jsonErrorMsg])
                
                //Error(No data available)
                DispatchQueue.main.async(execute: {
                    completionHandler(nil , error)
                });
                
            }
            else{
                
                //Success
                DispatchQueue.main.async(execute: {
                    completionHandler(responseArray , error)
                });
            }
        
        }
        
    }

    //Send Otp Api Method(POST)
    public func getSendOtpApiValuesWithUrlString(urlString url:String,  withPostData postDataDictionary:Dictionary<String, String>, callBackBlock completionHandler:@escaping (_ apiRecievedResponse:String?,_ error: NSError?) -> ()) {
        
        //user Authetication token
        let autheticationToken = (singleTon.sharedInstance.getUserAuthenticationToken()) ?? ""
        
        print("Authentication token in send otp api method is:\(autheticationToken)")
        
        self.commonPostServiceMethod(urlString: url, userAutheticationToken:autheticationToken, withPostData: postDataDictionary as Dictionary<String, AnyObject>) { (jSONObject: Dictionary<String, AnyObject>?, error:NSError?) in
            
            print("Send Otp api recieved response is:\(jSONObject)")
                        
            guard error == nil else{
                
                //Error handling
                let error = NSError(domain:"FiturbApp",
                                    code: 100,
                                    userInfo: [NSLocalizedFailureReasonErrorKey :error!.localizedFailureReason!])
                
                
                DispatchQueue.main.async(execute: {
                    
                    completionHandler(nil , error)
                });
                
                return
            }
            
            //Otp Sent successful or not message
            let message =  jSONObject?["message"]
            
            //Check array count
            if(message == nil){
                
                let error = NSError(domain:"FiturbApp",
                                    code: 100,
                                    userInfo: [NSLocalizedFailureReasonErrorKey :MyAppConstants.jsonErrorMsg])
                
                //Error(No data available)
                DispatchQueue.main.async(execute: {
                    completionHandler(nil , error)
                });
                
            }
            else{
                
                //Success
                DispatchQueue.main.async(execute: {
                    completionHandler(message as! String? , error)
                });
            }
            
        }
        
    }
    
    
    //Normal Sign up api service method(POST)
    public func getSignUpApiValuesWithUrlString(urlString url:String,  withPostData postDataDictionary:Dictionary<String, AnyObject>, callBackBlock completionHandler:@escaping (_ apiRecievedResponse:Array<AnyObject>?,_ error: NSError?) -> ()) {

        self.commonPostServiceMethod(urlString: url, userAutheticationToken:nil, withPostData: postDataDictionary) { (jSONObject: Dictionary<String, AnyObject>?, error:NSError?) in
            
            print("Sign up screen api recieved response is:\(jSONObject)")

            guard error == nil else{
                
               //Error handling
                let error = NSError(domain:"FiturbApp",
                                    code: 100,
                                    userInfo: [NSLocalizedFailureReasonErrorKey :error!.localizedFailureReason!])
                
                
                DispatchQueue.main.async(execute: {
                    
                    completionHandler(nil , error)
                });

                return
            }
            
            //Registration successful or not message
            let message =  jSONObject?["message"]
            
            //registered name
            let firstname = jSONObject?["output"]?["first_name"]
            
            //email
            let email = jSONObject?["output"]?["email"]
            
            //Mobile number
            let mobileNumber = jSONObject?["output"]?["mobile"]
            
            //Sign up modal class object
          let signUpClassmodalObj =  SignUpModelClass().initWithJsonData(message: message as? String, registeredEmail: email as? String, mobileNumber: mobileNumber as? String, firstName: firstname as? String) as? SignUpModelClass
            
            //Create array to pass all json parsed data to classes
            var responseArray = [AnyObject]()
            
            if signUpClassmodalObj != nil{
                
                responseArray.append(signUpClassmodalObj!)
                
                print("Modal object is:\(signUpClassmodalObj!.userFirstName!),\(signUpClassmodalObj!.registrationMessage!),\(signUpClassmodalObj!.userEmail!),\(signUpClassmodalObj!.userMobileNumber!)")
            }
            
            
            //Check array count
            if responseArray.count == 0{
                
                let error = NSError(domain:"FiturbApp",
                                    code: 100,
                                    userInfo: [NSLocalizedFailureReasonErrorKey :MyAppConstants.jsonErrorMsg])
                
                //Error(No data available)
                DispatchQueue.main.async(execute: {
                    completionHandler(nil , error)
                });
                
            }
            else{
                
                //Success
                DispatchQueue.main.async(execute: {
                    completionHandler(responseArray , error)
                });
            }
            
        }
        
    }
    
    //Facebook Login or SignUp api service Methods
    public func getSignUpOrLoginApiValuesWithUrlStringForSocialContainerFacebook(urlString url:String,  withPostData postDataDictionary:Dictionary<String, AnyObject>, callBackBlock completionHandler:@escaping (_ apiRecievedResponse:Array<AnyObject>?,_ error: NSError?) -> ()) {
        
        self.commonPostServiceMethod(urlString: url, userAutheticationToken:nil, withPostData: postDataDictionary as Dictionary<String, AnyObject>) { (jSONObject: Dictionary<String, AnyObject>?, error:NSError?) in
            
            print("FaceBook login api response is:\(jSONObject)")
            
            guard error == nil else{
                
                //Error handling
                let error = NSError(domain:"FiturbApp",
                                    code: 100,
                                    userInfo: [NSLocalizedFailureReasonErrorKey :MyAppConstants.jsonErrorMsg])
                
                
                DispatchQueue.main.async(execute: {
                    
                    completionHandler(nil , error)
                });
                
                return
            }
            
            //Registration successful or not message
            let message =  jSONObject?["message"]
            
            //registered name
            let firstname = jSONObject?["output"]?["first_name"]
            
            //email
            let email = jSONObject?["output"]?["email"]
            
            //Mobile number
            let mobileNumber = jSONObject?["output"]?["mobile"]
            
            //User authentication token
            let userAutheniticationToken = jSONObject?["output"]?["token"]

            //User ID
            let userId = jSONObject?["output"]?["user_id"]
            
            //User interest count
            let userInterestCount = jSONObject?["output"]?["interest_count"]
            
            //City name
            let cityName = jSONObject?["output"]?["city"]
            
            //Sign up modal class object
            let faceBookModelObj =  SocialContainerModel().initWithJsonData(message: message as? String, registeredEmail: email as? String, mobileNumber: mobileNumber as? String, firstName: firstname as? String,userAuthenticationToken: userAutheniticationToken as? String, iDUser:userId as? String, interestCount: userInterestCount as? String, cityNameText: cityName as? String) as? SocialContainerModel
            
            //Create array to pass all json parsed data to classes
            var responseArray = [AnyObject]()
            
            if faceBookModelObj != nil{
                
                responseArray.append(faceBookModelObj!)
                
                print("Modal object is:\(faceBookModelObj!.userFirstName!),\(faceBookModelObj!.registrationMessage!),\(faceBookModelObj!.userEmail!),\(faceBookModelObj!.userMobileNumber!),\(faceBookModelObj!.userAuthenticationToken!)")
            }
            
            
            //Check array count
            if responseArray.count == 0{
                
                let error = NSError(domain:"FiturbApp",
                                    code: 100,
                                    userInfo: [NSLocalizedFailureReasonErrorKey :MyAppConstants.jsonErrorMsg])
                
                //Error(No data available)
                DispatchQueue.main.async(execute: {
                    completionHandler(nil , error)
                });
                
            }
            else{
                
                //Success
                DispatchQueue.main.async(execute: {
                    completionHandler(responseArray , error)
                });
            }
            
        }
        
    }

    
    //Login Api Method
    public func getLoginApiValuesWithUrlString(urlString url:String,  withPostData postDataDictionary:Dictionary<String, AnyObject>, callBackBlock completionHandler:@escaping (_ apiRecievedResponse:Array<AnyObject>?,_ error: NSError?) -> ()) {
        
        
        self.commonPostServiceMethod(urlString: url,userAutheticationToken:nil,  withPostData: postDataDictionary as Dictionary<String, AnyObject>) { (jSONObject: Dictionary<String, AnyObject>?, error:NSError?) in
            
            
            print("Login screen api recieved response is:\(jSONObject)")
            
            guard error == nil else{
                
                //Error handling
                let error = NSError(domain:"FiturbApp",
                                    code: 100,
                                    userInfo: [NSLocalizedFailureReasonErrorKey :error!.localizedFailureReason!])
                
                
                DispatchQueue.main.async(execute: {
                    
                    completionHandler(nil , error)
                });
                
                return
            }
            
            //LOGIN successful or not message
            let loginMessage =  jSONObject?["message"]
            
            //User email
            let userEmail = jSONObject?["output"]?["email"]
            
            //Mobile Number
            let mobileNumber = jSONObject?["output"]?["mobile"]
            
            //Token ID
            let tokenID = jSONObject?["output"]?["token"]
            
            //user ID
            let userID = jSONObject?["output"]?["user_id"]
            
            //FirstName
            let firstName = jSONObject?["output"]?["first_name"]
            
            //Last name
            let lastName = jSONObject?["output"]?["last_name"]
            
            //Emailverified
            let emailverfied = jSONObject?["output"]?["email_verified"]
            
            //Mobile verified
            let mobileverified = jSONObject?["output"]?["mobile_verified"]
            
            //Interest Count
            let interestCount = jSONObject?["output"]?["interest_count"]
            
            //City name
            let cityName = jSONObject?["output"]?["city"]
            
            //Sign up modal class object
            let loginClassmodalObj =  LoginModel().initWithJsonData(loginMsg: loginMessage as? String, userEmail: userEmail as? String, userMobileNumber:mobileNumber as? String, tokenID: tokenID as? String, userID: userID as? String, userFirstName: firstName as? String, userLastName: lastName as? String,mobileVerifedValue:mobileverified as AnyObject? ,emailVerfiedvalue: emailverfied as AnyObject?, totalInterestCount: interestCount as? String, cityNameText: cityName as? String) as? LoginModel
            
            
            //Create array to pass all json parsed data to classes
            var responseArray = [AnyObject]()
            
            if loginClassmodalObj != nil{
                
                responseArray.append(loginClassmodalObj!)
                
                print("Modal object is:\(loginClassmodalObj!.message!),\(loginClassmodalObj!.mobileNumber!),\(loginClassmodalObj!.email!),\(loginClassmodalObj!.token!),\(loginClassmodalObj!.userID!),\(loginClassmodalObj!.firstName!),\(loginClassmodalObj!.lastName!)")
            }
            
            
            //Check array count
            if responseArray.count == 0{
                
                let error = NSError(domain:"FiturbApp",
                                    code: 100,
                                    userInfo: [NSLocalizedFailureReasonErrorKey :MyAppConstants.jsonErrorMsg])
                
                //Error(No data available)
                DispatchQueue.main.async(execute: {
                    completionHandler(nil , error)
                });
                
            }
            else{
                
                //Success
                DispatchQueue.main.async(execute: {
                    completionHandler(responseArray , error)
                });
            }
            
        }
    }
    
    //GetThermaTicList api service method
    public func getThematicsListApiValuesWithUrlString(urlString url:String, callBackBlock completionHandler:@escaping (_ apiRecievedResponse:Array<AnyObject>?,_ error: NSError?) -> ()) {
        
        //user Authetication token
        let autheticationToken = (singleTon.sharedInstance.getUserAuthenticationToken()) ?? ""

        self.commonGetServiceMethod(urlString:url , userAutheticationToken: autheticationToken) { (jSONObject:Dictionary<String, AnyObject>?, error:NSError?) in
            
            print("thematic list api response is:\(jSONObject)")
            
            guard error == nil else{
                
                //Error handling
                let error = NSError(domain:"FiturbApp",
                                    code: 100,
                                    userInfo: [NSLocalizedFailureReasonErrorKey :MyAppConstants.jsonErrorMsg])
                
                
                DispatchQueue.main.async(execute: {
                    
                    completionHandler(nil , error)
                });
                
                return
            }
            
            
            let message = jSONObject?["message"]
            
            let outPutArrayObj = jSONObject?["output"] as? Array<AnyObject>
            
            //Create array to pass all json parsed data to classes
            var responseArray = [AnyObject]()
            
            for arrayElements in outPutArrayObj!{
                
                //thematics Model object
                let thematicsModelObj = thematicsListModel().initWithJsonData(dictinaryObj: arrayElements as? Dictionary<String, AnyObject>, responseMessage: message as? String) as? thematicsListModel
                
                if thematicsModelObj != nil{
                
                    //Add model object to one array
                    responseArray.append(thematicsModelObj!)
                    
                }
                
            }
            
            //Check array count
            if responseArray.count == 0{
                
                let error = NSError(domain:"FiturbApp",
                                    code: 100,
                                    userInfo: [NSLocalizedFailureReasonErrorKey :MyAppConstants.jsonErrorMsg])
                
                //Error(No data available)
                DispatchQueue.main.async(execute: {
                    completionHandler(nil , error)
                });
                
            }
            else{
                
                //Success
                DispatchQueue.main.async(execute: {
                    completionHandler(responseArray , error)
                });
            }
        }
    }
    
    
    //get Interst List of Thermatics api service method
    public func getInterstListOfThermaticsApiValuesWithUrlString(urlString url:String, callbackBlock completionHandler:@escaping (_ apiRecievedResponse:Array<AnyObject>?,_ error:NSError?) -> ()){
        
        //user Authetication token
        let autheticationToken = (singleTon.sharedInstance.getUserAuthenticationToken()) ?? ""
        
        self.commonGetServiceMethod(urlString: url, userAutheticationToken: autheticationToken) { (jSONObject:Dictionary<String,AnyObject>?, error:NSError?) in
            
              print("Interst List of thematics  api response is:\(jSONObject)")
            
            guard error == nil else{
                
                //Error handling
                let error = NSError(domain:"FiturbApp",
                                    code: 100,
                                    userInfo: [NSLocalizedFailureReasonErrorKey :MyAppConstants.jsonErrorMsg])
                
                
                DispatchQueue.main.async(execute: {
                    
                    completionHandler(nil , error)
                });
                
                return
            }
            
            
            let message = jSONObject?["message"]
            
            let outPutArrayObj = jSONObject?["output"] as? Array<AnyObject>
            
            //Create array to pass all json parsed data to classes
            var responseArray = [AnyObject]()
            
            for arrayElements in outPutArrayObj!{
                
                //InterestList Model object of Thematics
                let interestListModelObj = InterestListOfThematicsModel().initWithJsonData(dictinaryObj: arrayElements as? Dictionary<String, AnyObject>, responseMessage: message as? String) as? InterestListOfThematicsModel
                
                if interestListModelObj != nil{
                    
                    //Add model object to one array
                    responseArray.append(interestListModelObj!)
                    
                }
                
            }
            
            //Check array count
            if responseArray.count == 0{
                
                let error = NSError(domain:"FiturbApp",
                                    code: 100,
                                    userInfo: [NSLocalizedFailureReasonErrorKey :MyAppConstants.jsonErrorMsg])
                
                //Error(No data available)
                DispatchQueue.main.async(execute: {
                    completionHandler(nil , error)
                });
                
            }
            else{
                
                //Success
                DispatchQueue.main.async(execute: {
                    completionHandler(responseArray , error)
                });
            }

        }
        
    }
    
    //Friends List Api(POST)
    public func getFriendsApiValuesWithUrlString(urlString url:String,  withPostData postDataDictionary:Dictionary<String, AnyObject>, callBackBlock completionHandler:@escaping (_ apiRecievedResponse:Array<AnyObject>?,_ error: NSError?) -> ()) {
        
        //user Authetication token
        let autheticationToken = (singleTon.sharedInstance.getUserAuthenticationToken()) ?? ""
        
        print("Authentication token in freind list api:\(autheticationToken)")
        
        self.commonPostServiceMethod(urlString: url, userAutheticationToken: autheticationToken, withPostData: postDataDictionary) { (jSONObject:Dictionary<String,AnyObject>?, error:NSError?) in
            
            print("friends list apis recieved response is:\(jSONObject)")
            
            guard error == nil else{
                
                //Error handling
                let error = NSError(domain:"FiturbApp",
                                    code: 100,
                                    userInfo: [NSLocalizedFailureReasonErrorKey :MyAppConstants.jsonErrorMsg])
                
                
                DispatchQueue.main.async(execute: {
                    
                    completionHandler(nil , error)
                });
                
                return
            }
            
            //Response message key
            let message = jSONObject?["message"]
            
            //Friends Collection
            let friendsCollection = jSONObject?["output"]?["friends"]
            
            //Recieved Friends collection
            let recievedFriendsCollection = jSONObject?["output"]?["recieved"]
            
            //Sent Friends collection
            let sentFriendsCollection = jSONObject?["output"]?["sent"]
            
            //Add above three collections into below array
            var friendsRecievedAndSentCollection = [AnyObject]()
            
            if (friendsCollection != nil){
                
                friendsRecievedAndSentCollection.append(friendsCollection as AnyObject)
            }
            
            if (recievedFriendsCollection != nil){
                
                friendsRecievedAndSentCollection.append(recievedFriendsCollection as AnyObject)
            }
            
            if (sentFriendsCollection != nil){
                
                friendsRecievedAndSentCollection.append(sentFriendsCollection as AnyObject)
            }
            
            //Create array to pass all json parsed data to classes
            var responseArray = [AnyObject]()

            if friendsRecievedAndSentCollection.count != 0{
             
                for (arrayIndex,arrayElements) in friendsRecievedAndSentCollection.enumerated(){
                    
                    for dictionaryObj in (arrayElements as? [AnyObject])!{
                        
                        var friendsType = ""
                        if arrayIndex == 0{
                            
                            //Already Friends
                            friendsType = "AlreadyFriends"
                        }
                        else if arrayIndex == 1{
                            
                            //Recieved Freinds
                            friendsType = "RecievedFriends"
                        }
                        else if arrayIndex == 2{
                            
                            //Sent friends
                            friendsType = "SentFriends"
                        }
                        
                        let friendListModelObj = FriendsListModel().initWithJsonData(dictinaryObj: dictionaryObj as? Dictionary<String, AnyObject>, responseMessage: message as! String?,friendsTypeName:friendsType) as? FriendsListModel
                        
                        if friendListModelObj != nil{
                            
                            responseArray.append(friendListModelObj!)
                            
                        }
                        
                    }
                    
                }

            }
            else{
                
                //If only friends are there
                //Friends Collection
                let onlyFriendsCollection = jSONObject?["output"] as? Array<AnyObject>
                
                if onlyFriendsCollection?.count != 0{
                    
                    for object in onlyFriendsCollection!{
                        
                        let alreadyFriendsDict = object as? Dictionary<String, AnyObject>
                        
                        let friendListModelObj = FriendsListModel().initWithJsonData(dictinaryObj: alreadyFriendsDict, responseMessage: message as! String?,friendsTypeName:"AlreadyFriends") as? FriendsListModel
                        
                        if friendListModelObj != nil{
                            
                            responseArray.append(friendListModelObj!)
                            
                        }
                        
                    }
                    
                }
                
            }
            
            //Check array count
            if responseArray.count == 0{
                
                let error = NSError(domain:"FiturbApp",
                                    code: 100,
                                    userInfo: [NSLocalizedFailureReasonErrorKey :message ?? MyAppConstants.jsonErrorMsg])
                
                //Error(No data available)
                DispatchQueue.main.async(execute: {
                    completionHandler(nil , error)
                });
                
            }
            else{
                
                //Success
                DispatchQueue.main.async(execute: {
                    completionHandler(responseArray , error)
                });
            }

        }
        
    }
    
    //Forget Password Api metthod(POST)
    public func postForgetPasswordApiValuesWithUrlString(urlString url:String,  withPostData postDataDictionary:Dictionary<String, String>, callBackBlock completionHandler:@escaping (_ apiRecievedResponse:String?,_ error: NSError?) -> ()) {
        
        //user Authetication token
        let autheticationToken = (singleTon.sharedInstance.getUserAuthenticationToken()) ?? ""
        
        print("Authentication token in Forget password api method is:\(autheticationToken)")
        
        self.commonPostServiceMethod(urlString: url, userAutheticationToken:autheticationToken, withPostData: postDataDictionary as Dictionary<String, AnyObject>) { (jSONObject: Dictionary<String, AnyObject>?, error:NSError?) in
            
            print("Forget password api recieved response is:\(jSONObject)")
            
            guard error == nil else{
                
                //Error handling
                let error = NSError(domain:"FiturbApp",
                                    code: 100,
                                    userInfo: [NSLocalizedFailureReasonErrorKey :error!.localizedFailureReason!])
                
                
                DispatchQueue.main.async(execute: {
                    
                    completionHandler(nil , error)
                });
                
                return
            }
            
            //Otp Sent successful or not message
            let message =  jSONObject?["message"]
            
            //Check array count
            if(message == nil){
                
                let error = NSError(domain:"FiturbApp",
                                    code: 100,
                                    userInfo: [NSLocalizedFailureReasonErrorKey :MyAppConstants.jsonErrorMsg])
                
                //Error(No data available)
                DispatchQueue.main.async(execute: {
                    completionHandler(nil , error)
                });
                
            }
            else{
                
                //Success
                DispatchQueue.main.async(execute: {
                    completionHandler(message as! String? , error)
                });
            }
            
        }
        
    }

    //Logout Api metthod(POST)
    public func logoutApiValuesWithUrlString(urlString url:String,  withPostData postDataDictionary:Dictionary<String, String>, callBackBlock completionHandler:@escaping (_ apiRecievedResponse:String?,_ error: NSError?) -> ()) {
        
        //user Authetication token
        let autheticationToken: String? = nil
        
        self.commonPostServiceMethod(urlString: url, userAutheticationToken:autheticationToken, withPostData: postDataDictionary as Dictionary<String, AnyObject>) { (jSONObject: Dictionary<String, AnyObject>?, error:NSError?) in
            
            print("Forget password api recieved response is:\(jSONObject)")
            
            guard error == nil else{
                
                //Error handling
                let error = NSError(domain:"FiturbApp",
                                    code: 100,
                                    userInfo: [NSLocalizedFailureReasonErrorKey :error!.localizedFailureReason!])
                
                
                DispatchQueue.main.async(execute: {
                    
                    completionHandler(nil , error)
                });
                
                return
            }
            
            //Otp Sent successful or not message
            let message =  jSONObject?["message"]
            
            //Check array count
            if(message == nil){
                
                let error = NSError(domain:"FiturbApp",
                                    code: 100,
                                    userInfo: [NSLocalizedFailureReasonErrorKey :MyAppConstants.jsonErrorMsg])
                
                //Error(No data available)
                DispatchQueue.main.async(execute: {
                    completionHandler(nil , error)
                });
                
            }
            else{
                
                //Success
                DispatchQueue.main.async(execute: {
                    completionHandler(message as! String? , error)
                });
            }
            
        }
        
    }
    
    //Accept Friend request Api metthod(POST)
    public func acceptFriendRequestApiValuesWithUrlString(urlString url:String,  withPostData postDataDictionary:Dictionary<String, String>, callBackBlock completionHandler:@escaping (_ apiRecievedResponse:String?,_ error: NSError?) -> ()) {
        
        //user Authetication token
         let autheticationToken = (singleTon.sharedInstance.getUserAuthenticationToken()) ?? ""
        
        self.commonPostServiceMethod(urlString: url, userAutheticationToken:autheticationToken, withPostData: postDataDictionary as Dictionary<String, AnyObject>) { (jSONObject: Dictionary<String, AnyObject>?, error:NSError?) in
            
            print("Accept friend request api recieved response is:\(jSONObject)")
            
            guard error == nil else{
                
                //Error handling
                let error = NSError(domain:"FiturbApp",
                                    code: 100,
                                    userInfo: [NSLocalizedFailureReasonErrorKey :error!.localizedFailureReason!])
                
                
                DispatchQueue.main.async(execute: {
                    
                    completionHandler(nil , error)
                });
                
                return
            }
            
            //Friend request accepted successful or not message
            let message =  jSONObject?["message"]
            
            //Check array count
            if(message == nil){
                
                let error = NSError(domain:"FiturbApp",
                                    code: 100,
                                    userInfo: [NSLocalizedFailureReasonErrorKey :MyAppConstants.jsonErrorMsg])
                
                //Error(No data available)
                DispatchQueue.main.async(execute: {
                    completionHandler(nil , error)
                });
                
            }
            else{
                
                //Success
                DispatchQueue.main.async(execute: {
                    completionHandler(message as! String? , error)
                });
            }
            
        }
        
    }

    //Reject Friend request Api metthod(POST)
    public func rejectFriendRequestApiValuesWithUrlString(urlString url:String,  withPostData postDataDictionary:Dictionary<String, String>, callBackBlock completionHandler:@escaping (_ apiRecievedResponse:String?,_ error: NSError?) -> ()) {
        
        //user Authetication token
        let autheticationToken = (singleTon.sharedInstance.getUserAuthenticationToken()) ?? ""
        
        self.commonPostServiceMethod(urlString: url, userAutheticationToken:autheticationToken, withPostData: postDataDictionary as Dictionary<String, AnyObject>) { (jSONObject: Dictionary<String, AnyObject>?, error:NSError?) in
            
            print("Reject Friend request api recieved response is:\(jSONObject)")
            
            guard error == nil else{
                
                //Error handling
                let error = NSError(domain:"FiturbApp",
                                    code: 100,
                                    userInfo: [NSLocalizedFailureReasonErrorKey :error!.localizedFailureReason!])
                
                
                DispatchQueue.main.async(execute: {
                    
                    completionHandler(nil , error)
                });
                
                return
            }
            
            //friend request rejected  or not message
            let message =  jSONObject?["message"]
            
            //Check array count
            if(message == nil){
                
                let error = NSError(domain:"FiturbApp",
                                    code: 100,
                                    userInfo: [NSLocalizedFailureReasonErrorKey :MyAppConstants.jsonErrorMsg])
                
                //Error(No data available)
                DispatchQueue.main.async(execute: {
                    completionHandler(nil , error)
                });
                
            }
            else{
                
                //Success
                DispatchQueue.main.async(execute: {
                    completionHandler(message as! String? , error)
                });
            }
            
        }
        
    }

    
    //Cancel Friend request Api metthod(POST)
    public func cancelFriendRequestApiValuesWithUrlString(urlString url:String,  withPostData postDataDictionary:Dictionary<String, String>, callBackBlock completionHandler:@escaping (_ apiRecievedResponse:String?,_ error: NSError?) -> ()) {
        
        //user Authetication token
         let autheticationToken = (singleTon.sharedInstance.getUserAuthenticationToken()) ?? ""
        
        self.commonPostServiceMethod(urlString: url, userAutheticationToken:autheticationToken, withPostData: postDataDictionary as Dictionary<String, AnyObject>) { (jSONObject: Dictionary<String, AnyObject>?, error:NSError?) in
            
            print("Cancel Friend request api recieved response is:\(jSONObject)")
            
            guard error == nil else{
                
                //Error handling
                let error = NSError(domain:"FiturbApp",
                                    code: 100,
                                    userInfo: [NSLocalizedFailureReasonErrorKey :error!.localizedFailureReason!])
                
                
                DispatchQueue.main.async(execute: {
                    
                    completionHandler(nil , error)
                });
                
                return
            }
            
            //friend request canceled  or not message
            let message =  jSONObject?["message"]
            
            //Check array count
            if(message == nil){
                
                let error = NSError(domain:"FiturbApp",
                                    code: 100,
                                    userInfo: [NSLocalizedFailureReasonErrorKey :MyAppConstants.jsonErrorMsg])
                
                //Error(No data available)
                DispatchQueue.main.async(execute: {
                    completionHandler(nil , error)
                });
                
            }
            else{
                
                //Success
                DispatchQueue.main.async(execute: {
                    completionHandler(message as! String? , error)
                });
            }
            
        }
        
    }
    
    //Send Friend request Api metthod(POST)
    public func sendFriendRequestApiValuesWithUrlString(urlString url:String,  withPostData postDataDictionary:Dictionary<String, String>, callBackBlock completionHandler:@escaping (_ apiRecievedResponse:String?,_ error: NSError?) -> ()) {
        
        //user Authetication token
         let autheticationToken = (singleTon.sharedInstance.getUserAuthenticationToken()) ?? ""
        
        self.commonPostServiceMethod(urlString: url, userAutheticationToken:autheticationToken, withPostData: postDataDictionary as Dictionary<String, AnyObject>) { (jSONObject: Dictionary<String, AnyObject>?, error:NSError?) in
            
            print("send Friend request api recieved response is:\(jSONObject)")
            
            guard error == nil else{
                
                //Error handling
                let error = NSError(domain:"FiturbApp",
                                    code: 100,
                                    userInfo: [NSLocalizedFailureReasonErrorKey :error!.localizedFailureReason!])
                
                
                DispatchQueue.main.async(execute: {
                    
                    completionHandler(nil , error)
                });
                
                return
            }
            
            //friend request send successfully  or not message
            let message =  jSONObject?["message"]
            
            //Check array count
            if(message == nil){
                
                let error = NSError(domain:"FiturbApp",
                                    code: 100,
                                    userInfo: [NSLocalizedFailureReasonErrorKey :MyAppConstants.jsonErrorMsg])
                
                //Error(No data available)
                DispatchQueue.main.async(execute: {
                    completionHandler(nil , error)
                });
                
            }
            else{
                
                //Success
                DispatchQueue.main.async(execute: {
                    completionHandler(message as! String? , error)
                });
            }
            
        }
        
    }

    
    //Search friend request api(POST)
    public func searchFriendRequestApiValuesWithUrlString(urlString url:String,  withPostData postDataDictionary:Dictionary<String, String>, callBackBlock completionHandler:@escaping (_ apiRecievedResponse:Array<AnyObject>?,_ error: NSError?) -> ()) {
        
        //user Authetication token
        let autheticationToken = (singleTon.sharedInstance.getUserAuthenticationToken()) ?? ""
        
        self.commonPostServiceMethod(urlString: url, userAutheticationToken:autheticationToken, withPostData: postDataDictionary as Dictionary<String, AnyObject>) { (jSONObject: Dictionary<String, AnyObject>?, error:NSError?) in
            
            print("Search Friend request api recieved response is:\(jSONObject)")
            
            guard error == nil else{
                
                //Error handling
                let error = NSError(domain:"FiturbApp",
                                    code: 100,
                                    userInfo: [NSLocalizedFailureReasonErrorKey :error!.localizedFailureReason!])
                
                
                DispatchQueue.main.async(execute: {
                    
                    completionHandler(nil , error)
                });
                
                return
            }
            
            //search friend successful  or not message
            let message =  jSONObject?["message"]
            
            //OutPut array
            let outPutArray = jSONObject?["output"] as? Array<AnyObject>
            
            //Create array to pass all json parsed data to classes
            var responseArray = [AnyObject]()
            
            if outPutArray != nil{
                
                for dictionary in outPutArray!{
                    
                    //search model object
                    let searchModelObj = SearchModel().initWithJsonData(message: message as? String, dictionaryObj: dictionary as? Dictionary<String, AnyObject>) as? SearchModel
                    
                    if searchModelObj != nil{
                        
                        responseArray.append(searchModelObj!)
                    }
                    
                }
            }
           
            
            //Check array count
            if(responseArray.count == 0){
                
                let error = NSError(domain:"FiturbApp",
                                    code: 100,
                                    userInfo: [NSLocalizedFailureReasonErrorKey :(message as? String == "no results found") ? message! : MyAppConstants.jsonErrorMsg])
                
                //Error(No data available)
                DispatchQueue.main.async(execute: {
                    completionHandler(nil , error)
                });
                
            }
            else{
                
                //Success
                DispatchQueue.main.async(execute: {
                    completionHandler(responseArray , error)
                });
            }
            
        }
        
    }

    //Add new group Api method(POST)
    public func addNewGroupRequestApiValuesWithUrlString(urlString url:String,  withPostData postDataDictionary:Dictionary<String, String>, callBackBlock completionHandler:@escaping (_ apiRecievedResponse:Array<AnyObject>?,_ error: NSError?) -> ()) {
        
        //user Authetication token
        let autheticationToken = (singleTon.sharedInstance.getUserAuthenticationToken()) ?? ""
        
        self.commonPostServiceMethod(urlString: url, userAutheticationToken:autheticationToken, withPostData: postDataDictionary as Dictionary<String, AnyObject>) { (jSONObject: Dictionary<String, AnyObject>?, error:NSError?) in
            
            print("Add new group api recieved response is:\(jSONObject)")
            
            guard error == nil else{
                
                //Error handling
                let error = NSError(domain:"FiturbApp",
                                    code: 100,
                                    userInfo: [NSLocalizedFailureReasonErrorKey :error!.localizedFailureReason!])
                
                
                DispatchQueue.main.async(execute: {
                    
                    completionHandler(nil , error)
                });
                
                return
            }
            
            //new group added successfully  or not message
            let message =  jSONObject?["message"]
            
            //Create array to pass all json parsed data to classes
            var responseArray = [AnyObject]()
            
            //Add new group model object
            let modelObj = AddNewGroupModel().initWithJsonData(msgText: message as? String) as? AddNewGroupModel
            
            if modelObj != nil{
                        
                responseArray.append(modelObj!)
                
                }
            
            //Check array count
            if(responseArray.count == 0){
                
                let error = NSError(domain:"FiturbApp",
                                    code: 100,
                                    userInfo: [NSLocalizedFailureReasonErrorKey :(message as? String == "no results found") ? message! : MyAppConstants.jsonErrorMsg])
                
                //Error(No data available)
                DispatchQueue.main.async(execute: {
                    completionHandler(nil , error)
                });
                
            }
            else{
                
                //Success
                DispatchQueue.main.async(execute: {
                    completionHandler(responseArray , error)
                });
            }
            
        }
        
    }

    
    //Group list api method(GET)
    public func getGroupListApiValuesWithUrlString(urlString url:String, callBackBlock completionHandler:@escaping (_ apiRecievedResponse:Array<AnyObject>?,_ error: NSError?) -> ()) {
        
        //user Authetication token
        let autheticationToken = (singleTon.sharedInstance.getUserAuthenticationToken()) ?? ""
        
        self.commonGetServiceMethod(urlString:url , userAutheticationToken: autheticationToken) { (jSONObject:Dictionary<String, AnyObject>?, error:NSError?) in
            
            print("Group list api response is:\(jSONObject)")
            
            guard error == nil else{
                
                //Error handling
                let error = NSError(domain:"FiturbApp",
                                    code: 100,
                                    userInfo: [NSLocalizedFailureReasonErrorKey :MyAppConstants.jsonErrorMsg])
                
                
                DispatchQueue.main.async(execute: {
                    
                    completionHandler(nil , error)
                });
                
                return
            }
            
            let message = jSONObject?["message"]
            
            let outPutArrayObj = jSONObject?["output"] as? Array<AnyObject>
            
            //Create array to pass all json parsed data to classes
            var responseArray = [AnyObject]()
            
            for arrayElements in outPutArrayObj!{
                
                //Group list Model object
                let groupListModelObj = GroupListModel().initWithJsonData(groupIdAndGroupNameDictionary: arrayElements as? Dictionary<String, AnyObject>, messageText: message as? String) as? GroupListModel
                
                if groupListModelObj != nil{
                    
                    //Add model object to one array
                    responseArray.append(groupListModelObj!)
                    
                }
                
            }
            
            //Check array count
            if responseArray.count == 0{
                
                let error = NSError(domain:"FiturbApp",
                                    code: 100,
                                    userInfo: [NSLocalizedFailureReasonErrorKey : message ?? MyAppConstants.jsonErrorMsg])
                
                //Error(No data available)
                DispatchQueue.main.async(execute: {
                    completionHandler(nil , error)
                });
                
            }
            else{
                
                //Success
                DispatchQueue.main.async(execute: {
                    completionHandler(responseArray , error)
                });
            }
        }
    }

    //Edit group Api method(POST)
    public func editGroupRequestApiValuesWithUrlString(urlString url:String,  withPostData postDataDictionary:Dictionary<String, String>, callBackBlock completionHandler:@escaping (_ apiRecievedResponse:Array<AnyObject>?,_ error: NSError?) -> ()) {
        
        //user Authetication token
        let autheticationToken = (singleTon.sharedInstance.getUserAuthenticationToken()) ?? ""
        
        self.commonPostServiceMethod(urlString: url, userAutheticationToken:autheticationToken, withPostData: postDataDictionary as Dictionary<String, AnyObject>) { (jSONObject: Dictionary<String, AnyObject>?, error:NSError?) in
            
            print("Edit group api recieved response is:\(jSONObject)")
            
            guard error == nil else{
                
                //Error handling
                let error = NSError(domain:"FiturbApp",
                                    code: 100,
                                    userInfo: [NSLocalizedFailureReasonErrorKey :error!.localizedFailureReason!])
                
                
                DispatchQueue.main.async(execute: {
                    
                    completionHandler(nil , error)
                });
                
                return
            }
            
            //group edited successfully  or not message
            let message =  jSONObject?["message"]
            
            //Create array to pass all json parsed data to classes
            var responseArray = [AnyObject]()
            
            //Add edit group model object
            let modelObj = EditGroupModel().initWithJsonData(messageText: message as? String) as? EditGroupModel
            
            if modelObj != nil{
                
                responseArray.append(modelObj!)
                
            }
            
            //Check array count
            if(responseArray.count == 0){
                
                let error = NSError(domain:"FiturbApp",
                                    code: 100,
                                    userInfo: [NSLocalizedFailureReasonErrorKey :(message as? String == "no results found") ? message! : MyAppConstants.jsonErrorMsg])
                
                //Error(No data available)
                DispatchQueue.main.async(execute: {
                    completionHandler(nil , error)
                });
                
            }
            else{
                
                //Success
                DispatchQueue.main.async(execute: {
                    completionHandler(responseArray , error)
                });
            }
            
        }
        
    }

    
    //Delete group api method(POST)
    public func deleteGroupRequestApiValuesWithUrlString(urlString url:String,  withPostData postDataDictionary:Dictionary<String, String>, callBackBlock completionHandler:@escaping (_ apiRecievedResponse:Array<AnyObject>?,_ error: NSError?) -> ()) {
        
        //user Authetication token
        let autheticationToken = (singleTon.sharedInstance.getUserAuthenticationToken()) ?? ""
        
        self.commonPostServiceMethod(urlString: url, userAutheticationToken:autheticationToken, withPostData: postDataDictionary as Dictionary<String, AnyObject>) { (jSONObject: Dictionary<String, AnyObject>?, error:NSError?) in
            
            print("delete group api recieved response is:\(jSONObject)")
            
            guard error == nil else{
                
                //Error handling
                let error = NSError(domain:"FiturbApp",
                                    code: 100,
                                    userInfo: [NSLocalizedFailureReasonErrorKey :error!.localizedFailureReason!])
                
                
                DispatchQueue.main.async(execute: {
                    
                    completionHandler(nil , error)
                });
                
                return
            }
            
            //group deleted successfully  or not message
            let message =  jSONObject?["message"]
            
            //Create array to pass all json parsed data to classes
            var responseArray = [AnyObject]()
            
            //Add delete group model object
            let modelObj = DeleteGroupModel().initWithJsonData(messageText: message as? String) as? DeleteGroupModel
            
            if modelObj != nil{
                
                responseArray.append(modelObj!)
                
            }
            
            //Check array count
            if(responseArray.count == 0){
                
                let error = NSError(domain:"FiturbApp",
                                    code: 100,
                                    userInfo: [NSLocalizedFailureReasonErrorKey :(message as? String == "no results found") ? message! : MyAppConstants.jsonErrorMsg])
                
                //Error(No data available)
                DispatchQueue.main.async(execute: {
                    completionHandler(nil , error)
                });
                
            }
            else{
                
                //Success
                DispatchQueue.main.async(execute: {
                    completionHandler(responseArray , error)
                });
            }
            
        }
        
    }

    //Group details api(POST)
    public func groupDetailsRequestApiValuesWithUrlString(urlString url:String,  withPostData postDataDictionary:Dictionary<String, String>, callBackBlock completionHandler:@escaping (_ apiRecievedResponse:Array<AnyObject>?,_ error: NSError?) -> ()) {
        
        //user Authetication token
        let autheticationToken = (singleTon.sharedInstance.getUserAuthenticationToken()) ?? ""
        
        self.commonPostServiceMethod(urlString: url, userAutheticationToken:autheticationToken, withPostData: postDataDictionary as Dictionary<String, AnyObject>) { (jSONObject: Dictionary<String, AnyObject>?, error:NSError?) in
            
            print("group details api recieved response is:\(jSONObject)")
            
            guard error == nil else{
                
                //Error handling
                let error = NSError(domain:"FiturbApp",
                                    code: 100,
                                    userInfo: [NSLocalizedFailureReasonErrorKey :error!.localizedFailureReason!])
                
                
                DispatchQueue.main.async(execute: {
                    
                    completionHandler(nil , error)
                });
                
                return
            }
            
            //group details successful  or not message
            let message =  jSONObject?["message"]
            
            //OutPut array
            let outPutArray = jSONObject?["output"] as? Array<AnyObject>
            
            //Create array to pass all json parsed data to classes
            var responseArray = [AnyObject]()
            
            if outPutArray != nil{
                
                for dictionary in outPutArray!{
                    
                    //group details model object
                    let groupDetailModelObj = GroupDetailsModel().initWithJsonData(message: message as? String, dictionaryObj: dictionary as? Dictionary<String, AnyObject>) as? GroupDetailsModel
                    
                    if groupDetailModelObj != nil{
                        
                        responseArray.append(groupDetailModelObj!)
                    }
                    
                }
            }
            
            //Check array count
            if(responseArray.count == 0){
                
                let error = NSError(domain:"FiturbApp",
                                    code: 100,
                                    userInfo: [NSLocalizedFailureReasonErrorKey : message ?? MyAppConstants.jsonErrorMsg])
                
                //Error(No data available)
                DispatchQueue.main.async(execute: {
                    completionHandler(nil , error)
                });
                
            }
            else{
                
                //Success
                DispatchQueue.main.async(execute: {
                    completionHandler(responseArray , error)
                });
            }
            
        }
        
    }

    //Delete group member api(POST)
    public func removeGroupMeberApiValuesWithUrlString(urlString url:String,  withPostData postDataDictionary:Dictionary<String, AnyObject>, callBackBlock completionHandler:@escaping (_ apiRecievedResponse:Array<AnyObject>?,_ error: NSError?) -> ()) {
        
        //user Authetication token
        let autheticationToken = (singleTon.sharedInstance.getUserAuthenticationToken()) ?? ""
        
        self.commonPostServiceMethod(urlString: url, userAutheticationToken:autheticationToken, withPostData: postDataDictionary as Dictionary<String, AnyObject>) { (jSONObject: Dictionary<String, AnyObject>?, error:NSError?) in
            
            print("remove group member api recieved response is:\(jSONObject)")
            
            guard error == nil else{
                
                //Error handling
                let error = NSError(domain:"FiturbApp",
                                    code: 100,
                                    userInfo: [NSLocalizedFailureReasonErrorKey :error!.localizedFailureReason!])
                
                
                DispatchQueue.main.async(execute: {
                    
                    completionHandler(nil , error)
                });
                
                return
            }
            
            //group member remove successful  or not message
            let message =  jSONObject?["message"]
            
            //Create array to pass all json parsed data to classes
            var responseArray = [AnyObject]()
            
                    //group member remove model object
                    let groupMemberDeleteModelObj = DeleteGroupMeberModel().initWithJsonData(messageText: message as? String) as? DeleteGroupMeberModel
                    
                    if groupMemberDeleteModelObj != nil{
                        
                        responseArray.append(groupMemberDeleteModelObj!)
                    }
            
            
            //Check array count
            if(responseArray.count == 0){
                
                let error = NSError(domain:"FiturbApp",
                                    code: 100,
                                    userInfo: [NSLocalizedFailureReasonErrorKey : message ?? MyAppConstants.jsonErrorMsg])
                
                //Error(No data available)
                DispatchQueue.main.async(execute: {
                    completionHandler(nil , error)
                });
                
            }
            else{
                
                //Success
                DispatchQueue.main.async(execute: {
                    completionHandler(responseArray , error)
                });
            }
            
        }
        
    }

    //Add group members api
    public func addGroupMebersApiValuesWithUrlString(urlString url:String,  withPostData postDataDictionary:Dictionary<String, AnyObject>, callBackBlock completionHandler:@escaping (_ apiRecievedResponse:Array<AnyObject>?,_ error: NSError?) -> ()) {
        
        //user Authetication token
        let autheticationToken = (singleTon.sharedInstance.getUserAuthenticationToken()) ?? ""
        
        self.commonPostServiceMethod(urlString: url, userAutheticationToken:autheticationToken, withPostData: postDataDictionary as Dictionary<String, AnyObject>) { (jSONObject: Dictionary<String, AnyObject>?, error:NSError?) in
            
            print("Add group members api recieved response is:\(jSONObject)")
            
            guard error == nil else{
                
                //Error handling
                let error = NSError(domain:"FiturbApp",
                                    code: 100,
                                    userInfo: [NSLocalizedFailureReasonErrorKey :error!.localizedFailureReason!])
                
                
                DispatchQueue.main.async(execute: {
                    
                    completionHandler(nil , error)
                });
                
                return
            }
            
            //group members added successful  or not message
            let message =  jSONObject?["message"]
            
            //Create array to pass all json parsed data to classes
            var responseArray = [AnyObject]()
            
            //group members add model object
            let addGroupMemberModelObj = addGroupMembersModel().initWithJsonData(messageText: message as? String) as? addGroupMembersModel
            
            if addGroupMemberModelObj != nil{
                
                responseArray.append(addGroupMemberModelObj!)
            }
            
            //Check array count
            if(responseArray.count == 0){
                
                let error = NSError(domain:"FiturbApp",
                                    code: 100,
                                    userInfo: [NSLocalizedFailureReasonErrorKey : message ?? MyAppConstants.jsonErrorMsg])
                
                //Error(No data available)
                DispatchQueue.main.async(execute: {
                    completionHandler(nil , error)
                });
                
            }
            else{
                
                //Success
                DispatchQueue.main.async(execute: {
                    completionHandler(responseArray , error)
                });
            }
            
        }
        
    }

    
    //Create activity Api method(POST)
    public func createActivityApiValuesWithUrlString(urlString url:String,  withPostData postDataDictionary:Dictionary<String, AnyObject>?, callBackBlock completionHandler:@escaping (_ apiRecievedResponse:Array<AnyObject>?,_ error: NSError?) -> ()) {
        
        //user Authetication token
        let autheticationToken = (singleTon.sharedInstance.getUserAuthenticationToken()) ?? ""
        
        self.commonPostServiceMethod(urlString: url, userAutheticationToken:autheticationToken, withPostData: (postDataDictionary)!) { (jSONObject: Dictionary<String, AnyObject>?, error:NSError?) in
            
            print("Create activity api recieved response is:\(jSONObject)")
            
            guard error == nil else{
                
                //Error handling
                let error = NSError(domain:"FiturbApp",
                                    code: 100,
                                    userInfo: [NSLocalizedFailureReasonErrorKey :error!.localizedFailureReason!])
                
                
                DispatchQueue.main.async(execute: {
                    
                    completionHandler(nil , error)
                });
                
                return
            }
            
            //Activity created successfully  or not message
            let message =  jSONObject?["message"]
            
            //Create array to pass all json parsed data to classes
            var responseArray = [AnyObject]()
            
            //Create activity model object
            let modelObj = CreateActivityModel().initWithJsonData(msgText: message as? String) as? CreateActivityModel
            
            if modelObj != nil{
                
                responseArray.append(modelObj!)
                
            }
            
            //Check array count
            if(responseArray.count == 0){
                
                let error = NSError(domain:"FiturbApp",
                                    code: 100,
                                    userInfo: [NSLocalizedFailureReasonErrorKey :(message as? String == "no results found") ? message! : MyAppConstants.jsonErrorMsg])
                
                //Error(No data available)
                DispatchQueue.main.async(execute: {
                    completionHandler(nil , error)
                });
                
            }
            else{
                
                //Success
                DispatchQueue.main.async(execute: {
                    completionHandler(responseArray , error)
                });
            }
            
        }
        
    }

    //MARK:- Common Post and Get service Methods
    
    //Common get service method
    func commonGetServiceMethod(urlString url:String, userAutheticationToken token:String?, callBackBlock completionHandler: @escaping (_ jSONObject: Dictionary<String, AnyObject>?,_ error: NSError?) -> ())  {
        
      //To replace characters which are not in range of ASCII to percent encoding form
       let urlWithPercentEscapes = url.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
        
        //request url string
        let request = NSMutableURLRequest(url: URL(string: urlWithPercentEscapes!)!)
        
        //Http header fields(Content type and Token)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        //User authetication Token
        if let userAuthenticationToken = token {
            
            request.addValue(userAuthenticationToken, forHTTPHeaderField:"Token")

        }
        
        // set up the session(URLSession)
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        
        //Url session data task(NSURLSessionDataTask)
        let task = session.dataTask(with: request as URLRequest) { data, response, error in
            guard error == nil && data != nil else {
                
                //Server Error handling
                let error = NSError(domain:"FiturbApp",
                                    code: 100,
                                    userInfo: [NSLocalizedFailureReasonErrorKey :MyAppConstants.noResponseFromServerErrorMsg])
                

                DispatchQueue.main.async(execute: {
                    completionHandler(nil , error)
                });
                
                return
            }
            
            do {
                
                //printing response in string format
                let responseString = String(data: data!, encoding: .utf8)
                print("response in string format for checking only = \(responseString)")
                
                //Convert data to Json format
                let parseJSON = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as?[String: AnyObject]
                
                //Check status code is 200(Successful) or Not
                if let httpStatus = response as? HTTPURLResponse , httpStatus.statusCode != 200 {
                    
                    // check for http errors
                    print("statusCode should be 200, but is \(httpStatus.statusCode)")
                    
                    if httpStatus.statusCode == 404 || httpStatus.statusCode == 400{
                        
                        print("Get service response with error status code is:\(parseJSON)")
                        
                        let errorMessage: String?
                        
                        if let msg = parseJSON?["message"]{
                            
                            errorMessage = msg as? String
                            
                        }
                        else{
                            
                            errorMessage = "Error Recieved"
                            
                        }
                        
                        let error = NSError(domain:"FiturbApp",
                                            code: 100,
                                            userInfo: [NSLocalizedFailureReasonErrorKey :errorMessage!])
                        
                        //Unauthorized request error
                        DispatchQueue.main.async(execute: {
                            completionHandler(nil , error)
                        });
                        
                    }
                    else{
                        
                        
                        let error = NSError(domain:"FiturbApp",
                                            code: 100,
                                            userInfo: [NSLocalizedFailureReasonErrorKey :"HTTP statsus code \(httpStatus.statusCode) error"])
                        
                        //HTTP Error
                        DispatchQueue.main.async(execute: {
                            completionHandler(nil , error)
                        });
                        
                    }
                    
                    return
                    
                }
                
                //JSON successfull
                if ((parseJSON?.count) != nil) {
                    
                    //Success response
                    DispatchQueue.main.async(execute: {
                        completionHandler(parseJSON , error as NSError?)
                    });
                    
                    return
                }
                else{
                    
                    //JSON Error handling
                    let error = NSError(domain:"FiturbApp",
                                        code: 100,
                                        userInfo: [NSLocalizedFailureReasonErrorKey :MyAppConstants.jsonErrorMsg])
                    
                    DispatchQueue.main.async(execute: {
                        completionHandler(nil , error)
                    });
                    
                    return
                }
                
            } catch let error as NSError {
                
                print("Failed to load: \(error.localizedDescription)")
                
                DispatchQueue.main.async(execute: {
                    completionHandler(nil , error)
                });
                
                return
                
            }

            
        }
        task.resume()
    }

    //Common post service Method
    func commonPostServiceMethod(urlString url:String, userAutheticationToken token:String?, withPostData postDataDictionary:Dictionary<String, AnyObject>, callBackBlock completionHandler: @escaping (_ jSONObject: Dictionary<String, AnyObject>?,_ error: NSError?) -> ())  {
        
        //To replace characters which are not in range of ASCII to percent encoding form
        let urlWithPercentEscapes = url.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
        
        //request url string
        let request = NSMutableURLRequest(url: URL(string: urlWithPercentEscapes!)!)
        
        //Post method
        request.httpMethod = "POST"
        
        //Http header
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        //User authetication Token
        if let userAuthenticationToken = token {
            
            request.addValue(userAuthenticationToken, forHTTPHeaderField:"Token")
            
        }
        
        //Post Data
        do {

            let jsonData = try JSONSerialization.data(withJSONObject: postDataDictionary, options: .prettyPrinted)
            
            //set Post data to Http body
            request.httpBody = jsonData
            
        } catch let error {
            
            print(error.localizedDescription)
            
            DispatchQueue.main.async(execute: {
                completionHandler(nil , error as NSError?)
            });
            
            return
        }
        
        // set up the session(URLSession)
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        
        //Url session data task(NSURLSessionDataTask)
        let task = session.dataTask(with: request as URLRequest) { data, response, error in
            guard error == nil && data != nil else {
                
                //Server Error handling
                let error = NSError(domain:"FiturbApp",
                                    code: 100,
                                    userInfo: [NSLocalizedFailureReasonErrorKey :MyAppConstants.noResponseFromServerErrorMsg])
                
                DispatchQueue.main.async(execute: {
                    completionHandler(nil , error)
                });
                
                return
            }
            
                
                do {
                    
                    //printing response in string format
                    let responseString = String(data: data!, encoding: .utf8)
                    print("response in string format for checking only = \(responseString)")
                    
                    //Convert data to Json format
                    let parseJSON = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as?[String: AnyObject]
                    
                    //Check status code is 200(Successful) or Not
                    if let httpStatus = response as? HTTPURLResponse , httpStatus.statusCode != 200 {
                        
                        // check for http errors
                        print("statusCode should be 200, but is \(httpStatus.statusCode)")

                        if httpStatus.statusCode == 404 || httpStatus.statusCode == 400{
                           
                            print("Post service response with error status code is:\(parseJSON)")

                            let errorMessage: String?
                            
                            if let msg = parseJSON?["message"]{
                                
                                errorMessage = msg as? String
                                
                            }
                            else{
                                
                                errorMessage = "Error Recieved"
                                
                            }
                            
                            let error = NSError(domain:"FiturbApp",
                                                code: 100,
                                                userInfo: [NSLocalizedFailureReasonErrorKey :errorMessage!])
                            
                            //Unauthorized request error
                            DispatchQueue.main.async(execute: {
                                completionHandler(nil , error)
                            });

                        }
                        else{
                            
                            
                            let error = NSError(domain:"FiturbApp",
                                                code: 100,
                                                userInfo: [NSLocalizedFailureReasonErrorKey :"HTTP statsus code \(httpStatus.statusCode) error"])
                            
                            //HTTP Error
                            DispatchQueue.main.async(execute: {
                                completionHandler(nil , error)
                            });

                        }
                        
                        return
                        
                    }

                    //JSON successfull
                    if ((parseJSON?.count) != nil) {
                        
                        //Success response
                        DispatchQueue.main.async(execute: {
                            completionHandler(parseJSON , error as NSError?)
                        });
                        
                        return
                    }
                    else{
                        
                        //JSON Error handling
                        let error = NSError(domain:"FiturbApp",
                                            code: 100,
                                            userInfo: [NSLocalizedFailureReasonErrorKey :MyAppConstants.jsonErrorMsg])
                        
                        DispatchQueue.main.async(execute: {
                            completionHandler(nil , error)
                        });
                        
                        return
                    }
                    
                } catch let error as NSError {
                    
                    print("Failed to load: \(error.localizedDescription)")
                    
                    DispatchQueue.main.async(execute: {
                        completionHandler(nil , error)
                    });
                    
                    return
                    
                }
                
            }
            
        task.resume()
        
    }

}
