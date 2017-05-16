//
//  AddNewFriendsPopViewController.swift
//  Fiturb
//
//  Created by DATAPPS on 3/30/17.
//  Copyright © 2017 Fiturb.DATAPPS. All rights reserved.
//

import UIKit

//MARK:- Protocol
protocol addNewFriendsProtocol: class{
    
    func callGroupDetailsApiProtocol() -> Void
    
}

class AddNewFriendsPopViewController: UIViewController,UITableViewDataSource,UITableViewDelegate,UIGestureRecognizerDelegate {

    //Protocol delegate variable
    var addNewFriendsProtocolDelegate: addNewFriendsProtocol? = nil
    
    //MARK:- IBOutlets
    
    var friendsPopUpCell : AddNewFriendsTableViewCell!

    @IBOutlet weak var friendsTableView: UITableView!
    
    @IBOutlet weak var closeButton: UIButton!
    
    //for friends list model object
    var friendsListModelObjArrayFromGrpMeberController = [AnyObject?]()
    
    //for group detail model object
    var groupDetailModelObjArray = [AnyObject?]()
    
    //Group list model object
    var selectedgroupListModelObj:GroupListModel?
    
    //Array to dislay table view cells
    var filteredFriendsCollectionArray = [Dictionary<String,String>]()
    
    //selected User id's collection array
    var selectedUserIdsArray = [String?]()
    
    //MARK:- ViewLife Cycle Methods
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        let gr = UITapGestureRecognizer(target: self, action: #selector(self.tagGestureRemovePOPUP))
        
        gr.delegate = self
        
        self.view.addGestureRecognizer(gr)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        
        closeButton.setFAIcon(icon: .FATimes, iconSize: 30, forState: .normal)
        
        closeButton.setTitleColor(UIColor.white, for: .normal)
     
        //Filter friend names
        self.filterFriendsNamesAndDisplay()
        
        //Reload table view
        self.friendsTableView.reloadData()
    }
    
    //MARK:- Api methods
    func addGroupMembersApi() -> Void {
        
        //Add Loader
        MBProgressHUD.showAdded(to: self.view, withScreenHeaderHeigth: 0.0, animated: true)
        
        //add group member url
        let urlString = MyAppConstants.addGroupMemberUrl
        
        //User ID
        var userIdCollection = [Dictionary<String,String>]()
        
        if self.selectedUserIdsArray.count != 0 {
            
            for object in self.selectedUserIdsArray {
                
                let userId = object
                
                //Add selected User Ids
                userIdCollection.append(["user_id":userId!])
            }
            
        }
        
        //Group id
        let groupId = (selectedgroupListModelObj != nil) ? selectedgroupListModelObj!.groupId!: ""
        
        //let postData
        let postdata = ["group_id":groupId,"members":userIdCollection] as Dictionary<String,AnyObject>
        
        print("Post data is:\(postdata)")
        
        ApiDataManager.singleTonObjectForApiManagerClass.addGroupMebersApiValuesWithUrlString(urlString: urlString, withPostData: postdata,callBackBlock: { (apiRecievedResponse:Array?, error:NSError?) in
            
            //Remove Loader
            MBProgressHUD.hide(for: self.view, animated: true)
            
            guard error == nil else{
                
                //Error handling
                print("Error recieved from Add new group member request api is:\(error!.localizedFailureReason!)")
                
                //Dsiplay alert
                let alertController = singleTon.sharedInstance.displayAlert(message: (error!.localizedFailureReason!), title: "Fiturb")
                self.present(alertController, animated: true, completion: nil)
                
                return
            }
            
            if apiRecievedResponse?.count != 0{
                
                let tempObj = apiRecievedResponse?[0] as! addGroupMembersModel
                
                print("add group member model object values are:\(tempObj.message!)")
                
                //call protocol method of group details api
                self.addNewFriendsProtocolDelegate?.callGroupDetailsApiProtocol()
                
                //Remove pop up
                self.view.removeFromSuperview()
            }
            
        })

    }
    
    //MARK:- IBAction Methods
    
    @IBAction func doneButtonPressed(_ sender: Any)
    {
        guard (self.selectedUserIdsArray.count != 0) else {
            
            //remove pop up without calling service
            self.view.removeFromSuperview()
            
            return
        }
        
        //Add group members api
        self.addGroupMembersApi()
        
    }
    
    @IBAction func closeButtonPressed(_ sender: UIButton)
    {
        self.view.removeFromSuperview()
    }
    
    //MARK:- Private Methods
    
    func tagGestureRemovePOPUP(_ gestureRecognizer: UIGestureRecognizer) {
        
        //Removing Pop up servies table view and background view
        self.view.removeFromSuperview()
        
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        
        if gestureRecognizer is UITapGestureRecognizer {
            
            let location = touch.location(in: friendsTableView)
            
            return (friendsTableView.indexPathForRow(at: location) == nil)
            
        }
        return true
    }
    
    func popUpCheckBoxActions(sender:UIButton)
    {

        if !sender .isSelected
        {
            if self.filteredFriendsCollectionArray.count != 0 {
                
                //user id of selected item
                let userId = (self.filteredFriendsCollectionArray[sender.tag]["userId"])
                
                //Add selected person User id
                self.selectedUserIdsArray.append(userId)
                
            }
            
            //check image
            sender.setImage(UIImage(named:"CheckBox"), for:.selected)
            sender.isSelected = true
            
        }
        else
        {
            
            if (self.filteredFriendsCollectionArray.count != 0) && (self.selectedUserIdsArray.count != 0){
                
                //User id to unselect
                let uncheckUserId = (self.filteredFriendsCollectionArray[sender.tag]["userId"])
                
                //Remove or filter selected person user id
                self.selectedUserIdsArray = self.selectedUserIdsArray.filter { $0 != uncheckUserId }
                
            }
            
            //Uncheck image
            sender.setImage(UIImage(named:"CheckBoxEmpty"), for: .normal)
            sender.isSelected = false
        }
        
    }
    
    //Filter names from friend List model and group detail model
    func filterFriendsNamesAndDisplay() -> Void {
        
        var checkFriendInList:Bool?
        
        if self.friendsListModelObjArrayFromGrpMeberController.count != 0{
            
            for responseRecievedobj in self.friendsListModelObjArrayFromGrpMeberController{
                
                checkFriendInList = false
                
                //friends list model object
                let friendListModelObject = responseRecievedobj as? FriendsListModel
                
                //If frineds type is "already freinds" then only display that name in list
                if (friendListModelObject != nil) && (friendListModelObject?.friendsType == "AlreadyFriends")
                {
                    
                    if self.groupDetailModelObjArray.count != 0{
                        
                        for responseRecievedobj in self.groupDetailModelObjArray{
                            
                            //Group details model object
                            let groupDetailsModelObject = responseRecievedobj as? GroupDetailsModel
                            
                            //compare friends user id
                            if (friendListModelObject?.userId == groupDetailsModelObject?.userId){
                                
                                checkFriendInList = true
                                break
                            }
                            
                        }
                    }
                    
                    if (checkFriendInList == false) {
                        
                        //Add user name and user id
                        let dictionaryObj = ["userName":friendListModelObject?.firstName,"userId":friendListModelObject?.userId]
                        
                        //Add friend to the array collection
                        self.filteredFriendsCollectionArray.append(dictionaryObj as! [String : String])
                        
                    }
                    
                }
                
            }
            
        }
        
    }

    //MARK:- UITableView Datasource and delegate methods Methods
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        let rowCount:Int?
        
        rowCount = (self.filteredFriendsCollectionArray.count != 0) ? self.filteredFriendsCollectionArray.count : 1
        
        return rowCount!
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        friendsPopUpCell = tableView.dequeueReusableCell(withIdentifier: "AddNewFriendsTableViewCell", for: indexPath) as! AddNewFriendsTableViewCell
        
        if self.filteredFriendsCollectionArray.count != 0 {
            
            friendsPopUpCell.fillCustomCellData(name: self.filteredFriendsCollectionArray[indexPath.row]["userName"], withButtonIndex:indexPath.row)
        }
        else{
            
                friendsPopUpCell.fillCustomCellDataWhenNoData()
        }
        
        //Action for check box
        friendsPopUpCell.friendsCheckBox.addTarget(self, action: #selector(popUpCheckBoxActions), for:.touchUpInside)
        
        return friendsPopUpCell
    }
}
