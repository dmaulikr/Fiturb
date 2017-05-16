//
//  EditUserProfileModel.swift
//  Fiturb
//
//  Created by Admin on 21/04/17.
//  Copyright © 2017 Fiturb.DATAPPS. All rights reserved.
//

import Foundation

class EditUserProfileModel {

    var message:String!
    
    func initWithJsonData(messageText:String?) -> AnyObject? {
        
        //Message
        self.message = messageText ?? "No data"
        
        return self
    }

}
