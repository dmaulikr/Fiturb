//
//  AccountListTableViewCell.swift
//  Fiturb
//
//  Created by Admin on 20/04/17.
//  Copyright © 2017 Fiturb.DATAPPS. All rights reserved.
//

import UIKit

class AccountListTableViewCell: UITableViewCell {

    @IBOutlet weak var accountListLabel: UILabel!
    
    @IBOutlet weak var accountListImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
