//
//  ActivityJoinedUsersTableViewCell.swift
//  Fiturb
//
//  Created by DATAPPS on 4/26/17.
//  Copyright © 2017 Fiturb.DATAPPS. All rights reserved.
//

import UIKit

class ActivityJoinedUsersTableViewCell: UITableViewCell {

    @IBOutlet weak var commentImageView: UIImageView!
    
    @IBOutlet weak var shareImageView: UIImageView!
    
    @IBOutlet weak var likeImageView: UIImageView!
    
    @IBOutlet weak var waitingListCountLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func materialDesignpartForActivityJoinedUsers()
    {
        
        //FontAwesome ImageIcons
        self.likeImageView.image = UIImage.fontAwesomeIcon(name: .heart, textColor: UIColor.black, size: CGSize(width: 100, height: 100))
        
        self.shareImageView.image = UIImage.fontAwesomeIcon(name: .shareAlt, textColor: UIColor.black, size: CGSize(width: 100, height: 100))
        
        self.commentImageView.image = UIImage.fontAwesomeIcon(name: .commenting, textColor: UIColor.black, size: CGSize(width: 100, height: 100))

    }
    
      
}
