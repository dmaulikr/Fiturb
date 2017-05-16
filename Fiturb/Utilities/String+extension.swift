//
//  String+extension.swift
//  Fiturb
//
//  Created by Admin on 09/03/17.
//  Copyright © 2017 Fiturb.DATAPPS. All rights reserved.
//

import Foundation

//String Extension to check phone number is valid
public extension String {
    
    //Check phone number is valid  or not
    public var validPhoneNumber:Bool {
        
        let types:NSTextCheckingResult.CheckingType = [.phoneNumber]
        
        guard let detector = try? NSDataDetector(types: types.rawValue) else { return false }
        
        if let match = detector.matches(in: self, options: [], range: NSMakeRange(0, characters.count)).first?.phoneNumber {
            
            return match == self
            
        }
        else{
            
            return false
        }
    }
    
    //Parse JSON string
    var parseJSONString: Any? {
        let data = self.data(using: String.Encoding.utf8, allowLossyConversion: false)
        guard let jsonData = data else { return nil }
        do { return try JSONSerialization.jsonObject(with: jsonData, options: JSONSerialization.ReadingOptions.mutableContainers) }
        catch { return nil }
    }
}
