//
//  ActivityTableViewCell.swift
//  Fiturb
//
//  Created by Admin on 06/04/17.
//  Copyright © 2017 Fiturb.DATAPPS. All rights reserved.
//

import UIKit

protocol ActivityTableViewCellProtocol:class {
    
    func likeActivityApiMethod(indexpathNumber:Int?,callBackBlock completionHandler:@escaping(_ message:String?,_ feedActivityModelObject:FeedActivityModel?) -> ())
    
    func unLikeActivityApiMethod(indexpathNumber:Int?,callBackBlock completionHandler:@escaping(_ message:String?,_ feedActivityModelObject:FeedActivityModel?) -> ())
    
 }

class ActivityTableViewCell : UITableViewCell
{
    //Protocol Object
    var activityTableViewCellDelegate:ActivityTableViewCellProtocol? = nil
    
    //1st part
    @IBOutlet weak var organiserName: UILabel!
    
    @IBOutlet weak var locationNameLabel: UILabel!
    
    @IBOutlet weak var cityNameLabel: UILabel!
    
    @IBOutlet weak var activityNameLabel: UILabel!
    
    @IBOutlet weak var activityDetailsLabel: UILabel!

    //2nd part
    @IBOutlet weak var likesCountLabel: UILabel!
    
    @IBOutlet weak var shresCountLabel: UILabel!
    
    @IBOutlet weak var commentsCountLabel: UILabel!
    
    //third part
     @IBOutlet weak var buttonToSelectUserActivityDetailInfo: UIButton!
    
    @IBOutlet weak var viewUserProfileButton: UIButton!
    
    @IBOutlet weak var timeTextLabel: UILabel!
    
    @IBOutlet weak var dateTextLabel: UILabel!
    
    @IBOutlet weak var monthYearLabel: UILabel!
    
    @IBOutlet weak var secondPartSubViewForColourSet: UIView!
    
    @IBOutlet weak var subView: UIView!
    
    @IBOutlet weak var likeCountImageView: UIImageView!
    
    @IBOutlet weak var shareCountImageview: UIImageView!
    
    @IBOutlet weak var commentCountImageView: UIImageView!
    
    @IBOutlet weak var friendsCountLbl: UILabel!
    
    @IBOutlet weak var plusButtonPressed: UIButton!
    
    @IBOutlet weak var fristFriendImageView: UIImageView!
    
    @IBOutlet weak var secondFriendImageView: UIImageView!
    
    @IBOutlet weak var userprofilePicImageView: UIImageView!
    
    @IBOutlet weak var likeOrUnlikeBtn: UIButton!
    
    @IBOutlet weak var shareBtn: UIButton!
    
    @IBOutlet weak var commentBtn: UIButton!
    
    //MARK:- Custom cell methods
    func activityTableviewCustomCellData(cellIndxpathNumber: Int?, organiserName: String?, activityName: String?, actitivityDescription:String?, dateAndTime:Dictionary<String, String>?,cityName: String?, likesCount:String?, sharesCount: String?, commentsCount: String?,distance: Int?,userProfileImageUrl:String?, isLikedValue: Bool?, hexColourStringValue:String?) -> Void {
        
        //cell UI customization
        self.materialDesignPart()
        
        //Organiser name
        self.organiserName.text = organiserName
        
        //Location adress(Keshav Later change lat and long to adress)
        self.locationNameLabel.text = String(format:"%d km from your locaion",distance!)
        
        //City name
        self.cityNameLabel.text = cityName
        
        //Activity name
        self.activityNameLabel.text = activityName
        
        //Activity details
        self.activityDetailsLabel.text = actitivityDescription
        
        //Likes count
        self.likesCountLabel.text = likesCount
        
        //isLiked or not and set likeOrUbblike btn tag
        self.likeOrUnlikeBtn.setTitle(((isLikedValue)! ? "Unlike" : "Like"), for: .normal)
        //Compulsory below button tag should set as table view cells row number
        self.likeOrUnlikeBtn.tag = cellIndxpathNumber!
        
        //Shares count
        self.shresCountLabel.text = sharesCount
        
        //Comments count
        self.commentsCountLabel.text = commentsCount
        
        //Date 
        self.dateTextLabel.text = dateAndTime?["date"]
        
        //Month year 
        self.monthYearLabel.text = "\(dateAndTime?["monthName"] ?? "0") \n\(dateAndTime?["year"] ?? "0")"
        
        //Time
        self.timeTextLabel.text = dateAndTime?["time"]
    
        //Second part sub view back ground colour
        self.secondPartSubViewForColourSet.backgroundColor = UIColor.init(hexString: hexColourStringValue!, withAplhaValue: 1.0)
        
//        //User profile picture
//        if self.userprofilePicImageView.image == nil {
//            
//            //Initially show loading image
//            self.userprofilePicImageView.image = UIImage(named:"LoadingImagePleaseWait")
//            UIImage.loadImageFromURL(imageUrlString: userProfileImageUrl,callback:{ [weak self] (image: UIImage?) -> () in
//                
//                //Check Uiimage contains image or not
//                let imageRef:CGImage? = image?.cgImage
//                
//                //Profile image
//                self?.userprofilePicImageView.image = (imageRef != nil) ? image : UIImage(named:"Default_Image")
//                
//            })
//        }

    }
    
    func materialDesignPart() -> Void {
        
        //friend Countlbl circle
        self.friendsCountLbl.layer.cornerRadius = 15
        self.friendsCountLbl.layer.borderWidth = 1
        self.friendsCountLbl.layer.borderColor = UIColor.white.cgColor
        
        //firends Imagview circles
        self.fristFriendImageView.layer.cornerRadius = 15
        self.fristFriendImageView.layer.borderWidth = 1
        self.fristFriendImageView.layer.borderColor = UIColor.white.cgColor
        
        self.secondFriendImageView.layer.cornerRadius = 15
        self.secondFriendImageView.layer.borderWidth = 1
        self.secondFriendImageView.layer.borderColor = UIColor.white.cgColor
        
        self.userprofilePicImageView.layer.cornerRadius = (self.userprofilePicImageView.frame.size.width/2)
        
        self.viewUserProfileButton.layer.cornerRadius = (self.viewUserProfileButton.frame.size.width/2)

        
        //Subview border
        self.subView.layer.borderWidth = 1
        
        self.subView.layer.borderColor = UIColor.lightGray.cgColor
        
        //FontAwesome ImageIcons
        self.likeCountImageView.image = UIImage.fontAwesomeIcon(name: .heart, textColor: UIColor.black, size: CGSize(width: 100, height: 100))
        
        self.shareCountImageview.image = UIImage.fontAwesomeIcon(name: .shareAlt, textColor: UIColor.black, size: CGSize(width: 100, height: 100))
        
        self.commentCountImageView.image = UIImage.fontAwesomeIcon(name: .commenting, textColor: UIColor.black, size: CGSize(width: 100, height: 100))
        
        self.plusButtonPressed.titleLabel?.font = UIFont.fontAwesome(ofSize: 20)
        
        self.plusButtonPressed.setTitle(String.fontAwesomeIcon(name: .plus), for: .normal)
        
    }
    
    //MARK:- Actions
    @IBAction func likeBtnAction(_ sender: UIButton) {
        
        let likeOrUnlikeBtnTitle = sender.title(for: .normal)
        
        if likeOrUnlikeBtnTitle == "Unlike"{
            
            //Call protocol method(like)
            activityTableViewCellDelegate?.unLikeActivityApiMethod(indexpathNumber: sender.tag, callBackBlock: { [weak self] (message:String?, feedActivityModelObject:FeedActivityModel?) in
                
                if (message != nil){
                    
                    if feedActivityModelObject != nil{
                        
                        let modelObj = feedActivityModelObject
                        
                        var likesTotalCount:Int? = Int((modelObj?.likeCount)!)
                        
                        likesTotalCount = ((likesTotalCount! >= 1) ? (likesTotalCount! - 1) : 0)
                        
                        //update like counts in model object
                        modelObj?.likeCount = String(format: "%d", likesTotalCount!)
                        
                        //Set count
                        self?.likesCountLabel.text = modelObj?.likeCount
                        
                        //Make Unlike to like
                        modelObj?.isLiked = false
                        sender.setTitle("Like", for: .normal)
                        
                    }
                }
                
            })

        }
        else if(likeOrUnlikeBtnTitle == "Like"){
            
            //Call protocol method(Unlike)
            activityTableViewCellDelegate?.likeActivityApiMethod(indexpathNumber: sender.tag, callBackBlock: { [weak self] (message:String?, feedActivityModelObject:FeedActivityModel?) in
                
                if (message != nil){
                    
                    if feedActivityModelObject != nil{
                        
                        let modelObj = feedActivityModelObject
                        
                        var likesTotalCount:Int? = Int((modelObj?.likeCount)!)
                        
                        likesTotalCount = ((likesTotalCount! >= 0) ?  (likesTotalCount! + 1) : 0)
                        
                        //update like counts in model object
                        modelObj?.likeCount = String(format: "%d", likesTotalCount!)

                        //set count
                        self?.likesCountLabel.text = modelObj?.likeCount
                        
                        //Make like to Unlike
                        modelObj?.isLiked = true
                        sender.setTitle("Unlike", for: .normal)
                        
                    }
                }
                
            })
        }
    }
    
    
    @IBAction func shareBtnAction(_ sender: UIButton) {
        
    }
    
    @IBAction func commentBtnAction(_ sender: UIButton) {
        
    }
}

