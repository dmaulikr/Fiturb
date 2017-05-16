//
//  FriendsDetailsInterestListTableViewCell.swift
//  Fiturb
//
//  Created by DATAPPS on 4/13/17.
//  Copyright © 2017 Fiturb.DATAPPS. All rights reserved.
//

import UIKit

class FriendsDetailsInterestListTableViewCell: UITableViewCell {

    
    @IBOutlet weak var userInterestNameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()

        // Initialization code
    }

    //MAKR:- Custom cell Methods
    func fillCustomCellData(userInterestNameText:String?) -> Void {
        
        //User interest name
        self.userInterestNameLabel.text = userInterestNameText
    }
    
}
