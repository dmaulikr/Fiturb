//
//  FriendsDetailsViewController.swift
//  Fiturb
//
//  Created by DATAPPS on 4/12/17.
//  Copyright © 2017 Fiturb.DATAPPS. All rights reserved.
//

import UIKit

class FriendsDetailsViewController: UIViewController,UITableViewDataSource,UITableViewDelegate,FriendsDetailsViewControllerProtocol,FriendsProfileProtcol {
    
    //MARK:- IBOutlets
    @IBOutlet weak var friendsDetailsTableView: UITableView!
    
    var FriendsDetailsHeaderCell:FriendsDetailsHeaderTableViewCell!
    
    //tableview header helping objects
    var needsReloadHeader = true
    
    var oldHeaderView = FriendsDetailsHeaderTableViewCell()
    
    var selectedSegmentedControlIndexValue: Int?
    
    //UserId of selected user
    var userIdOfSelectUser: String?
    
    //for View profile api
    var userDetailRecievedResponseArray = [Any?]()
    
    //For user comments api
    var userCommentsRecievedResponseArray = [Any?]()
    
    //For user list api
    var userInterestListApiRecievedResponseArray = [Any?]()

    //For Friends list api
    var friendsListApiResponseRecievedArray = [Any?]()
    
    //For Mutual friends list api
    var mutualFriendsListApiResponseRecievedArray = [Any?]()
    
    //For Followers friends list api
    var followersFriendsListApiResponseRecievedArray = [Any?]()
    
    //MARK:- ViewLife Cycle Methods
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        //CustomCell xib cells
        
        friendsDetailsTableView.register(UINib(nibName: "FriendsDetailsActivityTableViewCell", bundle: nil), forCellReuseIdentifier: "FriendsDetailsActivityTableViewCell")
        
        friendsDetailsTableView.register(UINib(nibName: "FriendsDetailsCommentsTableViewCell", bundle: nil), forCellReuseIdentifier: "FriendsDetailsCommentsTableViewCell")
        
        friendsDetailsTableView.register(UINib(nibName: "FriendsDetailsFriendsTableViewCell", bundle: nil), forCellReuseIdentifier: "FriendsDetailsFriendsTableViewCell")
        
        friendsDetailsTableView.register(UINib(nibName: "FriendsDetailsInterestListTableViewCell", bundle: nil), forCellReuseIdentifier: "FriendsDetailsInterestListTableViewCell")

    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        
        //User details Api
        self.viewProfileApi()
        
    }
    
    //MARK:- Api Methods
    func viewProfileApi() -> Void {
    
        //POST service
        
        //Add Loader
        MBProgressHUD.showAdded(to: self.view, withScreenHeaderHeigth: 0.0, animated: true)
        
        //url
        let urlString = MyAppConstants.userDetailUrl
        
        //Post data
        let postData = ["user_id":userIdOfSelectUser] as? Dictionary<String,String>
        
        ApiDataManager.singleTonObjectForApiManagerClass.getUserDetailApiValuesWithUrlString(urlString: urlString, withPostData: postData!) {  (apiRecievedResponse:Array?, error:NSError?) in
            
            //Remove Loader
            MBProgressHUD.hide(for: self.view, animated: true)
            
            //Remove User detail previous response
            if self.userDetailRecievedResponseArray.count != 0 {
                
                self.userDetailRecievedResponseArray.removeAll()
            }
            
            guard error == nil else{
                
                let errorText = error!.localizedFailureReason!
                
                if errorText == "ok successful"{
                    
                    //Reload Friends detail table view
                    self.friendsDetailsTableView.reloadData()
                    
                }
                else{
                    
                    //Reload friends detail table view
                    self.friendsDetailsTableView.reloadData()
                    
                    //Dsiplay alert
                    let alertController = singleTon.sharedInstance.displayAlert(message: errorText, title: "Fiturb")
                    
                    self.present(alertController, animated: true, completion: nil)
                }
                
                return
            }
            
            //Store recieved response
            self.userDetailRecievedResponseArray = apiRecievedResponse!
            
            if self.userDetailRecievedResponseArray.count != 0{
                
                for responseRecievedobj in self.userDetailRecievedResponseArray{
                    
                    let userDetailClassModalObj = responseRecievedobj as? userDetailModel
                    
                    print("User deatil Modal object is:\(userDetailClassModalObj!.thumbUrl!),\(userDetailClassModalObj!.firstName!),\(userDetailClassModalObj!.friendsCount!),\(userDetailClassModalObj!.followersCount!),\(userDetailClassModalObj!.reviewsRatingCount!),\(userDetailClassModalObj!.averageRatingTotalCount!),\(userDetailClassModalObj!.cityName!),\(userDetailClassModalObj!.accountCreatedDateAndTime!),\(userDetailClassModalObj!.userBirthdayDate!)")
                    
                }
                
                //Reload friends detail table view
                self.friendsDetailsTableView.reloadData()
            }
            
        }

    }
    
    
    func userCommentsApi() -> Void {
        
        //POST service
        
        //Add Loader
        MBProgressHUD.showAdded(to: self.view, withScreenHeaderHeigth: 0.0, animated: true)
        
        //url
        let urlString = String(format:"%@%@", MyAppConstants.baseUrlString,MyAppConstants.userCommentsUrl)
        
        //Post data
        let postData = ["user_id":userIdOfSelectUser] as? Dictionary<String,String>
        
        ApiDataManager.singleTonObjectForApiManagerClass.getUserCommentsApiValuesWithUrlString(urlString: urlString, withPostData: postData!) {  (apiRecievedResponse:Array?, error:NSError?) in
            
            //Remove Loader
            MBProgressHUD.hide(for: self.view, animated: true)
            
            //Remove User Comments previous response
            if self.userCommentsRecievedResponseArray.count != 0 {
                
                self.userCommentsRecievedResponseArray.removeAll()
            }
            
            guard error == nil else{
                
                let errorText = error!.localizedFailureReason!
                
                if errorText == "ok successful"{
                    
                    //Reload Friends detail table view
                    self.friendsDetailsTableView.reloadData()
                    
                }
                else{
                    
                    //Reload friends detail table view
                    self.friendsDetailsTableView.reloadData()
                    
                    //Dsiplay alert
                    let alertController = singleTon.sharedInstance.displayAlert(message: errorText, title: "Fiturb")
                    
                    self.present(alertController, animated: true, completion: nil)
                }
                
                return
            }
            
            //Store recieved response
            self.userCommentsRecievedResponseArray = apiRecievedResponse!
            
            if self.userCommentsRecievedResponseArray.count != 0{
                
                for responseRecievedobj in self.userCommentsRecievedResponseArray{
                    
                    let userCommentsClassModalObj = responseRecievedobj as? UserCommentsModel
                    
                    print("User comments Modal object is:\(userCommentsClassModalObj?.commentId!),\(userCommentsClassModalObj?.createdDateAndTime!),\(userCommentsClassModalObj?.userId!),\(userCommentsClassModalObj?.firstName!),\(userCommentsClassModalObj?.role!),\(userCommentsClassModalObj?.commentText!),\(userCommentsClassModalObj?.thumbUrl!),\(userCommentsClassModalObj?.averageRating!),\(userCommentsClassModalObj?.activityId!)")
                    
                }
                
                //Reload friends detail table view
                self.friendsDetailsTableView.reloadData()
            }
            
        }
        
    }

    
    func userInterestListApi() -> Void {
        
        //POST service
        
        //Add Loader
        MBProgressHUD.showAdded(to: self.view, withScreenHeaderHeigth: 0.0, animated: true)
        
        //User interest list url
        let urlString = String(format:"%@%@", MyAppConstants.baseUrlString,MyAppConstants.userInterestListUrl)
        
        //Post data
        let postData = ["user_id":userIdOfSelectUser] as? Dictionary<String,String>
        
        ApiDataManager.singleTonObjectForApiManagerClass.getUserInterestListApiValuesWithUrlString(urlString: urlString, withPostData: postData!) {  (apiRecievedResponse:Array?, error:NSError?) in
            
            //Remove Loader
            MBProgressHUD.hide(for: self.view, animated: true)
            
            //Remove User interest List previous response
            if self.userInterestListApiRecievedResponseArray.count != 0 {
                
                self.userInterestListApiRecievedResponseArray.removeAll()
            }
            
            guard error == nil else{
                
                let errorText = error!.localizedFailureReason!
                
                if errorText == "ok successful"{
                    
                    //set User Defaults IsSelected Key to False
                    UserDefaults.standard.set(false, forKey: "isUserInterestsAdded")
                    
                    //Reload Friends detail table view
                    self.friendsDetailsTableView.reloadData()
                    
                }
                else{
                    
                    //Reload friends detail table view
                    self.friendsDetailsTableView.reloadData()
                    
                    //Dsiplay alert
                    let alertController = singleTon.sharedInstance.displayAlert(message: errorText, title: "Fiturb")
                    
                    self.present(alertController, animated: true, completion: nil)
                }
                
                return
            }
            
            //Store recieved response
            self.userInterestListApiRecievedResponseArray = apiRecievedResponse!
            
            if self.userInterestListApiRecievedResponseArray.count != 0{
                
                for responseRecievedobj in self.userInterestListApiRecievedResponseArray{
                    
                    let userInterestListModalObj = responseRecievedobj as? InterestListModel
                    
                    print("User Interest list Modal object is:\(userInterestListModalObj?.message!),\(userInterestListModalObj?.interestId!),\(userInterestListModalObj?.interestName!),\(userInterestListModalObj?.interestIcon!)")
                    
                }

                //Reload friends detail table view
                self.friendsDetailsTableView.reloadData()
            }
            
        }
        
    }

    //MARK:- Protocol Methods for apis(mutual,followers and already friends list)
    func getMutualFriendsApiResponse(callBackBlock completionHandler:@escaping (_ apiRecievedResponse:Array<AnyObject>?) -> ()) {
        
        //POST service
        
        //Add Loader
        MBProgressHUD.showAdded(to: self.view, withScreenHeaderHeigth: 0.0, animated: true)
        
        //Mutual friends list url
        let urlString = String(format:"%@%@", MyAppConstants.baseUrlString,MyAppConstants.mutualFriendsUrl)
        
        //Post data
        let postData = ["user_id":userIdOfSelectUser]

        print("post data for mutual friends list is:\(postData)")
        ApiDataManager.singleTonObjectForApiManagerClass.getMutualFriendsApiValuesWithUrlString(urlString: urlString, withPostData: postData as Dictionary<String, AnyObject>) { [weak self] (apiRecievedResponse:Array?, error:NSError?) in
            
            //Remove Loader
            MBProgressHUD.hide(for: (self?.view)!, animated: true)
            
            //Remove mutual friends list previous response
            if self?.mutualFriendsListApiResponseRecievedArray.count != 0 {
                
                self?.mutualFriendsListApiResponseRecievedArray.removeAll()
            }
            
            guard error == nil else{
                
                let errorText = error!.localizedFailureReason!
                
                if errorText == "ok successful"{
                    
                    //Call back
                    DispatchQueue.main.async(execute: {
                        
                        completionHandler(self?.mutualFriendsListApiResponseRecievedArray as Array<AnyObject>?)
                    });
                    
                }
                else{
                    
                    //Call back
                    DispatchQueue.main.async(execute: {
                        
                        completionHandler(self?.mutualFriendsListApiResponseRecievedArray as Array<AnyObject>?)
                    });
                    
                    
                    //Dsiplay alert
                    let alertController = singleTon.sharedInstance.displayAlert(message: errorText, title: "Fiturb")
                    
                    self?.present(alertController, animated: true, completion: nil)
                }
                
                return
                
            }
            
            //Store recieved response
            self?.mutualFriendsListApiResponseRecievedArray = apiRecievedResponse!
            
            //Remove below part later
            if self?.mutualFriendsListApiResponseRecievedArray.count != 0{
                
                for responseRecievedobj in (self?.mutualFriendsListApiResponseRecievedArray)!{
                    
                    let tempObj = responseRecievedobj as! MutualFriendsModel
                    
                    print("Mutual Friends List model object values inside View profile screen is:\(tempObj.firstName!),\(tempObj.lastName!),\(tempObj.userID!),\(tempObj.imageUrl!),\(tempObj.message!)")
                    
                }
            }
            
            //Call back
            DispatchQueue.main.async(execute: {
                
                completionHandler(self?.mutualFriendsListApiResponseRecievedArray as Array<AnyObject>?)

            });
            
        }
        
    }
    
    func getFollowersFriendsApiResponse(callBackBlock completionHandler:@escaping (_ apiRecievedResponse:Array<AnyObject>?) -> ()) {
        
        //POST service
        
        //Add Loader
        MBProgressHUD.showAdded(to: self.view, withScreenHeaderHeigth: 0.0, animated: true)
        
        //Mutual friends list url
        let urlString = String(format:"%@%@", MyAppConstants.baseUrlString,MyAppConstants.followersFriendsUrl)
        
        //Post data
        let postData = ["user_id":userIdOfSelectUser]
        
        print("post data for Followers friends list is:\(postData)")
        ApiDataManager.singleTonObjectForApiManagerClass.getFollowersFriendsListApiValuesWithUrlString(urlString: urlString, withPostData: postData as Dictionary<String, AnyObject>) { [weak self] (apiRecievedResponse:Array?, error:NSError?) in
            
            //Remove Loader
            MBProgressHUD.hide(for: (self?.view)!, animated: true)
            
            //Remove Followers friends list previous response
            if self?.followersFriendsListApiResponseRecievedArray.count != 0 {
                
                self?.followersFriendsListApiResponseRecievedArray.removeAll()
            }
            
            guard error == nil else{
                
                let errorText = error!.localizedFailureReason!
                
                if errorText == "ok successful"{
                    
                    //Call back
                    DispatchQueue.main.async(execute: {
                        
                        completionHandler(self?.followersFriendsListApiResponseRecievedArray as Array<AnyObject>?)
                    });
                    
                }
                else{
                    
                    //Call back
                    DispatchQueue.main.async(execute: {
                        
                        completionHandler(self?.followersFriendsListApiResponseRecievedArray as Array<AnyObject>?)
                    });
                    
                    
                    //Dsiplay alert
                    let alertController = singleTon.sharedInstance.displayAlert(message: errorText, title: "Fiturb")
                    
                    self?.present(alertController, animated: true, completion: nil)
                }
                
                return
                
            }
            
            //Store recieved response
            self?.followersFriendsListApiResponseRecievedArray = apiRecievedResponse!
            
            //Remove below part later
            if self?.followersFriendsListApiResponseRecievedArray.count != 0{
                
                for responseRecievedobj in (self?.followersFriendsListApiResponseRecievedArray)!{
                    
                    let tempObj = responseRecievedobj as! FollowersFriendsModel
                    
                    print("Followers Friends List model object values inside View profile screen is:\(tempObj.firstName!),\(tempObj.lastName!),\(tempObj.userID!),\(tempObj.imageUrl!),\(tempObj.message!),\(tempObj.sinceTime!)")
                    
                }
            }
            
            //Call back
            DispatchQueue.main.async(execute: {
                
                completionHandler(self?.followersFriendsListApiResponseRecievedArray as Array<AnyObject>?)
                
            });
            
        }
        
    }
    
    func getFriendsListApiResponse(callBackBlock completionHandler:@escaping (_ apiRecievedResponse:[Array<Any?>]) -> ()) {
        
        //POST service
        
        //Add Loader
        MBProgressHUD.showAdded(to: self.view, withScreenHeaderHeigth: 0.0, animated: true)
        
        //friends list url
        let urlString = MyAppConstants.friendsListUrl
        
        //Post data
        let postData = ["user_id":userIdOfSelectUser]

        print("post data for friends list is:\(postData)")
        ApiDataManager.singleTonObjectForApiManagerClass.getFriendsApiValuesWithUrlString(urlString: urlString, withPostData: postData as Dictionary<String, AnyObject>) { [weak self] (apiRecievedResponse:Array?, error:NSError?) in
            
            //Remove Loader
            MBProgressHUD.hide(for: (self?.view)!, animated: true)
            
            //Remove friends list previous response
            if self?.friendsListApiResponseRecievedArray.count != 0 {
                
                self?.friendsListApiResponseRecievedArray.removeAll()
            }
            
            guard error == nil else{
                
                let errorText = error!.localizedFailureReason!
                
                if errorText == "ok successful"{
                    
                    //Call back
                    DispatchQueue.main.async(execute: {
                        
                        completionHandler([(self?.friendsListApiResponseRecievedArray)!])
                    });
                    
                }
                else{
                    
                    //Call back
                    DispatchQueue.main.async(execute: {
                        
                        completionHandler([(self?.friendsListApiResponseRecievedArray)!])
                    });
                    
                    
                    //Dsiplay alert
                    let alertController = singleTon.sharedInstance.displayAlert(message: errorText, title: "Fiturb")
                    
                    self?.present(alertController, animated: true, completion: nil)
                }
                
                return
                
            }
            
            //Store recieved response
            self?.friendsListApiResponseRecievedArray = apiRecievedResponse!
            
            //Remove below part later
            if self?.friendsListApiResponseRecievedArray.count != 0{
                
                for responseRecievedobj in (self?.friendsListApiResponseRecievedArray)!{
                    
                    let tempObj = responseRecievedobj as! FriendsListModel
                    
                    print("Friends List model object values inside View profile screen is:\(tempObj.firstName!),\(tempObj.lastName!),\(tempObj.userId!),\(tempObj.friendshipStatus!),\(tempObj.thumbUrl!),\(tempObj.onlineStatus!),\(tempObj.message!),\(tempObj.friendsType!)")
                    
                }
            }
            
            
            //Call back
            DispatchQueue.main.async(execute: {
                
                completionHandler([(self?.friendsListApiResponseRecievedArray)!])
                
            });
            
            
        }
        
    }
    
   
    //MARK:- Protocol methods for Fallow,Unfallow and Add Freinds Apis
    func getfallowFriendApiResponse(callBackBlock completionHandler:@escaping (_ apiRecievedResponse:[Array<AnyObject>?],_ userDetailModelObj:userDetailModel?) -> ())
    {
        //POST service
        
        //Add Loader
        MBProgressHUD.showAdded(to: self.view, withScreenHeaderHeigth: 0.0, animated: true)
        
        //Fallow friends list url
        let urlString = String(format:"%@%@", MyAppConstants.baseUrlString,MyAppConstants.followFriendUrl)
        
        //Model object
        let userDetailModelObj = self.userDetailRecievedResponseArray[0] as? userDetailModel
        
        //Post data
        let postData = ["user_id":userDetailModelObj?.userID]
        
        print("post data is:\(postData)")
        ApiDataManager.singleTonObjectForApiManagerClass.fallowApiValuesWithUrlString(urlString: urlString, withPostData: postData as! Dictionary<String, String>) { [weak self] (apiRecievedResponse:Array?, error:NSError?) in
            
            //Remove Loader
            MBProgressHUD.hide(for: (self?.view)!, animated: true)
        
            
            guard error == nil else{
                
                let errorText = error!.localizedFailureReason!
                
                if errorText == "ok successful"{
                    
                    //Call back
                    DispatchQueue.main.async(execute: {
                        
                        completionHandler([apiRecievedResponse!], userDetailModelObj)
                    });
                    
                }
                else{
                    
                    //Dsiplay alert
                    let alertController = singleTon.sharedInstance.displayAlert(message: errorText, title: "Fiturb")
                    
                    self?.present(alertController, animated: true, completion: nil)
                }
                
                return
                
            }
            
            
            if apiRecievedResponse?.count != 0{
            
                    //Fallow friend model object
                    let tempObj = apiRecievedResponse?[0] as! FollowFriendsModel
                
                   print("fallow friend model object values are:\(tempObj.message)")
                
                    //Call back
                    DispatchQueue.main.async(execute: {
                    
                        completionHandler([apiRecievedResponse!], userDetailModelObj)
                        
                    });
                
            }
            
        }
        
    }

    func getUnFallowFriendApiResponse(callBackBlock completionHandler:@escaping (_ apiRecievedResponse:[Array<AnyObject>?],_ userDetailModelObj:userDetailModel?) -> ())
    {
        //POST service
        
        //Add Loader
        MBProgressHUD.showAdded(to: self.view, withScreenHeaderHeigth: 0.0, animated: true)
        
        //Un fallow friends list url
        let urlString = String(format:"%@%@", MyAppConstants.baseUrlString,MyAppConstants.unfollowFriendUrl)
        
        //Model object
        let userDetailModelObj = self.userDetailRecievedResponseArray[0] as? userDetailModel
        
        //Post data
        let postData = ["user_id":userDetailModelObj?.userID]
        
        print("post data is:\(postData)")
        ApiDataManager.singleTonObjectForApiManagerClass.unFallowApiValuesWithUrlString(urlString: urlString, withPostData: postData as! Dictionary<String, String>) { [weak self] (apiRecievedResponse:Array?, error:NSError?) in
            
            //Remove Loader
            MBProgressHUD.hide(for: (self?.view)!, animated: true)
            
            
            guard error == nil else{
                
                let errorText = error!.localizedFailureReason!
                
                if errorText == "ok successful"{
                    
                    //Call back
                    DispatchQueue.main.async(execute: {
                        
                        completionHandler([apiRecievedResponse!], userDetailModelObj)
                    });
                    
                }
                else{
                    
                    //Dsiplay alert
                    let alertController = singleTon.sharedInstance.displayAlert(message: errorText, title: "Fiturb")
                    
                    self?.present(alertController, animated: true, completion: nil)
                }
                
                return
                
            }
            
            
            if apiRecievedResponse?.count != 0{
                
                //unFallow friend model object
                let tempObj = apiRecievedResponse?[0] as! UnFallowFriendsModel
                
                print(" unFallow friend model object values are:\(tempObj.message)")
                
                //Call back
                DispatchQueue.main.async(execute: {
                    
                    completionHandler([apiRecievedResponse!], userDetailModelObj)
                    
                });
                
            }
            
        }
        
    }
    
    func sendFriendApiResponse(callBackBlock completionHandler:@escaping (_ apiRecievedResponse:String?,_ userDetailModelObj:userDetailModel?) -> ()){
        
        //POST service
        
        //Add Loader
        MBProgressHUD.showAdded(to: self.view, withScreenHeaderHeigth: 0.0, animated: true)
        
        //send Friend Request url
        let urlString = String(format:"%@%@", MyAppConstants.baseUrlString,"Friend/friends/send_request")
        
        //Model object
        let userDetailModelObj = self.userDetailRecievedResponseArray[0] as? userDetailModel
        
        //Post data
        let postData = ["user_id":userDetailModelObj?.userID]
        
        print("Post data is:\(postData)")
        
        ApiDataManager.singleTonObjectForApiManagerClass.sendFriendRequestApiValuesWithUrlString(urlString: urlString, withPostData: (postData as? Dictionary<String, String>)!,callBackBlock: { (apirecievedResponse: String?, error:NSError?) in
            
            //Remove Loader
            MBProgressHUD.hide(for: self.view, animated: true)
            
            guard error == nil else{
                
                //Error handling
                print("Error recieved from send friend request api is:\(error!.localizedFailureReason!)")
                
                //Dsiplay alert
                let alertController = singleTon.sharedInstance.displayAlert(message: (error!.localizedFailureReason!), title: "Fiturb")
                self.present(alertController, animated: true, completion: nil)
                
                return
                
            }
            
            guard let apiResponse = apirecievedResponse else{
                
                print("Error in send Friend request")
                
                let alertController = singleTon.sharedInstance.displayAlert(message: "Error in Send friend request!", title: "Fiturb")
                
                self.present(alertController, animated: true, completion: nil)
                
                return
                
            }
            
            print("Sent friend request successfully")
            
            //Show Success msg
            let alertController = singleTon.sharedInstance.displayAlert(message: apiResponse, title: "Fiturb")
            self.present(alertController, animated: true, completion: nil)
            
            //Call back
            DispatchQueue.main.async(execute: {
                
                completionHandler(apirecievedResponse, userDetailModelObj)
                
            });
        })
        
    }

    //MARK:- IBActions
    @IBAction func backBtnPressedAction(_ sender: UIButton) {
        
        _ = navigationController?.popViewController(animated: false)
        
    }
    //MARK:- UITableview Datasource and Delegate Methods
    func numberOfSections(in tableView: UITableView) -> Int {

        var sectionsCount: Int = 0
        
        if self.userDetailRecievedResponseArray.count != 0{
            
            sectionsCount = 2
            
        }
        
        return sectionsCount
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        var tableViewRowsCount:Int?
    
        switch section {
        case 0:
            tableViewRowsCount = 1
            
        default:
            
            switch self.selectedSegmentedControlIndexValue ?? 0{
                
            case 0:
                //activity cell
                tableViewRowsCount = 9
                
            case 1:
                //comments cell
                tableViewRowsCount = ((self.userCommentsRecievedResponseArray.count != 0) ? self.userCommentsRecievedResponseArray.count : 0)
                
            case 2:
                //friends cell rows should always be one
                tableViewRowsCount = 1
                
            case 3:
                //User intrestList cell
                tableViewRowsCount = ((self.userInterestListApiRecievedResponseArray.count != 0) ? self.userInterestListApiRecievedResponseArray.count : 1)
                
            default:
                //No cells
                tableViewRowsCount = 0
            }
        }
        
        return tableViewRowsCount!
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        
        switch indexPath.section {
            
        case 0:
            
            //User View profile view data cell
            let viewProfileCell = tableView.dequeueReusableCell(withIdentifier: "FriendsProfileInFriendsDetailsTableViewCell", for: indexPath) as? FriendsProfileInFriendsDetailsTableViewCell
            
            //Set friends profile delegate protocol object
            viewProfileCell?.friendsProfileProtcolDelegate = self
            
            //View profile model object
            let userDetailModelObj = self.userDetailRecievedResponseArray[0] as? userDetailModel
            
            viewProfileCell?.materialDesignPart()
            
            //Custom cell data
            viewProfileCell?.customCellData(userNameText: userDetailModelObj?.firstName, friendShipStatusText: userDetailModelObj?.friendShipStatus, fallowValue: userDetailModelObj?.isFollowing, friendsCountText: userDetailModelObj?.friendsCount, followersCount: userDetailModelObj?.followersCount, userTotalRatingText: userDetailModelObj?.reviewsRatingCount, userAverageRatingText: userDetailModelObj?.averageRatingTotalCount, cityNameText: userDetailModelObj?.cityName, createdDataAndTimeText: userDetailModelObj?.accountCreatedDateAndTime, userBirthDayDateText: userDetailModelObj?.userBirthdayDate, userProfileImageUrl: userDetailModelObj?.thumbUrl,withUserDatailModelObj:userDetailModelObj)
            
            return viewProfileCell!
            
        default:
            
            switch self.selectedSegmentedControlIndexValue ?? 0
            {
                
            case 0:
                //activity cell
                let friendsDetailActivity = tableView.dequeueReusableCell(withIdentifier: "FriendsDetailsActivityTableViewCell", for: indexPath) as! FriendsDetailsActivityTableViewCell
                
                friendsDetailActivity.materialDesignOfFriendsActivityCell()
                
                return friendsDetailActivity
                
            case 1:
                
                //User comments cell
                let userCommentsCell = tableView.dequeueReusableCell(withIdentifier: "FriendsDetailsCommentsTableViewCell", for: indexPath) as! FriendsDetailsCommentsTableViewCell
                
                userCommentsCell.materialDesignOfFriendsCommentCell()
                
                //User comments model object
                let userCommnetsModelObj = self.userCommentsRecievedResponseArray[indexPath.row] as? UserCommentsModel
                
                //Custom cell data
                userCommentsCell.customCellData(thumbUrl: userCommnetsModelObj?.thumbUrl, userName: userCommnetsModelObj?.firstName, commentsCreatedTime: userCommnetsModelObj?.createdDateAndTime, role: userCommnetsModelObj?.role, commentsText: userCommnetsModelObj?.commentText, averageRating: userCommnetsModelObj?.averageRating)
                
                return userCommentsCell
                
            case 2:
                //friends cell
                let friendsDetailsFriends = tableView.dequeueReusableCell(withIdentifier: "FriendsDetailsFriendsTableViewCell", for: indexPath) as! FriendsDetailsFriendsTableViewCell
                
                //Set Delegate
                friendsDetailsFriends.FriendsDetailsViewControllerDelgate = self

                //custom cell method
                friendsDetailsFriends.customCellToReloadTableViewPresentInsideRow()
                
                return friendsDetailsFriends
                
            case 3:
                //intrestList cell
                let userIntrestListCell = tableView.dequeueReusableCell(withIdentifier: "FriendsDetailsInterestListTableViewCell", for: indexPath) as! FriendsDetailsInterestListTableViewCell
                
                var cellText: String? = "No data available"
                
                if self.userInterestListApiRecievedResponseArray.count != 0 {
                    
                    //User interest list model
                    let userInterestListModelObj = self.userInterestListApiRecievedResponseArray[indexPath.row] as? InterestListModel
                    
                    cellText = userInterestListModelObj?.interestName
                }
               
                //Custom cell method
                userIntrestListCell.fillCustomCellData(userInterestNameText:cellText)
                
                return userIntrestListCell
                
            default:
                
                return UITableViewCell()
                
            }
            
            
        }
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        switch indexPath.section {
        case 0:
            
            //View profile cell height
            return 301
            
        default:
            
            switch self.selectedSegmentedControlIndexValue ?? 0 {
                
            case 0:
                //Activity cell
                return 191
                
            case 1:
                
                //Comments cell
                return 172
                
            case 2:
                
                //Friends cell
                return 430
                
            case 3:
                
                //Intrest cell
                return 50

            default:
                return 0
                
            }
    
        }
        
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        
        if needsReloadHeader == true
        {
             FriendsDetailsHeaderCell = tableView.dequeueReusableCell(withIdentifier: "FriendsDetailsHeaderTableViewCell") as! FriendsDetailsHeaderTableViewCell
            
            FriendsDetailsHeaderCell.friendsDetailsSegment.addTarget(self, action: #selector(segmentAction), for: .valueChanged)
            
            oldHeaderView = FriendsDetailsHeaderCell
        }
        else
        {
            FriendsDetailsHeaderCell = oldHeaderView
            
        }
        
        return FriendsDetailsHeaderCell.contentView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        switch section {
        case 0:
            
            return 0
        default:
            
            return 51
            
        }
    
    }
   
    //MARK:- Private Methods
    
    //Segment Action
    func segmentAction(sender:UISegmentedControl)
    {
        //self.sampleTable.reloadData()
        print("selected index is = \(sender.selectedSegmentIndex)")
        
        //Temprary solution
        self.selectedSegmentedControlIndexValue = sender.selectedSegmentIndex
        
        needsReloadHeader = false
        
        switch self.selectedSegmentedControlIndexValue ?? Int(4) {
        case 0:
            
            //Call Activty Api
            break
            
        case 1:
            //Call user Comments Api method
            self.userCommentsApi()
            break
            
        case 2:
            //reload only table view
            self.friendsDetailsTableView.reloadData()
            break
            
        case 3:
            //Interest list api method
           self.userInterestListApi()
            break
            
        default:
            break
            
        }
        
    }

}
