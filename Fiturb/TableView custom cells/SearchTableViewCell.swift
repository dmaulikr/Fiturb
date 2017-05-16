//
//  SearchTableViewCell.swift
//  Fiturb
//
//  Created by Admin on 03/04/17.
//  Copyright © 2017 Fiturb.DATAPPS. All rights reserved.
//

import UIKit

protocol SearchProtocol:class {
    
    func sendApiProtocolMethod(buttonAdress:UIButton, customCellAdress:SearchTableViewCell) -> Void
    
}
class SearchTableViewCell: UITableViewCell {

    @IBOutlet weak var userImage: UIImageView!
    
    @IBOutlet weak var userName: UILabel!
    
    @IBOutlet weak var sendBtn: UIButton!
    
    //protocol varible
    var searchDelegate:SearchProtocol? = nil
    
    //MARK:- Actions
    func searchCellData(firstName: String, imageUrl: String) -> Void {
        
        //Unhide send btn
        self.sendBtn.isHidden = false
        
        //user name
        self.userName.text = firstName
        
        //user image
        
    }
    
    
    @IBAction func sendFriendRequestAction(_ sender: UIButton) {
        
        //Search protocol api method
        searchDelegate?.sendApiProtocolMethod(buttonAdress: sender, customCellAdress: self)
        
    }

}
