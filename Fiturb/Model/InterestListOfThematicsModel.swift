//
//  InterestListOfThematicsModel.swift
//  Fiturb
//
//  Created by Admin on 21/03/17.
//  Copyright © 2017 Fiturb.DATAPPS. All rights reserved.
//

import Foundation

class InterestListOfThematicsModel{
    
    var interestName: String!
    
    var interestId: String!
    
    var interestIcon: String!
    
    var interestMessage: String!
    
    //Json Parsing method
    func initWithJsonData(dictinaryObj dict:Dictionary<String, AnyObject>?, responseMessage message:String?) -> Any? {
        
        //Interest name
        self.interestName = dict?["interest_name"] as? String ?? "No data"
        
        //Interest iD
        self.interestId = dict?["interest_id"] as? String ?? "No data"
        
        //Interest Icon
        self.interestIcon = dict?["interest_icon"] as? String ?? "No data"
        
        //Interest message
        self.interestMessage = message ?? "No data"
        
        return self
        
    }

}
