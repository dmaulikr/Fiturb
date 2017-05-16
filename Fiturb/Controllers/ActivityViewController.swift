//
//  ActivityViewController.swift
//  Fiturb
//
//  Created by Admin on 13/03/17.
//  Copyright © 2017 Fiturb.DATAPPS. All rights reserved.
//

import UIKit
import FontAwesome_swift
import MapKit

class ActivityViewController: UIViewController,UITableViewDataSource,UITableViewDelegate,publishActivityProtocol,SelectedUserAndActivitiesInfoViewControllerProtcol,ActivityTableViewCellProtocol,chooseLocationProtocol{
    
        //For User profile Image caching and downloading images
        var task: URLSessionDownloadTask?
        var session: URLSession?
        var cacheUserProfilePic:NSCache<AnyObject, AnyObject>?

        //Activity joined members cache
        var cacheActivityJoinedMembers:NSCache<AnyObject, AnyObject>?
    
        //Paging variables
        var pageCount:Int = 1
    
        var isPageRefrshing:Bool = false

        @IBOutlet weak var mapviewObj: MKMapView!
    
        @IBOutlet weak var userLocationShowBtn: UIButton!
    
        //For feed activity api response
        var feedActivityApiResponseRecievedArray = [AnyObject?]()
    
        //For view profile api response
        var userDetailRecievedResponseArray = [Any?]()
    
        //City name
        var userCityNameText:String?
    
        //Outlets
        @IBOutlet weak var closeBtn: UIButton!
    
        @IBOutlet weak var openBtn: UIButton!
    
        @IBOutlet weak var filterButton: UIButton!
    
        @IBOutlet weak var plusButtonPressed: UIButton!

        @IBOutlet weak var activityTableView: UITableView!
    
        @IBOutlet weak var mainSubView: UIView!
    
        @IBOutlet weak var subView: UIView!
        
        @IBOutlet weak var downViewForSwipeUp: UIView!
        
        @IBOutlet weak var subVIewForSwipeDown: UIView!
    
        @IBOutlet weak var userCityLabel: UILabel!
    
        var selectedUserAndActivityInfoPopUpOBj:SelectedUserAndActivitiesInfoViewController?

        var chooseLocationScreenPopUpObj: ChooseLocationViewController?
    
        var sectionsCountOfTableView:Int = 0

    //MARK:- Life Cycle Methods
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        //Font aewsome image
        self.fontAwesomeImages()
        
        //Swipe Gesture recognizer
        let upSwipe = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipes(_:)))
        
        let downSwipe = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipes(_:)))
        
        let tapSwipeForSelectingLocation = UITapGestureRecognizer(target: self, action: #selector(tapSubviewToSelectLocation))

        upSwipe.direction = .up
        downSwipe.direction = .down
        
        downViewForSwipeUp.addGestureRecognizer(upSwipe)
        
        subVIewForSwipeDown.addGestureRecognizer(downSwipe)
        
        //for to select user location
        subVIewForSwipeDown.addGestureRecognizer(tapSwipeForSelectingLocation)

        //User Current location btn image
        self.userLocationShowBtn.setImage(UIImage(named:"UserCurrentLocation"), for: .normal)
        self.userLocationShowBtn.layer.cornerRadius = 6.0
        
        //Publish An Activity CustomCell Xib
        activityTableView.register(UINib(nibName: "PublishAnActivityTableViewCell", bundle: nil), forCellReuseIdentifier: "PublishAnActivityTableViewCell")
        
        //MAPVIEW: initializing location manager class to get current location
        self.mapviewObj.tag  = 3
        LocationManager.sharedInstanceOfLocationManager.initializeLocationManagerToGetCurrentLocation(mapViewObjectLoadingClass: self.mapviewObj)
    
        
    }
    
    override func viewWillAppear(_ animated: Bool){
        
        super.viewWillAppear(animated)
        
        //Set Activity View Header as user city name
        self.userCityLabel.text = self.userCityNameText ?? "City"
        
        if singleTon.sharedInstance.isLocationUpdated()!{
            
            if singleTon.sharedInstance.isUserInterestsAdded()! {
                
                if self.feedActivityApiResponseRecievedArray.count == 0 {
                    
                    //Call get activity Feed api method
                    pageCount = 1
                    self.getActivityFeedApi(pageCount:pageCount)
                    
                }
            }
            else{
                
                //Show alert for add interests and after pressing OK btn navigate to Add interests screen                
                self.showAltertForAddInterestsAndNavigateToAddInterestsScreen()
                
            }

        }
        else{
            
            //Show alert for Update location and after pressing OK btn navigate to choose location screen
            self.showAltertForLocationUpdateAndNavigateToChooseLocationScreen()
        }
    
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        super.viewWillDisappear(animated)
        
        //Reset map view annotation object
        LocationManager.sharedInstanceOfLocationManager.resetMapViewAnnotation()
        
    }

    //MARK:- API Methods
    //GET method
    func getActivityFeedApi(pageCount:Int?) -> Void {
        
        //Add Loader
        MBProgressHUD.showAdded(to: self.view, withScreenHeaderHeigth: 0.0, animated: true)
        
        let feedActivityUrl = String(format: "%@%i", MyAppConstants.feedActivityUrl,pageCount!)

        ApiDataManager.singleTonObjectForApiManagerClass.getActivityFeedApiValuesWithUrlString(urlString: feedActivityUrl,callBackBlock:  {  (apiRecievedResponse:Array<AnyObject>?, error:NSError?) in
            
            //Remove Loader
            MBProgressHUD.hide(for: self.view, animated: true)
            
            guard error == nil else{
                
                print("Error recieved")
                
                if self.isPageRefrshing == false{
                    
                    if self.feedActivityApiResponseRecievedArray.count != 0{
                        
                        self.feedActivityApiResponseRecievedArray.removeAll()
                    }
                    
                    let errorText = error!.localizedFailureReason!
                    
                    if errorText == "ok successful"{
                        
                        //Reload Activity Table view
                        self.activityTableView.reloadData()
                        
                    }
                    else{
                        
                        //Error handling
                        print("Error recieved from Feed activity api is:\(errorText)")
                        
                        //Reload Activity Table view
                        self.activityTableView.reloadData()
                        
                        //Dsiplay alert
                        let alertController = singleTon.sharedInstance.displayAlert(message: errorText, title: "Fiturb")
                        
                        self.present(alertController, animated: true, completion: nil)
                        
                    }
                    
                }
                
                return
            }
            
            //Success response 
            
            //ENABLE PAGING
            self.isPageRefrshing = false
            
            //Store recieved response
            self.feedActivityApiResponseRecievedArray = self.feedActivityApiResponseRecievedArray + apiRecievedResponse!
            
            if self.feedActivityApiResponseRecievedArray.count != 0{
                
                for responseRecievedobj in self.feedActivityApiResponseRecievedArray{
                    
                    let tempObj = responseRecievedobj! as! FeedActivityModel
                    
                    print("feed activity model object values are:\(tempObj.activityId!),\(tempObj.activityName!),\(String(describing: tempObj.activityTime!)),\(tempObj.capacity!),\(tempObj.status!),\(tempObj.longitude!),\(tempObj.latitude!),\(tempObj.entryFees!),\(tempObj.organisedBy!),\(tempObj.userId!),\(tempObj.registeredMembers!),\(tempObj.averageRating!),\(tempObj.reviewCounting!),\(tempObj.age!),\(tempObj.userThumb!),\(tempObj.activityThumb!),\(tempObj.joined!),\(tempObj.cityName!),\(tempObj.likeCount!),\(tempObj.sharesCount!),\(tempObj.commentsCount!),\(tempObj.isLiked!),\(tempObj.distance),\(tempObj.descriptionText)")
                    
                }
                
                //Reload Activity Table view
                self.activityTableView.reloadData()
            }
            
        })
        
    }


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
            if self.userDetailRecievedResponseArray.count != 0 {
                
                self.userDetailRecievedResponseArray.removeAll()
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
            self.userDetailRecievedResponseArray = apiRecievedResponse!
            
            if self.userDetailRecievedResponseArray.count != 0{
                
                for responseRecievedobj in self.userDetailRecievedResponseArray{
                    
                    let userDetailClassModalObj = responseRecievedobj as? userDetailModel
                    
                    print("User deatil Modal object is:\(userDetailClassModalObj!.thumbUrl!),\(userDetailClassModalObj!.firstName!),\(userDetailClassModalObj!.friendsCount!),\(userDetailClassModalObj!.followersCount!),\(userDetailClassModalObj!.reviewsRatingCount!),\(userDetailClassModalObj!.averageRatingTotalCount!),\(userDetailClassModalObj!.cityName!),\(userDetailClassModalObj!.accountCreatedDateAndTime!),\(userDetailClassModalObj!.userBirthdayDate!),\(userDetailClassModalObj!.friendShipStatus!),\(userDetailClassModalObj!.isFollowing!)")
                    
                }
                
                //Show pop up
                self.displaySelectedUserInfoAndActivityPopUpScreen()
                
            }
            
        }
        
    }

    //MARK:- Protcol methods for Like,UnLike and Share and comment Api's
    //POST
    func likeActivityApiMethod(indexpathNumber:Int?,callBackBlock completionHandler:@escaping(_ message:String?,_ feedActivityModelObject:FeedActivityModel?) -> ()){
        
        //Add Loader
        MBProgressHUD.showAdded(to: self.view, withScreenHeaderHeigth: 0.0, animated: true)
        
        //Like activity url
        let urlString = String(format:"%@%@", MyAppConstants.baseUrlString,MyAppConstants.likeActivityUrl)
        
        //feed activity Model obj
        let modelObj = self.feedActivityApiResponseRecievedArray[indexpathNumber!] as? FeedActivityModel
        
        //let postData
        let postdata = ["activity_id":modelObj?.activityId] as! Dictionary<String,String>
    
        ApiDataManager.singleTonObjectForApiManagerClass.likeApiValuesWithUrlString(urlString: urlString, withPostData: postdata,callBackBlock: { (apiRecievedResponse:Array?, error:NSError?) in
            
            //Remove Loader
            MBProgressHUD.hide(for: self.view, animated: true)
            
            guard error == nil else{
                
                //Error handling
                print("Error recieved from Like request api is:\(error!.localizedFailureReason!)")
                
                //Dsiplay alert
                let alertController = singleTon.sharedInstance.displayAlert(message: (error!.localizedFailureReason!), title: "Fiturb")
                self.present(alertController, animated: true, completion: nil)
                
                return
                
            }
            
            var likeActivityApiRecievedResponse:[Any?] = apiRecievedResponse!
            
            if likeActivityApiRecievedResponse.count != 0{
                
                let tempObj = likeActivityApiRecievedResponse[0] as! LikeModel
                
                print("Like activity model object values are:\(tempObj.message!)")
                
                //Call back
                DispatchQueue.main.async(execute: {
                    completionHandler(tempObj.message,self.feedActivityApiResponseRecievedArray[indexpathNumber!] as? FeedActivityModel)
                    
                });
                
            }
            
        })
        
    }
    
    func unLikeActivityApiMethod(indexpathNumber:Int?,callBackBlock completionHandler:@escaping(_ message:String?,_ feedActivityModelObject:FeedActivityModel?) -> ()){
        
        //Add Loader
        MBProgressHUD.showAdded(to: self.view, withScreenHeaderHeigth: 0.0, animated: true)
        
        //UNLike activity url
        let urlString = String(format:"%@%@", MyAppConstants.baseUrlString,MyAppConstants.unLikeActivityUrl)
        
        //feed activity Model obj
        let modelObj = self.feedActivityApiResponseRecievedArray[indexpathNumber!] as? FeedActivityModel
        
        //let postData
        let postdata = ["activity_id":modelObj?.activityId] as! Dictionary<String,String>
        
        ApiDataManager.singleTonObjectForApiManagerClass.unLikeApiValuesWithUrlString(urlString: urlString, withPostData: postdata,callBackBlock: { (apiRecievedResponse:Array?, error:NSError?) in
            
            //Remove Loader
            MBProgressHUD.hide(for: self.view, animated: true)
            
            guard error == nil else{
                
                //Error handling
                print("Error recieved from UNLike request api is:\(error!.localizedFailureReason!)")
                
                //Dsiplay alert
                let alertController = singleTon.sharedInstance.displayAlert(message: (error!.localizedFailureReason!), title: "Fiturb")
                self.present(alertController, animated: true, completion: nil)
                
                return
                
            }
            
            var likeActivityApiRecievedResponse:[Any?] = apiRecievedResponse!
            
            if likeActivityApiRecievedResponse.count != 0{
                
                let tempObj = likeActivityApiRecievedResponse[0] as! UnLikeModel
                
                print("UNLike activity model object values are:\(tempObj.message!)")
                
                //Call back
                DispatchQueue.main.async(execute: {
                    completionHandler(tempObj.message,self.feedActivityApiResponseRecievedArray[indexpathNumber!] as? FeedActivityModel)
                    
                });
                
            }
            
        })

    }
    
    
    //MARK:- Protocol methods
    func navigateToFriendDetailViewControllerProtocolMethod() -> Void{
            
            //Frinds detail view controller object
            let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            
            let friendsDetailViewController = storyBoard.instantiateViewController(withIdentifier: "FriendsDetailsViewController") as? FriendsDetailsViewController
            
            if self.userDetailRecievedResponseArray.count != 0{
                
                //View profile Model object
                let modelObj = self.userDetailRecievedResponseArray[0] as? userDetailModel
                
                //Send userId to next screen
                friendsDetailViewController?.userIdOfSelectUser = modelObj?.userID
            }
            
            self.navigationController?.pushViewController((friendsDetailViewController)!, animated: false)
    }
    
    func removePublishActivityCell(cellAdress:PublishAnActivityTableViewCell) -> Void{
        
        sectionsCountOfTableView = sectionsCountOfTableView - 1
        
        //Removing publish activity cell
        activityTableView.deleteSections(NSIndexSet(index: 1) as IndexSet, with: UITableViewRowAnimation.automatic)
        
    }
    
    func callFeedActivityApiProtocol(userSelectedCityName: String?) -> Void{
        
        //Set Activity View Header as user city name
        self.userCityLabel.text = userSelectedCityName ?? "City"
        
        if singleTon.sharedInstance.isUserInterestsAdded()! {
            
                //Set page refreshing to false to remove previous response and reload table view
                self.isPageRefrshing = false
            
                //Call get activity Feed api method
                pageCount = 1
                self.getActivityFeedApi(pageCount:pageCount)
                
        }
        else{
            
            //Show alert for add interests and after pressing OK btn navigate to Add interests screen
            self.showAltertForAddInterestsAndNavigateToAddInterestsScreen()
            
        }
        
    }
    
    //MARK:- Swipe Gesture recognizer Methods
    func handleSwipes(_ sender:UISwipeGestureRecognizer) {
        
        if (sender.direction == .left) {
            
            print("Swipe Left")
            
        }
        
        if (sender.direction == .right) {
            
            print("Swipe Right")
            
        }
        
        if sender.direction == .up {
            
            print("Swipe up")
            //Open sub view
            self.openSubView()
        }
        
        if sender.direction == .down {
            
            print("Swipe down")
            
            //Close sub view
            self.closeSubView()
            
        }
        
    }
    
    func tapSubviewToSelectLocation(){
        
        //Display choose location pop up screen
        self.chooseLocationPopUpScreenDisplay()
        
    }
    
    //MARK:- IB Actions
    
    @IBAction func createActivityBtnAction(_ sender: UIButton) {
        
        //Navigate to create activity view controller
        self.navigateToThematicsListController(createActivityOrAddInterests: "CreateActivity")
        
    }
    
    @IBAction func closeAction(_ sender: UIButton){
        
        self.closeSubView();
    }
    
    @IBAction func openAction(_ sender: UIButton) {
        
        self.openSubView()
        
    }
    
    @IBAction func BackToPreviousScreen(_ sender: UIButton) {
        
      _ = navigationController?.popViewController(animated: false)
        
    }
    
    @IBAction func filterActivityActionInsideSearch(_ sender: UIButton) {
        
        //Navigate to filter screen
        self.navigateToFilterScreen()
    }
    
    @IBAction func filterActivtyActionWhenScrollDown(_ sender: UIButton) {
        
        //Navigate to filter screen
        self.navigateToFilterScreen()
    }

    @IBAction func showUserCurrentLocation(_ sender: UIButton) {
        
        //Show user current location
        LocationManager.sharedInstanceOfLocationManager.displayUserLocation()
    }

    @IBAction func moveToActivityDetailViewController(_ sender: UIButton){
        
        //Navigate to activity detail view controller
        self.navigateToActivityDetailViewController(buttonTag:sender.tag)
        
    }
    
    //MARK:- Private Methods
    func closeSubView() -> Void {
        
        UIView.animate(withDuration: 1.0,
                       delay: 0.1,
                       options: UIViewAnimationOptions.transitionCurlDown,
                       animations: { () -> Void in
                        
                       // self.tabBarController?.tabBar.isHidden = true
                        
                        //Reframe front sub view
                        let xValueForView = 0
                        let yValueOfView =  (self.view.frame.size.height/12)
                        let viewWidth = self.view.frame.size.width
                        let viewHeight = 0
                        
                        self.mainSubView.frame = CGRect(x: xValueForView, y: (Int(yValueOfView+self.view.frame.size.height)), width:Int(viewWidth) , height:viewHeight)
                        
                        print("view height before close:\(viewHeight)")
                        
        }, completion: { (finished) -> Void in
            // ....
        })
        
    }
    
    func openSubView() -> Void {
        
        UIView.animate(withDuration: 1.0,
                       delay: 0.1,
                       options: UIViewAnimationOptions.transitionCurlUp,
                       animations: { () -> Void in
                        
                     //   self.tabBarController?.tabBar.isHidden = false
                        
                        //Reframe front sub view
                        let xValueForView = 0
                        let yValueOfView = (self.view.frame.size.height/12)
                        let viewWidth = self.view.frame.size.width
                        let viewHeight = (self.view.frame.size.height - yValueOfView)
                        
                        self.mainSubView.frame = CGRect(x: CGFloat(xValueForView), y: yValueOfView, width:viewWidth , height:viewHeight)
                        print("view height after open:\(viewHeight)")
                        
                        
        }, completion: { (finished) -> Void in
            // ....
        })
        
    }
    
    //font Awesome Image
    func fontAwesomeImages() -> Void
    {
        //Filter btn image
        filterButton.titleLabel?.font = UIFont.fontAwesome(ofSize: 20)
        filterButton.setTitle(String.fontAwesomeIcon(name: .sliders), for: .normal)
        filterButton.setTitleColor(UIColor.white, for: UIControlState.normal)
        filterButton.layer.cornerRadius = filterButton.frame.size.width/2
        filterButton.clipsToBounds = true
        filterButton.isHidden = true
        
        //PlusButton image
        plusButtonPressed.titleLabel?.font = UIFont.fontAwesome(ofSize: 20)
        plusButtonPressed.setTitle(String.fontAwesomeIcon(name: .plus), for: .normal)
        plusButtonPressed.setTitleColor(UIColor.white, for: UIControlState.normal)
        plusButtonPressed.layer.cornerRadius = plusButtonPressed.frame.size.width/2
        plusButtonPressed.clipsToBounds = true
        
        //Open btn image
        openBtn.titleLabel?.font = UIFont.fontAwesome(ofSize: 20)
        openBtn.setTitle(String.fontAwesomeIcon(name: .chevronUp), for: .normal)
        openBtn.setTitleColor(UIColor.white, for: UIControlState.normal)
        openBtn.layer.cornerRadius = 5
        
        //Close btn image
        closeBtn.titleLabel?.font = UIFont.fontAwesome(ofSize: 20)
        closeBtn.setTitle(String.fontAwesomeIcon(name: .chevronDown), for: .normal)
        closeBtn.setTitleColor(UIColor.white, for: UIControlState.normal)
        closeBtn.layer.cornerRadius = 5
        
    }
    
    func displayAlertMessage(message: String?) -> Void {
        
        //Display alert
        let alertController = singleTon.sharedInstance.displayAlert(message: message!, title: "Fiturb")
        self.present(alertController, animated: true, completion: nil)
        
    }
    
    func selectedUserAndActivityInformationAction(_ sender: UIButton) {
        
        if self.feedActivityApiResponseRecievedArray.count != 0{
            
            //Feed actvity model obj
            let feedActivityModelObj = self.feedActivityApiResponseRecievedArray[sender.tag] as? FeedActivityModel
            
            //User ID
            let selectedUserID: String? = feedActivityModelObj?.userId
            
            //calling view profile api
            self.viewProfileApi(userId: selectedUserID)
            
        }
        
    }
    
    func chooseLocationPopUpScreenDisplay() -> Void {
        
        let storyBoard = UIStoryboard(name:"Main", bundle: nil)
        
        self.chooseLocationScreenPopUpObj = storyBoard.instantiateViewController(withIdentifier: "ChooseLocationViewController") as? ChooseLocationViewController
        
        self.chooseLocationScreenPopUpObj?.view.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height)
        
        //Set choose location protocol delgate
        self.chooseLocationScreenPopUpObj?.chooseLocationProtocolDelegate = self
        
        self.view.addSubview((self.chooseLocationScreenPopUpObj?.view)!)
    }
    
    func showAltertForLocationUpdateAndNavigateToChooseLocationScreen() -> Void {
        
        //Show alert(Update user location)
        let alert = UIAlertController(title: "Fiturb",
                                      message: "Please update your location!",
                                      preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Ok", style: .default,handler:{ action -> Void in
            
            //Nvaigate to Choose location screen
            self.chooseLocationPopUpScreenDisplay()
            
        }))
        
        self.present(alert, animated: true, completion: nil)
        
    }
    
    func showAltertForAddInterestsAndNavigateToAddInterestsScreen() -> Void{
        
        //Show alert(Add user interests)
        let alert = UIAlertController(title: "Fiturb",
                                      message: "Please add your interests!",
                                      preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Ok", style: .default,handler:{ action -> Void in
            
            //Nvaigate to thematics list screen
            self.navigateToThematicsListController(createActivityOrAddInterests:"AddInterests")
            
        }))
        
        self.present(alert, animated: true, completion: nil)
        
    }
    
    func downloadAndCacheImage(imageUrl: String?, imageViewName:UIImageView?, indexPath: NSIndexPath?, andCacheName:inout NSCache<AnyObject, AnyObject>?) -> Void {
        
        //Cache initialization
        andCacheName = andCacheName ?? NSCache()
        
        if andCacheName?.object(forKey: (indexPath!).row as AnyObject) != nil {
            
            //Use Cache data
            print("Cached image used, no need to download it")
            
            //Set image
            imageViewName?.image = andCacheName?.object(forKey: (indexPath!).row as AnyObject) as? UIImage
        }
        else{
            
            //Session initialization
            session = session ?? URLSession.shared
            
            //DownLoad session Task initialization
            task = task ?? URLSessionDownloadTask()
            
            let url: URL? = URL(string: imageUrl!)
            
            task = session?.downloadTask(with: url!, completionHandler: { [andCacheName] (location: URL?, response: URLResponse?, error: Error?) -> Void in
                
                if let data = try? Data(contentsOf: location!){
                    
                    //In main thread set image
                    DispatchQueue.main.async(execute: { 
                        () -> Void in
                        
                        // Before we assign the image, check whether the current cell is visible
                        if self.activityTableView.cellForRow(at: indexPath! as IndexPath) != nil{
                            
                            let image: UIImage? = UIImage(data: data)
                            
                            imageViewName?.image = image
                            
                            //Store images inside Cache
                            andCacheName?.setObject(image!, forKey: (indexPath)?.row as AnyObject)
                            
                        }
    
                    })
                    
                }
                
            })
        
            task?.resume()

        }
        
    }
    
    //MARK:- Table view Delegate and Datasource methods
    func numberOfSections(in tableView: UITableView) -> Int {
        
        var sectionsCount:Int = 0
        
        //If there is proper response
        if (self.feedActivityApiResponseRecievedArray.count != 0){
            
            if(sectionsCountOfTableView != 2) {
        
                //Compulsory(means include advertimsement cell)
                sectionsCountOfTableView = 3

                sectionsCount = sectionsCountOfTableView
            
            }
            else{
                
                //Without advertisement cell
                sectionsCount = sectionsCountOfTableView
                
            }
        
        }
        
        return sectionsCount
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        var rowsCount:Int = 0
        
        if (self.feedActivityApiResponseRecievedArray.count != 0) {
            
            switch section {
            case 0:
                
                //Search cell
                rowsCount = 1
                
            case 1:
                
                if sectionsCountOfTableView == 3
                {
                    //Advertisement cell
                    rowsCount = 1
                }
                else{
                    
                    //Activity cell
                    rowsCount = (self.feedActivityApiResponseRecievedArray.count != 0) ? self.feedActivityApiResponseRecievedArray.count : 1
                }
                
            case 2:
                
                //Activity cell
                rowsCount = (self.feedActivityApiResponseRecievedArray.count != 0) ? self.feedActivityApiResponseRecievedArray.count : 1
                
            default: rowsCount = 0
                break
            }
            
        
        }
        
        return rowsCount
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.section {
        case 0:
            
            //Search table view custom cell
            let advanceSearchCell = self.loadSearchAdvancedCustomCell(withIndexPath: indexPath)
            
            return advanceSearchCell!
            
        case 1:
            
            if (sectionsCountOfTableView == 3){
             
                //Advertisement table custom cell
                let publishActivityCell = self.loadPublishActivityCustomCell(withIndexPath: indexPath)
                
                return publishActivityCell!
                
            }
            else{
                
                //Activity table view custom cell when section count  == 2
                let activityCustomCell = self.loadActivityCustomCell(withIndexPath: indexPath)
                
                return activityCustomCell!
                
            }
            
        case 2:
            
            //Activity table view custom cell when section count  == 3
            let activityCustomCell = self.loadActivityCustomCell(withIndexPath: indexPath)
            
            return activityCustomCell!
            
        default:
            return UITableViewCell()
        }

    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        var heightOfTableViewCustomCell:CGFloat?
        
        switch indexPath.section {
            
        case 0:
            
            heightOfTableViewCustomCell = 71
            
        case 1:
            
            heightOfTableViewCustomCell = 216
            
            
        case 2:
            
            heightOfTableViewCustomCell = 191
            
            
        default:
            
            heightOfTableViewCustomCell = 0
            
        }
        
        return heightOfTableViewCustomCell!
        
    }

    //MARK:- Tableview Custom cells Private methods
    func loadActivityCustomCell(withIndexPath:IndexPath?) -> ActivityTableViewCell? {
        
        let cellIdentifier: String = "ActivityTableViewCell"
        
        //Activity table view custom cell
        let activityCustomCell = self.activityTableView.dequeueReusableCell(withIdentifier: cellIdentifier,for: withIndexPath!) as? ActivityTableViewCell
        
        if self.feedActivityApiResponseRecievedArray.count != 0{
            
            //Activity feed model object
            let modelObj = self.feedActivityApiResponseRecievedArray[(withIndexPath?.row)!] as? FeedActivityModel
            
            //Set tag for buttonToSelectUserActivityDetailInfo button
            activityCustomCell?.buttonToSelectUserActivityDetailInfo.tag = (withIndexPath?.row)!
            
            //set view user profile Button tag
            activityCustomCell?.viewUserProfileButton.tag = (withIndexPath?.row)!
            
            //Set activity table view cell delegate
            activityCustomCell?.activityTableViewCellDelegate = self
            
            activityCustomCell?.viewUserProfileButton.addTarget(self, action:#selector(selectedUserAndActivityInformationAction(_:)), for: .touchUpInside)
            
            //Custom cell data
            activityCustomCell?.activityTableviewCustomCellData(cellIndxpathNumber:withIndexPath?.row,organiserName: modelObj?.organisedBy, activityName: modelObj?.activityName, actitivityDescription:modelObj?.descriptionText, dateAndTime:modelObj?.activityTime, cityName: modelObj?.cityName, likesCount: modelObj?.likeCount, sharesCount: modelObj?.sharesCount, commentsCount: modelObj?.commentsCount,distance:modelObj?.distance, userProfileImageUrl: modelObj?.userThumb, isLikedValue: modelObj?.isLiked, hexColourStringValue: modelObj?.hexColourString)
            
            //Load user profile image
            self.downloadAndCacheImage(imageUrl: modelObj?.userThumb, imageViewName: activityCustomCell?.userprofilePicImageView, indexPath: withIndexPath as NSIndexPath?, andCacheName: &cacheUserProfilePic)
            
            
//            //Load Activity joined members image
//            for joinedMemberImage in (modelObj?.joinedMembersImageUrls)! {
//                
//                 self.downloadAndCacheImage(imageUrl: joinedMemberImage as? String, imageViewName: activityCustomCell?.userprofilePicImageView, indexPath: withIndexPath as NSIndexPath?, andCacheName: &cacheActivityJoinedMembers)
//            }
        }
        
        return activityCustomCell
    }

    
    func loadSearchAdvancedCustomCell(withIndexPath:IndexPath?) -> AdvanceSearchTableViewCell? {
        
        let advanceSearchCell = self.activityTableView.dequeueReusableCell(withIdentifier: "AdvanceSearchTableViewCell") as? AdvanceSearchTableViewCell
        
        filterButton.isHidden = true
        
        //Add fontawesome image
        advanceSearchCell?.addfilterImage()
        
        return advanceSearchCell
        
    }
    
    func loadPublishActivityCustomCell(withIndexPath:IndexPath?) -> PublishAnActivityTableViewCell? {
        
        //Advertisement table custom cell
        let publishActivityCell = self.activityTableView.dequeueReusableCell(withIdentifier: "PublishAnActivityTableViewCell") as? PublishAnActivityTableViewCell
        
        //Set prptocol delegate
        publishActivityCell?.publishActivityDelegate = self
        
        publishActivityCell?.publishAnActivityMaterialDesignPart()
        
        return publishActivityCell
    }
    
    //MARK:- ScrollView Delegate Methods
    public func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>)
    {
        if self.feedActivityApiResponseRecievedArray.count != 0{
            
            filterButton.isHidden = false
            
            //Reload zeroth section cell of table view
             activityTableView.reloadSections(NSIndexSet(index: 0) as IndexSet, with: .none)

        }
        
    }
    
    public func scrollViewDidScroll(_ scrollView: UIScrollView){
        
        if (self.activityTableView.contentOffset.y >= (self.activityTableView.contentSize.height - self.activityTableView.bounds.size.height)) {
            
            if (isPageRefrshing == false){
        
                isPageRefrshing = true
                
                //Increment paging count
                pageCount = pageCount + 1
                
                //Call get activity api
                self.getActivityFeedApi(pageCount: pageCount)
                
            }
            
        }
        
    }
    
    //MARK:- Navigation methods
    func navigateToThematicsListController(createActivityOrAddInterests:String?) -> Void {
        
        //Create actvity or add interests action
        UserDefaults.standard.set(createActivityOrAddInterests, forKey:"CreateActivityOrAddInterests")

        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        
        let thematicsListViewController = storyBoard.instantiateViewController(withIdentifier: "ThematicsListViewController") as? ThematicsListViewController
        
        self.navigationController?.pushViewController((thematicsListViewController)!, animated: false)
    }
    
    func navigateToFilterScreen() -> Void {
        
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        
        let activityFilterViewControllerObj = storyBoard.instantiateViewController(withIdentifier: "activityFilterViewController") as? activityFilterViewController
        self.navigationController?.pushViewController((activityFilterViewControllerObj)!, animated: false)
    }

    func displaySelectedUserInfoAndActivityPopUpScreen() -> Void {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        self.selectedUserAndActivityInfoPopUpOBj = storyboard.instantiateViewController(withIdentifier: "SelectedUserAndActivitiesInfoViewController") as? SelectedUserAndActivitiesInfoViewController
        
        //Set delegate
        self.selectedUserAndActivityInfoPopUpOBj?.selectedUserAndActivitiesDelegate = self
        
        if self.userDetailRecievedResponseArray.count != 0{
            
            //Pass view profile response to pop up screen
            self.selectedUserAndActivityInfoPopUpOBj?.viewProfileApiResponseRecivedArray = self.userDetailRecievedResponseArray
        }
        
        self.selectedUserAndActivityInfoPopUpOBj?.view.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height)
        
        self.view.addSubview((self.selectedUserAndActivityInfoPopUpOBj?.view)!)
    }
    
    func navigateToActivityDetailViewController(buttonTag:Int?) -> Void {
        
        //ActivityDetailViewController
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        
        let activityDetailViewControllerObj = storyBoard.instantiateViewController(withIdentifier: "ActivityDetailViewController") as? ActivityDetailViewController
        
        //Send Selcted user activity to Activity detail View model
        let feedActivityModelObj = self.feedActivityApiResponseRecievedArray[buttonTag!] as? FeedActivityModel
        activityDetailViewControllerObj?.activityDetailViewModelObj?.selectedActivityID = feedActivityModelObj?.activityId
        
        self.navigationController?.pushViewController((activityDetailViewControllerObj)!, animated: false)
        
    }
}
