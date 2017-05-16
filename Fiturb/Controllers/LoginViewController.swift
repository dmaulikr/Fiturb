//
//  LoginViewController.swift
//  Fiturb
//
//  Created by Admin on 01/03/17.
//  Copyright © 2017 Fiturb.DATAPPS. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import Font_Awesome_Swift

class LoginViewController: UIViewController,navigateProtocol
{

    public var  forgotView:ForgotPasswordViewController!

    //Outlets
    
    //Scroll view object
    @IBOutlet weak var scrollViewOutlet: UIScrollView!

    var activeField: UITextField?

    /**Main First Sub View**/
    @IBOutlet weak var firstSubView: UIView!
    
    @IBOutlet weak var appLogoImageView: UIImageView!

    //SubView one(1) Inside First Sub View
    @IBOutlet weak var subViewOneInsideFirstSubView: UIView!
    
    @IBOutlet weak var facebookLoginBtn: UIButton!

    @IBOutlet weak var facebookIconImageView: UIImageView!
    
    //SubView Two(2) Inside First Sub View
    @IBOutlet weak var subViewTwoInsideFirstSubView: UIView!
    
    @IBOutlet weak var singleLineLabel: UILabel!
    
    @IBOutlet weak var orTextLabel: UILabel!
    
    
    /***Main Second  Sub View**/
    @IBOutlet weak var secondSubView: UIView!
    
    @IBOutlet weak var emailOrMobileEnterTextField: UITextField!
    
    @IBOutlet weak var passwordEnterTextField: UITextField!
    
    @IBOutlet weak var forgetPasswordButton: UIButton!
    
    
    /***Main Third Sub view***/
    @IBOutlet weak var thirdSubView: UIView!
    
    @IBOutlet weak var lginBtnOutlet: UIButton!
    
    //SubView one(1) Inside Third Sub View
    @IBOutlet weak var subViewOneInsideThirdSubView: UIView!
    
    @IBOutlet weak var notMemberYetTextLabel: UILabel!
    
    @IBOutlet weak var signUpNowButton: UIButton!
    
    public var  verifyOtpView:VerifyOtpViewController!
    
    var loginApiResponseRecievedArray = [AnyObject?]()
    
    var socialContainerApiResponseRecievedArray = [AnyObject?]()
    
    //MARK:- Life Cylcle Methods
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.navigationController?.isNavigationBarHidden = true
     
        //password text field secure text entry
        self.passwordEnterTextField.isSecureTextEntry = true

    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        
        self.registerForKeyboardNotifications()
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        
        super.viewWillDisappear(animated)
        
        self.deregisterFromKeyboardNotifications()
    }
    
     override func viewWillLayoutSubviews()
    {
      
        super.viewWillLayoutSubviews()
        
        //Scroll view content size
        self.setScrollViewContentSize()
        
    }
    
    
    //MARK:- API Methods
    func loginPostService() -> Void {
        
        //Add Loader
        MBProgressHUD.showAdded(to: self.view, withScreenHeaderHeigth: 0.0, animated: true)
        
        //Device id
        let device_ID = UIDevice.current.identifierForVendor!.uuidString

        //Device OS
        let deviceOS = UIDevice.current.systemName
        
        //Device OS version
        let currentDeviceOSVersion = singleTon.TheCurrentDeviceVersion

        //validate email text
        let validateEmail = (singleTon.sharedInstance.isValidEmail(testStr: self.emailOrMobileEnterTextField.text!) ? self.emailOrMobileEnterTextField.text! : "")
        
        //validate mobile number
        let validatePhoneNumber = ((self.emailOrMobileEnterTextField.text?.validPhoneNumber)! ? self.emailOrMobileEnterTextField.text! : "")
        
        //Post Data
        let postData = ["email":validateEmail, "mobile":validatePhoneNumber,
                        "password":passwordEnterTextField.text!, "device_id":device_ID, "device_os":deviceOS, "fcm_token":"123456", "os_version":currentDeviceOSVersion] as Dictionary<String, String>
        
        print("post data is:\(postData)")
        
        ApiDataManager.singleTonObjectForApiManagerClass.getLoginApiValuesWithUrlString(urlString: MyAppConstants.loginUrlString, withPostData: postData as Dictionary<String, AnyObject>) { (apiRecievedResponse:Array?, error:NSError?) in
            
            //Remove Loader
            MBProgressHUD.hide(for: self.view, animated: true)
            
            guard error == nil else{
                
                //Error handling
                print("Error recieved from sign up api is:\(error!.localizedFailureReason!)")
            
                //Dsiplay alert
                let alertController = singleTon.sharedInstance.displayAlert(message: (error!.localizedFailureReason!), title: "Fiturb")
                self.present(alertController, animated: true, completion: nil)
                
                return
            }
            
            self.loginApiResponseRecievedArray = apiRecievedResponse!
            
            let tempRecievedResponse = apiRecievedResponse?[0] as! LoginModel
            
            print("Login api model object eleents are:\(tempRecievedResponse.message!),\(tempRecievedResponse.email!),\(tempRecievedResponse.mobileNumber!),\(tempRecievedResponse.token!),\(tempRecievedResponse.userID!),\(tempRecievedResponse.firstName!),\(tempRecievedResponse.lastName!),\(tempRecievedResponse.interestCount!), and Authetication token is:\(tempRecievedResponse.token!),\(tempRecievedResponse.cityName),\(tempRecievedResponse.isCityNameUpdated)")
            
            //Store Token ID by using NSUSerDefaults 
            if let userAuthenticationToken = (tempRecievedResponse.token){
                
                UserDefaults.standard.set(userAuthenticationToken, forKey: "userAuthenticationToken")
                
            }
            else{
                
                UserDefaults.standard.set("", forKey: "userAuthenticationToken")
            }
            
            //Store User Id by usgin NSUserFDefaults
            if let userId = (tempRecievedResponse.userID){
                
                UserDefaults.standard.set(userId, forKey: "UserID")
            }
            else{
                
                UserDefaults.standard.set("", forKey: "UserID")
            }
            
            //set interest count is added or not
            if tempRecievedResponse.interestCount == "0"{
                
                //set User Defaults isUserInterestsAdded Key to False
                UserDefaults.standard.set(false, forKey:"isUserInterestsAdded")
            }
            else{
                
                //set User Defaults isUserInterestsAdded Key to True
                UserDefaults.standard.set(true, forKey:"isUserInterestsAdded")
                
            }
            
            //Check user location updated or not
            if tempRecievedResponse.isCityNameUpdated{
                
                //set User Defaults isUserLocationUpdated Key to True
                UserDefaults.standard.set(true, forKey:"isUserLocationUpdated")

            }
            else{
                
                //set User Defaults isUserLocationUpdated Key to False
                UserDefaults.standard.set(false, forKey:"isUserLocationUpdated")
            }
            
                guard tempRecievedResponse.message! != "missing parameters" else{
                    
                    print("not moving to account view controller")
                    
                    return
                }
                
                if (tempRecievedResponse.emailVerfied || tempRecievedResponse.mobileVerified){
                    
                    //Move to Accounts view controller
                    self.performSegue(withIdentifier: "AccountScreenID", sender:"loginModelObj")
                    
                }
                else{
                    
                    //Call Sent OTP api method
                    self.sentOtpApiMethod()
                }
            
            
            
            
//            //Dsiplay alert
//            let alertController = singleTon.sharedInstance.displayAlert(message: (tempRecievedResponse.message!) as! String, title: "Fiturb")
//            self.present(alertController, animated: true, completion: nil)
//
//            // Removing alert after 3 seconds
//            let delayTime = DispatchTime.now() + 2
//            DispatchQueue.main.asyncAfter(deadline: delayTime){
//                
//                //Dimsmiss alert after 3 seconds
//                alertController.dismiss(animated: true, completion: nil)
//                
//                guard tempRecievedResponse.message! as! String != "missing parameters" else{
//                    
//                    print("not moving to account view controller")
//                    
//                    return
//                }
//                
//                if (tempRecievedResponse.emailVerfied || tempRecievedResponse.mobileVerified){
//                    
//                    //Move to Accounts view controller
//                    self.performSegue(withIdentifier: "AccountScreenID", sender: nil)
//                    
//                }
//                else{
//                    
//                    //Call Sent OTP api method
//                    self.sentOtpApiMethod()
//                }
//                
//            }
            

        }
        
    }
    
    func loginWithFaceBookAccount(faceBookData:AnyObject?) -> Void {
        
        //Add Loader
        MBProgressHUD.showAdded(to: self.view, withScreenHeaderHeigth: 0.0, animated: true)

        //FaceBook Id
        let faceBookId = faceBookData?["id"] as? String
        
        //User name
        let userName = faceBookData?["name"] as? String
        
        
        //FCM Token
        let fcmToken = ""
        
        //Gender
        let gender = faceBookData?["gender"] as? String
        
        
        //Device ID
        let device_ID = UIDevice.current.identifierForVendor!.uuidString
        
        //Device OS
        let deviceOS = UIDevice.current.systemName
        
        //Device OS version
        let currentDeviceOSVersion = singleTon.TheCurrentDeviceVersion
        
        //Mobile Number
        let mobileNumber = ""
        
        //email ID
        let emailID = faceBookData?["email"] as? String
        
        
        //Profile pic
        let ProfilePic = ""
        
        //Pic Url
        let picUrl = (((faceBookData?["picture"] as? NSDictionary)?["data"] as? NSDictionary)?["url"] as? String)
        
        //Post data
        let postData = ["facebook_id":faceBookId!,"email":emailID!,"name":userName!,"gender":gender!,"fcm_token":fcmToken,"device_id":device_ID,"mobile":mobileNumber,"profile_pic":ProfilePic,"device_os":deviceOS,"os_version":currentDeviceOSVersion,"pic_url":picUrl!,"google_id":""] as Dictionary<String, String>
        
        print("Post data is:\(postData)")
        
        ApiDataManager.singleTonObjectForApiManagerClass.getSignUpOrLoginApiValuesWithUrlStringForSocialContainerFacebook(urlString: MyAppConstants.socialAunthenticationUrl, withPostData: postData as Dictionary<String, AnyObject>) { (apiRecievedResponse:Array?, error:NSError?) in
            
            //Remove Loader
            MBProgressHUD.hide(for: self.view, animated: true)
            
            guard error == nil else{
                
                //Error handling
                print("Error recieved from sign up api is:\(error!.localizedFailureReason!)")
                
                //Dsiplay alert
                let alertController = singleTon.sharedInstance.displayAlert(message: (error!.localizedFailureReason!), title: "Fiturb")
                self.present(alertController, animated: true, completion: nil)
                
                return
            }
            
            self.socialContainerApiResponseRecievedArray = apiRecievedResponse!

            let tempObj = apiRecievedResponse?[0] as! SocialContainerModel
            
            //Store Token ID by using NSUSerDefaults
            if let userAuthenticationToken = (tempObj.userAuthenticationToken){
                
                UserDefaults.standard.set(userAuthenticationToken, forKey: "userAuthenticationToken")
                
            }
            else{
                
                UserDefaults.standard.set("", forKey: "userAuthenticationToken")
            }
            
            //Store User Id by usgin NSUserFDefaults
            if let userId = (tempObj.userID){
                
                UserDefaults.standard.set(userId, forKey: "UserID")
            }
            else{
                
                UserDefaults.standard.set("", forKey: "UserID")
            }
            
            //set interest count is added or not
            if tempObj.interestCount == "0"{
                
                //set User Defaults isUserInterestsAdded Key to False
                UserDefaults.standard.set(false, forKey:"isUserInterestsAdded")
            }
            else{
                
                //set User Defaults isUserInterestsAdded Key to True
                UserDefaults.standard.set(true, forKey:"isUserInterestsAdded")
                
            }
            
            //Check user location updated or not
            if tempObj.isCityNameUpdated{
                
                //set User Defaults isUserLocationUpdated Key to True
                UserDefaults.standard.set(true, forKey:"isUserLocationUpdated")
                
            }
            else{
                
                //set User Defaults isUserLocationUpdated Key to False
                UserDefaults.standard.set(false, forKey:"isUserLocationUpdated")
            }
            
            print("Facebook login api model object elements: msg:\(tempObj.registrationMessage!),firstName:\(tempObj.userFirstName!),mobileNumber:\(tempObj.userMobileNumber!),email:\(tempObj.userEmail!),userAuthetication token:\(tempObj.userAuthenticationToken!),\(tempObj.cityName),\(tempObj.isCityNameUpdated)")
            
            //Navigate to Accounts view controller
            self.performSegue(withIdentifier: "AccountScreenID", sender: "SocialContainerModelObj")

        }
        
    }

    func sentOtpApiMethod() -> Void {
        
        //Add Loader
        MBProgressHUD.showAdded(to: self.view, withScreenHeaderHeigth: 0.0, animated: true)
        
        let tempModelObj = self.loginApiResponseRecievedArray[0]! as! LoginModel
        
        let dict: Dictionary<String,String>
        
        if (tempModelObj.emailVerfied!){
            
            //Email
            dict = ["email":emailOrMobileEnterTextField.text!]
            
        }
        else{
            
            //Mobile number
            dict = ["mobile":self.emailOrMobileEnterTextField.text!]
            
        }
        
        //Post data
        let postData = dict as Dictionary<String, String>
        
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
                
                return
                
            }
            
            guard let apiResponse = otpSentApiRecievedResponse else{
                
                print("Empty response")
                return
                
            }
            
            guard apiResponse == "otp sent successfully" else{
                
                return
                
            }
            
            //Display Verify OTP Password screen as pop up
            self.displayVerifyOtpPopScreen()
            
        })
        
    }

    
    //MARK:- IBAction Methods
    @IBAction func facebookButtonPressed(_ sender: Any) {
        if (FBSDKAccessToken.current() != nil)
        {
            // User is already logged in, do work such as go to next view controller.
            print("already logged in ")
            self.getFBUserData()
            
            return
        }
        
        
        let fbLoginManager : FBSDKLoginManager = FBSDKLoginManager()
        fbLoginManager.logIn(withReadPermissions: ["email"], from: self)
        { (result, error) in
            if (error == nil){
                let fbloginresult : FBSDKLoginManagerLoginResult = result!
                
                if fbloginresult.grantedPermissions != nil
                {
                    if(fbloginresult.grantedPermissions.contains("email"))
                    {
                        self.getFBUserData()
                        // fbLoginManager.logOut()
                        
                    }
                }
            }
        }
        
    }
    
    
    @IBAction func forgotButtonPressed(_ sender: UIButton) {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        self.forgotView = storyboard.instantiateViewController(withIdentifier: "ForgotPasswordViewController") as! ForgotPasswordViewController
        
        self.forgotView.view.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height)
        
        self.view.addSubview(self.forgotView.view)
        
    }

    @IBAction func loginBtnPressedAction(_ sender: UIButton) {
        
        //Login api method
        self.loginPostService()
    }
    
    //MARK:- Private Methods
    
    //Geting facebook detailes
    func getFBUserData(){
        
        if((FBSDKAccessToken.current()) != nil){
            
            FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "id, name, first_name, last_name, picture.type(large), email,gender"]).start(completionHandler: { (connection, result, error) -> Void in
                if (error == nil){
                    
                    let dict = result as! [String : AnyObject]
                    
                    print("Facebook data is:\(dict)")
                    
                    //Method to login with facebook
                    self.loginWithFaceBookAccount(faceBookData: dict as AnyObject?)
                    
                }
            })
        }
    }

    
    func setScrollViewContentSize() -> Void {
        
        //Set Scroll view Content size
        var sizeOfContent: CGFloat = 0
        
        let yValueAndHeightOfSubView:CGFloat = (self.subViewOneInsideThirdSubView.frame.origin.y - self.subViewOneInsideThirdSubView.frame.size.height)
        
        let yValueAndHeightOfThirdSubView:CGFloat = (self.thirdSubView.frame.origin.y + self.thirdSubView.frame.size.height)
        
        sizeOfContent = yValueAndHeightOfThirdSubView - yValueAndHeightOfSubView
        
        scrollViewOutlet.contentSize = CGSize(width: self.view.bounds.size.width, height: sizeOfContent)
        
        
    }

    func displayVerifyOtpPopScreen() -> Void {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        self.verifyOtpView = storyboard.instantiateViewController(withIdentifier: "VerifyOtpViewController") as! VerifyOtpViewController
        
        //Send Login Model object to verify Otp scree
        if self.loginApiResponseRecievedArray[0] != nil {
            
            let modelObj = self.loginApiResponseRecievedArray[0] as! LoginModel
            self.verifyOtpView.userEmail = modelObj.email
            self.verifyOtpView.userMobileNumber = modelObj.mobileNumber
            
        }
        
        //set up navigate protcol delegate
        self.verifyOtpView.navigateDelegate = self
        
        self.verifyOtpView.view.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height)
        
        self.view.addSubview(self.verifyOtpView.view)
        
    }

   
    //MARK:- Remote Notification Methods
    func registerForKeyboardNotifications(){
        
        //Adding notifies on keyboard appearing
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWasShown(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillBeHidden(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    func deregisterFromKeyboardNotifications(){
        
        //Removing notifies on keyboard appearing
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
    }
    
    func keyboardWasShown(notification: NSNotification){
        
        //Need to calculate keyboard exact size due to Apple suggestions
        self.scrollViewOutlet.isScrollEnabled = true
        
        var info = notification.userInfo!
        
        let keyboardSize = (info[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue.size
        
        let contentInsets : UIEdgeInsets = UIEdgeInsetsMake(0.0, 0.0, keyboardSize!.height+20, 0.0)
        
        self.scrollViewOutlet.contentInset = contentInsets
        
        self.scrollViewOutlet.scrollIndicatorInsets = contentInsets
        
        var aRect : CGRect = self.view.frame
        
        aRect.size.height -= keyboardSize!.height
        
        if let activeField = self.activeField {
            
            if (!aRect.contains(activeField.frame.origin)){
                
                self.scrollViewOutlet.scrollRectToVisible(activeField.frame, animated: true)
                
            }
        }
        
    }
    
    func keyboardWillBeHidden(notification: NSNotification){
        
        let contentInset:UIEdgeInsets = UIEdgeInsets.zero
        
        self.scrollViewOutlet.contentInset = contentInset
        
        
        //        //Once keyboard disappears, restore original positions
        //        var info = notification.userInfo!
        //
        //        let keyboardSize = (info[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue.size
        //
        //        let contentInsets : UIEdgeInsets = UIEdgeInsetsMake(0.0, 0.0, -keyboardSize!.height, 0.0)
        //
        //        self.scrollViewOutlet.contentInset = contentInsets
        //
        //        self.scrollViewOutlet.scrollIndicatorInsets = contentInsets
        //
        //        self.view.endEditing(true)
        //        
        //        self.scrollViewOutlet.isScrollEnabled = false

    }
    
    
    //MARK:- Text Field Delegate Methods
    func textFieldDidBeginEditing(_ textField: UITextField){
        
        activeField = textField
        
    }
    
    func textFieldDidEndEditing(_ textField: UITextField){
        
        activeField = nil
        
    }
    
    //hide keyboard when user tapps on return key on the keyboard
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        self.view.endEditing(true);
        return false;
        
    }
    
    //MARK:- Verify OTP Controler protocol method
    func navigateToActivityViewController() -> Void{
        
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        
        let newViewController = storyBoard.instantiateViewController(withIdentifier: "UITabBarController") as! UITabBarController
        
        //Activity controller index is zero
        newViewController.selectedIndex = 0
        
        self.navigationController?.pushViewController(newViewController, animated: false)
        
    }

    //MARK:- Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if sender as? String == "loginModelObj"{
            
            //Login model Model object
            let loginModelObj = self.loginApiResponseRecievedArray[0] as? LoginModel
            
            if loginModelObj != nil{
                
                let tabBarController = segue.destination as? UITabBarController
                
                //Activity controller index is zero
                tabBarController?.selectedIndex = 0
                
                //Pass City name to activity controller
                (tabBarController?.viewControllers?[0] as? ActivityViewController)?.userCityNameText = loginModelObj?.cityName
                
            }

        }
        else if sender as? String == "SocialContainerModelObj"{
            
            //SocialContainerModel object
            let socialContainerModelObj = self.socialContainerApiResponseRecievedArray[0] as? SocialContainerModel
            
            if socialContainerModelObj != nil{
                
                let tabBarController = segue.destination as? UITabBarController
                
                //Activity controller index is zero
                tabBarController?.selectedIndex = 0
                
                //Pass City name to activity controller
                (tabBarController?.viewControllers?[0] as? ActivityViewController)?.userCityNameText = socialContainerModelObj?.cityName
                
            }
        }
        
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        
        if identifier == "AccountScreenID" {
            
            return false
            
        }else{
         
            return true

        }
    }
    
}
