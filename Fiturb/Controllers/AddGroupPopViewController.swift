//
//  AddGroupPopViewController.swift
//  Fiturb
//
//  Created by DATAPPS on 3/28/17.
//  Copyright © 2017 Fiturb.DATAPPS. All rights reserved.
//

import UIKit

protocol AddNewGroupProtocol:class {
    
    func groupListApiCallandReloadFriendsTableViewMethod() -> Void
    
}
class AddGroupPopViewController: UIViewController {

    //Protcol variable
    var addNewGroupDelegate:AddNewGroupProtocol? = nil
    
    @IBOutlet weak var groupNameTextFiled: ACFloatingTextfield!
    //MARK:- IBOutlet 
    
    @IBOutlet weak var plusImageView: UIImageView!
    var selectedName:String? = nil

    var apiResponseRecievedArray = [AnyObject?]()
    
    //Group list model obj
    var groupListModelObject:GroupListModel?
    
    
    //MARK:- View Life Cycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
      
        //Group name text
        if (groupListModelObject != nil) {
            
            groupNameTextFiled.text = groupListModelObject?.groupName!
            
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        
        super.viewWillAppear(animated)
         plusImageView.image = UIImage.fontAwesomeIcon(name:.plus, textColor: UIColor.white, size: CGSize(width: 20, height: 20))
        
        //image corner radiues
        
        plusImageView.layer.cornerRadius = plusImageView.frame.width/2
        plusImageView.clipsToBounds = true
        
        //PopUp Hide Method
        
        popupRemoveMethod()
        
       
    }
    
    
    

   
  //MARK:- IBAction Methods
    
    @IBAction func validateButtonPressed(_ sender: Any)
    {
        if (groupListModelObject != nil) {
            
            //call group edit api
            self.editGroupApi()
        }
        else{
            
            //Call add new group meber api method
            self.addNewGroupApi()
        }
    }
    
  //MARK:- Private Methods
    
    func popupRemoveMethod() -> Void
    {
        let popupGesture = UITapGestureRecognizer(target: self, action: #selector(self.tagGestureRemovePOPUP))
        
        //gr.delegate = self
        self.view.addGestureRecognizer(popupGesture)
        
    }
    
    func tagGestureRemovePOPUP(_ gestureRecognizer: UIGestureRecognizer) {
        //Removing Pop up servies table view and background view
        self.view.removeFromSuperview()
        

    }
    
    //MARK:- Api methods
    func addNewGroupApi() -> Void {
        
        //POST method
        
        //Add Loader
        MBProgressHUD.showAdded(to: self.view, withScreenHeaderHeigth: 0.0, animated: true)
        
        //add new group url
        let urlString = MyAppConstants.addGroupUrl
        
        //let postData
        let postdata = ["group_name":groupNameTextFiled.text] as! Dictionary<String,String>
        
        ApiDataManager.singleTonObjectForApiManagerClass.addNewGroupRequestApiValuesWithUrlString(urlString: urlString, withPostData: postdata,callBackBlock: { (apiRecievedResponse:Array?, error:NSError?) in
            
            //Remove Loader
            MBProgressHUD.hide(for: self.view, animated: true)
            
            guard error == nil else{
                
                //Error handling
                print("Error recieved from add new group request api is:\(error!.localizedFailureReason!)")
                
                //Dsiplay alert
                let alertController = singleTon.sharedInstance.displayAlert(message: (error!.localizedFailureReason!), title: "Fiturb")
                self.present(alertController, animated: true, completion: nil)
                
                return
                
            }
            
            self.apiResponseRecievedArray = apiRecievedResponse!
            
            if self.apiResponseRecievedArray.count != 0{
                
                    
                    let tempObj = self.apiResponseRecievedArray[0] as! AddNewGroupModel
                    
                    print("add new group model object values are:\(tempObj.message!)")
                
                //Remove pop up
                self.view.removeFromSuperview()
                
                //Call protocol method
                self.addNewGroupDelegate?.groupListApiCallandReloadFriendsTableViewMethod()
                
                }
            
        })
    
    }
    
    func editGroupApi() -> Void {
        
        //Add Loader
        MBProgressHUD.showAdded(to: self.view, withScreenHeaderHeigth: 0.0, animated: true)
        
        //Edit  group url
        let urlString = MyAppConstants.editGroupUrl
        
        //let postData
        let postdata = ["group_id":groupListModelObject?.groupId, "group_name":groupNameTextFiled.text] as! Dictionary<String,String>
        
        ApiDataManager.singleTonObjectForApiManagerClass.editGroupRequestApiValuesWithUrlString(urlString: urlString, withPostData: postdata,callBackBlock: { (apiRecievedResponse:Array?, error:NSError?) in
            
            //Remove Loader
            MBProgressHUD.hide(for: self.view, animated: true)
            
            guard error == nil else{
                
                //Error handling
                print("Error recieved from edit group request api is:\(error!.localizedFailureReason!)")
                
                //Dsiplay alert
                let alertController = singleTon.sharedInstance.displayAlert(message: (error!.localizedFailureReason!), title: "Fiturb")
                self.present(alertController, animated: true, completion: nil)
                
                return
                
            }
            
            self.apiResponseRecievedArray = apiRecievedResponse!
            
            if self.apiResponseRecievedArray.count != 0{
                
                
                let tempObj = self.apiResponseRecievedArray[0] as! EditGroupModel
                
                print("edit group model object values are:\(tempObj.message!)")
                
                //Remove pop up
                self.view.removeFromSuperview()
                
                //Call protocol method
                self.addNewGroupDelegate?.groupListApiCallandReloadFriendsTableViewMethod()
                
            }
            
        })

    }
    //MARK:- UITextFiled Delegate Methods
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        
        return true
    }

  }
