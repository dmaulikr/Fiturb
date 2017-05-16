//
//  ByActivityTableViewCell.swift
//  Fiturb
//
//  Created by DATAPPS on 4/3/17.
//  Copyright © 2017 Fiturb.DATAPPS. All rights reserved.
//

import UIKit

class ByActivityTableViewCell: UITableViewCell {
    
    @IBOutlet weak var gamesDropDownImage: UIImageView!

    @IBOutlet weak var hangoutsView: UIView!
    
    @IBOutlet weak var sportsView: UIView!
    @IBOutlet weak var entertainmentDropDownImage: UIImageView!
    @IBOutlet weak var travelImageView: UIImageView!
    @IBOutlet weak var hangoutImageView: UIImageView!
    @IBOutlet weak var entertainmentImageView: UIImageView!
    @IBOutlet weak var sportsImageView: UIImageView!
    @IBOutlet weak var travelDropDownImage: UIImageView!
    @IBOutlet weak var hangOutsDropDownImage: UIImageView!
    @IBOutlet weak var sportsDropDownImageView: UIImageView!
    @IBOutlet weak var travelTextFiled: UITextField!
    @IBOutlet weak var hangoutTextField: UITextField!
    @IBOutlet weak var entertainmentTextFiled: UITextField!
    @IBOutlet weak var sportsTextFileld: UITextField!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
