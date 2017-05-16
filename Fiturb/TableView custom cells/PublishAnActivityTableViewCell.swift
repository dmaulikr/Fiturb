//
//  PublishAnActivityTableViewCell.swift
//  Fiturb
//
//  Created by DATAPPS on 4/7/17.
//  Copyright © 2017 Fiturb.DATAPPS. All rights reserved.
//

import UIKit

protocol publishActivityProtocol:class {
    
    func removePublishActivityCell(cellAdress:PublishAnActivityTableViewCell) -> Void
    
}

class PublishAnActivityTableViewCell: UITableViewCell {

    //Protocol object
    var publishActivityDelegate:publishActivityProtocol? = nil
    
    @IBOutlet weak var subView: UIView!
    
    @IBOutlet weak var publishActivityButton: UIButton!
    
    @IBOutlet weak var publishActivityCancelBtn: UIButton!
    
    override func awakeFromNib() {
        
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    //Add cancel image

    
    func publishAnActivityMaterialDesignPart()
    {
        //cancel image
        publishActivityCancelBtn.setFAIcon(icon: .FATimes, iconSize: 25, forState: .normal)
        
        publishActivityCancelBtn.setTitleColor(UIColor.lightGray, for: .normal)
        
        publishActivityButton.layer.cornerRadius = 5
        
        subView.layer.cornerRadius = 0
        
        subView.layer.shadowColor = UIColor (red: 0/255.0, green: 0/255.0, blue: 0/255.0, alpha: 1.0).cgColor
        
         subView.layer.shadowOffset = CGSize(width: 0, height: 1.75)
        
       subView.layer.shadowRadius = 1.7
        
       subView.layer.shadowOpacity = 0.45
 
    }
    
    
    @IBAction func removePublishActivityAction(_ sender: UIButton) {
        
        //Call protocol  method
        publishActivityDelegate?.removePublishActivityCell(cellAdress: self)
    }
    
}
