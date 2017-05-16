//
//  groupsTableViewCell.swift
//  Fiturb
//
//  Created by DATAPPS on 3/28/17.
//  Copyright © 2017 Fiturb.DATAPPS. All rights reserved.
//

import UIKit

//Protocol
protocol groupListProtocol:class {
    
    func groupDeleteRequestApi(buttonAdress:UIButton) -> Void
 
    func navigateToAddNewFriendController(buttonAdress:UIButton) ->Void
    
}

class groupsTableViewCell: UITableViewCell {
    
    //protocol delgate
    var groupListDelegate:groupListProtocol? = nil
    
    @IBOutlet weak var noDataAvailableLabel: UILabel!
    
    @IBOutlet weak var groupsNameLabel: UILabel!
    
    @IBOutlet weak var deleteGroupButton: UIButton!
    
    @IBOutlet weak var editGroupNameButton: UIButton!
    
    @IBOutlet weak var subviewOfGroup: UIView!
    
    //MARK:- Custom cell methods
    func fillGroupsInformation(groupName:String, withCellsIndexPaths:Int) -> Void {
        
        //group name
        self.groupsNameLabel.text = groupName
        
        //Edit btn image
        editGroupNameButton.setFAIcon(icon: .FAUserPlus, iconSize: 20, forState: .normal)
        editGroupNameButton.setTitleColor(UIColor.black, for: .normal)
        
        //Delete btn image
        deleteGroupButton.setFAIcon(icon: .FABan, iconSize: 20, forState: .normal)
        deleteGroupButton.setTitleColor(UIColor.red, for: .normal)
        
        //Btn tags
        editGroupNameButton.tag = withCellsIndexPaths
        deleteGroupButton.tag = withCellsIndexPaths
        
    }
    
    func noDataAvailable(noDataText:String?) -> Void {
        
        //No data available
        self.noDataAvailableLabel.text = noDataText
    }
    
    //MARK:- Actions
    
    @IBAction func deleteGroupAction(_ sender: UIButton) {
        
        //call delete group api method
        groupListDelegate?.groupDeleteRequestApi(buttonAdress: sender)
    }
    
    @IBAction func editGroupListAction(_ sender: UIButton) {
        
        //to Add new friend controller as pop up
        groupListDelegate?.navigateToAddNewFriendController(buttonAdress: sender)
        
    }
    
}
