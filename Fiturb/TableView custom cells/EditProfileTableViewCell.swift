//
//  EditProfileTableViewCell.swift
//  Fiturb
//
//  Created by DATAPPS on 4/21/17.
//  Copyright © 2017 Fiturb.DATAPPS. All rights reserved.
//

import UIKit

protocol EditProfileTableViewCellProtocol: class {
    
    func editProfileApi(customCellAdress:EditProfileTableViewCell?,callBackBlock completionHandler:@escaping(_ responseMessage:String?,_ error:Error?) -> ()) -> Void
}

class EditProfileTableViewCell: UITableViewCell {

    //Protocol object
    var editProfileTableViewCellDelegate: EditProfileTableViewCellProtocol? = nil
    
    @IBOutlet weak var cityTextField: ACFloatingTextfield!
    
    @IBOutlet weak var stateTextField: ACFloatingTextfield!
    
    @IBOutlet weak var countryTextField: ACFloatingTextfield!
    
    @IBOutlet weak var firstNameTextField: ACFloatingTextfield!
    
    @IBOutlet weak var lastNameTextField: ACFloatingTextfield!
    
    @IBOutlet weak var genderTextField: ACFloatingTextfield!
    
    @IBOutlet weak var birthdayTextField: ACFloatingTextfield!
    
    @IBOutlet weak var userProfileImageView: UIImageView!
    
    override func awakeFromNib() {
        
        super.awakeFromNib()
        // Initialization code
        
    }
   

    //MARK:- IBActions
    @IBAction func sumbitProfileAction(_ sender: UIButton) {
        
        editProfileTableViewCellDelegate?.editProfileApi(customCellAdress:self, callBackBlock: { (responseMessage:String?,_ error:Error?) in
            
            if error == nil{
                
                //Success
                print("profile edited Successfully")
                
            }
            else{
                
                print("error in profile edit")
            }
        
        })
    }
    
}
