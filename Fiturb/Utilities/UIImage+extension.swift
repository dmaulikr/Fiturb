//
//  UIImage+extension.swift
//  Fiturb
//
//  Created by Admin on 14/04/17.
//  Copyright © 2017 Fiturb.DATAPPS. All rights reserved.
//

import Foundation

extension UIImage
{
    class func loadImageFromURL(imageUrlString: String?, callback: @escaping (UIImage)->()) {
        DispatchQueue.global(qos: .userInitiated).async {
            
            var image = UIImage()
            
            let url = NSURL(string:imageUrlString!)
            
            if url != nil{
                
                let imageData = NSData.init(contentsOf: url! as URL)
                
                if let data = imageData {
                    
                    image = UIImage(data: data as Data)!
                    
                }
            }
            
            DispatchQueue.main.async(execute: {
                
                callback(image)
                
            })
        }
        
    }
}
