//
//  FriendsDetailsCommentsTableViewCell.swift
//  Fiturb
//
//  Created by DATAPPS on 4/12/17.
//  Copyright © 2017 Fiturb.DATAPPS. All rights reserved.
//

import UIKit

class FriendsDetailsCommentsTableViewCell: UITableViewCell {

    @IBOutlet weak var subviewOfComments: UIView!
    
    @IBOutlet weak var commentsProfilePicImageView: UIImageView!
    
    @IBOutlet weak var userName: UILabel!
    
    @IBOutlet weak var userRoleLabel: UILabel!
    
    @IBOutlet weak var createdDateAndTimeLabel: UILabel!
    
    @IBOutlet weak var userCommentsTextView: UITextView!
    
    @IBOutlet weak var averageRatingCountLabel: UILabel!
    
    override func awakeFromNib() {
        
        super.awakeFromNib()
        // Initialization code
    }

  //MARK:- Custom cell methods
    func customCellData(thumbUrl:String?, userName: String?, commentsCreatedTime: Dictionary<String, String>?, role: String?, commentsText: String?, averageRating: String?) -> Void {
        
        //user name
        self.userName.text = userName
        
        //Role
        self.userRoleLabel.text = role
        
        //created date and time
        self.createdDateAndTimeLabel.text =  String(format: "%@ %@ %@  %@", (commentsCreatedTime?["monthName"]) ?? "0",(commentsCreatedTime?["date"]) ?? "0",(commentsCreatedTime?["year"]) ?? "0",(commentsCreatedTime?["time"]) ?? "00:00:00")
        
        //Comments text
        self.userCommentsTextView.text = commentsText
        
        //average rating count number display
        self.averageRatingCountLabel.text = averageRating
        
        //User profile image
        //Initially show loading image
        self.commentsProfilePicImageView.image = UIImage(named:"LoadingImagePleaseWait")
        
        UIImage.loadImageFromURL(imageUrlString: thumbUrl,callback:{ [weak self] (image: UIImage?) -> () in
            
            //Check Uiimage contains image or not
            let imageRef:CGImage? = image?.cgImage
            
            //Profile image
            self?.commentsProfilePicImageView.image = (imageRef != nil) ? image : UIImage(named:"Default_Image")
            
        })

    }
    
    func materialDesignOfFriendsCommentCell()
    {
        
        //Imagecorner
        commentsProfilePicImageView.layer.cornerRadius = commentsProfilePicImageView.frame.size.height/2
        commentsProfilePicImageView.clipsToBounds = true
        
        
        //Border Shadow
        subviewOfComments.layer.cornerRadius = 0
        
        subviewOfComments.layer.shadowColor = UIColor (red: 0/255.0, green: 0/255.0, blue: 0/255.0, alpha: 1.0).cgColor
        
        subviewOfComments.layer.shadowOffset = CGSize(width: 0, height: 1.75)
        
        subviewOfComments.layer.shadowRadius = 1.7
        
        subviewOfComments.layer.shadowOpacity = 0.45
    }


}
