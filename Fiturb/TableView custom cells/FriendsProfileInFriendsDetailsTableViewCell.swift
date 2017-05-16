//
//  FriendsProfileInFriendsDetailsTableViewCell.swift
//  Fiturb
//
//  Created by DATAPPS on 4/12/17.
//  Copyright © 2017 Fiturb.DATAPPS. All rights reserved.
//

import UIKit
import Cosmos

protocol FriendsProfileProtcol: class {
    
    //fallow api method
    func getfallowFriendApiResponse(callBackBlock completionHandler:@escaping (_ apiRecievedResponse:[Array<AnyObject>?],_ userDetailModelObj:userDetailModel?) -> ())
    
    //Unfallow api method
     func getUnFallowFriendApiResponse(callBackBlock completionHandler:@escaping (_ apiRecievedResponse:[Array<AnyObject>?],_ userDetailModelObj:userDetailModel?) -> ())
    
    //Send friend request api method
    func sendFriendApiResponse(callBackBlock completionHandler:@escaping (_ apiRecievedResponse:String?,_ userDetailModelObj:userDetailModel?) -> ())
    
}

class FriendsProfileInFriendsDetailsTableViewCell: UITableViewCell {

    //Protocol object
    var friendsProfileProtcolDelegate:FriendsProfileProtcol? = nil
    
    //view profile model object
    var userDetailModel:userDetailModel?
    
    @IBOutlet weak var profilePicImageView: UIImageView!
    
    @IBOutlet weak var starRatingView: CosmosView!
    
    @IBOutlet weak var followButton: UIButton!
    
    @IBOutlet weak var addFriendButton: UIButton!
    
    @IBOutlet weak var fiturbJoinImageView: UIImageView!
    
    @IBOutlet weak var dateOfBirthImageView: UIImageView!
    
    @IBOutlet weak var locationImageView: UIImageView!
    
    @IBOutlet weak var userNameLabel: UILabel!
    
    @IBOutlet weak var friendsAndFollowersCountLabel: UILabel!
    
    @IBOutlet weak var totalRatingCountLabel: UILabel!
    
    @IBOutlet weak var cityNameLabel: UILabel!
    
    @IBOutlet weak var accountCreatedDateAndTimeLabel: UILabel!
    
    @IBOutlet weak var userBirthDayDate: UILabel!
    
    override func awakeFromNib() {
        
        super.awakeFromNib()
        
        // Initialization code
        
    }
    
    //MARK:- Custom cell method
    func customCellData(userNameText:String?,friendShipStatusText:String?,fallowValue:Bool?, friendsCountText:String?, followersCount: String?, userTotalRatingText:String?, userAverageRatingText:String?, cityNameText: String?, createdDataAndTimeText:Dictionary<String, String>?, userBirthDayDateText:Dictionary<String, String>?,userProfileImageUrl: String?,withUserDatailModelObj:userDetailModel?) -> Void{
        
        //Initially hide Follow and add friend buttons when loading
        self.hideFollowAndAddFriendButtons()
        
        //User detail model object
        if self.userDetailModel == nil{
            
            self.userDetailModel = withUserDatailModelObj
        }
        
        //UserName
        self.userNameLabel.text = userNameText

        //fallow and Add friend btn values
        self.fallowAndAddFriendBtnValuesFillMethod(friendShipStatus: friendShipStatusText, isFallowingValue: fallowValue)
        
        //Friends and Followers count
        self.friendsAndFollowersCountLabel.text = String(format: "%@ - %@", friendsCountText!,followersCount!)
        
        //Total rating
        self.totalRatingCountLabel.text = userTotalRatingText
        
        //Average rating(stars)
        self.starRatingView.rating = Double(userAverageRatingText!) ?? 0.0
        
        //City name
        self.cityNameLabel.text = cityNameText
        
        //Account created time
        self.accountCreatedDateAndTimeLabel.text = String(format: "Fiturb since %@ %@ %@", (createdDataAndTimeText?["monthName"]) ?? "0",(createdDataAndTimeText?["date"]) ?? "0",(createdDataAndTimeText?["year"]) ?? "0")
        
        //BirthDay Date
        self.userBirthDayDate.text = String(format: "%@ %@ %@ ", (userBirthDayDateText?["monthName"]) ?? "0",(userBirthDayDateText?["date"]) ?? "0",(userBirthDayDateText?["year"]) ?? "0")
        
        
        if self.profilePicImageView.image == nil {
            
            //Initially show loading image
            self.profilePicImageView.image = UIImage(named:"LoadingImagePleaseWait")
            UIImage.loadImageFromURL(imageUrlString: userProfileImageUrl,callback:{ [weak self] (image: UIImage?) -> () in
                
                //Check Uiimage contains image or not
                let imageRef:CGImage? = image?.cgImage
                
                //Profile image
                self?.profilePicImageView.image = (imageRef != nil) ? image : UIImage(named:"Default_Image")
                
            })
        }
        
    }
    
    //Adding FontAwesome Image
   func materialDesignPart(){
    
    //Follow btn
    followButton.titleLabel?.font = UIFont.fontAwesome(ofSize: 20)
    followButton.setTitle(String.fontAwesomeIcon(name: .rssSquare), for: .normal)
    
    //Add friend button
    addFriendButton.titleLabel?.font = UIFont.fontAwesome(ofSize: 20)
    addFriendButton.setTitle(String.fontAwesomeIcon(name: .userPlus), for: .normal)

    locationImageView.image = UIImage.fontAwesomeIcon(name:.mapMarker, textColor: UIColor.black, size: CGSize(width: 200, height: 200))
    
    fiturbJoinImageView.image = UIImage.fontAwesomeIcon(name:.clockO, textColor: UIColor.black, size: CGSize(width: 200, height: 200))

    dateOfBirthImageView.image = UIImage.fontAwesomeIcon(name:.birthdayCake, textColor: UIColor.black, size: CGSize(width: 200, height: 200))
    
    //imagecorener radiues
    self.profilePicImageView.layer.cornerRadius = self.profilePicImageView.frame.size.width/2
    self.profilePicImageView.clipsToBounds = true
    
    }
    
    func hideFollowAndAddFriendButtons() -> Void {
        
        self.followButton.isHidden = true
        
        self.addFriendButton.isHidden = true
        
    }
    
    func fallowAndAddFriendBtnValuesFillMethod(friendShipStatus:String?, isFallowingValue:Bool?) -> Void {
        
        //Add Friend button
        if (friendShipStatus != nil) {
            
            //Friendship status == 0 meaans pending
            if friendShipStatus == "0" {
                
                //Unhide addFriendbtn
                self.addFriendButton.isHidden = false
                
                self.addFriendButton.setTitleColor(UIColor.orange, for: UIControlState.normal)
                //Disable user interaction
                self.addFriendButton.isUserInteractionEnabled = false
                
            }
            else if (friendShipStatus == "1"){
                
                self.addFriendButton.isHidden = false
                
                self.addFriendButton.setTitleColor(UIColor.green, for: UIControlState.normal)
                //Disable user interaction
                self.addFriendButton.isUserInteractionEnabled = false
                
            }
            else if(friendShipStatus == "2"){
                
                //Your own account so hide
                self.addFriendButton.isHidden = true
            }
            else{
                
                //Unhide addFriendbtn
                self.addFriendButton.isHidden = false
                self.addFriendButton.setTitleColor(UIColor.black, for: UIControlState.normal)
                //Enable user interaction
                self.addFriendButton.isUserInteractionEnabled = true
                
            }
            
        }
        
        //FALLOW BTN
        //Check wheather he is following or not
        let isFollowing: Bool = (isFallowingValue)!
        
        if friendShipStatus == "2"{
            
            //Hide followers btn bcz same profile
            followButton.isHidden = true
            
        }
        else{
            
            followButton.isHidden = false
            
            if isFollowing{
                
                //Set green colour to button
                followButton.setTitleColor(UIColor.green, for: UIControlState.normal)
            }
            else{
                
                //set black colour
                followButton.setTitleColor(UIColor.black, for: UIControlState.normal)
            }
            
        }
        
    }
    
    //MARK:- Api methods
    func fallowFriendApi() -> Void {
        
        //Calling protocol method
        friendsProfileProtcolDelegate?.getfallowFriendApiResponse(callBackBlock: { [weak self] (apiRecievedResponse:[Array<AnyObject>?], userDetailModelObj:userDetailModel?) in
            
            if apiRecievedResponse[0]?.count != 0{
                
                if userDetailModelObj != nil{
                 
                    //View profile Model object
                    self?.userDetailModel = userDetailModelObj
                    
                    //Set is following to true
                    self?.userDetailModel?.isFollowing = true
                    
                    //Set green colour to fallow btn
                    self?.followButton.setTitleColor(UIColor.green, for: UIControlState.normal)
                    
                }
                
            }
            
        })
        
    }

    func unFallowFriendApi() -> Void {
        
        //Calling protocol method
        friendsProfileProtcolDelegate?.getUnFallowFriendApiResponse(callBackBlock: { [weak self] (apiRecievedResponse:[Array<AnyObject>?], userDetailModelObj:userDetailModel?) in
            
            if apiRecievedResponse[0]?.count != 0{
                
                if userDetailModelObj != nil{
                    
                    //View profile Model object
                    self?.userDetailModel = userDetailModelObj
                    
                    //Set is following to true
                    self?.userDetailModel?.isFollowing = false
                    
                    //Set Black colour to btn
                    self?.followButton.setTitleColor(UIColor.black, for: UIControlState.normal)

                    
                }
                
            }
            
        })
        
    }
    
    func sendFriendRequestApi() -> Void{
        
        //Calling protocol method
        friendsProfileProtcolDelegate?.sendFriendApiResponse(callBackBlock: { [weak self] (apiRecievedResponse:String?, userDetailModelObj:userDetailModel?) in
            
            if (apiRecievedResponse != nil) {
                
                if userDetailModelObj != nil{
                    
                    //View profile Model object
                    self?.userDetailModel = userDetailModelObj
                    
                    //Disable user interaction
                    self?.addFriendButton.isUserInteractionEnabled = false
                    
                    //Change btn colour
                    self?.addFriendButton.setTitleColor(UIColor.orange, for: UIControlState.normal)
                   
                }
                
            }
            
        })

    }

    
    //MARK:- IBActions
    @IBAction func followAndUnFollowAction(_ sender: UIButton) {
        
        if self.userDetailModel != nil{
            
            //View profile Model object
            let modelObj = self.userDetailModel
            
            if modelObj != nil {
                
                if (modelObj?.isFollowing)! {
                    
                    //Calling UN fallow friends api
                    self.unFallowFriendApi()
                }
                else{
                    
                    //Calling fallow friends api
                    self.fallowFriendApi()
                    
                }
                
            }
            
        }
        
    }
    
    @IBAction func addFriendAction(_ sender: UIButton) {
        
        //View profile Model object
        if self.userDetailModel != nil {
            
            let modelObj = self.userDetailModel
            
            if modelObj != nil{
                
                //Call send friend request api
                self.sendFriendRequestApi()
                
            }
            
        }
        
    }
    
}
