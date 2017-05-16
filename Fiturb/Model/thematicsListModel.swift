//
//  thematicsListModel.swift
//  Fiturb
//
//  Created by Admin on 15/03/17.
//  Copyright © 2017 Fiturb.DATAPPS. All rights reserved.
//

import Foundation

class thematicsListModel
{
    var themeName: String!
    
    var themeId: String!

    var themeIcon: String!

    var themeMessage: String!
    
    //Json Parsing method
    func initWithJsonData(dictinaryObj dict:Dictionary<String, AnyObject>?, responseMessage message:String?) -> Any? {
        
        //Theme name
        self.themeName = dict?["theme_name"] as? String ?? "No data"
        
        //Theme iD
        self.themeId = dict?["theme_id"] as? String ?? "No data"
        
        //Theme Icon
        self.themeIcon = dict?["theme_icon"] as? String ?? "No data"
        
        //Theme message
        self.themeMessage = message ?? "No data"
        
        return self
        
    }
    
}
