//
//  SignUpViewController.swift
//  Fiturb
//
//  Created by Admin on 03/03/17.
//  Copyright © 2017 Fiturb.DATAPPS. All rights reserved.
//

import UIKit
import FBSDKLoginKit

class SignUpViewController: UIViewController,UITextFieldDelegate,UIGestureRecognizerDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,navigateProtocol {
    
    //Outlets
    
    @IBOutlet weak var faceBookImage: UIImageView!
    
    @IBOutlet weak var dateOfBirthImage: UIImageView!
    
    @IBOutlet weak var lastNameImage: UIImageView!
    
    @IBOutlet weak var firstNameImage: UIImageView!
    
    @IBOutlet weak var passwordImage: UIImageView!
    
    @IBOutlet weak var emailImage: UIImageView!
    
    @IBOutlet weak var mobileImage: UIImageView!
    //Scroll view object
    @IBOutlet weak var scrollViewOutlet: UIScrollView!
    
    var activeField: UITextField?

    @IBOutlet weak var SubViewForLoginBtn: UIView!
    
    @IBOutlet weak var termsAndConditionTextView: UITextView!
    
    @IBOutlet weak var termsAndConditionButton: UIButton!
    
    @IBOutlet weak var mrButton: UIButton!
    
    @IBOutlet weak var mrsButton: UIButton!
    
    @IBOutlet weak var dateOfBirthTextFiled: ACFloatingTextfield!
    
    @IBOutlet weak var mobileNmbrTextField: ACFloatingTextfield!
    
    @IBOutlet weak var emailTextField: ACFloatingTextfield!
    
    @IBOutlet weak var passwordTextField: ACFloatingTextfield!
    
    @IBOutlet weak var firstNameTextField: ACFloatingTextfield!
    
    @IBOutlet weak var lastNameTextField: ACFloatingTextfield!
    
    @IBOutlet weak var thirdSubView: UIView!
    
    var datePicker:UIDatePicker!
    
    var isButtonChecked:Bool = false
    
    var tapTerm:UITapGestureRecognizer = UITapGestureRecognizer()
    
    var apiResponseRecievedArray = [AnyObject?]()
    
    var pickerImage:UIImagePickerController? = UIImagePickerController()

    @IBOutlet weak var profilePicImageView: UIImageView!

    var popover:UIPopoverController?=nil

    var base64StringFormat:String?
    
    public var  verifyOtpView:VerifyOtpViewController!

    //MARK:- Life Cycle Methods
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        pickerImage?.delegate = self

        //password text field secure text entry
        self.passwordTextField.isSecureTextEntry = true
        
        //Image picker method
        GesturesMethods()
        
        //Date picker method
        self.datePickerMethod()
        
    

    }

    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        
        //FontAwesome Images
        
        self.materialDesignForFontAwesomeImages()
        
        //ImageCorner Radius
        profilePicImageView.layer.cornerRadius = (profilePicImageView.frame.width/2)
        profilePicImageView.clipsToBounds = true
        
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
        //self.setScrollViewContentSize()

    }

    //MARK:- API Methods
    func signUpPostService() -> Void {
        
        
        //Add Loader
        MBProgressHUD.showAdded(to: self.view, withScreenHeaderHeigth: 0.0, animated: true)

        //Profile Pic base64 string format checking
        if base64StringFormat == nil {
            
            let profileImage = self.profilePicImageView.image != nil ? self.profilePicImageView.image : UIImage(named: "AppLogoImage")
            
            base64StringFormat = singleTon.sharedInstance.convertImageToBase64EncodingFormat(image: profileImage!)
            
        }
        
        //Append base64 string with text string
        var profilePicBase64StringFormatWithString:String?

        if (base64StringFormat != nil) {
            
            profilePicBase64StringFormatWithString = "data:image/png;base64,"+base64StringFormat!
            
        }

        //Gender text
        let genderTextString = (mrButton.isSelected ? "Male" : (mrsButton.isSelected ? "Female" : ""))
        
        //validate email text
        let validateEmail = (singleTon.sharedInstance.isValidEmail(testStr: self.emailTextField.text!) ? self.emailTextField.text! : "")
        
        //validate mobile number
        let validatePhoneNumber = ((self.mobileNmbrTextField.text?.validPhoneNumber)! ? self.mobileNmbrTextField.text! : "")
        
         //Post data
         let postData = ["birthday":self.dateOfBirthTextFiled.text!,"email":validateEmail,"first_name":firstNameTextField.text!,"gender":genderTextString,"last_name":lastNameTextField.text!,"middle_name":"","mobile":validatePhoneNumber,"name":"","password":passwordTextField.text!,"profile_pic":profilePicBase64StringFormatWithString!] as Dictionary<String, String>
        
//        //Post data
//        let postData = ["birthday":self.dateOfBirthTextFiled.text!,"email":validateEmail,"first_name":firstNameTextField.text!,"gender":genderTextString,"last_name":lastNameTextField.text!,"middle_name":"","mobile":validatePhoneNumber,"name":"","password":passwordTextField.text!,"profile_pic":""] as Dictionary<String, String>
        
        ApiDataManager.singleTonObjectForApiManagerClass.getSignUpApiValuesWithUrlString(urlString: MyAppConstants.SignUpUrlString, withPostData: postData as Dictionary<String, AnyObject>) { (apiRecievedResponse:Array?, error:NSError?) in
            
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
            
            //Store recieved response
            self.apiResponseRecievedArray = apiRecievedResponse!
            
            let tempObj = self.apiResponseRecievedArray[0] as! SignUpModelClass
            
            print("Sign up api model object elements are: msg:\(tempObj.registrationMessage!),firstName:\(tempObj.userFirstName!),mobileNumber:\(tempObj.userMobileNumber!),email:\(tempObj.userEmail!)")

            //Display Verify OTP Password screen as pop up
            self.displayVerifyOtpPopScreen()
            
        }
        
    }

    func signUpWithFaceBookAccount(faceBookData:AnyObject?) -> Void {
        
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
            
            //Store recieved response
            self.apiResponseRecievedArray = apiRecievedResponse!
            
            let tempObj = self.apiResponseRecievedArray[0] as! SocialContainerModel
            
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
            
            print("Facebook Sign up api model object elements: msg:\(tempObj.registrationMessage!),firstName:\(tempObj.userFirstName!),mobileNumber:\(tempObj.userMobileNumber!),email:\(tempObj.userEmail!),userAuthetication token:\(tempObj.userAuthenticationToken!),\(tempObj.cityName),\(tempObj.isCityNameUpdated)")
            
            //Navigate to Accounts view controller
            self.actitvityViewController(cityNameText: tempObj.cityName)

        }

    }
    
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
        let validateEmail = (singleTon.sharedInstance.isValidEmail(testStr: self.emailTextField.text!) ? self.emailTextField.text! : "")
        
        //validate mobile number
        let validatePhoneNumber = ((self.mobileNmbrTextField.text?.validPhoneNumber)! ? self.mobileNmbrTextField.text! : "")
        
        //Post Data
        let postData = ["email":validateEmail, "mobile":validatePhoneNumber,
                        "password":passwordTextField.text!, "device_id":device_ID, "device_os":deviceOS, "fcm_token":"123456", "os_version":currentDeviceOSVersion] as Dictionary<String, String>
        
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
            
            self.apiResponseRecievedArray = apiRecievedResponse!
            
            let tempRecievedResponse = apiRecievedResponse?[0] as! LoginModel
            
            print("Login api model object eleents are:\(tempRecievedResponse.message!),\(tempRecievedResponse.email!),\(tempRecievedResponse.mobileNumber!),\(tempRecievedResponse.token!),\(tempRecievedResponse.userID!),\(tempRecievedResponse.firstName!),\(tempRecievedResponse.lastName!), and Authetication token is:\(tempRecievedResponse.token!),\(tempRecievedResponse.cityName),\(tempRecievedResponse.isCityNameUpdated)")
            
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
                self.actitvityViewController(cityNameText: tempRecievedResponse.cityName)
                
            }
            else{
                
                print("Mobile is not verified")
                
            }
            
        }
        
    }
    
    //MARK:- IBAction Methods
    @IBAction func faceBookButtonPressed(_ sender: Any)
    {
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
            
            if (error == nil)
            {
                
                let fbloginresult : FBSDKLoginManagerLoginResult = result!
                
                if fbloginresult.grantedPermissions != nil
                {
                    
                    if(fbloginresult.grantedPermissions.contains("email"))
                    {
                        self.getFBUserData()
                        
                    }
                }
            }
        }

    }
    
   
    @IBAction func mrsButtonAction(_ sender: UIButton) {
        
        let RadioButtonforMrs:UIButton = sender
        
        self.radiobuttonActionforMrs(RadioButtonforMrs)
    }
    
    
    @IBAction func mrButtonAction(_ sender: UIButton) {
        
        let RadioButtonforMr:UIButton = sender
        self.radiobuttonActionforMr(RadioButtonforMr)
    }
    
    
    @IBAction func termsAndConditionButtonAction(_ sender: UIButton) {
        
        sender.isSelected = !sender.isSelected
        if(sender.isSelected == true)
        {
            isButtonChecked = true
            sender.setImage(UIImage(named:"CheckBox"), for: UIControlState.selected)
            
        }
        else
        {
            isButtonChecked = false
            sender.setImage(UIImage(named:"CheckBoxEmpty"), for: UIControlState.normal)
            
        }
        
    }
    
    
    @IBAction func signUpButtonPressed(_ sender: UIButton) {
        
        //Post service method
        self.signUpPostService()
    
    }

    
    //MARK:- Private Methods
    //FacebookGeting Detailes
    
    func getFBUserData(){
        if((FBSDKAccessToken.current()) != nil)
        {
            FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "id, name, first_name, last_name, picture.type(large), email,gender"]).start(completionHandler:
                {
                    (connection, result, error) -> Void in
                    if (error == nil)
                    {
                        let dict = result as! [String : AnyObject]
                        
                        print(dict)
                        
                        self.signUpWithFaceBookAccount(faceBookData: dict as AnyObject)
                        
                    }
            })
        } 
    }

    
    func radiobuttonActionforMrs(_ Button: UIButton) {
        
        if !Button.isSelected
        {
            Button.isSelected = true
            Button.setImage(UIImage(named: "RadioCheckBtnImage"), for: .selected)
            
            self.mrButton.setImage(UIImage(named: "RadioUnCheckBtnImage"), for: .selected)
            self.mrButton.isSelected = false
        }
        else {
            Button.isSelected = false
            Button.setImage(UIImage(named: "RadioUnCheckBtnImage"), for: .normal)
            
        }
        
    }
    
    func radiobuttonActionforMr(_ Button: UIButton) {
        if !Button.isSelected
        {
            Button.isSelected = true
            Button.setImage(UIImage(named: "RadioCheckBtnImage"), for: .selected)
            
            self.mrsButton.setImage(UIImage(named: "RadioUnCheckBtnImage"), for: .selected)
            self.mrsButton.isSelected = false
        }
        else {
            Button.isSelected = false
            Button.setImage(UIImage(named: "RadioUnCheckBtnImage"), for: .normal)
        }
    }
    
    
    func GesturesMethods()
    {
        
        let imageGesture = UITapGestureRecognizer(target: self, action: #selector(SignUpViewController.tappedImageView))
        
        profilePicImageView.addGestureRecognizer(imageGesture)
        profilePicImageView.isUserInteractionEnabled = true
        
        let textViewGesture = UITapGestureRecognizer(target: self, action: #selector(SignUpViewController.tapTextView))
        
        termsAndConditionTextView.addGestureRecognizer(textViewGesture)
        termsAndConditionTextView.isUserInteractionEnabled = true
        
        
    }
    
    
    func tappedImageView()
    {
        
        
        let alert:UIAlertController=UIAlertController(title: "Choose Image", message: nil, preferredStyle: UIAlertControllerStyle.actionSheet)
        
        let cameraAction = UIAlertAction(title: "Camera", style: UIAlertActionStyle.default)
        {
            UIAlertAction in
            self.openCamera()
            
        }
        let gallaryAction = UIAlertAction(title: "Gallary", style: UIAlertActionStyle.default)
        {
            UIAlertAction in
            self.openGallary()
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel)
        {
            UIAlertAction in
            
        }
        
        // Add the actions
        alert.addAction(cameraAction)
        alert.addAction(gallaryAction)
        alert.addAction(cancelAction)
        // Present the controller
        if UIDevice.current.userInterfaceIdiom == .phone
        {
            self.present(alert, animated: true, completion: nil)
        }
        else
        {
            popover=UIPopoverController(contentViewController: alert)
            popover!.present(from: profilePicImageView.frame, in: self.view, permittedArrowDirections: UIPopoverArrowDirection.any, animated: true)
            
        }
        
    }
    
    
    func tapTextView() -> Void {
        
        
        
    }
    
    func displayVerifyOtpPopScreen() -> Void {
        
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        self.verifyOtpView = storyboard.instantiateViewController(withIdentifier: "VerifyOtpViewController") as! VerifyOtpViewController
        
        //Send Login Model object to verify Otp scree
        if self.apiResponseRecievedArray[0] != nil {
            
            let modelObj = self.apiResponseRecievedArray[0] as! SignUpModelClass
            self.verifyOtpView.userEmail = modelObj.userEmail
            self.verifyOtpView.userMobileNumber = modelObj.userMobileNumber
        }
        
        //set up navigate protcol delegate
        self.verifyOtpView.navigateDelegate = self
        
        self.verifyOtpView.view.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height)
        
        self.view.addSubview(self.verifyOtpView.view)
    }
    
    //MARK:- Date picker methods
    //datepicker methods
    
    func datePickerMethod()
    {
        datePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        self.dateOfBirthTextFiled.inputView = datePicker
        let toolBarforDob = UIToolbar(frame: CGRect(x: CGFloat(0), y: CGFloat(0), width: CGFloat(320), height: CGFloat(44)))
        toolBarforDob.tintColor = UIColor.gray
        let doneBtnforDob = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(self.showSelectedDate))
        
        
        let cancelBtnforDob = UIBarButtonItem(title: "Cancel", style: .done, target: self, action: #selector(cancel_clicked))
        
        let spaceforDob = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        toolBarforDob.items = [cancelBtnforDob, spaceforDob, doneBtnforDob]
        self.dateOfBirthTextFiled.inputAccessoryView = toolBarforDob
    }
    func showSelectedDate()
    {
        
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MM-yyyy"
        self.dateOfBirthTextFiled.text = formatter.string(from: datePicker.date)
        
        self.view.endEditing(true)
        
    }
    func cancel_clicked()
    {
        
        dateOfBirthTextFiled.text = ""
        
        self.view.endEditing(true)

      
        
    }
    
    func materialDesignForFontAwesomeImages()
    {
        
        
        mobileImage.image = UIImage.fontAwesomeIcon(name: .mobile, textColor: UIColor.black, size: CGSize(width: 20, height: 20))
        
        emailImage.image = UIImage.fontAwesomeIcon(name: .envelopeO, textColor: UIColor.black, size: CGSize(width: 20, height: 20))
        
        passwordImage.image = UIImage.fontAwesomeIcon(name: .lock, textColor: UIColor.black, size: CGSize(width: 20, height: 20))
        
        firstNameImage.image = UIImage.fontAwesomeIcon(name: .user, textColor: UIColor.black, size: CGSize(width: 20, height: 20))
        
        lastNameImage.image = UIImage.fontAwesomeIcon(name: .user, textColor: UIColor.black, size: CGSize(width: 20, height: 20))
        
        dateOfBirthImage.image = UIImage.fontAwesomeIcon(name: .calendar, textColor: UIColor.black, size: CGSize(width: 20, height: 20))
    
    }
    
    
    //MARK:- ImagePicker Delegate Methods
    
    func openCamera()
    {
        if(UIImagePickerController .isSourceTypeAvailable(UIImagePickerControllerSourceType.camera))
        {
            pickerImage!.sourceType = UIImagePickerControllerSourceType.camera
            self .present(pickerImage!, animated: true, completion: nil)
        }
        else
        {
            openGallary()
            
        }
    }
    
    func openGallary()
    {
        pickerImage!.sourceType = UIImagePickerControllerSourceType.photoLibrary
        
        if UIDevice.current.userInterfaceIdiom == .phone
        {
            self.present(pickerImage!, animated: true, completion: nil)
        }
        else
        {
            popover=UIPopoverController(contentViewController: pickerImage!)
            
            popover!.present(from: profilePicImageView.frame, in: self.view, permittedArrowDirections: UIPopoverArrowDirection.any, animated: true)
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any])
    {
        picker .dismiss(animated: true, completion: nil)
    
        //Set selected image
        self.profilePicImageView.image = info[UIImagePickerControllerOriginalImage] as? UIImage
        
        //Set base 64 string format to nil
        if base64StringFormat != nil{
            
            base64StringFormat = nil
        }
        
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController)
    {
        dismiss(animated: true, completion: nil)
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
      
        //Call Login Api method
        self.loginPostService()

    }
    
    //MARK:- Navigation Methods
    func actitvityViewController(cityNameText: String?) -> Void {
        
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        
        let newViewController = storyBoard.instantiateViewController(withIdentifier: "UITabBarController") as? UITabBarController
        
        //Activity controller index is zero
        newViewController?.selectedIndex = 0
        
        //Set city name
        (newViewController?.viewControllers?[0] as? ActivityViewController)?.userCityNameText = cityNameText
        
        self.navigationController?.pushViewController(newViewController!, animated: false)
    }
    
}
