//
//  FriendsViewController.swift
//  Fiturb
//
//  Created by DATAPPS on 3/17/17.
//  Copyright © 2017 Fiturb.DATAPPS. All rights reserved.
//

import UIKit

class FriendsViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,firendTableViewCellProtocol,UISearchBarDelegate,SearchProtocol,AddNewGroupProtocol,groupListProtocol{
    
    // IBOutlet
    @IBOutlet weak var friendsTableView: UITableView!
    
    @IBOutlet weak var searchTableView: UITableView!
    
    @IBOutlet weak var friendSegmentControl: UISegmentedControl!
    
    @IBOutlet weak var segmentControllerObject: UISegmentedControl!
    
    //for Friends list api
    var friendsListApiResponseRecievedArray = [AnyObject?]()

    //For followers friend list
    var followersFriendsListApiResponseRecievedArray = [AnyObject]()
    
    //for search api
    var searchApiResponseRecievedArray = [AnyObject]()
    
    //for group list api
    var groupListApiResponseRecievedArray = [AnyObject]()
    
    let nameArray = ["Sunil","Kumar","Shanthan","Madhu"]
    
    let friendsListArray = ["7 friends","4 friends","No friends","10 friends "]
    
    let offlineAndOnlineArray = ["online","offline","offline","online"]
    
    @IBOutlet weak var plusButtonPressed: UIButton!
    
    //add group pop object
    public var addGroupPopUp:AddGroupPopViewController!
    
    //add group memeber pop up object
    public var addGroupMembersPopUp:GroupMembersPopupViewController!

    //MARK:- Life cycle methods
    override func viewDidLoad() {
        
        super.viewDidLoad()

        //Hide search Table view
        self.searchTableView.isHidden = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        
       // if self.friendsListApiResponseRecievedArray.count == 0{
            
            //Get friends list info
            self.getFriendsListApi()
       // }

        //Plus icon image
        self.setPlusBtnIconImage()
        
    }
    
    
    //MARK:- Api Methods
    private func getFriendsListApi() -> Void {
        
        //POST service
        
        //Add Loader
        MBProgressHUD.showAdded(to: self.view, withScreenHeaderHeigth: 0.0, animated: true)
        
        //Friends list url
        let friendsListUrl = MyAppConstants.friendsListUrl
        
        //Post data
       let postData = ["user_id":singleTon.sharedInstance.getUserID()]
        
        print("post data for friend list is:\(postData)")
        
        ApiDataManager.singleTonObjectForApiManagerClass.getFriendsApiValuesWithUrlString(urlString: friendsListUrl, withPostData: postData as Dictionary<String, AnyObject>) { (apiRecievedResponse:Array?, error:NSError?) in
            
            //Remove Loader
            MBProgressHUD.hide(for: self.view, animated: true)
            
            //Remove friends list previous response
            if self.friendsListApiResponseRecievedArray.count != 0 {
                
                self.friendsListApiResponseRecievedArray.removeAll()
            }

            guard error == nil else{
                
                let errorText = error!.localizedFailureReason!
                
                if errorText == "ok successful"{
                    
                    //Reload group List table view
                    self.friendsTableView.reloadData()
                    
                    //Display alert
                    self.displayAlertMessage(message:"No data available!")
                    
                }
                else{
                    
                    //Reload friendList List table view
                    self.friendsTableView.reloadData()
                    
                    //Dsiplay alert
                    let alertController = singleTon.sharedInstance.displayAlert(message: errorText, title: "Fiturb")
                    
                    self.present(alertController, animated: true, completion: nil)
                }
                
                return
                
            }

            //Store recieved response
            self.friendsListApiResponseRecievedArray = apiRecievedResponse!
            
            //Remove below part later
            if self.friendsListApiResponseRecievedArray.count != 0{
                
                for responseRecievedobj in self.friendsListApiResponseRecievedArray{
                    
                    let tempObj = responseRecievedobj as! FriendsListModel
                    
                    print("Friends List model object values are:\(tempObj.firstName!),\(tempObj.lastName!),\(tempObj.userId!),\(tempObj.friendshipStatus!),\(tempObj.thumbUrl!),\(tempObj.onlineStatus!),\(tempObj.message!),\(tempObj.friendsType!)")
                    
                }
            }
            
            //Rleoad table view
            self.friendsTableView.reloadData()
            
        }
    }
    
    func followersFriendListApi() -> Void {
        
        //Add Loader
        MBProgressHUD.showAdded(to: self.view, withScreenHeaderHeigth: 0.0, animated: true)
        
        //Mutual friends list url
        let urlString = String(format:"%@%@", MyAppConstants.baseUrlString,MyAppConstants.followersFriendsUrl)
        
        //Post data
        let postData = ["user_id":singleTon.sharedInstance.getUserID()]
        
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
                    
                    //Rleoad table view
                    self?.friendsTableView.reloadData()
                    
                    //Display alert
                    self?.displayAlertMessage(message:"No data available!")
                }
                else{
                    
                    //Rleoad table view
                    self?.friendsTableView.reloadData()
                    
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
                    
                    print("Followers Friends List model object values inside Friends screen is:\(tempObj.firstName!),\(tempObj.lastName!),\(tempObj.userID!),\(tempObj.imageUrl!),\(tempObj.message!),\(tempObj.sinceTime!)")
                    
                }
            }
            
            //Rleoad table view
            self?.friendsTableView.reloadData()
            
        }
        
    }
    
    func searchApi(searchString:String) -> Void {
        
        //Add Loader
        MBProgressHUD.showAdded(to: self.view, withScreenHeaderHeigth: 0.0, animated: true)
        
        //search url
        let searchUrlString = MyAppConstants.searchRequestUrl
        
        //Post data
        let postData = ["query":searchString] as Dictionary<String,String>
        
        ApiDataManager.singleTonObjectForApiManagerClass.searchFriendRequestApiValuesWithUrlString(urlString: searchUrlString, withPostData: postData,callBackBlock: { (apiRecievedResponse:Array?, error:NSError?) in
            
            //Remove Loader
            MBProgressHUD.hide(for: self.view, animated: true)
            
            //Remove previous search api response
             if self.searchApiResponseRecievedArray.count != 0{
                
                self.searchApiResponseRecievedArray.removeAll()
            }
            
            guard error == nil else{
                
                //Error handling
                print("Error recieved from Search friend request api is:\(error!.localizedFailureReason!)")
                
                //Dsiplay alert
                let alertController = singleTon.sharedInstance.displayAlert(message: (error!.localizedFailureReason!), title: "Fiturb")
                self.present(alertController, animated: true, completion: nil)
                
                return
                
            }
            
            print("search friends successfull")
            self.searchApiResponseRecievedArray = apiRecievedResponse!
            
            if self.searchApiResponseRecievedArray.count != 0{
                
                for responseRecievedobj in self.searchApiResponseRecievedArray{
                    
                    let tempObj = responseRecievedobj as! SearchModel
                    
                    print("Search model object values are:\(tempObj.mesgText!),\(tempObj.userID!),\(tempObj.mobilenumber!),\(tempObj.firstName!),\(tempObj.lastName!),\(tempObj.thumbUrlImage!)")
                }
                
                //Reload search table view
                self.searchTableView.reloadData()
                
            }
            
            
        })
        
    }
    
    func groupListApiMethod() -> Void {
        
        //Get service
        
        //Add Loader
        MBProgressHUD.showAdded(to: self.view, withScreenHeaderHeigth: 0.0, animated: true)
        
        //url
        let urlString = MyAppConstants.groupListUrl
        
        ApiDataManager.singleTonObjectForApiManagerClass.getGroupListApiValuesWithUrlString(urlString:urlString) {  (apiRecievedResponse:Array?, error:NSError?) in
            
            //Remove Loader
            MBProgressHUD.hide(for: self.view, animated: true)
            
            //Remove group list previous response
            if self.groupListApiResponseRecievedArray.count != 0 {
                
                self.groupListApiResponseRecievedArray.removeAll()
            }

            guard error == nil else{
                
                let errorText = error!.localizedFailureReason!
                
                if errorText == "ok successful"{
                    
                    //Reload group List table view
                    self.friendsTableView.reloadData()
                 
                    //Display alert
                    self.displayAlertMessage(message:"No data available!")
                    
                }
                else{
                    
                    //Reload group List table view
                    self.friendsTableView.reloadData()
                    
                    //Dsiplay alert
                    let alertController = singleTon.sharedInstance.displayAlert(message: errorText, title: "Fiturb")
                    
                    self.present(alertController, animated: true, completion: nil)
                }
                
                return
            }
            
            //Store recieved response
            self.groupListApiResponseRecievedArray = apiRecievedResponse!
            
            if self.groupListApiResponseRecievedArray.count != 0{
                
                for responseRecievedobj in self.groupListApiResponseRecievedArray{
                    
                    let tempObj = responseRecievedobj as! GroupListModel
                    
                    print("Group list model object values are:\(tempObj.groupId!),\(tempObj.groupName!),\(tempObj.message!)")
                    
                }
                
                //Reload Group segment control table view view
               self.friendsTableView.reloadData()
            }
            
        }

    }
    
    //POST
    func groupDeleteApi(groupId:String) -> Void {
        
        //Add Loader
        MBProgressHUD.showAdded(to: self.view, withScreenHeaderHeigth: 0.0, animated: true)
        
        //delete  group url
        let urlString = MyAppConstants.deleteGroupUrl
        
        //let postData
        let postdata = ["group_id":groupId] 
        
        ApiDataManager.singleTonObjectForApiManagerClass.deleteGroupRequestApiValuesWithUrlString(urlString: urlString, withPostData: postdata,callBackBlock: { (apiRecievedResponse:Array?, error:NSError?) in
            
            //Remove Loader
            MBProgressHUD.hide(for: self.view, animated: true)
            
            guard error == nil else{
                
                //Error handling
                print("Error recieved from delete  group request api is:\(error!.localizedFailureReason!)")
                
                //Dsiplay alert
                let alertController = singleTon.sharedInstance.displayAlert(message: (error!.localizedFailureReason!), title: "Fiturb")
                self.present(alertController, animated: true, completion: nil)
                
                return
                
            }
            
            
            if apiRecievedResponse?.count != 0{
                
                let tempObj = apiRecievedResponse?[0] as! DeleteGroupModel
                
                print("delete group model object values are:\(tempObj.message!)")
                
                //Call group list api method
                self.groupListApiMethod()
            }
            
        })
        
    }
    
    
    //MARK:- Protocol Delegate methods(send,Accept,reject and Cancel api methods)
    func acceptFriendRequestApi(buttonAdress:UIButton, customCellAdress:FriendsTableViewCell) -> Void {
        
        //Add Loader
        MBProgressHUD.showAdded(to: self.view, withScreenHeaderHeigth: 0.0, animated: true)
        
        let modelObjToGetuserId = self.friendsListApiResponseRecievedArray[buttonAdress.tag] as! FriendsListModel
        
        //accept Friend Request url
        let urlString = MyAppConstants.acceptFriendRquestUrl
        
        //post data
        let userid = modelObjToGetuserId.userId
        
        let postData = ["user_id":userid] as! Dictionary<String,String>
        
        ApiDataManager.singleTonObjectForApiManagerClass.acceptFriendRequestApiValuesWithUrlString(urlString: urlString, withPostData: postData,callBackBlock: { (apirecievedResponse: String?, error:NSError?) in
            
            //Remove Loader
            MBProgressHUD.hide(for: self.view, animated: true)
            
            guard error == nil else{
                
                //Error handling
                print("Error recieved from Accept friend request api is:\(error!.localizedFailureReason!)")
                
                //Dsiplay alert
                let alertController = singleTon.sharedInstance.displayAlert(message: (error!.localizedFailureReason!), title: "Fiturb")
                self.present(alertController, animated: true, completion: nil)
                
                return
                
            }
            
            guard let apiResponse = apirecievedResponse else{
                
                print("Error in Friend request accept")
                
                let alertController = singleTon.sharedInstance.displayAlert(message: "Error in friend request accept!", title: "Fiturb")
                
                self.present(alertController, animated: true, completion: nil)

                return
                
            }
            
            print("friend request accepted successfully")
            
            //Hide accept and reject button
            customCellAdress.acceptFriendsBtn.isHidden = true
            customCellAdress.rejectFriends.isHidden = true

            //call friends list api
            self.getFriendsListApi()
        })
        
    }

    func rejectFriendRequestApi(buttonAdress:UIButton, customCellAdress:FriendsTableViewCell) -> Void{
        
        //Add Loader
        MBProgressHUD.showAdded(to: self.view, withScreenHeaderHeigth: 0.0, animated: true)
        
        let modelObjToGetuserId = self.friendsListApiResponseRecievedArray[buttonAdress.tag] as! FriendsListModel
        
        //reject Friend Request url
        let urlString = MyAppConstants.rejectFriendRequestUrl
        
        //post data
        let userid = modelObjToGetuserId.userId
        
        let postData = ["user_id":userid] as! Dictionary<String,String>
        
        ApiDataManager.singleTonObjectForApiManagerClass.rejectFriendRequestApiValuesWithUrlString(urlString: urlString, withPostData: postData,callBackBlock: { (apirecievedResponse: String?, error:NSError?) in
            
            //Remove Loader
            MBProgressHUD.hide(for: self.view, animated: true)
            
            guard error == nil else{
                
                //Error handling
                print("Error recieved from reject friend request api is:\(error!.localizedFailureReason!)")
                
                //Dsiplay alert
                let alertController = singleTon.sharedInstance.displayAlert(message: (error!.localizedFailureReason!), title: "Fiturb")
                self.present(alertController, animated: true, completion: nil)
                
                return
                
            }
            
            guard let apiResponse = apirecievedResponse else{
                
                print("Error in Friend request reject")
                
                let alertController = singleTon.sharedInstance.displayAlert(message: "Error in friend request reject!", title: "Fiturb")
                
                self.present(alertController, animated: true, completion: nil)
                
                return
                
            }
            
            print("friend request rejected successfully")
            
            //Hide accept and reject button
            customCellAdress.acceptFriendsBtn.isHidden = true
            customCellAdress.rejectFriends.isHidden = true

            //call friends list api
            self.getFriendsListApi()
            
        })
        
    }

    func cancelFriendRequestApi(buttonAdress:UIButton, customCellAdress:FriendsTableViewCell) -> Void{
        
        //Add Loader
        MBProgressHUD.showAdded(to: self.view, withScreenHeaderHeigth: 0.0, animated: true)
        
        let modelObjToGetuserId = self.friendsListApiResponseRecievedArray[buttonAdress.tag] as! FriendsListModel
        
        //Cancel Friend Request url
        let urlString = MyAppConstants.cancelFriendRequestUrl
        
        //post data
        let userid = modelObjToGetuserId.userId
        
        let postData = ["user_id":userid] as! Dictionary<String,String>
        
        ApiDataManager.singleTonObjectForApiManagerClass.cancelFriendRequestApiValuesWithUrlString(urlString: urlString, withPostData: postData,callBackBlock: { (apirecievedResponse: String?, error:NSError?) in
            
            //Remove Loader
            MBProgressHUD.hide(for: self.view, animated: true)
            
            guard error == nil else{
                
                //Error handling
                print("Error recieved from Cancel friend request api is:\(error!.localizedFailureReason!)")
                
                //Dsiplay alert
                let alertController = singleTon.sharedInstance.displayAlert(message: (error!.localizedFailureReason!), title: "Fiturb")
                self.present(alertController, animated: true, completion: nil)
                
                return
                
            }
            
            guard let apiResponse = apirecievedResponse else{
                
                print("Error in cancel Friend request")
                
                let alertController = singleTon.sharedInstance.displayAlert(message: "Error in Cancel friend request!", title: "Fiturb")
                
                self.present(alertController, animated: true, completion: nil)
                
                return
                
            }
            
            //Hide cancel button
            customCellAdress.cancelFriends.isHidden = true
            
            print("friend request Cancelled successfully")
            
            //call friends list api
            self.getFriendsListApi()
            
        })
        
    }

    func sendApiProtocolMethod(buttonAdress:UIButton, customCellAdress:SearchTableViewCell) -> Void{
        
        //Add Loader
        MBProgressHUD.showAdded(to: self.view, withScreenHeaderHeigth: 0.0, animated: true)
        
        let modelObjToGetuserId = self.searchApiResponseRecievedArray[buttonAdress.tag] as! SearchModel
        
        //send Friend Request url
        let urlString = MyAppConstants.sendFriendRequestUrl
        
        //post data
        let userid = modelObjToGetuserId.userID
        
        let postData = ["user_id":userid] as! Dictionary<String,String>
        
        ApiDataManager.singleTonObjectForApiManagerClass.sendFriendRequestApiValuesWithUrlString(urlString: urlString, withPostData: postData,callBackBlock: { (apirecievedResponse: String?, error:NSError?) in
            
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
                
                let alertController = singleTon.sharedInstance.displayAlert(message: "Error in Cancel friend request!", title: "Fiturb")
                
                self.present(alertController, animated: true, completion: nil)
                
                return
                
            }
            
            //Hide sendBtn button
            customCellAdress.sendBtn.isHidden = true
            
            print("Sent friend request successfull")
            
            //Show Success msg
            let alertController = singleTon.sharedInstance.displayAlert(message: apiResponse, title: "Fiturb")
            
            self.present(alertController, animated: true, completion: nil)
            
        })

    }
    
    //MARK:- Add New Group protocol delagate method
    func groupListApiCallandReloadFriendsTableViewMethod() -> Void{
        
        //call Group list Api method
        self.groupListApiMethod()
        
    }
    
    //MARK:- Group list Protocol delegate method(for Group delete api)
    func groupDeleteRequestApi(buttonAdress:UIButton) -> Void{
    
        let modelObjToGetuserId = self.groupListApiResponseRecievedArray[buttonAdress.tag] as! GroupListModel
        
        //slected group id
        let groupId = modelObjToGetuserId.groupId
        
        //Delete group Api method
        self.groupDeleteApi(groupId: groupId!)
        
    }
    
    func navigateToAddNewFriendController(buttonAdress:UIButton) ->Void
    {
        
        let groupListModelObj = self.groupListApiResponseRecievedArray[buttonAdress.tag] as! GroupListModel
        
        //Show group name mebers list pop up method
        self.showGroupMembersListPopUpScreen(groupListModelObj:groupListModelObj)
        
    }
    
    //MARK:- IBAction methods
    @IBAction func selectedSegementControlIndexAction(_ sender: UISegmentedControl) {
        
        switch segmentControllerObject.selectedSegmentIndex {
            
        case 0: print("Friends view")
        
            //Remove group list previous response to allow table view selection only for group list
            if self.groupListApiResponseRecievedArray.count != 0 {
            
                self.groupListApiResponseRecievedArray.removeAll()
            }
        
            plusButtonPressed.isHidden = true
        
            //call friends list api
            self.getFriendsListApi()
        
            break
            
            
        case 1: print("Following view")
        
            plusButtonPressed.isHidden = true
        
            //Call followers list api
            self.followersFriendListApi()
        
            break
            
        case 2:print("Groups view")
        
            plusButtonPressed.isHidden = false
        
            //call Group list Api method
            self.groupListApiMethod()
        
            break
            
        default:
            break
        }
        
    }
    
    @IBAction func plusButtonPressed(_ sender: Any) {
        
        //add group name popup
        addGroupPopMethod(groupListModelObj: nil)
        
    }
    
    //MARK:- UITableView Datasource Methods
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        var sectionsCount: Int? = 0
        if ((self.friendsListApiResponseRecievedArray.count != 0) || (self.followersFriendsListApiResponseRecievedArray.count != 0) || (self.groupListApiResponseRecievedArray.count != 0)){
         
            sectionsCount = 1
        }
        
        return sectionsCount!
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        var rowsCount: Int?
        
        if (tableView == self.searchTableView) {
            
            rowsCount = self.searchApiResponseRecievedArray.count
            
        }
        else if(tableView == self.friendsTableView){
            
            print(segmentControllerObject.selectedSegmentIndex)
            
            switch segmentControllerObject.selectedSegmentIndex {
            case 0:
                
                //Friends list segment control
                rowsCount = ((self.friendsListApiResponseRecievedArray.count != 0) ? self.friendsListApiResponseRecievedArray.count : 0)
                
            case 1:
                
                //Followers segment control
                rowsCount = ((self.followersFriendsListApiResponseRecievedArray.count != 0) ? self.followersFriendsListApiResponseRecievedArray.count : 0)

                
            case 2:
                
                //Groups segemnt control
                rowsCount = ((self.groupListApiResponseRecievedArray.count != 0) ? self.groupListApiResponseRecievedArray.count : 0)
                
            default:
            
                rowsCount = 0
                break
            }

            
        }
        
        return rowsCount!
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        
        var cell: UITableViewCell?
        
        if (tableView == self.friendsTableView) {
            
            switch segmentControllerObject.selectedSegmentIndex {
                
            case 0:
                
                let friendsCustomCell = tableView.dequeueReusableCell(withIdentifier: "FriendsTableViewCell", for: indexPath) as? FriendsTableViewCell
                
                //custom cell adress
                cell = friendsCustomCell
                
                //set fiends list cell delgate
                friendsCustomCell?.friendsApisDelegate = self
                
                if self.friendsListApiResponseRecievedArray.count != 0 {
                    
                    let friendsModelObj = self.friendsListApiResponseRecievedArray[indexPath.row] as! FriendsListModel
                    
                    //add tag to buttons
                    friendsCustomCell?.acceptFriendsBtn.tag = indexPath.row
                    
                    friendsCustomCell?.rejectFriends.tag = indexPath.row
                    
                    friendsCustomCell?.cancelFriends.tag = indexPath.row
                    
                    //Call custom cell method
                    friendsCustomCell?.fillFriendsInformation(friendsType: friendsModelObj.friendsType, firstName: friendsModelObj.firstName, lastName: friendsModelObj.lastName, friendShipStatus: friendsModelObj.friendshipStatus, onlineStatus: friendsModelObj.onlineStatus, thumbUrl: friendsModelObj.thumbUrl)
                }
                
            case 1:
                
                let followersCustomCell = tableView.dequeueReusableCell(withIdentifier: "FollowersListTableViewCell", for: indexPath) as? FollowersListTableViewCell
                
                //custom cell adress
                cell = followersCustomCell
                
                if self.followersFriendsListApiResponseRecievedArray.count != 0{
                    
                    //Followers list model obj
                    let followerModelObj = self.followersFriendsListApiResponseRecievedArray[indexPath.row] as? FollowersFriendsModel
                    
                    followersCustomCell?.fillCustomCellData(imageUrl: followerModelObj?.imageUrl, followerNameText: followerModelObj?.firstName)
                    
                }
               
            case 2:
                
               let grpTableviewCell = tableView.dequeueReusableCell(withIdentifier: "groupsTableViewCell", for: indexPath) as? groupsTableViewCell
                
                //custom cell adress
                cell = grpTableviewCell
                
                //set group list cell delgate
                grpTableviewCell?.groupListDelegate = self
               
               if self.groupListApiResponseRecievedArray.count != 0{
                
                let groupListModelObj = self.groupListApiResponseRecievedArray[indexPath.row] as! GroupListModel
                
                //custom cell method
                grpTableviewCell?.fillGroupsInformation(groupName: groupListModelObj.groupName, withCellsIndexPaths: indexPath.row)
                
                //Unhide plus btn
                plusButtonPressed.isHidden = false
                
               }
                
            default: break
                
                
            }
            
        }
        else if (tableView == self.searchTableView)
        {
            
            let searchTableViewCell = tableView.dequeueReusableCell(withIdentifier: "searchTableViewCell", for: indexPath) as! SearchTableViewCell
            
            cell = searchTableViewCell
            
            //set cell delgate
            searchTableViewCell.searchDelegate = self
            
            let searchModelObj = self.searchApiResponseRecievedArray[indexPath.row] as? SearchModel
            
            //Fill search custom cell data
            if (searchModelObj != nil) {
                
                searchTableViewCell.searchCellData(firstName: (searchModelObj?.firstName)!, imageUrl: (searchModelObj?.thumbUrlImage)!)
            }
            
            
        }
        
        
         return cell!
        
    }
    
    //MARK:- UITableView Delegate Methods
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
     
        var heightOfTableView:CGFloat?
        
        if tableView == friendsTableView {
            
            switch segmentControllerObject.selectedSegmentIndex {
            case 0,1:
                
                heightOfTableView = 81
                
            default:
                
                heightOfTableView = 51
                break
            }
            
        }
        else if(tableView == searchTableView){
            
             heightOfTableView = 71

        }

        return heightOfTableView!
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        //Only for group list
        if (tableView == self.friendsTableView) && (self.groupListApiResponseRecievedArray.count != 0) {
            
            let groupListModelObj = self.groupListApiResponseRecievedArray[indexPath.row] as! GroupListModel
            
            //add group name popup
            addGroupPopMethod(groupListModelObj:groupListModelObj)
        }
        else if(tableView == self.friendsTableView) && (self.friendsListApiResponseRecievedArray.count != 0){
            
            //Navigate to friends detail view controleer
            self.navigateToFriendsDetailViewController(indexPathOfSelectedItem:indexPath)
        }
    
    }

    
    //MARK:- Private methods
    func setPlusBtnIconImage() -> Void {
        
        //plusButtonPressed  // Set icon size
        plusButtonPressed.setFAIcon(icon: .FAPlus, iconSize: 30, forState: .normal)
        
        plusButtonPressed.setTitleColor(UIColor.white, for: .normal)
        
        plusButtonPressed.layer.cornerRadius = plusButtonPressed.frame.size.height/2
        
        plusButtonPressed.clipsToBounds = true
        
        plusButtonPressed.isHidden = true
        
    }

    func enableCancelBtnWhenKeyboardDissapears(searchBar:UISearchBar) -> Void{
        
        for subView in searchBar.subviews {
            
            for view in subView.subviews {
                
                if view.isKind(of:NSClassFromString("UIButton")!) {
                    
                        let cancelButton = view as! UIButton
                        cancelButton.isEnabled = true
                    
                }
            }
        }
    }
    
    func addGroupPopMethod(groupListModelObj:GroupListModel?)
    {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
         self.addGroupPopUp = storyboard.instantiateViewController(withIdentifier: "AddGroupPopViewController") as! AddGroupPopViewController
        
        //Set add group delegate
        self.addGroupPopUp.addNewGroupDelegate = self
        
        //Send Group list model object to group view controller
        self.addGroupPopUp.groupListModelObject = groupListModelObj
        
        self.addGroupPopUp.view.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height)
        
        self.view.addSubview(self.addGroupPopUp.view)
        
    }
    
    func showGroupMembersListPopUpScreen(groupListModelObj:GroupListModel) -> Void {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        self.addGroupMembersPopUp = storyboard.instantiateViewController(withIdentifier: "GroupMembersPopupViewController") as! GroupMembersPopupViewController
        
        //send group list model obj to add group pop screen
        self.addGroupMembersPopUp.groupListModelObjForGrupID = groupListModelObj
        
        //Send friends list model obj array to next screen
        self.addGroupMembersPopUp.friendsListModelObjArray = self.friendsListApiResponseRecievedArray
        
        self.addGroupMembersPopUp.view.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height)
        
        self.view.addSubview(self.addGroupMembersPopUp.view)
    }

    func displayAlertMessage(message: String?) -> Void {
        
        //Display alert
        let alertController = singleTon.sharedInstance.displayAlert(message: message!, title: "Fiturb")
        self.present(alertController, animated: true, completion: nil)

    }
    
    //MARK:- Search Bar delegate method
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar){
        
        //disappaer keyboard
        searchBar.resignFirstResponder()
        
        //Enable cancel button when keyboard dissapears
        self.enableCancelBtnWhenKeyboardDissapears(searchBar: searchBar)
        
        //Call search api
        self.searchApi(searchString:searchBar.text!)
        
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar){
        
        //remove cancel btn
        searchBar.setShowsCancelButton(false, animated: true)
        
        searchBar.text = ""
        
        //Hide search Table view
        self.searchTableView.isHidden = true
        
        //disappaer keyboard
        searchBar.resignFirstResponder()
        
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        
        //Show cancel btn
        searchBar .setShowsCancelButton(true, animated: true)
        
        searchBar.text = ""
        
        //Remove previous response of search api
        if self.searchApiResponseRecievedArray.count != 0 {
            
             self.searchApiResponseRecievedArray.removeAll()
        }
       
        //reload search table view
        self.searchTableView.reloadData()
        
        //Unhide search table view
        self.searchTableView.isHidden = false

    }
    
    //MARK:- Navigation methods
    func navigateToFriendsDetailViewController(indexPathOfSelectedItem:IndexPath) -> Void {
        
        //Frinds detail view controller object
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        
        let friendsDetailViewController = storyBoard.instantiateViewController(withIdentifier: "FriendsDetailsViewController") as? FriendsDetailsViewController
        
        if self.friendsListApiResponseRecievedArray.count != 0{
         
            //Friends list model object
            let friendsModelObj = self.friendsListApiResponseRecievedArray[indexPathOfSelectedItem.row] as! FriendsListModel
            
            //Send userId to next screen
            friendsDetailViewController?.userIdOfSelectUser = friendsModelObj.userId
        }
        
        self.navigationController?.pushViewController((friendsDetailViewController)!, animated: false)
    }
    
}
