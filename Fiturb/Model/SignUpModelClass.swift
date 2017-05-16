//
//  SignUpModelClass.swift
//  Fiturb
//
//  Created by Admin on 07/03/17.
//  Copyright © 2017 Fiturb.DATAPPS. All rights reserved.
//

import Foundation

class SignUpModelClass: NSObject {

    var registrationMessage:String!
    
    var userEmail:String!
    
    var userMobileNumber:String!
    
    var userFirstName: String!

   //Json parsing Method
    func initWithJsonData(message registrationMsg:String?, registeredEmail email:String?, mobileNumber number:String?, firstName name:String?) -> AnyObject? {
        
        //Registration message
        self.registrationMessage = registrationMsg ?? "No data"
        
        //Email
        self.userEmail = email ?? "No data"
        
        //user mobile number
       self.userMobileNumber = number ?? "No data"
        
        //User first name
        self.userFirstName = name ?? "No data"
        
        return self
        
    }

}
