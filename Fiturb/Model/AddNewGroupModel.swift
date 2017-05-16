//
//  AddNewGroupModel.swift
//  Fiturb
//
//  Created by Admin on 04/04/17.
//  Copyright © 2017 Fiturb.DATAPPS. All rights reserved.
//

import Foundation

class AddNewGroupModel {
    
    var message:String!
    
    func initWithJsonData(msgText:String?) -> AnyObject? {
        
        //successful new group added or not message text
        self.message = msgText ?? "No data"
        
        return self
    }
    
}
