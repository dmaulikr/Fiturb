//
//  AccountViewController.swift
//  Fiturb
//
//  Created by Admin on 15/03/17.
//  Copyright © 2017 Fiturb.DATAPPS. All rights reserved.
//

import UIKit
import FontAwesome_swift

class AccountViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    //Outlets
    
    //View Profile api
    var viewProfileApiRecievedResponseArray = [AnyObject?]()
    
    @IBOutlet weak var accountTableView: UITableView!
    
    var accountDetailsTableCell:AccountDetailsTableViewCell!
    
    let profileArray = ["Edit your profile","Manage my passions","Custom Filters"]
    
    let profileArrayImages = [FontAwesome.pencil , FontAwesome.heart, FontAwesome.sliders]
    
    let exitArray = ["Messages","Add activity"]
    
    let exitArrayImages = [FontAwesome.envelopeO,FontAwesome.plus]
    
    let helpUsArray = ["Invite Facebook Friends","Invite Whatsapp Friends","Invite Gmail Friends","Feedback","Rate us on PlayStore","Share App"]
    
    let helpUsArrayImages = [FontAwesome.facebook,FontAwesome.whatsapp,FontAwesome.google,FontAwesome.bullhorn,FontAwesome.star,FontAwesome.shareAlt]
    
    let otherArray = ["About Fiturb","Privacy Policy","Terms & Conditions","Delete Account","User blocks","Sign Out"]
    
    let otherArrayImages = [FontAwesome.info,FontAwesome.fileText,FontAwesome.fileText,FontAwesome.ban,FontAwesome.userTimes,FontAwesome.signOut]
    

    //MARK:- Life Cycle Methods
    override func viewDidLoad() {
        
        super.viewDidLoad()

        
    }

    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
    
        //User id of account holder
        let userIdOfAccountHolder = singleTon.sharedInstance.getUserID()
        
        //Call view profile api method
        self.viewProfileApi(userId: userIdOfAccountHolder)
        
    }

    // MARK:- UITableView DataSource Methods
    func numberOfSections(in tableView: UITableView) -> Int {
        
        var sectionsCount:Int? = 0
        
        if self.viewProfileApiRecievedResponseArray.count != 0 {
            
            sectionsCount = 5

        }
        
        return sectionsCount!
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(section)
        
        var rowsCount:Int?
        
        switch section
        {
        case 0:
            
            rowsCount = ((self.viewProfileApiRecievedResponseArray.count != 0) ? self.viewProfileApiRecievedResponseArray.count : 0)
            
        case 1:
            
            rowsCount = profileArray.count
            
        case 2:
            
            rowsCount = exitArray.count
            
        case 3:
            
            rowsCount = helpUsArray.count
            
        case 4:
            
            rowsCount = otherArray.count
            
        default:
        
            rowsCount = 0
        }
        
        return rowsCount!
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.section
        {
        case 0:
            
            accountDetailsTableCell = tableView.dequeueReusableCell(withIdentifier: "AccountDetailsTableViewCell", for: indexPath) as! AccountDetailsTableViewCell
            
            //Model object
            let viewprofileModelObj = self.viewProfileApiRecievedResponseArray[0] as? userDetailModel
            
            //calling Custom cell Ui adjustments method
            accountDetailsTableCell.accountDetailCustomCellUIAdjustments()
            
            //Calling Custom cell methods
            accountDetailsTableCell.fillCustomCellData(userFirstNameText: viewprofileModelObj?.firstName, friendsCountText: viewprofileModelObj?.friendsCount, followersCountText: viewprofileModelObj?.followersCount, cityNameText: viewprofileModelObj?.cityName, createdTimeText: viewprofileModelObj?.accountCreatedDateAndTime, profilePicImageUrl: viewprofileModelObj?.thumbUrl)

            return accountDetailsTableCell
            
        case 1:
            
            let profileArrayListCell = tableView.dequeueReusableCell(withIdentifier: "AccountListTableViewCell", for: indexPath) as! AccountListTableViewCell
            
            profileArrayListCell.accountListLabel.text = profileArray[indexPath.row]
            
            profileArrayListCell.accountListImageView.image = UIImage.fontAwesomeIcon(name:profileArrayImages[indexPath.row], textColor: UIColor.white, size: CGSize(width: 200, height: 200))
            
            return profileArrayListCell
            
        case 2:
            
            let exitArrayListCell = tableView.dequeueReusableCell(withIdentifier: "AccountListTableViewCell", for: indexPath) as! AccountListTableViewCell
            
            exitArrayListCell.accountListLabel.text = exitArray[indexPath.row]
            
            exitArrayListCell.accountListImageView.image = UIImage.fontAwesomeIcon(name:exitArrayImages[indexPath.row], textColor: UIColor.white, size: CGSize(width: 200, height: 200))
            
            return exitArrayListCell
            
        case 3:
            
            let helpArrayListCell = tableView.dequeueReusableCell(withIdentifier: "AccountListTableViewCell", for: indexPath) as! AccountListTableViewCell
            helpArrayListCell.accountListLabel.text = helpUsArray[indexPath.row]
            
            helpArrayListCell.accountListImageView.image = UIImage.fontAwesomeIcon(name:helpUsArrayImages[indexPath.row], textColor: UIColor.white, size: CGSize(width: 200, height: 200))
            
            return helpArrayListCell
            
        case 4:
            
            let otherListArrayCell = tableView.dequeueReusableCell(withIdentifier: "AccountListTableViewCell", for: indexPath) as! AccountListTableViewCell
            otherListArrayCell.accountListLabel.text = otherArray[indexPath.row]
            
            otherListArrayCell.accountListImageView.image = UIImage.fontAwesomeIcon(name:otherArrayImages[indexPath.row], textColor: UIColor.white, size: CGSize(width: 200, height: 200))
            
            
            return otherListArrayCell
            
        default:
            
            return UITableViewCell()
        }
        
        
    }
    
    // MARK:- UITableView Delegate Methods
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        print(indexPath.section)
        
        switch indexPath.section {
        case 1:
            
            switch indexPath.row {
            case 0:
                print("Edit profile row")
                //Navigate to Edit profile view Controller
                self.navigateToEditProfileViewController()
                
            case 1:
                print("Manage my passion row")
                
                //Add interest functionallity
                UserDefaults.standard.set("AddInterests", forKey:"CreateActivityOrAddInterests")
                
                //Move to Thematics list view controller
                self.performSegue(withIdentifier:"ThematicsListViewController", sender: nil)
                
            default:
                
                print("Thirdrow")

            }
        case 2:
            
            switch indexPath.row {
            case 0:
                print("Third setion")
            default:
                print("Third setion")

            }
            
        case 3:
            switch indexPath.row {
            case 0:
                print("Firstrow")
            case 1:
                
                print("secondrow")
            case 2:
                print("thirdrow")
                
            case 3:
                print("fourthrow")
            case 4:
                print("fithrow")
            default:
                 print("Fourth section")
            }
        
            
        default:
            
            switch indexPath.row {
            case 0:
                print("firstrow")
            case 1:
                
                print("secondrow")
            case 2:
                print("thirdrow")
                
            case 3:
                print("Delete account row")
                
                //Call Delete user account api
                self.deleteUserAccountApi()
                
            case 4:
                print("fithrow")
                
            case 5:
                    //Sign out Api method
                    self.signOutApi()
                
            default: break
                
            }
            
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        var rowsHeight: CGFloat?
        
        let tableViewHight:CGFloat? = self.view.frame.size.height
        
        if indexPath.section == 0
        {
            //minimum 254
            //rowsHeight = (tableViewHight!/2.23)
            rowsHeight = 255
        }
        else
        {
            //minimum 40
            //rowsHeight = (tableViewHight!/14)
            rowsHeight = 41
        }
        
        return rowsHeight!
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let headerCell = tableView.dequeueReusableCell(withIdentifier: "HeaderTitle_TableviewCell") as! HeaderTitle_TableviewCell
        
        switch section {
            
        case 1:
            
            headerCell.headerTitleLabel.text = "PROFILE"
            
        case 2:
            
            headerCell.headerTitleLabel.text = "EXIT"
            
        case 3:
            
            headerCell.headerTitleLabel.text = "HELP US"
            
        default:
            
            headerCell.headerTitleLabel.text = "OTHER"
        }
    
        return headerCell
        
    }
    
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        var headerHeight:CGFloat?
        
        
        if section == 0{
            
            headerHeight = 0
        }
        else{
            
            headerHeight = 41
            
        }
        
        return headerHeight!
    }
    
    //MARK:- Private Methods
    
    func displayAlertMessage(message: String?) -> Void {
        
        //Display alert
        let alertController = singleTon.sharedInstance.displayAlert(message: message!, title: "Fiturb")
        self.present(alertController, animated: true, completion: nil)
        
    }
    
    
    //MARK:- Api methods
    func viewProfileApi(userId:String?) -> Void {
        
        //POST service
        
        //Add Loader
        MBProgressHUD.showAdded(to: self.view, withScreenHeaderHeigth: 0.0, animated: true)
        
        //url
        let urlString = MyAppConstants.userDetailUrl
        
        //Post data
        let postData = ["user_id":userId] as? Dictionary<String,String>
        
        ApiDataManager.singleTonObjectForApiManagerClass.getUserDetailApiValuesWithUrlString(urlString: urlString, withPostData: postData!) {  (apiRecievedResponse:Array?, error:NSError?) in
            
            //Remove Loader
            MBProgressHUD.hide(for: self.view, animated: true)
            
            //Remove User detail previous response
            if self.viewProfileApiRecievedResponseArray.count != 0 {
                
                self.viewProfileApiRecievedResponseArray.removeAll()
            }
            
            guard error == nil else{
                
                let errorText = error!.localizedFailureReason!
                
                if errorText == "ok successful"{
                    
                    //Display alert
                    self.displayAlertMessage(message: "No data available!")
                    
                }
                else{
                    
                    //Display alert
                    self.displayAlertMessage(message:errorText)
                    
                }
                
                return
            }
            
            //Store recieved response
            self.viewProfileApiRecievedResponseArray = apiRecievedResponse!
            
            if self.viewProfileApiRecievedResponseArray.count != 0{
                
                for responseRecievedobj in self.viewProfileApiRecievedResponseArray{
                    
                    let userDetailClassModalObj = responseRecievedobj as? userDetailModel
                    
                    print("User deatil Modal object is:\(userDetailClassModalObj!.thumbUrl!),\(userDetailClassModalObj!.firstName!),\(userDetailClassModalObj!.friendsCount!),\(userDetailClassModalObj!.followersCount!),\(userDetailClassModalObj!.reviewsRatingCount!),\(userDetailClassModalObj!.averageRatingTotalCount!),\(userDetailClassModalObj!.cityName!),\(userDetailClassModalObj!.accountCreatedDateAndTime!),\(userDetailClassModalObj!.userBirthdayDate!),\(userDetailClassModalObj!.friendShipStatus!),\(userDetailClassModalObj!.isFollowing!)")
                    
                }
                
                //reload Accounts table view
                self.accountTableView.reloadData()
                
            }
            
        }
        
    }

    
    func signOutApi() -> Void {
        
        //Add Loader
        MBProgressHUD.showAdded(to: self.view, withScreenHeaderHeigth: 0.0, animated: true)
        
        //SignOut url
        let urlString = MyAppConstants.signOutUrl
        
        //post data
        let authenticationToken = singleTon.sharedInstance.getUserAuthenticationToken() ?? ""
        
        let postData = ["token":authenticationToken] as Dictionary<String,String>
        
        ApiDataManager.singleTonObjectForApiManagerClass.logoutApiValuesWithUrlString(urlString: urlString, withPostData: postData,callBackBlock: { (apirecievedResponse, error) in
            
            //Remove Loader
            MBProgressHUD.hide(for: self.view, animated: true)
            
            guard error == nil else{
                
                //Error handling
                print("Error recieved from Logout api is:\(error!.localizedFailureReason!)")
                
                //Dsiplay alert
                let alertController = singleTon.sharedInstance.displayAlert(message: (error!.localizedFailureReason!), title: "Fiturb")
                self.present(alertController, animated: true, completion: nil)
                
                return
                
            }
            
            guard let apiResponse = apirecievedResponse else{
                
                print("Empty response")
                return
                
            }
            
            guard apiResponse == "logout successful" else{
                
                print("Error in logout")
                
                //Show error message that passwrd not updated successfully
                let alertController = singleTon.sharedInstance.displayAlert(message: "Error in logout!", title: "Fiturb")
                
                self.present(alertController, animated: true, completion: nil)
                
                return
                
            }
            
            print("logout successfully")
            
            let msgString = "logout successfully"
            
            //Display alert
            let alert = UIAlertController(title: "Fiturb",
                                          message: msgString,
                                          preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "Ok", style: .default,handler:{ action -> Void in
                
                //SignOut successfully move to login screen
                self.navigateToLoginScreen()
                
            }))
            
            self.present(alert, animated: true, completion: nil)
            
        })
        
    }
    
    func deleteUserAccountApi() -> Void {
        
        //Add Loader
        MBProgressHUD.showAdded(to: self.view, withScreenHeaderHeigth: 0.0, animated: true)
        
        //delete  user account url
        let urlString = String(format: "%@%@", MyAppConstants.baseUrlString,MyAppConstants.deleteUserAccountUrl)
        
        //User id of account holder
        let userId = singleTon.sharedInstance.getUserID()
        
        //let postData
        let postdata = ["user_id":userId]
        
        ApiDataManager.singleTonObjectForApiManagerClass.deleteUserAccountApiValuesWithUrlString(urlString: urlString, withPostData: postdata as! Dictionary<String, String>,callBackBlock: { (apiRecievedResponse:Array?, error:NSError?) in
            
            //Remove Loader
            MBProgressHUD.hide(for: self.view, animated: true)
            
            guard error == nil else{
                
                //Error handling
                print("Error recieved from delete  User account request api is:\(error!.localizedFailureReason!)")
                
                //Dsiplay alert
                let alertController = singleTon.sharedInstance.displayAlert(message: (error!.localizedFailureReason!), title: "Fiturb")
                self.present(alertController, animated: true, completion: nil)
                
                return
                
            }
            
            
            if apiRecievedResponse?.count != 0{
                
                let modelObj = apiRecievedResponse?[0] as! DeleteUserAccountModel
                
                print("delete user account object values are:\(modelObj.message!)")
                
                if modelObj.message == "ok successful"{
                
                    print("Account deleted succefully")
                    
                    let msgString = "Account deleted succefully"
                    
                    //Display alert
                    let alert = UIAlertController(title: "Fiturb",
                                                  message: msgString,
                                                  preferredStyle: .alert)
                    
                    alert.addAction(UIAlertAction(title: "Ok", style: .default,handler:{ action -> Void in
                    
                        //Navigate to Login screen(Pop up)
                        self.navigateToLoginScreen()

                        
                    }))
                 
                    self.present(alert, animated: true, completion: nil)
                }
            }
        })
        
    }

        
    //MARK:- Navigation
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        
        if identifier == "ThematicsListViewController" {
            
            return false
            
        }else{
            
            return true
            
        }
    }
    
    func navigateToLoginScreen() -> Void {
        
        var pushController = false
        
        let viewControllers: [UIViewController]  = (self.navigationController?.viewControllers)! as [UIViewController]
        
        for individualController in viewControllers{
            
            if individualController is LoginViewController {
                
                pushController = true
                
                //Pop to login view controller
               _ =  self.navigationController?.popToViewController(individualController, animated: false)
            }
            
        }
    
        
        if pushController == false {
            
            pushController = true
            
            //Push login view controller
            let loginViewControler = self.storyboard?.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
            
            self.navigationController?.pushViewController(loginViewControler, animated: true)
            
        }
        
    }
    
    func navigateToEditProfileViewController() -> Void {
        
        //EditProfileViewController
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        
        let editProfileViewController = storyBoard.instantiateViewController(withIdentifier: "EditProfileViewController") as? EditProfileViewController
        
        self.navigationController?.pushViewController(editProfileViewController!, animated: false)
    }

}
