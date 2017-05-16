//
//  CalenderActivityModel.swift
//  Fiturb
//
//  Created by Admin on 08/04/17.
//  Copyright © 2017 Fiturb.DATAPPS. All rights reserved.
//

import Foundation

class CalenderActivityModel {
    
    var activityId: String!
    
    var activityName: String!
    
    var activityStartTime: Dictionary<String, String>?
    
    var activityEndTime: Dictionary<String, String>?
    
    var longitude: String!
    
    var latitude: String!
    
    var messageText: String!
    
    func initWithJsonData(calenderActivityDictionary:Dictionary<String,AnyObject>?,message: String?) -> Any?{
        
        //Message text
        self.messageText = message ?? "No data"
        
        //Activity Id
        self.activityId = calenderActivityDictionary?["activity_id"] as? String ?? "No data"
        
        //Activity name
        self.activityName = calenderActivityDictionary?["activity_name"] as? String ?? "No data"
        
        //start time
        //self.activityStartTime = calenderActivityDictionary?["start_time"] ?? "No data"
        
//        //End time
//        self.activityEndTime = calenderActivityDictionary?["end_time"] ?? "No data"
        
        //latitude
        self.latitude = calenderActivityDictionary?["latitude"] as? String ?? "No data"
        
        //Longitude
        self.longitude = calenderActivityDictionary?["longitude"] as? String ?? "No data"
    
        /***start time***/
        //Convert string to datefomate
        let startTimeDateString:String? = calenderActivityDictionary?["start_time"] as? String ?? "0000-00-00 00:00:00"
        self.activityStartTime = (singleTon.sharedInstance.convertStringToDate(dateString:startTimeDateString))
        print("start time  is:\(String(describing: self.activityStartTime))")
        
        
        /***End time***/
        //Convert string to datefomate
        let endTimeDateString: String? = calenderActivityDictionary?["end_time"] as? String ?? "0000-00-00 00:00:00"
        self.activityEndTime = (singleTon.sharedInstance.convertStringToDate(dateString:endTimeDateString))
        print("End time  is:\(String(describing: self.activityEndTime))")
        
        return self
        
    }
    
}
