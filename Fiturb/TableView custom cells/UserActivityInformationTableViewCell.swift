//
//  UserActivityInformationTableViewCell.swift
//  Fiturb
//
//  Created by DATAPPS on 4/27/17.
//  Copyright © 2017 Fiturb.DATAPPS. All rights reserved.
//

import UIKit

class UserActivityInformationTableViewCell: UITableViewCell {

    @IBOutlet weak var staticTextImageView: UIImageView!
    
    @IBOutlet weak var organizedByImageView: UIImageView!
    
    @IBOutlet weak var entryFeesImageView: UIImageView!
    
    @IBOutlet weak var addressImageView: UIImageView!
    
    @IBOutlet weak var startTimeImageView: UIImageView!
    
    @IBOutlet weak var dateAndTimeLabel: UILabel!
    
    @IBOutlet weak var adressLabel: UILabel!
    
    @IBOutlet weak var entryFeesLabel: UILabel!
    
    @IBOutlet weak var organisedByLabel: UILabel!
    
    @IBOutlet weak var descriptionLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func customCellData(startDateAndTime: String?, adressText: String?, entryFees: String?, organisedBy: String?, descriptionText: String?) -> Void {
        
        self.dateAndTimeLabel.text = startDateAndTime
        
        self.adressLabel.text = adressText
     
        self.entryFeesLabel.text = entryFees
        
        self.organisedByLabel.text = organisedBy
        
        self.descriptionLabel.text = descriptionText
    }
    
    func materialDesignPartForUserActivityInformation (){
        
        startTimeImageView.image = UIImage.fontAwesomeIcon(name: .calendar, textColor: UIColor.black, size: CGSize(width: 100, height: 100))
        
        addressImageView.image = UIImage.fontAwesomeIcon(name: .mapMarker, textColor: UIColor.black, size: CGSize(width: 100, height: 100))
        
        organizedByImageView.image = UIImage.fontAwesomeIcon(name: .user, textColor: UIColor.black, size: CGSize(width: 100, height: 100))
        
         staticTextImageView.image = UIImage.fontAwesomeIcon(name: .info, textColor: UIColor.black, size: CGSize(width: 100, height: 100))
        
        entryFeesImageView.image = UIImage.fontAwesomeIcon(name: .creditCard, textColor: UIColor.black, size: CGSize(width: 100, height: 100))
        

    }


}
