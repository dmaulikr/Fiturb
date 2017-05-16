//
//  SelectLocationViewController.swift
//  Fiturb
//
//  Created by Admin on 12/04/17.
//  Copyright © 2017 Fiturb.DATAPPS. All rights reserved.
//

import UIKit
import MapKit

//protocol
protocol selectLocationProtocol:class {
    
    func passSelectedLocationAdress(latAndLongDict:Dictionary<String, CLLocationDegrees>?) -> Void
}

class SelectLocationViewController: UIViewController {
    
    @IBOutlet weak var backBtn: UIButton!
    
    @IBOutlet weak var mapviewObj: MKMapView!

    //Protocol object
    var selecteLocationProtocolDelegate: selectLocationProtocol? = nil
    
    @IBOutlet weak var userLocationShowBtn: UIButton!

    //MARK:- Life cycle methods
    override func viewDidLoad() {
        
        super.viewDidLoad()

        self.backBtn.setFAIcon(icon:.FAArrowLeft, iconSize: 20, forState: .normal)
        
        self.backBtn.setTitleColor(UIColor.black, for: .normal)
        
        //User Current location btn image
        self.userLocationShowBtn.setImage(UIImage(named:"UserCurrentLocation"), for: .normal)
        self.userLocationShowBtn.layer.cornerRadius = 6.0

        //MAPVIEW: initializing location manager class to get current location
        self.mapviewObj.tag  = 2
        LocationManager.sharedInstanceOfLocationManager.initializeLocationManagerToGetCurrentLocation(mapViewObjectLoadingClass: self.mapviewObj)
        
    }

    override func viewWillDisappear(_ animated: Bool) {
        
        super.viewWillDisappear(animated)
        
        //Reset map view annotation object
        LocationManager.sharedInstanceOfLocationManager.resetMapViewAnnotation()
        
    }
    
    //MARK:- IBActions
    @IBAction func locationSelectAction(_ sender: UIButton) {
        
        //Get lat and longtiude of selected location
        let selectedLocation : Dictionary<String,CLLocationDegrees>? =  LocationManager.sharedInstanceOfLocationManager.getSelectedLocationAdress()
        
        if (selectedLocation != nil) {
            
            if let _ = selectedLocation?["Latitude"],let _ = selectedLocation?["Longitude"]{
                
                //Call prptocol method
                selecteLocationProtocolDelegate?.passSelectedLocationAdress(latAndLongDict: selectedLocation)
                
            }
            
        }
        
        //Pop to activity filter view controller
        self.navigateToActivityFilterViewController()
    }

    @IBAction func backBtnAction(_ sender: UIButton) {
        
        //Pop to activity filter view controller
        self.navigateToActivityFilterViewController()
    }
    
    func navigateToActivityFilterViewController() -> Void {
        
        _ = navigationController?.popViewController(animated: false)

        
    }
    
    @IBAction func showUserCurrentLocation(_ sender: UIButton) {
        
        //Show user current location
        LocationManager.sharedInstanceOfLocationManager.displayUserLocation()
    }
    
}
