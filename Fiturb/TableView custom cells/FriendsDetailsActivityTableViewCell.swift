//
//  FriendsDetailsActivityTableViewCell.swift
//  Fiturb
//
//  Created by DATAPPS on 4/12/17.
//  Copyright © 2017 Fiturb.DATAPPS. All rights reserved.
//

import UIKit

class FriendsDetailsActivityTableViewCell: UITableViewCell {

    @IBOutlet weak var subviewOfActivity: UIView!
    @IBOutlet weak var activityProfilePicImageView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    //Material DesignPart
    func materialDesignOfFriendsActivityCell()
    {
        
        //Imagecorner 
        activityProfilePicImageView.layer.cornerRadius = activityProfilePicImageView.frame.size.height/2
        activityProfilePicImageView.clipsToBounds = true
        
        
        //Border Shadow
        subviewOfActivity.layer.cornerRadius = 0
        
        subviewOfActivity.layer.shadowColor = UIColor (red: 0/255.0, green: 0/255.0, blue: 0/255.0, alpha: 1.0).cgColor
        
        subviewOfActivity.layer.shadowOffset = CGSize(width: 0, height: 1.75)
        
        subviewOfActivity.layer.shadowRadius = 1.7
        
        subviewOfActivity.layer.shadowOpacity = 0.45
    }

}
