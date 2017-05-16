//
//  FriendsDetailsFriendsTableViewCell.swift
//  Fiturb
//
//  Created by DATAPPS on 4/13/17.
//  Copyright © 2017 Fiturb.DATAPPS. All rights reserved.
//

import UIKit

protocol FriendsDetailsViewControllerProtocol:class {
    
    func getFriendsListApiResponse(callBackBlock completionHandler:@escaping (_ apiRecievedResponse:[Array<Any?>]) -> ())

    func getMutualFriendsApiResponse(callBackBlock completionHandler:@escaping (_ apiRecievedResponse:Array<AnyObject>?) -> ())
    
     func getFollowersFriendsApiResponse(callBackBlock completionHandler:@escaping (_ apiRecievedResponse:Array<AnyObject>?) -> ())
    
}

class FriendsDetailsFriendsTableViewCell: UITableViewCell {

    //Friends list api response array
    //Protocol object
    var FriendsDetailsViewControllerDelgate:FriendsDetailsViewControllerProtocol? = nil
    
    //For friends list api response
    var friendsListApiResponseRecievedArray = [Any?]()
    
    //For mutual friends list api response
    var mutualFriendsListApiResponseRecievedArray = [AnyObject?]()
    
    //For Followers friends list api response
    var followersFriendsListApiResponseRecievedArray = [AnyObject?]()
    
    @IBOutlet weak var friendsDetailesFriendsTableview: UITableView!
    
    @IBOutlet weak var friendsDetailsFriendsSegment: UISegmentedControl!
    
    let friend = ["sunil","anil","kumar","fggfgf","fhdhhhfhf","fjhfhjhf","iiiii","guruurur","gjjfjjjgjg","fhfhhfhf","iiiiiiii","rrrrrrrr","qqqqqqq"]
    
    let common = ["anil","kumar","madhu"]

    let followers = ["madhu","yyyyy","tttttt","hhhhh"]
    
    override func awakeFromNib() {
        
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        self.friendsDetailesFriendsTableview.register(UITableViewCell.self, forCellReuseIdentifier: "mycell")

        // Configure the view for the selected state
    }
    
    //MARK:- Custom cells methods
    func customCellToReloadTableViewPresentInsideRow() -> Void {

        //Friends list api method calling
        self.friendsListApi()
        
    }
    
    //MARK:- Api methods
    func mutualFriendsListApi() -> Void {
        
        //Calling protocol method
        FriendsDetailsViewControllerDelgate?.getMutualFriendsApiResponse(callBackBlock: {[weak self] (responseRecievedArray:Array<AnyObject>?) in
            
            //Remove prevoius response
            if self?.mutualFriendsListApiResponseRecievedArray.count != 0{
                
                self?.mutualFriendsListApiResponseRecievedArray.removeAll()
            }
            
            if responseRecievedArray?.count != 0{
                
                //Store response
                self?.mutualFriendsListApiResponseRecievedArray = [responseRecievedArray?[0]]
                
            }
            
            //Reload table view
            self?.friendsDetailesFriendsTableview.reloadData()
        })
        
    }
    
    func followersFriendsListApi() -> Void {
        
        //Calling protocol method
        FriendsDetailsViewControllerDelgate?.getFollowersFriendsApiResponse(callBackBlock: {[weak self] (responseRecievedArray:Array<AnyObject>?) in
            
            //Remove prevoius response
            if self?.followersFriendsListApiResponseRecievedArray.count != 0{
                
                self?.followersFriendsListApiResponseRecievedArray.removeAll()
                
            }
            
            if responseRecievedArray?.count != 0{
                
                //Store response
                self?.followersFriendsListApiResponseRecievedArray = [responseRecievedArray?[0]]
                
                }
            
            //Reload table view
            self?.friendsDetailesFriendsTableview.reloadData()
        })
        
    }
    
    func friendsListApi() -> Void {
        
        //Calling protocol method
        FriendsDetailsViewControllerDelgate?.getFriendsListApiResponse(callBackBlock: {[weak self] (responseRecievedArray:[Array<Any?>]) in
            
            //Remove prevoius response
            if self?.friendsListApiResponseRecievedArray.count != 0{
                
                self?.friendsListApiResponseRecievedArray.removeAll()
                
            }
            
            if responseRecievedArray.count != 0{
                
                if (responseRecievedArray[0] as AnyObject).count != 0{
                    
                    for modelObject in responseRecievedArray[0]{
                        
                        let friendsType = (modelObject as? FriendsListModel)?.friendsType
                        
                        if  friendsType == "AlreadyFriends"{
                            
                            //Store friends list api response
                            self?.friendsListApiResponseRecievedArray.append(modelObject)
                            
                        }
                        
                    }
                    
                }

            }
            
            //Reload table view
            self?.friendsDetailesFriendsTableview.reloadData()
            
        })
        
    }
    
    //MARK:- IBActions
    @IBAction func friendsDetailsFriendsSegmentAction(_ sender: UISegmentedControl) {
        
        let selectedSegemnetControlIndex = sender.selectedSegmentIndex
        
        if selectedSegemnetControlIndex == 0 {
            
            //Friends list
            if self.friendsListApiResponseRecievedArray.count == 0{
                
                //Friends list api method
                self.friendsListApi()

            }
            else{
                
                //Reload table view
                self.friendsDetailesFriendsTableview.reloadData()
            }
            
        }
        else if(selectedSegemnetControlIndex == 1){
            
            //Mutual Friends list
             if self.mutualFriendsListApiResponseRecievedArray.count == 0{
                
                //mutual friends list api data
                self.mutualFriendsListApi()
            }
            else{
                
                //Reload table view
                self.friendsDetailesFriendsTableview.reloadData()
                
            }
            
        }
        else if(selectedSegemnetControlIndex == 2){
            
            //Followes list
            if self.followersFriendsListApiResponseRecievedArray.count == 0{
                
                //Followers friends list api data
                self.followersFriendsListApi()
            }
            else{
                
                //Reload table view
                self.friendsDetailesFriendsTableview.reloadData()
                
            }
            
        }
        
    }

}


//MARK:- friendsDetailesFriendsTableview Datasouce and delegate methods
extension FriendsDetailsFriendsTableViewCell:UITableViewDataSource
{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        var rowsCount:Int?
        
        switch friendsDetailsFriendsSegment.selectedSegmentIndex
        {
        case 0:
            
            //Friends list cell
            rowsCount = ((self.friendsListApiResponseRecievedArray.count != 0) ? self.friendsListApiResponseRecievedArray.count : 1)
            
        case 1:
            
            //Common friends list cell
            rowsCount = ((self.mutualFriendsListApiResponseRecievedArray.count != 0) ? self.mutualFriendsListApiResponseRecievedArray.count : 1)
            
        case 2:
            
            //Followers list cell
            rowsCount =  ((self.followersFriendsListApiResponseRecievedArray.count != 0) ? self.followersFriendsListApiResponseRecievedArray.count : 1)
            
        default:
            
            //No cell
            rowsCount = 0
            break
            
        }
        
        return rowsCount!
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        
        let mycell=tableView.dequeueReusableCell(withIdentifier: "mycell", for: indexPath)
        
        switch friendsDetailsFriendsSegment.selectedSegmentIndex {
            
        case 0:
            
            //Friends list cell
            var cellText:String? = "No data available"
            if self.friendsListApiResponseRecievedArray.count != 0{
             
                let friendsListModel = self.friendsListApiResponseRecievedArray[indexPath.row] as? FriendsListModel
                
                cellText = friendsListModel?.firstName
            }
            
            mycell.textLabel?.text = cellText
            
        case 1:
            
            //Common friends list cell
            var cellText:String? = "No data available"
            if self.mutualFriendsListApiResponseRecievedArray.count != 0 {
                
                let mutualFriendModelObj = self.mutualFriendsListApiResponseRecievedArray[indexPath.row] as? MutualFriendsModel
                
                cellText = mutualFriendModelObj?.firstName
            }
            
            mycell.textLabel?.text = cellText
            
        case 2:
            
            //Followers friends list cell
            var cellText:String? = "No data available"
            if self.followersFriendsListApiResponseRecievedArray.count != 0 {
                
                let followrsFriendsModelObj = self.followersFriendsListApiResponseRecievedArray[indexPath.row] as? FollowersFriendsModel
                
                cellText = followrsFriendsModelObj?.firstName
            }
            
            mycell.textLabel?.text = cellText
            
        default:
            break
        }
        
        return mycell
    }
}

extension FriendsDetailsFriendsTableViewCell:UITableViewDelegate
{
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 50
        
    }
    
}

