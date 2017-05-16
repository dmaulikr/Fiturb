//
//  activityFilterViewController.swift
//  Fiturb
//
//  Created by Admin on 11/04/17.
//  Copyright © 2017 Fiturb.DATAPPS. All rights reserved.
//

import UIKit
import MapKit

class activityFilterViewController: UIViewController,UITableViewDataSource,UITableViewDelegate,UIPickerViewDelegate,UIPickerViewDataSource,selectLocationProtocol {

    //MARK:- IBOutlets
    
    @IBOutlet weak var chekmarkButton: UIButton!
    
    @IBOutlet weak var cancelButton: UIButton!
    
    @IBOutlet weak var filterTableView: UITableView!
    
    //Distance Picker
    var byLocationCell:ByLocationTableViewCell!
    
    var distancePicker:UIPickerView!
    
    let distanceArray = ["2 Km","3 Km","4 Km","5 Km","6 Km","7 Km","8 Km","9 Km","10 Km","11 Km","12 Km","13 Km"," 14 Km","15 Km"]
    let sportsArray = ["cricket","foot ball","billiards","bowling","tennis"]
    let hangoutsArray = ["coffe","dance","drinks","party","pub"]
    let entertainmentArray = ["movies","plays","satge show","comedy talks","dance"]
    let travelArray = ["trekking","bike-ride","car-ride","waterfall","hill station"]
    
    
    var byActivityCell:ByActivityTableViewCell!
    //sports picker
    var sportsPicker:UIPickerView!
    //Enterinment Picker
    var entertainmentPicker:UIPickerView!
    //Hangouts Picker
    var hangoutsPicker:UIPickerView!
    //Travel Picker
    var travelPicker:UIPickerView!
    
    var latitudeObj: CLLocationDegrees?
    
    var longitudeObj: CLLocationDegrees?
    
    //MARK:- ViewLife Cycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Custom xib cell
        filterTableView.register(UINib(nibName: "ByActivityTableViewCell", bundle: nil), forCellReuseIdentifier: "ByActivityTableViewCell")

        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        cancelButton.setFAIcon(icon: .FATimes, iconSize: 25, forState: .normal)
        
        cancelButton.setTitleColor(UIColor.white, for: .normal)
        
        //chermark Imageview
        chekmarkButton.setFAIcon(icon: .FACheck, iconSize: 25, forState: .normal)
        
        chekmarkButton.setTitleColor(UIColor.white, for: .normal)
        
    }
    
    //MARK:- Selected location protocol method
    func passSelectedLocationAdress(latAndLongDict:Dictionary<String, CLLocationDegrees>?) -> Void{
        
        //Show Selected location
        self.showSelectedLocationOnMapView(latAndLongDict:latAndLongDict)
        
    }
    
    func showSelectedLocationOnMapView(latAndLongDict:Dictionary<String, CLLocationDegrees>?) -> Void {
        
        if let latitude = latAndLongDict?["Latitude"],let longitude = latAndLongDict?["Longitude"]{
            
        let coordinations = CLLocationCoordinate2D(latitude: latitude,longitude:longitude)
        
        //Zoom to showing location
        let span = MKCoordinateSpanMake(1,1)
        
        let region = MKCoordinateRegion(center: coordinations, span: span)
        
        let annotation = MKPointAnnotation()
            
        annotation.coordinate = coordinations
            
        byLocationCell.mapViewObjectOfActivityFilter.addAnnotation(annotation)
            
        byLocationCell.mapViewObjectOfActivityFilter?.setRegion(region, animated: true)
            
        }
        
    }
    
    //MARK:- IBActiones
    
    @IBAction func cancelButtonPressed(_ sender: UIButton) {
        
        _ = navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func mapSelectedAction(_ sender: UIButton) {
        
        //Navigate to Selcect location view controller
        self.navigateSelectLocationViewController()
        
    }
    //MARK:- Private Methods
    
    
    ///Distance pickerView
    
    func distancePickerMethod()
    {
        distancePicker = UIPickerView(frame: CGRect.zero)
        
        distancePicker.tag = 101
        distancePicker.delegate = self
        distancePicker.dataSource = self
        distancePicker.showsSelectionIndicator = true
        //Tool bar
        
        //let toolBar = UIToolbar().ToolbarPiker(#selector(FilterHomeViewController.dismissPicker))
        
        let distanceToolBar = UIToolbar().ToolbarPiker(doneAction: #selector(self.doneDistance), cancelAction: #selector(self.cancelDistance))
        self.byLocationCell.distanceTextFiled.inputView = distancePicker
        
        self.byLocationCell.distanceTextFiled.inputAccessoryView = distanceToolBar
        
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
    
    
    //Sports picker
    
    
    func sportsPickerMethod()
    {
        sportsPicker = UIPickerView(frame: CGRect.zero)
        
        sportsPicker.tag = 102
        sportsPicker.delegate = self
        sportsPicker.dataSource = self
        sportsPicker.showsSelectionIndicator = true
        //Tool bar
        
        //let toolBar = UIToolbar().ToolbarPiker(#selector(FilterHomeViewController.dismissPicker))
        
        let sportsToolBar = UIToolbar().ToolbarPiker(doneAction: #selector(self.doneDistance), cancelAction: #selector(self.cancelDistance))
        self.byActivityCell.sportsTextFileld.inputView = sportsPicker
        
        self.byActivityCell.sportsTextFileld.inputAccessoryView = sportsToolBar
        
        
    }
    
    //Entertainment Picker
    func entertainmentPickerMethod()
    {
        entertainmentPicker = UIPickerView(frame: CGRect.zero)
        
        entertainmentPicker.tag = 103
        entertainmentPicker.delegate = self
        entertainmentPicker.dataSource = self
        entertainmentPicker.showsSelectionIndicator = true
        //Tool bar
        
        //let toolBar = UIToolbar().ToolbarPiker(#selector(FilterHomeViewController.dismissPicker))
        
        let entertainmentToolBar = UIToolbar().ToolbarPiker(doneAction: #selector(self.doneDistance), cancelAction: #selector(self.cancelDistance))
        self.byActivityCell.entertainmentTextFiled.inputView = entertainmentPicker
        
        self.byActivityCell.entertainmentTextFiled.inputAccessoryView = entertainmentToolBar
        
        
    }
    
    //Hangouts Picker
    
    func hangoutsPickerMethod()
    {
        hangoutsPicker = UIPickerView(frame: CGRect.zero)
        
        hangoutsPicker.tag = 104
        hangoutsPicker.delegate = self
        hangoutsPicker.dataSource = self
        hangoutsPicker.showsSelectionIndicator = true
        //Tool bar
        
        //let toolBar = UIToolbar().ToolbarPiker(#selector(FilterHomeViewController.dismissPicker))
        
        let hangoutsToolBar = UIToolbar().ToolbarPiker(doneAction: #selector(self.doneDistance), cancelAction: #selector(self.cancelDistance))
        self.byActivityCell.hangoutTextField.inputView = hangoutsPicker
        
        self.byActivityCell.hangoutTextField.inputAccessoryView = hangoutsToolBar
        
        
    }
    
    //Travel Picker
    func travelPickerMethod()
    {
        travelPicker = UIPickerView(frame: CGRect.zero)
        
        travelPicker.tag = 105
        travelPicker.delegate = self
        travelPicker.dataSource = self
        travelPicker.showsSelectionIndicator = true
        //Tool bar
        
        //let toolBar = UIToolbar().ToolbarPiker(#selector(FilterHomeViewController.dismissPicker))
        
        let travelToolBar = UIToolbar().ToolbarPiker(doneAction: #selector(self.doneDistance), cancelAction: #selector(self.cancelDistance))
        self.byActivityCell.travelTextFiled.inputView = travelPicker
        
        self.byActivityCell.travelTextFiled.inputAccessoryView = travelToolBar
        
        
    }
    
    //Add the dropDown imageView
    
    
    func addDropDownImageView(dropDownImage:UIImageView)
    {
        
        dropDownImage.image = UIImage.fontAwesomeIcon(name:.caretDown, textColor: UIColor.black, size: CGSize(width: 200, height: 200))
    }
    
    
    //MARK:-UITableView Datasource Methods
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 4
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 1
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.section {
        case 0:
            
            let sortBycell = tableView.dequeueReusableCell(withIdentifier: "SortByTableViewCell", for: indexPath) as! SortByTableViewCell
            
            return sortBycell
            
            
        case 1:
            
            byLocationCell = tableView.dequeueReusableCell(withIdentifier: "ByLocationTableViewCell", for: indexPath) as! ByLocationTableViewCell
            
            byLocationCell.selectLocationMapButton.layer.cornerRadius = (byLocationCell.selectLocationMapButton.frame.size.height/2)
            
            //Show selected location
            let selectedLocation  = NSMutableDictionary()
            //Latitude
            selectedLocation.setValue(byLocationCell.mapViewObjectOfActivityFilter?.centerCoordinate.latitude, forKey: "Latitude")
            //Longitude
            selectedLocation.setValue(byLocationCell.mapViewObjectOfActivityFilter?.centerCoordinate.longitude, forKey: "Longitude")
            
            self.showSelectedLocationOnMapView(latAndLongDict:selectedLocation as? Dictionary<String, CLLocationDegrees>)
            
            distancePickerMethod()
            
            //Add dropdown image
            addDropDownImageView(dropDownImage: byLocationCell.dropDownDistanceImage)
            
            
            return byLocationCell
            
            
        case 2:
            
            byActivityCell = tableView.dequeueReusableCell(withIdentifier: "ByActivityTableViewCell", for: indexPath) as! ByActivityTableViewCell
            
            
            sportsPickerMethod()
            entertainmentPickerMethod()
            hangoutsPickerMethod()
            travelPickerMethod()
            //view border color
            byActivityCell.sportsView.layer.borderWidth = 1
            byActivityCell.sportsView.layer.borderColor = UIColor.blue.cgColor
            byActivityCell.hangoutsView.layer.borderWidth = 1
            byActivityCell.hangoutsView.layer.borderColor = UIColor.blue.cgColor
            
            
            //fontawesome images
            
            byActivityCell.travelImageView.image = UIImage.fontAwesomeIcon(name:.plane, textColor: UIColor.white, size: CGSize(width: 100, height: 100))
            
            addDropDownImageView(dropDownImage: byActivityCell.sportsDropDownImageView)
            addDropDownImageView(dropDownImage: byActivityCell.travelDropDownImage)
            addDropDownImageView(dropDownImage: byActivityCell.entertainmentDropDownImage)
            addDropDownImageView(dropDownImage: byActivityCell.hangOutsDropDownImage)
            
            
            
            
            return byActivityCell
            
        case 3:
            
            let byPeopleCell = tableView.dequeueReusableCell(withIdentifier: "ByPeopleTableViewCell", for: indexPath) as! ByPeopleTableViewCell
            
            return byPeopleCell
            
            
        default:
            
            return UITableViewCell()
        }
        
    }
    
    //MARK:-UITableView Delegate Methods
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 0:
            
            return 91
            
        case 1:
            
            return 281
            
            
        case 2:
            
            return 191
            
        case 3:
            
            return 101
            
        default:
            return 0
        }
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
            
            return distanceArray.count
        }
        else if  pickerView.tag == 102
            
        {
            return sportsArray.count
        }
        else if  pickerView.tag == 103
            
        {
            return entertainmentArray.count
        }
        else if  pickerView.tag == 104
            
        {
            return hangoutsArray.count
        }
        else
        {
            return travelArray.count
        }
        
        
        
        
        
        
        //return distanceArray.count
    }
    public func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String?
    {
        if pickerView.tag  == 101
        {
            return distanceArray[row]
            
        }
        else if pickerView.tag  == 102
            
        {
            return sportsArray[row]
        }
        else if pickerView.tag  == 103
            
        {
            return entertainmentArray[row]
        }
        else if pickerView.tag  == 104
            
        {
            return hangoutsArray[row]
        }
            
        else
        {
            
            return travelArray[row]
        }
        
        
        
        //return distanceArray[row]
    }
    
    public func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int)
        
    {
        if pickerView.tag  == 101
        {
            self.byLocationCell.distanceTextFiled.text = distanceArray[row]
            
        }
        else if pickerView.tag  == 102
            
        {
            
            self.byActivityCell.sportsTextFileld.text = sportsArray[row]
        }
            
        else if pickerView.tag  == 103
            
        {
            
            self.byActivityCell.entertainmentTextFiled.text = entertainmentArray[row]
        }
        else if pickerView.tag  == 104
            
        {
            
            self.byActivityCell.hangoutTextField.text = hangoutsArray[row]
        }
        else
            
        {
            
            self.byActivityCell.travelTextFiled.text = travelArray[row]
        }

    }

    //Navigate to select location viewController
    func navigateSelectLocationViewController() -> Void {
        
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        
        let selectLocationControllerObject = storyBoard.instantiateViewController(withIdentifier: "SelectLocationViewController") as! SelectLocationViewController
        
        //set delegate 
        selectLocationControllerObject.selecteLocationProtocolDelegate = self
        
        self.navigationController?.pushViewController(selectLocationControllerObject, animated: false)
    }
    
}
