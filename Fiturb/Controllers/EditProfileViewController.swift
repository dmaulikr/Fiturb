//
//  EditProfileViewController.swift
//  Fiturb
//
//  Created by DATAPPS on 4/21/17.
//  Copyright © 2017 Fiturb.DATAPPS. All rights reserved.
//

import UIKit

class EditProfileViewController: UIViewController,UITableViewDataSource,UITableViewDelegate,UIPickerViewDelegate,UIPickerViewDataSource,UIImagePickerControllerDelegate,UINavigationControllerDelegate,EditProfileTableViewCellProtocol {
    
    var editProfileCell:EditProfileTableViewCell!
    
     var pickerImage:UIImagePickerController? = UIImagePickerController()
    
     var datePicker:UIDatePicker!
    //Gender picker
    var genderPicker:UIPickerView!
    //Country Picker
    var countryPicker:UIPickerView!
    //State Picker
    var statePicker:UIPickerView!
    //City Picker
    var cityPicker:UIPickerView!
    
    //Image base 64 string format
    var base64StringFormat:String?

    let genderNames = ["Male","Female"]
    let countryNames = ["india","US"]
    let stateNames = ["bangalore","AP"]
    let cityNames = ["Kurnool","Nandyal"]
    
    //MARK:- Life cycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        pickerImage!.delegate = self

    }
    
    //MARK:- Protocol Methods(for editProfileApi Api)
    func editProfileApi(customCellAdress:EditProfileTableViewCell?, callBackBlock completionHandler:@escaping(_ responseMessage:String?,_ error:Error?) -> ()) -> Void{
        
        //Add Loader
        MBProgressHUD.showAdded(to: self.view, withScreenHeaderHeigth: 0.0, animated: true)
        
        //Edit user profile url
        let urlString = String(format: "%@%@", MyAppConstants.baseUrlString,MyAppConstants.editUserProfileUrl)
        
//        //first name
//        let firstNameText = "Keshav"
//        
//        //last name
//        let lastNameText = "M B"
//        
//        //BirthDay Date
//        let birthDayDate = "22-01-1993"
//        
//        //gender
//        let genderText = "male"
//        
//        //City text
//        let cityText = "Shimoga"
//        
//        //State
//        let stateText = "Karnataka"
//        
//        //Country
//        let countryText = "India"
//        
//        //Profile pic
//        let profilePictureUrl = ""
        
        //first name
        let firstNameText = customCellAdress?.firstNameTextField.text ?? ""
        
        //last name
        let lastNameText = customCellAdress?.lastNameTextField.text ?? ""
        
        //BirthDay Date
        let birthDayDate = customCellAdress?.birthdayTextField.text ?? ""
        
        //gender
        let genderText = customCellAdress?.genderTextField.text ?? ""
        
        //City text
        let cityText = customCellAdress?.cityTextField.text ?? ""
        
        //State
        let stateText = customCellAdress?.stateTextField.text ?? ""
        
        //Country
        let countryText = customCellAdress?.countryTextField.text ?? ""
        
        //Profile pic        
        //Profile Pic base64 string format checking
        if base64StringFormat == nil {
            
            let profileImage = customCellAdress?.userProfileImageView.image != nil ? customCellAdress?.userProfileImageView.image : UIImage(named: "AppLogoImage")
            
            base64StringFormat = singleTon.sharedInstance.convertImageToBase64EncodingFormat(image: profileImage!)
            
        }
        
        //Append base64 string with text string
        var profilePicBase64StringFormatWithString:String?
        
        if (base64StringFormat != nil) {
            
            profilePicBase64StringFormatWithString = "data:image/png;base64,"+base64StringFormat!
            
        }

        //let PostData
        let postdata = ["first_name":firstNameText,
                        "last_name":lastNameText,
                        "birthday":birthDayDate,
                        "profile_pic":profilePicBase64StringFormatWithString,
                        "gender":genderText,
                        "city":cityText,
                        "state":stateText,
                        "country":countryText]
        
        ApiDataManager.singleTonObjectForApiManagerClass.editUserProfileApiValuesWithUrlString(urlString: urlString, withPostData: postdata as! Dictionary<String, String> ,callBackBlock: { (apiRecievedResponse:Array?, error:NSError?) in
            
            //Remove Loader
            MBProgressHUD.hide(for: self.view, animated: true)
            
            guard error == nil else{
                
                //Call Back for error
                DispatchQueue.main.async(execute: {
                    completionHandler(nil,error)
                })

                //Error handling
                print("Error recieved from edit user profile request api is:\(error!.localizedFailureReason!)")
                
                //Dsiplay alert
                let alertController = singleTon.sharedInstance.displayAlert(message: (error!.localizedFailureReason!), title: "Fiturb")
                self.present(alertController, animated: true, completion: nil)
                
                return
                
            }
            
            
            if apiRecievedResponse?.count != 0{
                
                let modelObj = apiRecievedResponse?[0] as! EditUserProfileModel
                
                print("edit user profile values are:\(modelObj.message!)")
                
                //Display alert
                    let alert = UIAlertController(title: "Fiturb",
                                                  message: modelObj.message,
                                                  preferredStyle: .alert)
                    
                    alert.addAction(UIAlertAction(title: "Ok", style: .default,handler:{ action -> Void in
                        
                        if modelObj.message == "profile edited successfully"{
                            
                            //Pop up back to previous screen after prssing ok
                            self.popUpBackToPreviousScreen()
                        }
                        
                    }))
                    self.present(alert, animated: true, completion: nil)

                //Call Back for success
                DispatchQueue.main.async(execute: {
                    completionHandler(modelObj.message,nil)
                })
                
            }
        })
        
    }
    
    //MARK:- UITableview Delegate Methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
         editProfileCell = tableView.dequeueReusableCell(withIdentifier: "EditProfileTableViewCell", for: indexPath) as? EditProfileTableViewCell
        
        //Set delegate object
        editProfileCell.editProfileTableViewCellDelegate = self
        
        //ImageViewGesturesMethods
        self.GesturesMethods()

        self.datePickerMethod()
    
        self.genderPickerMethod()
        
        self.countryPickerMethod()
        
        self.statePickerMethod()
        
        self.cityPickerMethod()
        
        return editProfileCell
    }
    
    //MARK:- UITableview Delegate Methods
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 548
    }
    
    //MARK:- UITextFiled Delegate Methods
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        
        return true
    }
    
    //MARK:- IBActions
    @IBAction func backBtnAction(_ sender: UIButton) {
        
        self.popUpBackToPreviousScreen()
    }

    //MARK:- PrivateMethods
    func GesturesMethods()
    {
        
        let imageGesture = UITapGestureRecognizer(target: self, action: #selector(SignUpViewController.tappedImageView))
        
        editProfileCell.userProfileImageView.addGestureRecognizer(imageGesture)
        
        editProfileCell.userProfileImageView.isUserInteractionEnabled = true
    
        
        
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
           
            
        }
        


    
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

        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any])
    {
        picker .dismiss(animated: true, completion: nil)
        
        //Set selected image
        editProfileCell.userProfileImageView.image = info[UIImagePickerControllerOriginalImage] as? UIImage
        
        //Set base 64 string format to nil
        if base64StringFormat != nil{
            
            base64StringFormat = nil
        }
        
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController)
    {
        dismiss(animated: true, completion: nil)
    }
    
    //BirthdayTextField Picker
    
    func datePickerMethod()
    {
        datePicker = UIDatePicker()
        
        datePicker.datePickerMode = .dateAndTime
        
         editProfileCell.birthdayTextField.inputView = datePicker
        
        let dateToolBar = UIToolbar().ToolbarPiker(doneAction: #selector(self.showSelectedDate), cancelAction: #selector(self.cancel_clicked))
        
       editProfileCell.birthdayTextField.inputAccessoryView = dateToolBar
    }
    
    func showSelectedDate()
    {
        
        self.view .endEditing(true)
        
        let formatter = DateFormatter()
        
        // formatter.dateFormat = "dd-MM-yyyy"
        
        formatter.dateFormat = "yyyy-MM-dd"
        
        editProfileCell.birthdayTextField.text = formatter.string(from: datePicker.date)
        
    }
    
    func cancel_clicked()
    {
        
      editProfileCell.birthdayTextField.text = ""
        self.view .endEditing(true)
        
    }
    
    //Gender,country,State,City picker
    
    
    func genderPickerMethod()
    {
        genderPicker = UIPickerView(frame: CGRect.zero)
        
        genderPicker.tag = 101
        genderPicker.delegate = self
        genderPicker.dataSource = self
        genderPicker.showsSelectionIndicator = true
        //Tool bar
        
        //let toolBar = UIToolbar().ToolbarPiker(#selector(FilterHomeViewController.dismissPicker))
        
        let distanceToolBar = UIToolbar().ToolbarPiker(doneAction: #selector(self.doneDistance), cancelAction: #selector(self.cancelDistance))
        editProfileCell.genderTextField.inputView = genderPicker
        
        editProfileCell.genderTextField.inputAccessoryView = distanceToolBar
        
        //self.byLocationCell.distanceTextFiled.inputView = distancePicker
        
    }
    //DistanceTextField
    func doneDistance()
    {
        
        
        self.view.endEditing(true)
    }
    //CancelTextField
    func cancelDistance(){
        
        self.view.endEditing(true)
        
    }
    
    
    //Country picker
    
    
    func countryPickerMethod()
    {
        countryPicker = UIPickerView(frame: CGRect.zero)
        
        countryPicker.tag = 102
        countryPicker.delegate = self
        countryPicker.dataSource = self
        countryPicker.showsSelectionIndicator = true
        //Tool bar
        
        //let toolBar = UIToolbar().ToolbarPiker(#selector(FilterHomeViewController.dismissPicker))
        
        let countryToolBar = UIToolbar().ToolbarPiker(doneAction: #selector(self.doneDistance), cancelAction: #selector(self.cancelDistance))
       editProfileCell.countryTextField.inputView = countryPicker
        
        editProfileCell.countryTextField.inputAccessoryView = countryToolBar
        
        
    }
    
    //State Picker
    func statePickerMethod()
    {
        statePicker = UIPickerView(frame: CGRect.zero)
        
        statePicker.tag = 103
        statePicker.delegate = self
        statePicker.dataSource = self
        statePicker.showsSelectionIndicator = true
        //Tool bar
        
        //let toolBar = UIToolbar().ToolbarPiker(#selector(FilterHomeViewController.dismissPicker))
        
        let stateToolBar = UIToolbar().ToolbarPiker(doneAction: #selector(self.doneDistance), cancelAction: #selector(self.cancelDistance))
        editProfileCell.stateTextField.inputView = statePicker
        
       editProfileCell.stateTextField.inputAccessoryView = stateToolBar
        
        
    }
    
    //Hangouts Picker
    
    func cityPickerMethod()
    {
        cityPicker = UIPickerView(frame: CGRect.zero)
        
        cityPicker.tag = 104
        cityPicker.delegate = self
        cityPicker.dataSource = self
        cityPicker.showsSelectionIndicator = true
        //Tool bar
        
        //let toolBar = UIToolbar().ToolbarPiker(#selector(FilterHomeViewController.dismissPicker))
        
        let cityToolBar = UIToolbar().ToolbarPiker(doneAction: #selector(self.doneDistance), cancelAction: #selector(self.cancelDistance))
        editProfileCell.cityTextField.inputView = cityPicker
        
       editProfileCell.cityTextField.inputAccessoryView = cityToolBar
        
        
    }
    

    //MARK: - UIPickerView Datasource & Delegate  Methods
    public func numberOfComponents(in pickerView: UIPickerView) -> Int
    {
        
        
        return 1
        
    }
    
    public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int
    {
        if pickerView.tag == 101
        {
            
            return genderNames.count
        }
        else if  pickerView.tag == 102
            
        {
            return countryNames.count
        }
        else if  pickerView.tag == 103
            
        {
            return stateNames.count
        }
    
        
        else
        {
            return cityNames.count
        }
        
        
        //return distanceArray.count
    }
    public func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String?
    {
        if pickerView.tag  == 101
        {
            return genderNames[row]
            
        }
        else if pickerView.tag  == 102
            
        {
            return countryNames[row]
        }
        else if pickerView.tag  == 103
            
        {
            return stateNames[row]
        }
            
        else
        {
            
            return cityNames[row]
        }
        
        
        
        //return distanceArray[row]
    }
    
    public func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int)
        
    {
        if pickerView.tag  == 101
        {
           editProfileCell.genderTextField.text = genderNames[row]
            
        }
        else if pickerView.tag  == 102
            
        {
            
           editProfileCell.countryTextField.text = countryNames[row]
        }
            
        else if pickerView.tag  == 103
            
        {
            
           editProfileCell.stateTextField.text = stateNames[row]
        }
        else
            
        {
            
           editProfileCell.cityTextField.text = cityNames[row]
        }
   }
    
    //MARK:- Navigation method
    func popUpBackToPreviousScreen() -> Void {
        
        _ = navigationController?.popViewController(animated: false)
    }

}
