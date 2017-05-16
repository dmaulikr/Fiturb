//
//  AdvanceSearchTableViewCell.swift
//  Fiturb
//
//  Created by DATAPPS on 4/6/17.
//  Copyright © 2017 Fiturb.DATAPPS. All rights reserved.
//

import UIKit

class AdvanceSearchTableViewCell: UITableViewCell {

    @IBOutlet weak var advanceSearchFilterButtonPressed: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    //add fontawesome image
    
    func addfilterImage()
    {
        advanceSearchFilterButtonPressed.titleLabel?.font = UIFont.fontAwesome(ofSize: 20)
        advanceSearchFilterButtonPressed.setTitle(String.fontAwesomeIcon(name: .sliders), for: .normal)
        advanceSearchFilterButtonPressed.setTitleColor(UIColor.black, for: UIControlState.normal)
         advanceSearchFilterButtonPressed.layer.cornerRadius = advanceSearchFilterButtonPressed.frame.size.width/2
        advanceSearchFilterButtonPressed.clipsToBounds = true
    }

}
