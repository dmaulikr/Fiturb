//
//  InterestListTableViewCell.swift
//  Fiturb
//
//  Created by Admin on 21/03/17.
//  Copyright © 2017 Fiturb.DATAPPS. All rights reserved.
//

import UIKit

class InterestListTableViewCell: UITableViewCell {

    @IBOutlet weak var interstListText: UILabel!
    
    @IBOutlet weak var cellSubView: UIView!
    
    override func awakeFromNib() {
        
        super.awakeFromNib()
        
        // Initialization code
    }

    //MARK:- Custom cell methods
    func interestList(interestText:String?) -> Void {

        //Set interest item name
        if let itemText = interestText{
            
            interstListText.text = itemText
            
        }
        
        //        //set image
        //        if let imageName = image {
        //
        //            thematicsListItemImage.image = imageName
        //
        //        }
    }
        
}
