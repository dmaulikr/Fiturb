//
//  FollowersListTableViewCell.swift
//  Fiturb
//
//  Created by Admin on 17/04/17.
//  Copyright © 2017 Fiturb.DATAPPS. All rights reserved.
//

import UIKit

class FollowersListTableViewCell: UITableViewCell {

    @IBOutlet weak var followerImage: UIImageView!
    
    @IBOutlet weak var followerNameLabel: UILabel!
    
    @IBOutlet weak var noDataAvailableLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    //MARK:- Custom cell methods

    func fillCustomCellData(imageUrl:String?,followerNameText: String?) -> Void {
        
        //Follower name
        self.followerNameLabel.text = followerNameText
        
        //follower pic
        if self.followerImage.image == nil {
            
            //Initially show loading image
            self.followerImage.image = UIImage(named:"LoadingImagePleaseWait")
            UIImage.loadImageFromURL(imageUrlString: imageUrl,callback:{ [weak self] (image: UIImage?) -> () in
                
                //Check Uiimage contains image or not
                let imageRef:CGImage? = image?.cgImage
                
                //Profile image
                self?.followerImage.image = (imageRef != nil) ? image : UIImage(named:"Default_Image")
                
            })
        }
        
    }
    
    func noDataAvailable(noDataText:String?) -> Void {
        
        //No data available
        self.noDataAvailableLabel.text = noDataText
    }
}
