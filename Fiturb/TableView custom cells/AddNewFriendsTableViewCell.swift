//
//  AddNewFriendsTableViewCell.swift
//  Fiturb
//
//  Created by DATAPPS on 3/30/17.
//  Copyright © 2017 Fiturb.DATAPPS. All rights reserved.
//

import UIKit

class AddNewFriendsTableViewCell: UITableViewCell {

    @IBOutlet weak var friendsCheckBox: UIButton!
    
    @IBOutlet weak var friendsNames: UILabel!
    
    @IBOutlet weak var friendsImageView: UIImageView!
    
    //MARK:- Custom cell methods
    func fillCustomCellData(name:String?, withButtonIndex:Int) -> Void {
        
        //UnHide check box btn and image view
        friendsCheckBox.isHidden = false
        friendsImageView.isHidden = false
        
        //User name
        self.friendsNames.text = name
        
        //btn index
        self.friendsCheckBox.tag = withButtonIndex
    }
    
    func fillCustomCellDataWhenNoData() -> Void {
        
        //hide check box btn and image view
        friendsCheckBox.isHidden = true
        friendsImageView.isHidden = true
        
        self.friendsNames.text = "No Friends available to add!"

    }
}
