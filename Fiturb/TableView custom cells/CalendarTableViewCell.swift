//
//  CalendarTableViewCell.swift
//  Fiturb
//
//  Created by DATAPPS on 3/31/17.
//  Copyright © 2017 Fiturb.DATAPPS. All rights reserved.
//

import UIKit

class CalendarTableViewCell: UITableViewCell {

    @IBOutlet weak var calendarPlusButton: UIButton!
    
     @IBOutlet weak var activityNameText: UILabel!
    
    @IBOutlet weak var timeTextLabel: UILabel!
    
    @IBOutlet weak var dateTextLabel: UILabel!
    
    @IBOutlet weak var monthYearLabel: UILabel!
    
    @IBOutlet weak var firstSubView: UIView!
    
    @IBOutlet weak var mainView: UIView!
    
       override func awakeFromNib() {
        
        super.awakeFromNib()
        // Initialization code
        
    }
    
    //MARK:- Custom cell methods
    func customCellData(activityName:String?, activityStartDateAndTime:Dictionary<String, String>?) -> Void {
        
        //cell UIadjstments method
        self.customCellUiAdjustments()
        
        //Activty name
        self.activityNameText.text = activityName
        
        //Date
        self.dateTextLabel.text = activityStartDateAndTime?["date"]
        
        //Month year
        self.monthYearLabel.text = "\(activityStartDateAndTime?["monthName"] ?? "0") \n\(activityStartDateAndTime?["year"] ?? "0")"
        
        //Time
        self.timeTextLabel.text = activityStartDateAndTime?["time"]
        
        
    }
    
    private func customCellUiAdjustments() -> Void {
        
        //Main view border
        self.calendarPlusButton.setFAIcon(icon:.FACalendarPlusO, iconSize: 20, forState: .normal)
        
        self.calendarPlusButton.setTitleColor(UIColor.black, for: .normal)
        
        self.mainView.layer.borderWidth = 1
        
        self.mainView.layer.borderColor = UIColor.lightGray.cgColor
                
    }

}
