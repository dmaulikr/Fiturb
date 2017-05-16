//
//  GroupMembersPopupViewController.swift
//  Fiturb
//
//  Created by DATAPPS on 3/30/17.
//  Copyright © 2017 Fiturb.DATAPPS. All rights reserved.
//

import UIKit

class GroupMembersPopupViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,UIGestureRecognizerDelegate,groupMembersProtocol,addNewFriendsProtocol{
    
  //MARK:- IBOutlet Methods
    
    @IBOutlet weak var groupMembersTableView: UITableView!
    
    public var addnewFriendPopupView:AddNewFriendsPopViewController!
    
    @IBOutlet weak var closeButton: UIButton!

    var groupDetailApiResponseRecievedArray = [AnyObject?]()
    
    //group list model obj for group id
    var groupListModelObjForGrupID:GroupListModel?
    
    //Array friends list model object
    var friendsListModelObjArray = [AnyObject?]()
    
  //MARK:- View LifeCycle Methods
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        let gr = UITapGestureRecognizer(target: self, action: #selector(self.tagGestureRemovePOPUP))
        
        gr.delegate = self
        
        self.view.addGestureRecognizer(gr)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        
        closeButton.setFAIcon(icon:.FATimes, iconSize: 30, forState: .normal)
        
        closeButton.setTitleColor(UIColor.white, for: .normal)
        
        
        //group details api method
        self.groupDetailsApi()
    }
    
    //MARK:- Api methods
    
    //POST method
    func groupDetailsApi() -> Void {
        
        //Add Loader
        MBProgressHUD.showAdded(to: self.view, withScreenHeaderHeigth: 0.0, animated: true)
        
        //group detail url
        let UrlString = MyAppConstants.groupDetailUrl
        
        //Post data
        let postData = ["group_id":(groupListModelObjForGrupID != nil) ? groupListModelObjForGrupID!.groupId!: ""] as Dictionary<String,String>
        
        ApiDataManager.singleTonObjectForApiManagerClass.groupDetailsRequestApiValuesWithUrlString(urlString: UrlString, withPostData: postData,callBackBlock: { (apiRecievedResponse:Array?, error:NSError?) in
            
            //Remove Loader
            MBProgressHUD.hide(for: self.view, animated: true)
            
            //remove previous api call response
            if self.groupDetailApiResponseRecievedArray.count != 0{
                
                self.groupDetailApiResponseRecievedArray.removeAll()
            }
            
            guard error == nil else{
                
                let errorText = error!.localizedFailureReason!
                
                if errorText == "ok successful"{
                    
                    //Reload group members table view
                    self.groupMembersTableView.reloadData()
                    
                }
                else{
                    
                    //Reload group members table view
                    self.groupMembersTableView.reloadData()
                    
                    //Error handling
                    print("Error recieved from group detail api is:\(error!.localizedFailureReason!)")
                    
                    //Dsiplay alert
                    let alertController = singleTon.sharedInstance.displayAlert(message: (error!.localizedFailureReason!), title: "Fiturb")
                    self.present(alertController, animated: true, completion: nil)

                }
                
                return
                
            }
            
            self.groupDetailApiResponseRecievedArray = apiRecievedResponse!
            
            if self.groupDetailApiResponseRecievedArray.count != 0{
                
                for responseRecievedobj in self.groupDetailApiResponseRecievedArray{
                    
                    let tempObj = responseRecievedobj as! GroupDetailsModel
                    
                    print("group detail model object values are:\(tempObj.message!),\(tempObj.userId!),\(tempObj.firstName!),\(tempObj.lastName!),\(tempObj.imageurl!))")
                }
                
              //Reload group members table view
               self.groupMembersTableView.reloadData()
              
            }
            
        })
        
    }

    //POST method
    func removeGroupMeberApi(userId:String) -> Void {
        
        //Add Loader
        MBProgressHUD.showAdded(to: self.view, withScreenHeaderHeigth: 0.0, animated: true)
        
        //remove group url
        let urlString = MyAppConstants.removeGroupMeberUrl
        
        //User ID
        var userIdCollection = [Dictionary<String,String>]()
        userIdCollection.append(["user_id":userId])
        
        let groupId = (groupListModelObjForGrupID != nil) ? groupListModelObjForGrupID!.groupId!: ""
        
        //let postData
        let postdata = ["group_id":groupId,"members":userIdCollection] as Dictionary<String,AnyObject>
        
        print("Post data is:\(postdata)")
        
        ApiDataManager.singleTonObjectForApiManagerClass.removeGroupMeberApiValuesWithUrlString(urlString: urlString, withPostData: postdata,callBackBlock: { (apiRecievedResponse:Array?, error:NSError?) in
            
            //Remove Loader
            MBProgressHUD.hide(for: self.view, animated: true)
            
            guard error == nil else{
                
                //Error handling
                print("Error recieved from remove group member request api is:\(error!.localizedFailureReason!)")
                
                //Dsiplay alert
                let alertController = singleTon.sharedInstance.displayAlert(message: (error!.localizedFailureReason!), title: "Fiturb")
                self.present(alertController, animated: true, completion: nil)
                
                return
            }
            
            if apiRecievedResponse?.count != 0{
                
                let tempObj = apiRecievedResponse?[0] as! DeleteGroupMeberModel
                
                print("remove group member model object values are:\(tempObj.message!)")
                
                //Call group detail api method
                self.groupDetailsApi()
            }
            
        })
        
    }
    
    //MARK:- Add New Friends protocol delegate method
    func callGroupDetailsApiProtocol() -> Void{
        
        //Call group detail api to display added friends 
        self.groupDetailsApi()
        
    }
    
    //MARK:- Group mebers protocol delegate methods
    func removeGroupMebersApi(buttonAdress:UIButton) -> Void{
        
        //Group detail model obj
        let modelObjToGetUserId = self.groupDetailApiResponseRecievedArray[buttonAdress.tag] as! GroupDetailsModel
        
        //slected user id
        let userId = modelObjToGetUserId.userId
        
        //remove group meber Api method
        self.removeGroupMeberApi(userId: userId!)
        
    }
    
    //MARK:- Private Methods
    
    func tagGestureRemovePOPUP(_ gestureRecognizer: UIGestureRecognizer) {
        
        //Removing Pop up servies table view and background view
        self.view.removeFromSuperview()
        
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        
        if gestureRecognizer is UITapGestureRecognizer {
            
            let location = touch.location(in: groupMembersTableView)
            
            return (groupMembersTableView.indexPathForRow(at: location) == nil)
            
        }
        
        return true
    }

    //MARK:- IBAction Methods
    
    @IBAction func addNewMembersButtonPressed(_ sender: Any)
    {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        self.addnewFriendPopupView = storyboard.instantiateViewController(withIdentifier: "AddNewFriendsPopViewController") as! AddNewFriendsPopViewController
        
        //Set add new friends protocol delegate
        self.addnewFriendPopupView.addNewFriendsProtocolDelegate = self
        
        //Pass friends model object array to add new friends controller
        self.addnewFriendPopupView.friendsListModelObjArrayFromGrpMeberController = self.friendsListModelObjArray
        
        //pass group detail model object to add new friends controller
        self.addnewFriendPopupView.groupDetailModelObjArray = self.groupDetailApiResponseRecievedArray
        
        //Pass selected egroup list model object
        self.addnewFriendPopupView.selectedgroupListModelObj = self.groupListModelObjForGrupID
        
        self.addnewFriendPopupView.view.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height)
        
        self.view.addSubview(self.addnewFriendPopupView.view)
    }
    
    @IBAction func closeButtonPressed(_ sender: Any)
    {
        self.view.removeFromSuperview()

    }


    // MARK: - UITableView Datasource and delgate Methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        let rowsCount = (self.groupDetailApiResponseRecievedArray.count != 0) ? self.groupDetailApiResponseRecievedArray.count : 1
        
        return rowsCount
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let groupDetailCell = tableView.dequeueReusableCell(withIdentifier: "GroupMembersTableViewCell", for: indexPath) as! GroupMembersTableViewCell
        
        if self.groupDetailApiResponseRecievedArray.count != 0 {
            
            //Group detail model object
            let modelObj = self.groupDetailApiResponseRecievedArray[indexPath.row] as? GroupDetailsModel
            
            //initialize group member protocol delegate
            groupDetailCell.groupMebersprotocolDelegate = self
            
            //Custom cell method
            groupDetailCell.fillGroupDetailCustomCellData(name: (modelObj?.firstName)!, imageUrl: (modelObj?.imageurl)!,withCellsIndexPaths:indexPath.row)
            
        }
        else{
            
            //Custom cell method
            groupDetailCell.noMembersInGroup(text: "No members in group")
            
        }
        
        return groupDetailCell
    }

}
