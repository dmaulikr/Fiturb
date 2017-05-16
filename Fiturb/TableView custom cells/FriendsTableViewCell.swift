//
//  FriendsTableViewCell.swift
//  Fiturb
//
//  Created by Admin on 23/03/17.
//  Copyright © 2017 Fiturb.DATAPPS. All rights reserved.
//

import UIKit

protocol firendTableViewCellProtocol:class {
    
    func acceptFriendRequestApi(buttonAdress:UIButton, customCellAdress:FriendsTableViewCell) -> Void
    
    func cancelFriendRequestApi(buttonAdress:UIButton, customCellAdress:FriendsTableViewCell) -> Void

    func rejectFriendRequestApi(buttonAdress:UIButton, customCellAdress:FriendsTableViewCell) -> Void
    
}

class FriendsTableViewCell : UITableViewCell
{
    //declare prtocol variable
    var friendsApisDelegate:firendTableViewCellProtocol? = nil
    
    @IBOutlet weak var noDataAvailableLabel: UILabel!
    
    @IBOutlet weak var friendsImageView: UIImageView!
    
    @IBOutlet weak var friendsNameLabel: UILabel!
    
    @IBOutlet weak var onelineAndOfflineCircleLbl: UILabel!
    
    @IBOutlet weak var onlineAndOfflineNameLbl: UILabel!
    
    @IBOutlet weak var onlineAndOfflineImageView: UIImageView!
    
    @IBOutlet weak var acceptFriendsBtn: UIButton!
    
    @IBOutlet weak var rejectFriends: UIButton!
    
    @IBOutlet weak var cancelFriends: UIButton!
    
    //MARK:- Custom cell Methods
    
    func fillFriendsInformation(friendsType: String, firstName: String, lastName: String, friendShipStatus: String, onlineStatus: String, thumbUrl: String ) -> Void{
        
        //Friends name
        friendsNameLabel.text = firstName
        
        //Online staus
        onlineAndOfflineNameLbl.text = onlineStatus
        
        //online and offline circle and images
        if (onlineAndOfflineNameLbl.text == "TRUE")
        {
            
            onlineAndOfflineNameLbl.textColor = UIColor.green
            
            onelineAndOfflineCircleLbl.backgroundColor = UIColor.green
            
            onlineAndOfflineImageView.image = UIImage.fontAwesomeIcon(name:.commentingO, textColor: UIColor.black, size: CGSize(width: 200, height: 200))
            
        }
        else
        {
            onlineAndOfflineNameLbl.textColor = UIColor.red

            onelineAndOfflineCircleLbl.backgroundColor = UIColor.red
            
            onlineAndOfflineImageView.image = UIImage.fontAwesomeIcon(name:.envelopeO , textColor: UIColor.black, size: CGSize(width: 200, height: 200))
            
            
        }
        
        //Check friends type(sent, recieved or already friends type)
        if friendsType == "AlreadyFriends" {
            
            //Alrerady friends
            acceptFriendsBtn.isHidden = true
            rejectFriends.isHidden = true
            cancelFriends.isHidden = true
            
        }
        else if friendsType == "SentFriends"{
            
            //Sent friends
            acceptFriendsBtn.isHidden = true
            rejectFriends.isHidden = true
            cancelFriends.isHidden = false
            
        }
        else if friendsType == "RecievedFriends"{
            
            //Recievd friends
            acceptFriendsBtn.isHidden = false
            rejectFriends.isHidden = false
            cancelFriends.isHidden = true
            
        }
        else{
            
            //Hide all buttons
            acceptFriendsBtn.isHidden = true
            rejectFriends.isHidden = true
            cancelFriends.isHidden = true
        }
        
    }
    
    func noDataAvailable(noDataText:String?) -> Void {
        
        //No data available
        self.noDataAvailableLabel.text = noDataText
    }
    
    
    //MARK:- custom cell Button actions
    
    @IBAction func acceptFriendRequestAction(_ sender: UIButton) {
        
         print("Accept friends")
        friendsApisDelegate?.acceptFriendRequestApi(buttonAdress: sender, customCellAdress: self)
    }
    
    
    @IBAction func cancelFriendRequestAction(_ sender: UIButton) {
        
        print("Cancel friends")
        friendsApisDelegate?.cancelFriendRequestApi(buttonAdress: sender, customCellAdress: self)

    }
    
    @IBAction func rejectFriendRequestAction(_ sender: UIButton) {
        
        print("reject friends")
        
        friendsApisDelegate?.rejectFriendRequestApi(buttonAdress: sender, customCellAdress: self)
        

    }
    
}
