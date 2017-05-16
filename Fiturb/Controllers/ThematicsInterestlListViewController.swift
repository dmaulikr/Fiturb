//
//  ThematicsInterestlListViewController.swift
//  Fiturb
//
//  Created by Admin on 20/03/17.
//  Copyright © 2017 Fiturb.DATAPPS. All rights reserved.
//

import UIKit

//MARK: Protocol
protocol dataPassBackToPreviousProtocol: class{
    
    func passDataToThematicsListController(count:Int?) -> Void
    
}

class ThematicsInterestlListViewController: UIViewController,UITableViewDelegate,UITableViewDataSource{

    //Protocol object
    weak var dataBackDelegate:dataPassBackToPreviousProtocol? = nil
    
    //Outlets
    @IBOutlet weak var thematicsInterstTableView: UITableView!
    
    @IBOutlet weak var interestlistHeaderText: UILabel!
    
    var userInterestListApiResponseRecievedArray = [AnyObject?]()
    
    var selectedThematicsListname:String?
    
    var selectedItemCount: Int = 0
    
    var itemIndexPathForIndexId: Int?
    
    var selectedInterestListIdsArray = [String?]()
    
    var addUserInterestListApiRecievedResponseArray = [Any?]()
    
    var seletedInterestsModelObjectsCollectionArray = [thematicsListModel?]()
    
    //all api's response store array
    var totalUserInterestListApisResponseArray = [Any?]()
    
    var thematicsListModelObjCountValue: Int = 0
    
    @IBOutlet weak var validateBtn: UIButton!
    
    //MARK:- Life Cycle Methods
    override func viewDidLoad() {
        
        super.viewDidLoad()

//        //Set View header text
//        if let interestListHeadername = selectedThematicsListname{
//            
//            self.interestlistHeaderText.text = interestListHeadername
//        }
        
        //Button text(Validate or Next)
        let btnText = ((self.seletedInterestsModelObjectsCollectionArray.count == 1) ? "Validate" : "Next")
        validateBtn.setTitle(btnText, for: .normal)
        
    }

    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
     
        if self.userInterestListApiResponseRecievedArray.count == 0{
            
            //Theme name
            let themeName = (self.seletedInterestsModelObjectsCollectionArray[thematicsListModelObjCountValue])?.themeName
            
            //Get intrest list of thematics
            self.thematicsInterestListApi(themeName: themeName)
            
        }
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        super.viewWillDisappear(animated)
        
        //Call protocol method
        dataBackDelegate?.passDataToThematicsListController(count: selectedItemCount)
        
    }
    
    //MARK:- API Methods
    private func  thematicsInterestListApi(themeName:String?) -> Void {
   
        //Set screen heading name as theme name
        self.interestlistHeaderText.text = themeName
        
        //Add Loader
        MBProgressHUD.showAdded(to: self.view, withScreenHeaderHeigth: 0.0, animated: true)
    
        //url String
        let urlStringWithSlecteditemidentifier = MyAppConstants.interestlistOfThematicslistUrl.appending(themeName!)
        ApiDataManager.singleTonObjectForApiManagerClass.getInterstListOfThermaticsApiValuesWithUrlString(urlString: urlStringWithSlecteditemidentifier) {  (apiRecievedResponse:Array?, error:NSError?) in
        
            //Remove Loader
            MBProgressHUD.hide(for: self.view, animated: true)
        
            guard error == nil else{
            
                //Error handling
                print("Error recieved from Interest List of thematics api is:\(error!.localizedFailureReason!)")
            
                //Dsiplay alert
                let alertController = singleTon.sharedInstance.displayAlert(message: (error!.localizedFailureReason!), title: "Fiturb")
                self.present(alertController, animated: true, completion: nil)
            
                return
            }
        
            //Store recieved response
            self.userInterestListApiResponseRecievedArray = apiRecievedResponse!
        
            if self.userInterestListApiResponseRecievedArray.count != 0{
            
                //Add response to total response storing array
                self.totalUserInterestListApisResponseArray.append(self.userInterestListApiResponseRecievedArray)
                
                for responseRecievedobj in self.userInterestListApiResponseRecievedArray{
                
                    let tempObj = responseRecievedobj as! InterestListOfThematicsModel
                
                    print("Interest List model object values are:\(tempObj.interestName!),\(tempObj.interestId!),\(tempObj.interestIcon!),\(tempObj.interestMessage!)")
                }
            
                //Reload Table view
                self.thematicsInterstTableView.reloadData()
            
            }
        
        }

    }
    
    func addUserInterestListApi() -> Void {
        
        //POST service
        
        //Add Loader
        MBProgressHUD.showAdded(to: self.view, withScreenHeaderHeigth: 0.0, animated: true)
        
        //add User Interest list url
        let urlString = String(format:"%@%@", MyAppConstants.baseUrlString,MyAppConstants.addUserInterestlistUrl)
        
        if selectedInterestListIdsArray.count == 0 {
            
            //Remove Loader
            MBProgressHUD.hide(for: self.view, animated: true)
            
            let alertController = singleTon.sharedInstance.displayAlert(message: "please select Interests from the above list!", title: "Fiturb")
            
            self.present(alertController, animated: true, completion: nil)
            
            return
        }
        
        //Post data
        let postData  = ["interest_id":singleTon.sharedInstance.convertArrayToString(arrayObj: self.selectedInterestListIdsArray)] as? Dictionary<String,String>
       // let postData  = singleTon.sharedInstance.getUserID() as? Dictionary<String,String>
        
        ApiDataManager.singleTonObjectForApiManagerClass.addUserInterestListApiValuesWithUrlString(urlString: urlString, withPostData: postData!) {  (apiRecievedResponse:Array?, error:NSError?) in
            
            //Remove Loader
            MBProgressHUD.hide(for: self.view, animated: true)
            
            //Remove Add User interest List previous response
            if self.addUserInterestListApiRecievedResponseArray.count != 0 {
                
                self.addUserInterestListApiRecievedResponseArray.removeAll()
            }
            
            guard error == nil else{
                
                let errorText = error!.localizedFailureReason!
                
                if errorText == "ok successful"{
                    
                    print("No interests added")
                }
                else{
                    
                    //Dsiplay alert
                    let alertController = singleTon.sharedInstance.displayAlert(message: errorText, title: "Fiturb")
                    
                    self.present(alertController, animated: true, completion: nil)
                }
                
                return
            }
            
            //Store recieved response
            self.addUserInterestListApiRecievedResponseArray = apiRecievedResponse!
            
            if self.addUserInterestListApiRecievedResponseArray.count != 0{
                
                for responseRecievedobj in self.addUserInterestListApiRecievedResponseArray{
                    
                    let addUserInterestListModalObj = responseRecievedobj as? AddUserInterestsModel
                    
                    print("Add User Interest list Modal object is:\(addUserInterestListModalObj?.message!),\(addUserInterestListModalObj?.interestId!),\(addUserInterestListModalObj?.interestName!),\(addUserInterestListModalObj?.interestIcon!)")
                    
                }
                
                //set User Defaults IsSelected Key to True
                UserDefaults.standard.set(true, forKey:"isUserInterestsAdded")
                
                //Show alert(User interests Added successfully)
                let alert = UIAlertController(title: "Fiturb",
                                              message: "User Interests added successfully!",
                                              preferredStyle: .alert)
                
                alert.addAction(UIAlertAction(title: "Ok", style: .default,handler:{ action -> Void in

                    
                    DispatchQueue.main.async(execute: {
                        
                        //Pop to Activity screen
                        self.navigateToActivityViewController()
                        
                    });
                    
                }))
                
                self.present(alert, animated: true, completion: nil)
                
                
            }
            
        }
        
    }


    //MARK:- IBAction methods
    
//    @IBAction func validateAction(_ sender: UIButton) {
//        
//        if UserDefaults.standard.value(forKey: "controllerNameForVisibleBtn") as? String == "ActivityViewController"{
//            
//            //Navigate to create Activity view controller
//            self.navigateToCreateActivityController()
//
//        }
//        else if(UserDefaults.standard.value(forKey: "controllerNameForVisibleBtn") as? String == "AccountViewController"){
//            
//            //Call Add user interest lists api
//            self.addUserInterestListApi()
//            
//        }
//        
//    }
    
    @IBAction func validateAction(_ sender: UIButton) {
        
        if UserDefaults.standard.value(forKey: "CreateActivityOrAddInterests") as? String == "CreateActivity"{
            
            //Navigate to create Activity view controller
            self.navigateToCreateActivityController()
            
        }
        else if(UserDefaults.standard.value(forKey: "CreateActivityOrAddInterests") as? String == "AddInterests"){
            
            //Increments count value when user pressed next
            thematicsListModelObjCountValue = thematicsListModelObjCountValue + 1

            if  thematicsListModelObjCountValue <= (self.seletedInterestsModelObjectsCollectionArray.count - 1){
                
                //Button text(Validate or Next)
                let btnText = ((thematicsListModelObjCountValue == (self.seletedInterestsModelObjectsCollectionArray.count-1)) ? "Validate" : "Next")
                sender.setTitle(btnText, for: .normal)

                //Theme name
                let themeName = (self.seletedInterestsModelObjectsCollectionArray[thematicsListModelObjCountValue])?.themeName
                
                //Get intrest list of thematics
                self.thematicsInterestListApi(themeName: themeName)
                
            }
            else{
                
                //Call Add user interest lists api
                self.addUserInterestListApi()
            }
            
            
        }
        
    }

    //MARK:- Private methods
//    func selectedRowsCount(indexPathOfSelectedRow:IndexPath) -> Void {
//     
//        let cell = self.thematicsInterstTableView.cellForRow(at: indexPathOfSelectedRow)
//        
//        guard (cell?.isSelected)! else{
//            
//            return
//        }
//        
//        //Show checkmark for selected items
//        cell?.accessoryType = .checkmark
//
//        //Count the selected rows
//        selectedItemCount += 1
//        
//        //Model object
//        let modelObj = self.userInterestListApiResponseRecievedArray[indexPathOfSelectedRow.row] as! InterestListOfThematicsModel
//        
//        let interestId:String = modelObj.interestId
//        
//        //Add selected user interest to Array
//        self.selectedInterestListIdsArray.append(interestId)
//        
//    }
//    
//    func deselectedRows(indexpathOfDeselectedRow:IndexPath) -> Void {
//        
//         guard let deselectedRowCell = self.thematicsInterstTableView.cellForRow(at:indexpathOfDeselectedRow) else {
//            
//            return
//        }
//        
//        //Remove check mark 
//        deselectedRowCell.accessoryType = .none
//        
//        //Uncount deselected rows
//        selectedItemCount -= 1
//        
//        if (self.userInterestListApiResponseRecievedArray.count != 0) && (self.selectedInterestListIdsArray.count != 0){
//            
//            //Interest Id to Check id is present in array or not
//            let modelObj = self.userInterestListApiResponseRecievedArray[indexpathOfDeselectedRow.row] as! InterestListOfThematicsModel
//            
//            let interestId:String = modelObj.interestId
//            
//            //Remove or filter unchecked Interests
//            self.selectedInterestListIdsArray = self.selectedInterestListIdsArray.filter { $0 != interestId }
//            
//        }
//        
//    }
    
    func selectedRowsCount(indexPathOfSelectedRow:IndexPath) -> Void {
        
        let cell = self.thematicsInterstTableView.cellForRow(at: indexPathOfSelectedRow) as? InterestListTableViewCell
        
        guard (cell?.isSelected)! else{
            
            return
        }
        
        //Show checkmark for selected items
       // cell?.accessoryType = .checkmark
        
        //Change cell background view colour
        cell?.cellSubView.backgroundColor = UIColor.lightGray
        
        //Count the selected rows
        selectedItemCount += 1
        
        //Model object
        let modelObj = (self.totalUserInterestListApisResponseArray[thematicsListModelObjCountValue] as? [AnyObject?])?[indexPathOfSelectedRow.row] as! InterestListOfThematicsModel
        
        let interestId:String = modelObj.interestId
        
        //Add selected user interest to Array
        self.selectedInterestListIdsArray.append(interestId)
        
    }
    
    func deselectedRows(indexpathOfDeselectedRow:IndexPath) -> Void {
        
        guard let deselectedRowCell = self.thematicsInterstTableView.cellForRow(at:indexpathOfDeselectedRow) as? InterestListTableViewCell else {
            
            return
        }
        
        //Remove check mark
        //deselectedRowCell.accessoryType = .none

        //Change cell background view colour
        deselectedRowCell.cellSubView.backgroundColor = UIColor.white
        
        //Uncount deselected rows
        selectedItemCount -= 1
        
        if (self.totalUserInterestListApisResponseArray.count != 0) && (self.selectedInterestListIdsArray.count != 0){
            
            //Interest Id to Check id is present in array or not
            let modelObj = (self.totalUserInterestListApisResponseArray[thematicsListModelObjCountValue] as? [AnyObject?])?[indexpathOfDeselectedRow.row] as! InterestListOfThematicsModel
            
            let interestId:String = modelObj.interestId
            
            //Remove or filter unchecked Interests
            self.selectedInterestListIdsArray = self.selectedInterestListIdsArray.filter { $0 != interestId }
            
        }
        
    }

    //MARK:- Table view Data Source and Delgate methods
//    func numberOfSections(in tableView: UITableView) -> Int {
//
//        return 1
//    }
    
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//
//        return self.userInterestListApiResponseRecievedArray.count
//    }
//    
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//
//        let interestListCustomCell = tableView.dequeueReusableCell(withIdentifier:"interestListCell", for: indexPath) as! InterestListTableViewCell
//        
//        if  self.userInterestListApiResponseRecievedArray[indexPath.row] != nil {
//            
//            let eachResponseObj = self.userInterestListApiResponseRecievedArray[indexPath.row] as! InterestListOfThematicsModel
//            
//            if interestListCustomCell.isSelected{
//                
//                //Show checkmark for selected items
//                interestListCustomCell.accessoryType = .checkmark
//            }
//            else{
//                
//                interestListCustomCell.accessoryType = .none
//            }
//            
//            //fill custom cell data
//            interestListCustomCell.interestList(interestText: eachResponseObj.interestName)
//            
//        }
//
//        return interestListCustomCell
//        
//    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        var sectionsCount:Int? = 0
        
        if self.totalUserInterestListApisResponseArray.count != 0{
            
            sectionsCount = (((self.totalUserInterestListApisResponseArray[thematicsListModelObjCountValue] as? [AnyObject])?.count) != 0 ? 1 : 0)
        }
        
        return sectionsCount!
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        let rowsCount = ((self.totalUserInterestListApisResponseArray[thematicsListModelObjCountValue] as? [AnyObject])?.count) ?? 0
        
        return rowsCount
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let interestListCustomCell = tableView.dequeueReusableCell(withIdentifier:"interestListCell", for: indexPath) as! InterestListTableViewCell
        
        if  (self.totalUserInterestListApisResponseArray[thematicsListModelObjCountValue] as? [AnyObject])?[indexPath.row] != nil {
            
            let eachResponseObj = (self.totalUserInterestListApisResponseArray[thematicsListModelObjCountValue] as? [AnyObject])?[indexPath.row] as! InterestListOfThematicsModel
            
            //For check mark
            if self.selectedInterestListIdsArray.count != 0{
                
                if self.selectedInterestListIdsArray.contains(where: {$0 == eachResponseObj.interestId})
                {
                    //Show checkmark for selected items
                    //interestListCustomCell.accessoryType = .checkmark
                    
                    //Change cell background view colour
                    interestListCustomCell.cellSubView.backgroundColor = UIColor.lightGray

                }
                else{
                    
                    //Uncheck mark
                   // interestListCustomCell.accessoryType = .none

                    //Change cell background view colour
                    interestListCustomCell.cellSubView.backgroundColor = UIColor.white
                }
            }
            
            //fill custom cell data
            interestListCustomCell.interestList(interestText: eachResponseObj.interestName)
            
        }
        
        return interestListCustomCell
        
    }

    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        let tableViewCellsHeight:CGFloat = (tableView.frame.size.height/10)
        
        return tableViewCellsHeight
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        itemIndexPathForIndexId = indexPath.row
        
        //Selected rows count method
        self.selectedRowsCount(indexPathOfSelectedRow: indexPath)
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        
        //Deselcted rows count
        self.deselectedRows(indexpathOfDeselectedRow: indexPath)
    }
    
    //MARK:- Navigation Methods
    @IBAction func BackToPreviousScreen(_ sender: UIButton) {
        
        //Decrement model object count value
        thematicsListModelObjCountValue = (thematicsListModelObjCountValue > 0) ? (thematicsListModelObjCountValue - 1) : -1
        
        if thematicsListModelObjCountValue >= 0{
            
            //Reload table view
            self.thematicsInterstTableView.reloadData()
            
        }
        else{
            
             _ = navigationController?.popViewController(animated: true)
            
        }
        
    }
    
    func navigateToCreateActivityController() -> Void {
        
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        
        let createActivityViewControllerObj = storyBoard.instantiateViewController(withIdentifier: "CreateActivityViewController") as? CreateActivityViewController
        
        if self.userInterestListApiResponseRecievedArray.count != 0  && itemIndexPathForIndexId != nil{
            
            let thematicsInterestListModelObj = self.userInterestListApiResponseRecievedArray[itemIndexPathForIndexId!] as? InterestListOfThematicsModel
            
            createActivityViewControllerObj?.thematicsInterestListModel = thematicsInterestListModelObj
        }
        
        self.navigationController?.pushViewController((createActivityViewControllerObj)!, animated: false)
        
    }
    
    //Home screen
    func navigateToActivityViewController() -> Void {
        
        let viewControllers: [UIViewController]  = (self.navigationController?.viewControllers)! as [UIViewController]
        
        for individualController in viewControllers{
            
            if individualController is UITabBarController {
                
                var activityControllerObj: UITabBarController?
                
                activityControllerObj = individualController as? UITabBarController
                
                activityControllerObj?.selectedIndex = 0
                
                //Pop to Activity view controller
                _ =  self.navigationController?.popToViewController(individualController, animated: false)
                
            }
            
        }
        
    }

}
