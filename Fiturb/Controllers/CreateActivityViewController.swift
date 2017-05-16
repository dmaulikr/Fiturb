//
//  CreateActivityViewController.swift
//  Fiturb
//
//  Created by DATAPPS on 4/7/17.
//  Copyright © 2017 Fiturb.DATAPPS. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class CreateActivityViewController: UIViewController,UITextFieldDelegate,CLLocationManagerDelegate,MKMapViewDelegate{
    
    //MARK:- IBOutlet
    @IBOutlet weak var freeButton: UIButton!
    
    @IBOutlet weak var cancelButtonImage: UIButton!
    
    @IBOutlet weak var payingButton: UIButton!
    
    @IBOutlet weak var timeTextField: UITextField!
    
    @IBOutlet weak var dateTextField: UITextField!
    
    @IBOutlet weak var titleTextFiled: UITextField!
    
    @IBOutlet weak var payingTextFiled: UITextField!
    
    @IBOutlet weak var maximumTextField: UITextField!
    
    @IBOutlet weak var noButton: UIButton!
    
    @IBOutlet weak var maximumButton: UIButton!
    
    @IBOutlet weak var maximumAndNoImage: UIImageView!
    
    @IBOutlet weak var infoImage: UIImageView!
    
    @IBOutlet weak var freeAndPayingImage: UIImageView!
    
    @IBOutlet weak var writeTitleImage: UIImageView!
    
    @IBOutlet weak var dateAndTimeImage: UIImageView!
    
    @IBOutlet weak var createActivitySubView: UIView!
    
    @IBOutlet weak var descriptionTextField: UITextField!
    
    @IBOutlet weak var switchObj: UISwitch!
    
    @IBOutlet weak var userLocationShowBtn: UIButton!

    var selectedLocation : Dictionary<String,CLLocationDegrees>?
    
    var datePicker:UIDatePicker!
    
    var timepicker:UIDatePicker!
    
    var thematicsInterestListModel: InterestListOfThematicsModel?
    
    var createActivityApiResponseRecievedArray = [Any?]()
    
    //Mapview
//    var annotation: MKPointAnnotation? = nil
//    
//    var centerAnnotationView: MKPinAnnotationView?
//    
//     var locationManager: CLLocationManager?
    
    @IBOutlet weak var mapViewObject: MKMapView!
    
    //MARK:- Life Cycle methods
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.payingTextFiled.isHidden = true
        
        self.maximumTextField.isHidden = true

        //Enable No  and free radio btns intially
         self.noButton.setImage(UIImage(named: "RadioCheckBtnImage"), for: .selected)
        self.noButton.isSelected = true
        
        self.freeButton.setImage(UIImage(named: "RadioCheckBtnImage"), for: .selected)
        self.freeButton.isSelected = true
        

        //User Current location btn image
        self.userLocationShowBtn.setImage(UIImage(named:"UserCurrentLocation"), for: .normal)
        self.userLocationShowBtn.layer.cornerRadius = 6.0
        
        //MAPVIEW: initializing location manager class to get current location
        self.mapViewObject.tag  = 1
        LocationManager.sharedInstanceOfLocationManager.initializeLocationManagerToGetCurrentLocation(mapViewObjectLoadingClass: self.mapViewObject)

    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        
        //DatePicker Method
        self.datePickerMethod()
        
        //TimePicker Method
        self.timePickerMethod()
        
        //FontAwesome Images
        self.fontAwesomeImage()
    }
   
    override func viewWillDisappear(_ animated: Bool) {
        
        super.viewWillDisappear(animated)
        
        //Reset map view annotation object
        LocationManager.sharedInstanceOfLocationManager.resetMapViewAnnotation()
        
    }
    
    //MARK:- Api methods
    func createActivityApi() -> Void {
        
        //Add Loader
        MBProgressHUD.showAdded(to: self.view, withScreenHeaderHeigth: 0.0, animated: true)
        
        //Create Activity url
        let urlString = MyAppConstants.createActivityUrl
        
        //Activity name
        let activityName = titleTextFiled.text ?? ""
        
        //Activity time
        let activityTime = dateTextField.text ?? ""
        
        //Interest Id
        let interestId = thematicsInterestListModel?.interestId ?? ""
        
        //Entry fess
        let entryFess = payingTextFiled.text ?? "Free"
        
        //Description
        let description = descriptionTextField.text ?? ""

        //capacity
        let capacity = maximumTextField.text ?? "No"
        
        //Public or private activity
        let publicOrPrivate = self.switchObj.isOn ? "true" : "false"
        
        //Latitude
        let latitude = selectedLocation?["Latitude"] ?? 0
        
        //let longitude
        let longitude = selectedLocation?["Longitude"] ?? 0
        
        if (latitude == 0) || (longitude == 0) {
            
            //Remove Loader
            MBProgressHUD.hide(for: self.view, animated: true)
            
            //Dsiplay alert
            let alertController = singleTon.sharedInstance.displayAlert(message: "Please select location to create activity!", title: "Fiturb")
            self.present(alertController, animated: true, completion: nil)
            return
            
        }
        
        //let postData
        let postdata = ["activity_name":activityName, "interest_id":interestId, "capacity":capacity, "activity_time":activityTime, "end_time":"2014-28-07", "description":description, "longitude":longitude, "latitude":latitude, "entry_fees":entryFess, "private_activity":publicOrPrivate, "image":""] as Dictionary<String,AnyObject>
        
        ApiDataManager.singleTonObjectForApiManagerClass.createActivityApiValuesWithUrlString(urlString: urlString, withPostData: postdata,callBackBlock: { (apiRecievedResponse:Array?, error:NSError?) in
            
            //Remove Loader
            MBProgressHUD.hide(for: self.view, animated: true)
            
            //Remove Create activity previous response
            if self.createActivityApiResponseRecievedArray.count != 0 {
                
                self.createActivityApiResponseRecievedArray.removeAll()
            }
            
            guard error == nil else{
                
                //Error handling
                print("Error recieved from Create activity request api is:\(error!.localizedFailureReason!)")
                
                //Dsiplay alert
                let alertController = singleTon.sharedInstance.displayAlert(message: (error!.localizedFailureReason!), title: "Fiturb")
                self.present(alertController, animated: true, completion: nil)
                
                return
                
            }
            
            self.createActivityApiResponseRecievedArray = apiRecievedResponse!
            
            if self.createActivityApiResponseRecievedArray.count != 0{
                
                let tempObj = self.createActivityApiResponseRecievedArray[0] as? CreateActivityModel
                
                print("Create activity model object values are:\(tempObj?.message!)")
                
                //Navigate to Activity view controller
                self.navigateToActivityViewController()
                
            }
            
        })
        
    }
    
//    //MARK:- MKMapView methods
//    func initializeLocationManagerToGetCurrentLocation() -> Void{
//        
//        mapViewObject.delegate = self
//        
//        mapViewObject.showsUserLocation = true
//        
//        locationManager?.desiredAccuracy = kCLLocationAccuracyBest
//        
//        locationManager?.delegate = self
//        
//        //Check for Location Services
//        if (CLLocationManager.locationServicesEnabled()) {
//            
//            locationManager = CLLocationManager()
//            
//            locationManager?.delegate = self
//            
//            locationManager?.desiredAccuracy = kCLLocationAccuracyBest
//            
//            locationManager?.requestAlwaysAuthorization()
//            
//            locationManager?.requestWhenInUseAuthorization()
//            
//        }
//        
//        locationManager?.requestWhenInUseAuthorization()
//        
//        if CLLocationManager.locationServicesEnabled() {
//            
//            locationManager?.startUpdatingLocation()
//            
//        }
//    }
//
//    func createAnotationView() -> Void {
//        
//        if annotation == nil {
//            
//            self.annotation = MKPointAnnotation()
//        }
//        
//        self.centerAnnotationView =  self.mapView(self.mapViewObject, addInsideAnnotationView: annotation!) as? MKPinAnnotationView
//        
//        self.mapViewObject.addSubview(self.centerAnnotationView!)
//    }
//    
//    //initialize centre annotation view
//    func mapView(_ mapView: MKMapView,
//                 addInsideAnnotationView: MKAnnotation) -> MKAnnotationView?{
//        
//        if(self.centerAnnotationView == nil){
//            
//            self.centerAnnotationView = (MKPinAnnotationView.init(annotation: self.annotation, reuseIdentifier: "centerAnnotationView"))
//            
//            self.centerAnnotationView?.pinTintColor = UIColor.red
//            
//        }
//        
//        return self.centerAnnotationView
//    }
//    
//    //Keep annotation view in the middle of map view
//    func moveMapAnnotationToCoordinate(coordinate: CLLocationCoordinate2D) -> Void {
//        
//        let mapViewPoint: CGPoint = self.mapViewObject.convert(coordinate, toPointTo: self.mapViewObject)
//        
//        var xOffset: CGFloat = 0.0
//        if ((self.centerAnnotationView?.bounds.midX) != nil){
//            
//            xOffset = ((self.centerAnnotationView?.bounds.midX)! - 15)
//        }
//        
//        var yOffset: CGFloat = 0.0
//        if ((self.centerAnnotationView?.bounds.midY) != nil){
//            
//            yOffset = (-(self.centerAnnotationView?.bounds.midY)! - 10)
//        }
//        
//        self.centerAnnotationView?.center = CGPoint(x: mapViewPoint.x + xOffset, y: mapViewPoint.y + yOffset)
//        
//    }
//    
//    //MKmapView delegate method
//    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
//        
//        if (self.annotation?.coordinate.latitude != self.mapViewObject.centerCoordinate.latitude) || (self.annotation?.coordinate.longitude != self.mapViewObject.centerCoordinate.longitude){
//            
//            self.annotation?.coordinate = mapView.centerCoordinate
//            
//            //Method to keep pin always in the middle of map view
//            self.moveMapAnnotationToCoordinate(coordinate: mapView.centerCoordinate)
//            
//            print("map view center latitude :\(self.mapViewObject.centerCoordinate.latitude) and longtude is:\(self.mapViewObject.centerCoordinate.longitude)")
//        }
//        
//    }
//    
//    //MapView Delegate method
//    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//        
//            manager.stopUpdatingLocation()
//            
//            //User curent location
//            let userLocation:CLLocation = locations[0] as CLLocation
//            
//            let coordinations = CLLocationCoordinate2D(latitude: userLocation.coordinate.latitude,longitude: userLocation.coordinate.longitude)
//            
//            let span = MKCoordinateSpanMake(1,1)
//            
//            let region = MKCoordinateRegion(center: coordinations, span: span)
//            
//            mapViewObject.setRegion(region, animated: true)
//        
//    }
    
    //MARK:- IBAction Methods
    @IBAction func freeButtonPressed(_ sender: UIButton)
    {
        let RadioButtonforFree:UIButton = sender
        
        self.radiobuttonActionforFree(RadioButtonforFree)
        
    }
    
    @IBAction func payingButtonPressed(_ sender: UIButton)
    {
        let RadioButtonforPaying:UIButton = sender
        self.radiobuttonActionforPaying(RadioButtonforPaying)
    }
    
    @IBAction func noButtonPressed(_ sender: UIButton)
    {
        let RadioButtonforNo:UIButton = sender
        
        self.radiobuttonActionforNo(RadioButtonforNo)

    }
    
    @IBAction func maximumButtonPressed(_ sender: UIButton)
    {
        let RadioButtonforMaximum:UIButton = sender
        
        self.radiobuttonActionforMaximum(RadioButtonforMaximum)

    }
    
    @IBAction func closeSubView(_ sender: UIButton) {
        
        //Close create activity sub view
        self.closeSubView()
    }
    
    @IBAction func selectLocationAction(_ sender: UIButton) {
        
        //Get lat and longtiude of selected location
        selectedLocation =  LocationManager.sharedInstanceOfLocationManager.getSelectedLocationAdress()
        
            print("Selected locations lat:\(selectedLocation?["Latitude"]) and longitude: \(selectedLocation?["Longitude"])")
            
        //Open create activity sub view
        self.openSubView()
        
    }
    
//    @IBAction func selectLocationAction(_ sender: UIButton) {
//        
//        //If both lat and long are zero
//        if (self.annotation?.coordinate.latitude == 0) && (self.annotation?.coordinate.longitude == 0){
//            
//            self.annotation?.coordinate = self.mapViewObject.centerCoordinate
//            
//        }
//        
//        //Open create activity sub view
//        self.openSubView()
//        
//    }

    @IBAction func validateCreateActivityAction(_ sender: UIButton) {
        
        //call Create activty api
        self.createActivityApi()
        
    }
    
    
    @IBAction func switchValueChangedAction(_ sender: UISwitch) {
        

    }
    
    
    @IBAction func cancelActivityAction(_ sender: Any) {
        
        //Navigate to Activity view controller
        self.navigateToActivityViewController()
        
    }
    
    @IBAction func showUserCurrentLocation(_ sender: UIButton) {
        
        //Show user current location
        LocationManager.sharedInstanceOfLocationManager.displayUserLocation()
    }

    
    //MARK:- Private Methods
    func closeSubView() -> Void {
        
        UIView.animate(withDuration: 1.0,
                       delay: 0.1,
                       options: UIViewAnimationOptions.transitionCurlDown,
                       animations: { () -> Void in
                        
                        //Reframe front sub view
                        let xValueForView = 0
                        let yValueOfView =  (self.view.frame.size.height/4.13)
                        let viewWidth = self.view.frame.size.width
                        let viewHeight = 0
                        
                        self.createActivitySubView.frame = CGRect(x: xValueForView, y: (Int(yValueOfView+self.view.frame.size.height)), width:Int(viewWidth) , height:viewHeight)
                        
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
                        
                        //Reframe front sub view
                        let xValueForView = 0
                        let yValueOfView = (self.view.frame.size.height/4.13)
                        let viewWidth = self.view.frame.size.width
                        let viewHeight = (self.view.frame.size.height - yValueOfView)
                        
                        self.createActivitySubView.frame = CGRect(x: CGFloat(xValueForView), y: yValueOfView, width:viewWidth , height:viewHeight)
                        print("view height after open:\(viewHeight)")
                        
                        
        }, completion: { (finished) -> Void in
            // ....
        })
        
    }

    
    //MARK:- TextField Delegate Methods
     public func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        
        textField.resignFirstResponder()
        
        return true
    }
    
    //MARK:- Private Methods
    //date PickerMethod
    func datePickerMethod()
    {
        datePicker = UIDatePicker()
        
        datePicker.datePickerMode = .dateAndTime
        
        dateTextField.inputView = datePicker

        let dateToolBar = UIToolbar().ToolbarPiker(doneAction: #selector(self.showSelectedDate), cancelAction: #selector(self.cancel_clicked))
        
        dateTextField.inputAccessoryView = dateToolBar
    }
    
    func showSelectedDate()
    {
        
        self.view .endEditing(true)
        
        let formatter = DateFormatter()
        
        // formatter.dateFormat = "dd-MM-yyyy"
        
        formatter.dateFormat = "yyyy-MM-dd hh:mm:ss a"

        dateTextField.text = formatter.string(from: datePicker.date)
        
    }
    
    func cancel_clicked()
    {
        
        dateTextField.text = ""
        self.view .endEditing(true)
        
    }
    
    //Time Picker Method
    func timePickerMethod()
    {
        timepicker = UIDatePicker()
        
//        timepicker.datePickerMode = .time
        
        timepicker.datePickerMode = .date

        timeTextField.inputView = timepicker
        
        let timeToolBar = UIToolbar().ToolbarPiker(doneAction: #selector(self.showSelectedTime), cancelAction: #selector(self.cancel_clickedTime))
        
        timeTextField.inputAccessoryView = timeToolBar
    }
    
    func showSelectedTime()
    {
        let formatter = DateFormatter()
        
//        formatter.dateFormat = "hh mm a"
        
       // formatter.dateFormat = "dd-MM-yyyy"

        formatter.dateFormat = "yyyy-MM-dd hh:mm:ss a"

        timeTextField.text = formatter.string(from: timepicker.date)
        
        self.view.endEditing(true)
    }
    
    func cancel_clickedTime()
    {
        
        timeTextField.text = ""
        
        self.view.endEditing(true)
        
    }
    
    //Button action for free
    func radiobuttonActionforFree(_ Button: UIButton) {
        
        if !Button.isSelected
        {
            Button.isSelected = true
            Button.setImage(UIImage(named: "RadioCheckBtnImage"), for: .selected)
            
            //Hide paying text field
            self.payingTextFiled.isHidden = true
            
            self.payingButton.setImage(UIImage(named: "RadioUnCheckBtnImage"), for: .normal)
            self.payingButton.isSelected = false
            
        }
        else{
            
            Button.isSelected = false
            Button.setImage(UIImage(named: "RadioUnCheckBtnImage"), for: .normal)
            
        }
        
    }
    
    //Button action for pay
    func radiobuttonActionforPaying(_ Button: UIButton) {
        
        if !Button.isSelected
        {
            Button.isSelected = true
            
            Button.setImage(UIImage(named: "RadioCheckBtnImage"), for: .selected)
            
            //Unhide paying text field
             self.payingTextFiled.isHidden = false
            
            self.freeButton.setImage(UIImage(named: "RadioUnCheckBtnImage"), for: .normal)
            
            self.freeButton.isSelected = false
            
        }
        else {
            
            Button.isSelected = false
            
            Button.setImage(UIImage(named: "RadioUnCheckBtnImage"), for: .normal)
            
            //Hide paying text field
            self.payingTextFiled.isHidden = true
        }
        
    }
    
    //Button action for No
    func radiobuttonActionforNo(_ Button: UIButton) {
        
        if !Button.isSelected
        {
            Button.isSelected = true
            Button.setImage(UIImage(named: "RadioCheckBtnImage"), for: .selected)
            
            //Hide maximum text field
            self.maximumTextField.isHidden = true
            
            self.maximumButton.setImage(UIImage(named: "RadioUnCheckBtnImage"), for: .normal)
            
            self.maximumButton.isSelected = false
        }
        else {
            Button.isSelected = false
            Button.setImage(UIImage(named: "RadioUnCheckBtnImage"), for: .normal)
            
        }
        
    }
    
    //Button action for Maximum
    func radiobuttonActionforMaximum(_ Button: UIButton) {
        
        if !Button.isSelected
        {
            Button.isSelected = true
            Button.setImage(UIImage(named: "RadioCheckBtnImage"), for: .selected)
            
            //UnHide maximum text field
            self.maximumTextField.isHidden = false
            
            self.noButton.setImage(UIImage(named: "RadioUnCheckBtnImage"), for: .normal)
            self.noButton.isSelected = false
        }
        else {
            
            //Hide maximum text field
            self.maximumTextField.isHidden = true
            
            Button.isSelected = false
            Button.setImage(UIImage(named: "RadioUnCheckBtnImage"), for: .normal)
            
        }
    }
    
    //Font AwesomeImage
    func fontAwesomeImage()
    {
        self.writeTitleImage.image = UIImage.fontAwesomeIcon(name:.pencil, textColor: UIColor.lightGray, size: CGSize(width: 200, height: 200))
        
        self.dateAndTimeImage.image = UIImage.fontAwesomeIcon(name: .calendar, textColor: UIColor.black, size: CGSize(width: 200, height: 200))
        
        self.freeAndPayingImage.image = UIImage.fontAwesomeIcon(name: .money, textColor: UIColor.black, size: CGSize(width: 200, height: 200))
        
        self.infoImage.image = UIImage.fontAwesomeIcon(name: .info, textColor: UIColor.black, size: CGSize(width: 200, height: 200))
        
        self.maximumAndNoImage.image = UIImage.fontAwesomeIcon(name: .users, textColor: UIColor.black, size: CGSize(width: 200, height: 200))
        
        //Cance Button Image
        cancelButtonImage.setFAIcon(icon: .FATimes, iconSize: 25, forState: .normal)
        
        cancelButtonImage.setTitleColor(UIColor.white, for: .normal)

    }
    
    //MARK:- Navigation methods
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
