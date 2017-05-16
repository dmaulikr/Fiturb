//
//  GroupMembersTableViewCell.swift
//  Fiturb
//
//  Created by DATAPPS on 3/30/17.
//  Copyright © 2017 Fiturb.DATAPPS. All rights reserved.
//

import UIKit

protocol groupMembersProtocol:class {
    
    func removeGroupMebersApi(buttonAdress:UIButton) -> Void
    
}

class GroupMembersTableViewCell: UITableViewCell {
    
    //protocol object
    var groupMebersprotocolDelegate:groupMembersProtocol? = nil
    
    @IBOutlet weak var groupMembersNameLbl: UILabel!
    
    @IBOutlet weak var groupMembersImageView: UIImageView!
   
    @IBOutlet weak var deleteGroupMemberBtn: UIButton!
    
    //MARK: Custom cell methods
    func fillGroupDetailCustomCellData(name:String?, imageUrl:String?, withCellsIndexPaths:Int) -> Void {
        
        //Unhide btn and imageview
        deleteGroupMemberBtn.isHidden = false
        groupMembersImageView.isHidden = false
        
        //Delete btn image
        deleteGroupMemberBtn.setFAIcon(icon: .FABan, iconSize: 20, forState: .normal)
        deleteGroupMemberBtn.setTitleColor(UIColor.red, for: .normal)
        
        //Btn tags
        deleteGroupMemberBtn.tag = withCellsIndexPaths
        
        //Group members name
        self.groupMembersNameLbl.text = name!
        
        //group meber image
        
    }
    
    func noMembersInGroup(text:String?) -> Void {
        
        self.groupMembersNameLbl.text = text!
        
        //hide delete btn and image view
        deleteGroupMemberBtn.isHidden = true
        groupMembersImageView.isHidden = true
        
    }
    
    //MARK:- Action
    
    @IBAction func deleteGroupMemberAction(_ sender: UIButton) {
        
        //Call protcol method
        groupMebersprotocolDelegate?.removeGroupMebersApi(buttonAdress: sender)
        
    }
    
}
