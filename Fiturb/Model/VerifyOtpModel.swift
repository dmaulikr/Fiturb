//
//  VerifyOtpModel.swift
//  Fiturb
//
//  Created by Admin on 27/03/17.
//  Copyright © 2017 Fiturb.DATAPPS. All rights reserved.
//

import Foundation

class VerifyOtpModel{
    
    var message: String!
    
    var mobileVerification: String!
    
    func initWithJsonData(messageText:String?, mobileVerificationText: String?) -> Any? {
        
        //Success or failure message
        self.message = messageText ?? "No data"
        
        //mobile verifcation text
        self.mobileVerification = mobileVerificationText ?? "No data"
        
        return self
    }
    
}
