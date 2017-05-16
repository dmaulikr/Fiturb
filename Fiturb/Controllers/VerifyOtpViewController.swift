//
//  VerifyOtpViewController.swift
//  Fiturb
//
//  Created by Admin on 27/03/17.
//  Copyright © 2017 Fiturb.DATAPPS. All rights reserved.
//

import UIKit

//MARK: Protocol
protocol navigateProtocol: class{
    
    func navigateToActivityViewController() -> Void
    
}

class VerifyOtpViewController: UIViewController {

    //Protocol object
    weak var navigateDelegate:navigateProtocol? = nil

    @IBOutlet weak var OtpTextField: ACFloatingTextfield!
    
    @IBOutlet weak var imageView: UIImageView!
    
    var userEmail: String?
    
    var userMobileNumber: String?
        
    //MARK:- Life cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        
         imageView.image = UIImage.fontAwesomeIcon(name:.pencilSquare, textColor: UIColor.orange, size: CGSize(width: 200, height: 200))
        
    }
    
    //MARK:- IBAction Methods
    @IBAction func verifyOtpAction(_ sender: UIButton) {
        
        //Verify Otp Api method
        self.getVerifyOtpApiMethods()
        
    }
    
    @IBAction func resendOtpAction(_ sender: UIButton) {
        
        //Send Otp Api Method
        self.sentOtpApiMethod()
        
    }
    
    //MARK:- Api Methods
    
    func getVerifyOtpApiMethods() -> Void{
        
        //Add Loader
        MBProgressHUD.showAdded(to: self.view, withScreenHeaderHeigth: 0.0, animated: true)

        let emailOrMobileNumber:String?
        
//        if singleTon.sharedInstance.isValidEmail(testStr:userEmail!) {
//            
//            //Email
//            emailOrMobileNumber = "email/\(userEmail!)/otp/\(OtpTextField.text!)"
//            
//        }
//        else{
//            
//            //Mobile
//            emailOrMobileNumber = "mobile/\(userMobileNumber!)/otp/\(OtpTextField.text!)"
//            
//        }
        
        if (userMobileNumber?.validPhoneNumber)!{
            
            //Mobile
            emailOrMobileNumber = "mobile/\(userMobileNumber!)/otp/\(OtpTextField.text!)"
            
        }
        else{
            
            //Email
            emailOrMobileNumber = "email/\(userEmail!)/otp/\(OtpTextField.text!)"
            
        }
        
        //url String
        let urlStringWithSlecteditemidentifier = MyAppConstants.verifyOtpUrl.appending(emailOrMobileNumber!)
        
        ApiDataManager.singleTonObjectForApiManagerClass.getVerifyOtpApiValuesWithUrlString(urlString: urlStringWithSlecteditemidentifier) {  (apiRecievedResponse:Array?, error:NSError?) in
            
            //Remove Loader
            MBProgressHUD.hide(for: self.view, animated: true)
            
            guard error == nil else{

                //Error handling
                print("Error recieved from Vrify Otp api is:\(error!.localizedFailureReason!)")
                
                //Dsiplay alert
                let alertController = singleTon.sharedInstance.displayAlert(message: (error!.localizedFailureReason!), title: "Fiturb")
                self.present(alertController, animated: true, completion: nil)
                
                //Remove Pop up screen
                self.view.removeFromSuperview()
                
                return
            }
            

            let ModelObj = apiRecievedResponse?[0] as! VerifyOtpModel
            
            print("Verify Otp Model object values are:\(ModelObj.message!),\(ModelObj.mobileVerification!)")
         
            guard (ModelObj.mobileVerification!) == "1" else{
                
                print("Mobile is not verified")
                return
            }
        
            //mobile Verified so Move to Home Screen(protocol method)
            self.navigateDelegate?.navigateToActivityViewController()
            
            //Remove Pop up screen
            self.view.removeFromSuperview()
        }
     
    }

    func sentOtpApiMethod() -> Void {
        
        //Add Loader
        MBProgressHUD.showAdded(to: self.view, withScreenHeaderHeigth: 0.0, animated: true)
        
        //Email or Mobile Number
        let mobileNumberOrEmail:Dictionary<String,String>
        
//        if singleTon.sharedInstance.isValidEmail(testStr:userEmail!) {
//            
//            //Email
//            mobileNumberOrEmail = ["email":userEmail!]
//            
//        }
//        else{
//            
//            //Mobile
//            mobileNumberOrEmail = ["mobile":userMobileNumber!]
//            
//        }
        
        if (userMobileNumber?.validPhoneNumber)!{
            
            //Mobile
            mobileNumberOrEmail = ["mobile":userMobileNumber!]
           
        }
        else{
            
            //Email
            mobileNumberOrEmail = ["email":userEmail!]
            
        }
        
        //Post data
        let postData = mobileNumberOrEmail as Dictionary<String, String>
        
        //Call Otp sent Api
        ApiDataManager.singleTonObjectForApiManagerClass.getSendOtpApiValuesWithUrlString(urlString: MyAppConstants.sendOtpUrl, withPostData: postData, callBackBlock: { (otpSentApiRecievedResponse:String?, error:NSError?) in
            
            //Remove Loader
            MBProgressHUD.hide(for: self.view, animated: true)
            
            guard error == nil else{
                
                //Error handling
                print("Error recieved from sign up api is:\(error!.localizedFailureReason!)")
                
                //Dsiplay alert
                let alertController = singleTon.sharedInstance.displayAlert(message: (error!.localizedFailureReason!), title: "Fiturb")
                self.present(alertController, animated: true, completion: nil)
                
                //Remove Pop up screen
                //self.view.removeFromSuperview()

                return
                
            }
            
            guard let apiResponse = otpSentApiRecievedResponse else{
                
                print("Empty response")
                return
                
            }
            
            guard apiResponse == "otp sent successfully" else{
                
                return
                
            }
            
        })
        
    }

    //MARK:- UITextFiled Delegate Methods
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        
        return true
    }
    
}

