//
//  alamofireApiDataManager.swift
//  Fiturb
//
//  Created by Admin on 08/05/17.
//  Copyright © 2017 Fiturb.DATAPPS. All rights reserved.
//

import Foundation
import Alamofire
import UIKit

class alamofireApiDataManager: NSObject {

    //MARK:- SingleTon object
    //Single ton object
    static let singleTonObjectForAlamofireApiDataManager = alamofireApiDataManager()
    
    private override init() {
        
        
    }
    
    //MARK:- Api methods
    
    //Activity Detial(Post method)
    func activityDetailsApiValuesWithUrlString(urlString: String, postDataDicitionary:Dictionary<String, Any>?, callBackBlock completionHandler:@escaping(_ responseRecievedArray:Array<Any>?, _ error:NSError?) -> ()) -> Void {
        
        //HTTP Headers
        let httpHeaders: HTTPHeaders = [
            "Content-Type": "application/json",
            "Accept": "application/json",
            "Token":(singleTon.sharedInstance.getUserAuthenticationToken()) ?? ""
        ]
        
        //Calling common post service method
        self.commonPostServiceMethodAlamofire(url: urlString, postData: postDataDicitionary, headers: httpHeaders, callBackBlock: {(responseString: String?,error: NSError?) in
            
            print("Activity detail api respons is:\(responseString)")

            guard error == nil else{
                
                //Error handling
                DispatchQueue.main.async(execute: {
                    completionHandler(nil , error)
                });
                
                return
            }
            
            let modelObj = ActivityDetailModel(JSONString: responseString!)
            
            //Create array to pass all json parsed data to classes
            var responseArray = [Any?]()
            
            if modelObj != nil{
                
                responseArray.append(modelObj!)
                
            }
            
            //Check array count
            if responseArray.count == 0{
                
                let error = NSError(domain:"FiturbApp",
                                    code: 100,
                                    userInfo: [NSLocalizedFailureReasonErrorKey : modelObj?.messageText ?? MyAppConstants.jsonErrorMsg])
                
                //Error(No data available)
                DispatchQueue.main.async(execute: {
                    completionHandler(nil , error)
                });
                
            }
            else{
                
                //Success
                DispatchQueue.main.async(execute: {
                    completionHandler(responseArray , error)
                });
            }
        })
        
    }
    
    
    //MARK:- Alamofire common POST and GET Services
    
    //GET method
    func commonGetServiceMethodAlamofire(url: String, postData: Dictionary<String, Any>?, headers:Dictionary<String, String>?, callBackBlock completionHandler:@escaping(_ responseString: String?, _ error: NSError?) -> ()) -> Void {
    
        Alamofire.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: headers).responseString { (response:DataResponse<String>) in
            
            print("GET service response is:\(response)")
            
            if response.response?.statusCode == 200{
                
                switch response.result{
                    
                case .success(let responseString):
                    
                    print("GET Success block response :\(responseString)")
                    
                    //JSON format data
                    let jSonFormatData = responseString.parseJSONString
                    print("GET service response in Json format is:\(String(describing: jSonFormatData))")

                    //Success Call back
                    DispatchQueue.main.async(execute: {
                        
                        completionHandler(responseString, nil)
                    });
                    
                    return
                    
                case .failure(let error):
                    
                    print("GET failure block error:\(error)")
                    
                    //Error Call back
                    DispatchQueue.main.async(execute: {
                        
                        completionHandler(nil, error as NSError?)
                    });
                    
                    return
                }
                
            }
            else{
                
                //Server error
                print("Server Error recieved")
                
                let errorMessage = MyAppConstants.noResponseFromServerErrorMsg
                
                let error = NSError(domain:"FiturbApp",
                                    code: 100,
                                    userInfo: [NSLocalizedFailureReasonErrorKey :errorMessage])
                
                //Server error callBack
                DispatchQueue.main.async(execute: {
                    completionHandler(nil , error)
                });
                
                return
            }
            
        }
    
    }
    
    //POST method
    func commonPostServiceMethodAlamofire(url:String, postData:Dictionary<String, Any>?, headers:Dictionary<String, String>?, callBackBlock completionHandler:@escaping(_ responseString: String?, _ error: NSError?) -> ()) ->  Void {
        
        Alamofire.request(url, method:.post, parameters: postData, encoding: JSONEncoding.default, headers: headers).responseString {(response:DataResponse<String>) in
            
            print("POST service response is:\(response)")
            
            if response.response?.statusCode == 200{
                
                switch response.result{
                    
                case .success(let responseString):
                    
                    print("POST Success block response :\(responseString)")
                    
                    //JSON format data
                    let jSonFormatData = responseString.parseJSONString
                    print("POST service response in Json format is:\(String(describing: jSonFormatData))")
                    
                    //Success Call back
                    DispatchQueue.main.async(execute: {
                        
                        completionHandler(responseString, nil)
                    });
                        
                    return
                    
                case .failure(let error):
                    
                    print("POST failure block error:\(error)")
                    
                    //Error Call back
                    DispatchQueue.main.async(execute: {
                        
                        completionHandler(nil, error as NSError?)
                    });
                    
                    return
                }
                
            }
            else{
                
                //Server error
                print("Server Error recieved")
                
                let errorMessage = MyAppConstants.noResponseFromServerErrorMsg
                
                let error = NSError(domain:"FiturbApp",
                                    code: 100,
                                    userInfo: [NSLocalizedFailureReasonErrorKey :errorMessage])
                
                //Server error callBack
                DispatchQueue.main.async(execute: {
                    completionHandler(nil , error)
                });
                
                return
            }
            
        }

    }
    
}
