//
//  ActivityDetailViewController.swift
//  Fiturb
//
//  Created by DATAPPS on 4/26/17.
//  Copyright © 2017 Fiturb.DATAPPS. All rights reserved.
//

import UIKit

class ActivityDetailViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    @IBOutlet weak var activityDetailTableView: UITableView!
    
    @IBOutlet weak var closeBtn: UIButton!
        
    //ActivityDetail ViewModel Object
    var activityDetailViewModelObj:ActivityDetailViewModel? = ActivityDetailViewModel()
    
    //MARK:- LifeCycle methods
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        //Close btn Ui settings
        self.closeButtonUiAdjustments()
        
       //Cusom xib table view cells registration method
        self.customXibCellsRegistration()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        
        //Call activity details api
        self.activityDetailsApi()
        
    }
    
    //MARK:- API Supporting Methods
    
    //Post method
    func activityDetailsApi() -> Void {
    
            //Activity detail url
            let activityDetailUrl = String(format: "%@%@", MyAppConstants.baseUrlString,MyAppConstants.acitivityDetailUrl)
    
            //Post data
            let postData = ["activity_id": activityDetailViewModelObj?.selectedActivityID ?? ""]
    
            print("Post data is:\(postData)")
    
            activityDetailViewModelObj?.activityDetailApi(urlString: activityDetailUrl, postData: postData, callBackBlock: { [weak self] (successOrFailure:responseResult<String>) in
                
                switch successOrFailure{
    
                case .Success(let messageText):
    
                    print("Activity detail api Success response:\(String(describing: messageText))")
    
                    print("model object values are:\(String(describing: self?.activityDetailViewModelObj?.descriptionText)),\(self?.activityDetailViewModelObj?.startDateAndTime),\(self?.activityDetailViewModelObj?.endDateAndTime),\(self?.activityDetailViewModelObj?.adress),\(self?.activityDetailViewModelObj?.entryFees),\(self?.activityDetailViewModelObj?.organisedBy)")
    
                    //Set table view datasource and delgate
                    self?.activityDetailTableView.delegate = self
                    self?.activityDetailTableView.dataSource = self
                    
                   //Reload Table view
                    self?.activityDetailTableView.reloadData()
                    
                case .Failure(let error):
    
                    print("Actiivty detail api failure response:\(String(describing: error))")
                    
                    //Error msg alert
                    self?.displayAlert(alertMessage: error?.localizedDescription)
                    
                    return
                  
               }
                
                },loaderCallBackBlock:{ [weak self] (addOrRemoveLoader:loaderAddOrRemove) in
                
                switch(addOrRemoveLoader){
                    
                    case .AddLoader:
                        
                            //Add loader method
                            self?.addLoader()
                    
                    case .RemoveLoader:
                    
                            //Remove loader method
                            self?.removeLoader()
                    
            }
                    
        })
            
    }

    //MARK:- UITableview DataSource and Delegate Methods
    func numberOfSections(in tableView: UITableView) -> Int {
        
        var sectionsCount: Int?
        
        sectionsCount = activityDetailViewModelObj!.getNumberOfSection()
        
        return sectionsCount!
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        
        var rowsCount: Int?
        
        rowsCount = activityDetailViewModelObj?.getNumberOfRowsOfTableView(sectionNumber: section)

        return rowsCount!
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.section {
            
        case 0:
            
            let userActivityInformationCell = tableView.dequeueReusableCell(withIdentifier: "UserActivityInformationTableViewCell", for: indexPath) as! UserActivityInformationTableViewCell
            
            //UI update
            userActivityInformationCell.materialDesignPartForUserActivityInformation()
            
            //Custom cell data method
            userActivityInformationCell.customCellData(startDateAndTime: activityDetailViewModelObj?.startDateAndTime, adressText: activityDetailViewModelObj?.adress, entryFees: activityDetailViewModelObj?.entryFees, organisedBy: activityDetailViewModelObj?.organisedBy, descriptionText: activityDetailViewModelObj?.descriptionText)
            
            return userActivityInformationCell
            
        case 1:
            
            let gggg = tableView.dequeueReusableCell(withIdentifier: "FriendsProfilePicTableViewCell", for: indexPath)
            
            return gggg
            
        case 2:
            
            let activityJoinedUsers = tableView.dequeueReusableCell(withIdentifier: "ActivityJoinedUsersTableViewCell", for: indexPath) as! ActivityJoinedUsersTableViewCell
            
            if indexPath.row == 0
            {
                activityJoinedUsers.waitingListCountLbl .isHidden = false
            }
            else
            {
                activityJoinedUsers .waitingListCountLbl . isHidden = true
            }
            activityJoinedUsers.materialDesignpartForActivityJoinedUsers()
            
            return activityJoinedUsers
            
        case 3:
            
            let activityUsersReviews = tableView.dequeueReusableCell(withIdentifier: "UsersReviewsTableViewCell", for: indexPath) as! UsersReviewsTableViewCell
            
            if indexPath.row == 0
            {
                
                activityUsersReviews.reviewslbl.isHidden = false
            }
            else
            {
                activityUsersReviews.reviewslbl.isHidden = true
            }
            
            return activityUsersReviews
            
        default:
            
            return UITableViewCell()
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        let rowsHeight: CGFloat?
        
        rowsHeight = activityDetailViewModelObj?.getHeightOfEachSectionCellOfTableView(sectionNumber: indexPath.section)
        
        return rowsHeight!
    }
    
    //MARK:- IBActions
    @IBAction func closeBtnAction(_ sender: Any) {
        
        _ = navigationController?.popViewController(animated: false)
    }
    
    //MARK:- Private Methods
    func customXibCellsRegistration() -> Void{
        
        activityDetailTableView.register(UINib(nibName: "ActivityJoinedUsersTableViewCell", bundle: nil), forCellReuseIdentifier: "ActivityJoinedUsersTableViewCell")
        
        activityDetailTableView.register(UINib(nibName: "UsersReviewsTableViewCell", bundle: nil), forCellReuseIdentifier: "UsersReviewsTableViewCell")
        
        activityDetailTableView.register(UINib(nibName: "FriendsProfilePicTableViewCell", bundle: nil), forCellReuseIdentifier: "FriendsProfilePicTableViewCell")
    }
    
    func closeButtonUiAdjustments() -> Void {
        
        //Close btn radius and image
        closeBtn.titleLabel?.font = UIFont.fontAwesome(ofSize: 20)
        closeBtn.setTitle(String.fontAwesomeIcon(name: .times), for: .normal)
        closeBtn.setTitleColor(UIColor.white, for: UIControlState.normal)
        closeBtn.layer.cornerRadius = (closeBtn.frame.size.width/2)
        closeBtn.clipsToBounds = true
        
    }

    func addLoader() -> Void {
        
        //Add Loader
        MBProgressHUD.showAdded(to: self.view, withScreenHeaderHeigth: 0.0, animated: true)
        
    }
    
    func removeLoader() -> Void {
        
        //Remove Loader
        MBProgressHUD.hide(for: self.view, animated: true)

    }
    
    func displayAlert(alertMessage: String?) -> Void {
        
        //Dsiplay alert
        let alertController = singleTon.sharedInstance.displayAlert(message: alertMessage!, title: "Fiturb")
        self.present(alertController, animated: true, completion: nil)
    }
}




////class ActivityDetailViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
//
//    @IBOutlet weak var activityDetailTableView: UITableView!
//    
//    var activityDetailApiResponseRecievedArray = [Any?]()
//    
//    @IBOutlet weak var closeBtn: UIButton!
//    
//    var selectedactivityID : String?
//    
//    //MARK:- LifeCycle methods
//    override func viewDidLoad() {
//        
//        super.viewDidLoad()
//        
//        //Close btn radius and image
//        closeBtn.titleLabel?.font = UIFont.fontAwesome(ofSize: 20)
//        closeBtn.setTitle(String.fontAwesomeIcon(name: .times), for: .normal)
//        closeBtn.setTitleColor(UIColor.white, for: UIControlState.normal)
//        closeBtn.layer.cornerRadius = (closeBtn.frame.size.width/2)
//        closeBtn.clipsToBounds = true
//        
//        activityDetailTableView.register(UINib(nibName: "ActivityJoinedUsersTableViewCell", bundle: nil), forCellReuseIdentifier: "ActivityJoinedUsersTableViewCell")
//        
//        activityDetailTableView.register(UINib(nibName: "UsersReviewsTableViewCell", bundle: nil), forCellReuseIdentifier: "UsersReviewsTableViewCell")
//        
//        activityDetailTableView.register(UINib(nibName: "FriendsProfilePicTableViewCell", bundle: nil), forCellReuseIdentifier: "FriendsProfilePicTableViewCell")
//
//    }
//    
//    override func viewWillAppear(_ animated: Bool) {
//        
//        super.viewWillAppear(animated)
//        
//        //Call activity details api
//        self.activityDetailsApi()
//        
//    }
//    
//    //MARK:-API Methods
//    //Post method
//    func activityDetailsApi() -> Void {
//        
//        //Activity detail url
//        let activityDetailUrl = String(format: "%@%@", MyAppConstants.baseUrlString,MyAppConstants.acitivityDetailUrl)
//        
//        //Post data
//        let postData = ["activity_id": "258"]
//        //let postData = ["activity_id": selectedactivityID ?? ""]
//        print("Post data is:\(postData)")
//        
//        alamofireApiDataManager.singleTonObjectForAlamofireApiDataManager.activityDetailsApiValuesWithUrlString(urlString: activityDetailUrl, postDataDicitionary: postData, callBackBlock: { [weak self] (responseRecievedArray:Array?, error:NSError?) in
//            
//            guard error == nil else{
//                
//                //Error handling
//                print("Error recieved from Activity detail api:\(String(describing: error))")
//                
//                //Dsiplay alert
//                let alertController = singleTon.sharedInstance.displayAlert(message: (error!.localizedFailureReason!), title: "Fiturb")
//                self?.present(alertController, animated: true, completion: nil)
//                
//                return
//            }
//            
//            print("response is:\(String(describing: responseRecievedArray))")
//            
//            //Success
//            if responseRecievedArray?.count != 0{
//                
//                self?.activityDetailApiResponseRecievedArray = responseRecievedArray!
//                
//                //Activity detail model Object
//                let activityDetailModelObj = self?.activityDetailApiResponseRecievedArray[0] as? ActivityDetailModel
//                
//                print(activityDetailModelObj?.messageText as Any,activityDetailModelObj?.title as Any,activityDetailModelObj?.startDateAndTime as Any,activityDetailModelObj?.endDateAndTime as Any,activityDetailModelObj?.latitude as Any,activityDetailModelObj?.longitude as Any,activityDetailModelObj?.description as Any,activityDetailModelObj?.capacity as Any,activityDetailModelObj?.regisiteredMembersCount as Any,activityDetailModelObj?.waitingCount as Any,activityDetailModelObj?.entryFees as Any,activityDetailModelObj?.likesCount as Any,activityDetailModelObj?.sharesCount as Any,activityDetailModelObj?.organiserPicture as Any,activityDetailModelObj?.userId as Any,activityDetailModelObj?.organisedBy as Any, activityDetailModelObj?.adress as Any,activityDetailModelObj?.interestId as Any,activityDetailModelObj?.interestName as Any,activityDetailModelObj?.colour as Any,activityDetailModelObj?.isJoined as Any,activityDetailModelObj?.isLiked as Any,activityDetailModelObj?.isTimeUp as Any)
//                
//                //Comments model object Array
//                let commentsModelResponseArray = (self?.activityDetailApiResponseRecievedArray[0] as? ActivityDetailModel)?.commentsCollection
//                
//                for eachModelObj in commentsModelResponseArray!{
//                    
//                    let commentsModelObj = eachModelObj as commentsModel
//                    
//                    print(commentsModelObj.userId as Any, commentsModelObj.firstName as Any, commentsModelObj.thumbUrl as Any, commentsModelObj.commentId as Any, commentsModelObj.commentsText as Any, commentsModelObj.reviewsCount as Any)
//                }
//                
//                //For Members model object Array
//                let membersModelResponseArray = (self?.activityDetailApiResponseRecievedArray[0] as? ActivityDetailModel)?.membersCollection
//                
//                for eachObj in membersModelResponseArray!{
//                    
//                    let membersModelObj = eachObj as membersModel
//                    
//                    print(membersModelObj.userId as Any, membersModelObj.firstName as Any, membersModelObj.thumbUrl as Any, membersModelObj.averageRating as Any, membersModelObj.memberStatus as Any, membersModelObj.memberRole as Any)
//                
//                }
//                
//                //For Ratings model object arrya
//                let ratingsModelResponseArray = (self?.activityDetailApiResponseRecievedArray[0] as? ActivityDetailModel)?.ratingsCollection
//                
//                for eachObj in ratingsModelResponseArray!{
//                    
//                    let ratingModelObj = eachObj as ratingsModel
//                    print(ratingModelObj.ratingId as Any,ratingModelObj.reviewsText as Any,ratingModelObj.ratingTotal as Any,ratingModelObj.createdDataAndTime as Any,ratingModelObj.reviewerId as Any,ratingModelObj.reviewedBy as Any,ratingModelObj.reviewerImageUrl as Any,ratingModelObj.reviewerAvergeRating as Any,ratingModelObj.reviewerRatingsCount as Any,ratingModelObj.reviewesByThisUser as Any)
//                    
//                }
//                
//            }
//            
//        })
//    }
//    
//    //MARK:- UITableview DataSource Methods
//    func numberOfSections(in tableView: UITableView) -> Int {
//        return 4
//    }
//    
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        
//        switch section {
//        case 0:
//            return 1
//        case 1:
//            return 1
//            
//        case 2:
//            return 4
//            
//        case 3:
//            return 3
//            
//        default:
//            
//            return 0
//        }
//    }
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        
//        switch indexPath.section {
//        case 0:
//            
//            let userActivityInformationCell = tableView.dequeueReusableCell(withIdentifier: "UserActivityInformationTableViewCell", for: indexPath) as! UserActivityInformationTableViewCell
//            
//            userActivityInformationCell.materialDesignPartForUserActivityInformation()
//            
//            return userActivityInformationCell
//            
//        case 1:
//            
//            
//            let gggg = tableView.dequeueReusableCell(withIdentifier: "FriendsProfilePicTableViewCell", for: indexPath)
//            
//                   //let userActivityInformationCell = tableView.dequeueReusableCell(withIdentifier: "UserActivityInformationTableViewCell", for: indexPath) as! UserActivityInformationTableViewCell
//            
//            return gggg
//            
//        case 2:
//            
//            let activityJoinedUsers = tableView.dequeueReusableCell(withIdentifier: "ActivityJoinedUsersTableViewCell", for: indexPath) as! ActivityJoinedUsersTableViewCell
//            
//            if indexPath.row == 0
//            {
//                activityJoinedUsers.waitingListCountLbl .isHidden = false
//            }
//            else
//            {
//                activityJoinedUsers .waitingListCountLbl . isHidden = true
//            }
//            activityJoinedUsers.materialDesignpartForActivityJoinedUsers()
//            
//            return activityJoinedUsers
//            
//        case 3:
//            
//            let activityUsersReviews = tableView.dequeueReusableCell(withIdentifier: "UsersReviewsTableViewCell", for: indexPath) as! UsersReviewsTableViewCell
//            
//            if indexPath.row == 0
//            {
//                
//                activityUsersReviews.reviewslbl.isHidden = false
//            }
//            else
//            {
//                activityUsersReviews.reviewslbl.isHidden = true
//            }
//            return activityUsersReviews
//            
//        default:
//            return UITableViewCell()
//        }
//        
//        
//        
//    }
//    
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        switch indexPath.section {
//            
//        case 0:
//            return 193
//            
//        case 1:
//            //return 193
//            return 91
//        case 2:
//            return 190
//        case 3:
//            return 150
//            
//        default:
//            return 0
//        }
//    }
//    
//    //MARK:- IBActions
//    @IBAction func closeBtnAction(_ sender: Any) {
//        
//        _ = navigationController?.popViewController(animated: false)
//    }
//   
//}

