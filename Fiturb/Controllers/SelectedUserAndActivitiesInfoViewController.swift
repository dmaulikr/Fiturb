//
//  SelectedUserAndActivitiesInfoViewController.swift
//  Fiturb
//
//  Created by Admin on 18/04/17.
//  Copyright © 2017 Fiturb.DATAPPS. All rights reserved.
//

import UIKit
import Cosmos

protocol SelectedUserAndActivitiesInfoViewControllerProtcol:class {
    
    func navigateToFriendDetailViewControllerProtocolMethod() -> Void
    
}

class SelectedUserAndActivitiesInfoViewController: UIViewController {

    //Protocol object
    var selectedUserAndActivitiesDelegate:SelectedUserAndActivitiesInfoViewControllerProtcol? = nil
    
    //MARK:- IBOutlets
    @IBOutlet weak var locationImageView: UIImageView!
    
    @IBOutlet weak var profilePicImageView: UIImageView!
    
    @IBOutlet weak var starRatingView: CosmosView!
    
    @IBOutlet weak var followButton: UIButton!
    
    @IBOutlet weak var addFriendButton: UIButton!
    
    @IBOutlet weak var userNameLabel: UILabel!
    
    @IBOutlet weak var userCityLabel: UILabel!
    
    //For fallow friends url
    var fallowFriendsApiRecievedResponse = [Any?]()
    
    //For unFallow friends url
    var unFallowFriendsApiRecievedResponse = [Any?]()
    
    //For view profile response 
    var viewProfileApiResponseRecivedArray = [Any?]()
    
    //MARK:- LifeCycle Methods
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        //Fontawesome Images
        self.materialDesignPart()
        
        //Initially hide Follow and add friend buttons when loading
        self.hideFollowAndAddFriendButtons()
        
        self.popupRemoveMethod()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        if viewProfileApiResponseRecivedArray.count != 0{
            
            //Display api response values
            self.displayApiValuesOnScreen()
        }
       
    }
    
    //MARK:- APi Methods
    func fallowFriendsApi(userID: String?) -> Void {
        
        //Add Loader
        MBProgressHUD.showAdded(to: self.view, withScreenHeaderHeigth: 0.0, animated: true)
        
        //Fallow friends url
        let urlString = String(format:"%@%@", MyAppConstants.baseUrlString,MyAppConstants.followFriendUrl)
        
        //let postData
        let postdata = ["user_id":userID] as! Dictionary<String,String>
        
        print("Post data is:\(postdata)")
        
        ApiDataManager.singleTonObjectForApiManagerClass.fallowApiValuesWithUrlString(urlString: urlString, withPostData: postdata,callBackBlock: { (apiRecievedResponse:Array?, error:NSError?) in
            
            //Remove Loader
            MBProgressHUD.hide(for: self.view, animated: true)
            
            guard error == nil else{
                
                //Error handling
                print("Error recieved from Fallow friends request api is:\(error!.localizedFailureReason!)")
                
                //Dsiplay alert
                let alertController = singleTon.sharedInstance.displayAlert(message: (error!.localizedFailureReason!), title: "Fiturb")
                self.present(alertController, animated: true, completion: nil)
                
                return
            }
            
            self.fallowFriendsApiRecievedResponse = apiRecievedResponse!
            
            if self.fallowFriendsApiRecievedResponse.count != 0{
                
                let tempObj = self.fallowFriendsApiRecievedResponse[0] as! FollowFriendsModel
                
                print("Fallow friends model object values are:\(tempObj.message!)")
                
                //View profile Model object
                let modelObj = self.viewProfileApiResponseRecivedArray[0] as? userDetailModel
                modelObj?.isFollowing = true
                        
                //Set green colour to fallow btn
                self.followButton.setTitleColor(UIColor.green, for: UIControlState.normal)

            }
            
        })
        
    }

    func unFallowFriendsApi(userID: String?) -> Void {
        
        //Add Loader
        MBProgressHUD.showAdded(to: self.view, withScreenHeaderHeigth: 0.0, animated: true)
        
        //unFallow friends url
        let urlString = String(format:"%@%@", MyAppConstants.baseUrlString,MyAppConstants.unfollowFriendUrl)
        
        //let postData
        let postdata = ["user_id":userID] as! Dictionary<String,String>
        
        print("Post data is:\(postdata)")
        
        ApiDataManager.singleTonObjectForApiManagerClass.unFallowApiValuesWithUrlString(urlString: urlString, withPostData: postdata,callBackBlock: { (apiRecievedResponse:Array?, error:NSError?) in
            
            //Remove Loader
            MBProgressHUD.hide(for: self.view, animated: true)
            
            guard error == nil else{
                
                //Error handling
                print("Error recieved from UNFallow friends request api is:\(error!.localizedFailureReason!)")
                
                //Dsiplay alert
                let alertController = singleTon.sharedInstance.displayAlert(message: (error!.localizedFailureReason!), title: "Fiturb")
                self.present(alertController, animated: true, completion: nil)
                
                return
            }
            
            self.unFallowFriendsApiRecievedResponse = apiRecievedResponse!
            
            if self.unFallowFriendsApiRecievedResponse.count != 0{
                
                let tempObj = self.unFallowFriendsApiRecievedResponse[0] as! UnFallowFriendsModel
                
                print("UnFallow friends model object values are:\(tempObj.message!)")
             
                //View profile Model object
                let modelObj = self.viewProfileApiResponseRecivedArray[0] as? userDetailModel
                modelObj?.isFollowing = false
                
                //Set Black colour to btn
                self.followButton.setTitleColor(UIColor.black, for: UIControlState.normal)

            }
            
        })
        
    }

    func sendFriedRequest(userID: String?) -> Void {
        
        //Add Loader
        MBProgressHUD.showAdded(to: self.view, withScreenHeaderHeigth: 0.0, animated: true)
        
        //send Friend Request url
        let urlString = String(format:"%@%@", MyAppConstants.baseUrlString,"Friend/friends/send_request")
        
        //let postData
        let postdata = ["user_id":userID] as! Dictionary<String,String>
        
        print("Post data is:\(postdata)")
        
        ApiDataManager.singleTonObjectForApiManagerClass.sendFriendRequestApiValuesWithUrlString(urlString: urlString, withPostData: postdata,callBackBlock: { (apirecievedResponse: String?, error:NSError?) in
            
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
            
            //Orange color
            self.addFriendButton.setTitleColor(UIColor.orange, for: UIControlState.normal)
            //Disable user interaction
            self.addFriendButton.isUserInteractionEnabled = false
            
        })

    }
    
    //MARK:- Pravite Methods
    func materialDesignPart() -> Void
    {
        followButton.titleLabel?.font = UIFont.fontAwesome(ofSize: 20)
        
        followButton.setTitle(String.fontAwesomeIcon(name: .rssSquare), for: .normal)
        
        //followButton.setTitleColor(UIColor.black, for: UIControlState.normal)
        
        addFriendButton.titleLabel?.font = UIFont.fontAwesome(ofSize: 20)
        
        addFriendButton.setTitle(String.fontAwesomeIcon(name: .userPlus), for: .normal)
        
        //Add friend btn border colour with radius
        addFriendButton.layer.cornerRadius = 6.0
        addFriendButton.layer.borderColor = UIColor.black.cgColor
        
        //addFriendButton.setTitleColor(UIColor.black, for: UIControlState.normal)
        
        self.locationImageView.image = UIImage.fontAwesomeIcon(name:.mapMarker, textColor: UIColor.black, size: CGSize(width: 200, height: 200))
        
        self.profilePicImageView.layer.cornerRadius = self.profilePicImageView.frame.height/2
        
        self.profilePicImageView.clipsToBounds = true
        
    }
    
    func popupRemoveMethod() -> Void
    {
        let popupGesture = UITapGestureRecognizer(target: self, action: #selector(self.tagGestureRemovePOPUP))
        
        //gr.delegate = self
        self.view.addGestureRecognizer(popupGesture)
        
    }
    
    func tagGestureRemovePOPUP(_ gestureRecognizer: UIGestureRecognizer) {
        
        //Removing Pop up servies table view and background view
        self.view.removeFromSuperview()
        
    }
    
    func displayApiValuesOnScreen() -> Void {
        
        //View profile Model object
        let viewProfileModelObj = self.viewProfileApiResponseRecivedArray[0] as? userDetailModel
        
        //first name text
        self.userNameLabel.text = viewProfileModelObj?.firstName
        
        //city name
        self.userCityLabel.text = viewProfileModelObj?.cityName
        
        //check FriendShip status
        let friendShipStatus:String? = viewProfileModelObj?.friendShipStatus
        
        if (viewProfileModelObj?.friendShipStatus != nil) {
            
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
        
        //Check wheather he is following or not
        let isFollowing: Bool = (viewProfileModelObj?.isFollowing)!
        
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
        
        
        //Average rating count
        self.starRatingView.rating = Double((viewProfileModelObj?.averageRatingTotalCount)!) ?? 0.0
        
        //User profile image
        if self.locationImageView.image == nil {
            
            //image url
            let userImageUrl: String? = viewProfileModelObj?.thumbUrl
            
            //Initially show loading image
            self.locationImageView.image = UIImage(named:"LoadingImagePleaseWait")
            UIImage.loadImageFromURL(imageUrlString:userImageUrl ,callback:{ [weak self] (image: UIImage?) -> () in
                
                //Check Uiimage contains image or not
                let imageRef:CGImage? = image?.cgImage
                
                //Profile image
                self?.locationImageView.image = (imageRef != nil) ? image : UIImage(named:"Default_Image")
                
            })
        }
        
    }
    

    func hideFollowAndAddFriendButtons() -> Void {
        
        self.followButton.isHidden = true
        
        self.addFriendButton.isHidden = true
        
    }
    
    //MARK:- IBActions
    @IBAction func followAndUnFollowAction(_ sender: UIButton) {
        
        //View profile Model object
        let modelObj = self.viewProfileApiResponseRecivedArray[0] as? userDetailModel
        
        if modelObj != nil {
            
                if (modelObj?.isFollowing)! {
                
                    //Calling UN fallow friends api
                    self.unFallowFriendsApi(userID: modelObj?.userID)
            }
            else{
                    
                    //Calling fallow friends api
                    self.fallowFriendsApi(userID: modelObj?.userID)
                    
            }
            
        }
        
    }
    
    @IBAction func addFriendAction(_ sender: UIButton) {
        
        //View profile Model object
        let modelObj = self.viewProfileApiResponseRecivedArray[0] as? userDetailModel
        
        if modelObj != nil{
            
            //Call send friend request api
            self.sendFriedRequest(userID: modelObj?.userID)
            
        }
    }
    
    @IBAction func viewProfileAction(_ sender: UIButton) {
        
        //remove pop up
        self.view.removeFromSuperview()
        
        //Calling protocol method(navigate to Friends detail screen)
        selectedUserAndActivitiesDelegate?.navigateToFriendDetailViewControllerProtocolMethod()
        
    }
    
}
