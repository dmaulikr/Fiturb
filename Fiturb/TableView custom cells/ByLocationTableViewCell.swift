//
//  ByLocationTableViewCell.swift
//  Fiturb
//
//  Created by DATAPPS on 4/3/17.
//  Copyright © 2017 Fiturb.DATAPPS. All rights reserved.
//

import UIKit
import MapKit

class ByLocationTableViewCell: UITableViewCell {

    @IBOutlet weak var mapViewObjectOfActivityFilter: MKMapView!
    
    @IBOutlet weak var selectLocationMapButton: UIButton!
    
    @IBOutlet weak var dropDownDistanceImage: UIImageView!
    
    @IBOutlet weak var distanceTextFiled: UITextField!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
