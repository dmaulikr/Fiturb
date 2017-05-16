//
//  AccountDetails TableViewCell.swift
//  Fiturb
//
//  Created by Admin on 20/04/17.
//  Copyright © 2017 Fiturb.DATAPPS. All rights reserved.
//

import UIKit

class AccountDetailsTableViewCell:UITableViewCell
{
    
    @IBOutlet weak var userNameLabel: UILabel!
    
    @IBOutlet weak var friendsAndFollowersCountLabel: UILabel!
    
    @IBOutlet weak var cityNameLabel: UILabel!
    
    @IBOutlet weak var accountCreatedTimeLabel: UILabel!
    
    @IBOutlet weak var locationImageView: UIImageView!
    
    @IBOutlet weak var dateAndTimeImageView: UIImageView!
    
    @IBOutlet weak var profilePicImageView: UIImageView!
    
    //MARK:- Custom cell methods
    func fillCustomCellData(userFirstNameText: String?, friendsCountText: String?, followersCountText: String?, cityNameText: String?, createdTimeText: Dictionary<String, String>?, profilePicImageUrl: String?) -> Void {
        
        //User name
        self.userNameLabel.text = userFirstNameText
        
        //Friends and followers count
        self.friendsAndFollowersCountLabel.text = String(format: "%@ Friends - %@ Followers", friendsCountText!,followersCountText!)
        
        //cityname 
        self.cityNameLabel.text = cityNameText
        
        //Created time
        self.accountCreatedTimeLabel.text = String(format: "Fiturb since %@ %@ %@", (createdTimeText?["monthName"]) ?? "0",(createdTimeText?["date"]) ?? "0",(createdTimeText?["year"]) ?? "0")
        
        //user profile picture
       if self.profilePicImageView.image == nil{
        
            //Initially show loading image
            self.profilePicImageView.image = UIImage(named:"LoadingImagePleaseWait")
            UIImage.loadImageFromURL(imageUrlString: profilePicImageUrl,callback:{ [weak self] (image: UIImage?) -> () in
            
                //Check Uiimage contains image or not
                let imageRef:CGImage? = image?.cgImage
            
                //Profile image
                self?.profilePicImageView.image = (imageRef != nil) ? image : UIImage(named:"AppLogoImage")
            
            })
        }
        
    }
    
    func accountDetailCustomCellUIAdjustments() -> Void {
        
        //image corner radius
        self.profilePicImageView.layer.cornerRadius = self.profilePicImageView.frame.width/2
        self.profilePicImageView.layer.borderWidth = 1
        self.profilePicImageView.layer.borderColor = UIColor.white.cgColor
        self.profilePicImageView.clipsToBounds = true
        
        //Set images
        self.locationImageView.image = UIImage.fontAwesomeIcon(name: .mapMarker, textColor: UIColor.black, size: CGSize(width: 100, height: 100))
        self.dateAndTimeImageView.image = UIImage.fontAwesomeIcon(name: .clockO, textColor: UIColor.black, size: CGSize(width: 100, height: 100))
        
    }
    
}
