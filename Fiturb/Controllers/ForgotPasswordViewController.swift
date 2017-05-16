//
//  ForgotPasswordViewController.swift
//  Fiturb
//
//  Created by Admin on 03/03/17.
//  Copyright © 2017 Fiturb.DATAPPS. All rights reserved.
//

import UIKit

class ForgotPasswordViewController: UIViewController {
   
    @IBOutlet weak var qustionMarkImageView: UIImageView!
    
    public var  resetPasswordObj:ResetPassWordViewController!
    
    var window:UIWindow!

    @IBOutlet weak var emailOrMobileNumberTextField: ACFloatingTextfield!
    
    //MARK:- Life cycle methods
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        qustionMarkImageView.image = UIImage.fontAwesomeIcon(name:.question, textColor: UIColor.white, size: CGSize(width: 200, height: 200))

        
        let popupGesture = UITapGestureRecognizer(target: self, action: #selector(self.tagGestureRemovePOPUP))
        
        //gr.delegate = self
        self.view.addGestureRecognizer(popupGesture)
        
        }
    
    //MARK:- UITextFiled Delegate Methods
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        
        return true
    }
    
    //MARK:- IBAction Methods
    @IBAction func sendButtonPressed(_ sender: Any) {

        //Method to call Sent Otp api
        self.sentOtpApiMethod()
        
    }

    //MARK:- Sent OTP Api Method
    func sentOtpApiMethod() -> Void {
        
        //Add Loader
        MBProgressHUD.showAdded(to: self.view, withScreenHeaderHeigth: 0.0, animated: true)
        
        //Email or Mobile Number
        let mobileNumberOrEmail:Dictionary<String,String>
        
        if singleTon.sharedInstance.isValidEmail(testStr:emailOrMobileNumberTextField.text!) {
            
            //Email
            mobileNumberOrEmail = ["email":emailOrMobileNumberTextField.text!]
            
        }
        else{
            
            //Mobile
            mobileNumberOrEmail = ["mobile":emailOrMobileNumberTextField.text!]
            
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
            
            //Navigate to Reset Password view controller if Otp sent successfully
            self.navigateToResetPasswordController()
            
        })
        
    }

    //MARK:- Private Methods
    func navigateToResetPasswordController() -> Void {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        self.resetPasswordObj = storyboard.instantiateViewController(withIdentifier: "ResetPassWordViewController") as! ResetPassWordViewController
        
        self.resetPasswordObj.view.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height)
        
        //Pass view adress and user entered mobile number or email
        self.resetPasswordObj.forgetPasswordViewControllerViewAdress = self.view
        self.resetPasswordObj.mobileNumberOrEmail = emailOrMobileNumberTextField.text
        
        self.view.addSubview(self.resetPasswordObj.view)

    }
    
    func tagGestureRemovePOPUP(_ gestureRecognizer: UIGestureRecognizer) {
        //Removing Pop up servies table view and background view
        self.view.removeFromSuperview()
        
    }
    
}
