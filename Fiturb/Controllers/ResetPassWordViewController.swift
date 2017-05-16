//
//  ResetPassWordViewController.swift
//  Fiturb
//
//  Created by DATAPPS on 3/16/17.
//  Copyright © 2017 Fiturb.DATAPPS. All rights reserved.
//

import UIKit

class ResetPassWordViewController: UIViewController {

    @IBOutlet weak var questionMarkImageView: UIImageView!
    
    @IBOutlet weak var otpTextField: ACFloatingTextfield!
    
    
    @IBOutlet weak var newPassword: ACFloatingTextfield!
    
    public var  forgetPasswordViewControllerViewAdress:UIView!

    var mobileNumberOrEmail:String?
    
    //MARK:- Life cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        questionMarkImageView.image = UIImage.fontAwesomeIcon(name:.question, textColor: UIColor.white, size: CGSize(width: 200, height: 200))
        
        // Do any additional setup after loading the view.
        let popupGesture = UITapGestureRecognizer(target: self, action: #selector(self.tagGestureRemovePOPUP))
        
        self.view.addGestureRecognizer(popupGesture)
    }
    
    //MARK:- Gesture Recognizer Methods
    func tagGestureRemovePOPUP(_ gestureRecognizer: UIGestureRecognizer) {
        
        self.view.removeFromSuperview()
    }
    
    //MARK:- UITextFiled Delegate Methods
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    //MARK:- IBAction Methods
    @IBAction func resetPasswordButtonPressed(_ sender: Any) {

        //Call reset password api method
        self.resetPasswordApi()

    }
    
    //MARK:- Reset password api method
    func resetPasswordApi() -> Void {
        
        //Add Loader
        MBProgressHUD.showAdded(to: self.view, withScreenHeaderHeigth: 0.0, animated: true)
        
        //Forget password url
        let urlString =  MyAppConstants.forgetPasswordUrl
        
//        //Post data
//        let postData = ["mobile":mobileNumberOrEmail!,"password":newPassword.text!,"otp":otpTextField.text!] as Dictionary<String,String>
        
        //Email or Mobile Number
        let checkmobileNumberEmail:Dictionary<String,String>
        
        if singleTon.sharedInstance.isValidEmail(testStr:mobileNumberOrEmail!) {
            
            //Email
            checkmobileNumberEmail = ["email":mobileNumberOrEmail!,"password":newPassword.text!,"otp":otpTextField.text!] as Dictionary<String,String>
            
        }
        else{
            
            //Mobile
            checkmobileNumberEmail = ["mobile":mobileNumberOrEmail!,"password":newPassword.text!,"otp":otpTextField.text!] as Dictionary<String,String>
        }
        
        //Post data
        let postData = checkmobileNumberEmail as Dictionary<String, String>

        ApiDataManager.singleTonObjectForApiManagerClass.postForgetPasswordApiValuesWithUrlString(urlString:urlString, withPostData: postData,callBackBlock:{ (resetPassswordMsg:String?, error:NSError?) in
            
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
            
            guard let apiResponse = resetPassswordMsg else{
                
                print("Empty response")
                return
                
            }
            
            guard apiResponse == "password updated successfully" else{
                
                print("Error:Passwrd not updated")
                
                //Show error message that passwrd not updated successfully
                let alertController = singleTon.sharedInstance.displayAlert(message: "Error:Password not updated!", title: "Fiturb")
                
                self.present(alertController, animated: true, completion: nil)

                return
                
            }
            
            print("Password updated successfully")
            
            //Remove all sub views added on login view controller
            self.forgetPasswordViewControllerViewAdress?.removeFromSuperview()
            
        })
        
    }
   
}
