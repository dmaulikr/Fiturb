//
//  LocationManager.swift
//  CenterPinMapView
//
//  Created by Admin on 12/04/17.
//  Copyright © 2017 Fiturb.DATAPPS. All rights reserved.
//

import Foundation
import MapKit
import CoreLocation

class LocationManager:NSObject,CLLocationManagerDelegate,MKMapViewDelegate  {
    
    //Location manager SingleTon Object
    static let sharedInstanceOfLocationManager = LocationManager()
    
    private override init() {
        
    }
    
    //Mapview
    var annotation: MKPointAnnotation? = nil
    
    var centerAnnotationView: MKPinAnnotationView?
    
    var locationManager: CLLocationManager?
    
    var mapViewObject: MKMapView?
    
    var userCurrentLocationegion: MKCoordinateRegion?
    
    //MARK:- MapView Delegate methods
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        
        if (self.annotation?.coordinate.latitude != self.mapViewObject?.centerCoordinate.latitude) || (self.annotation?.coordinate.longitude != self.mapViewObject?.centerCoordinate.longitude){
            
            self.annotation?.coordinate = mapView.centerCoordinate
            
            //Method to keep pin always in the middle of map view
            self.moveMapAnnotationToCoordinate(coordinate: mapView.centerCoordinate)
            
            print("map view center latitude :\(self.mapViewObject?.centerCoordinate.latitude) and longtude is:\(self.mapViewObject?.centerCoordinate.longitude)")
        }
        
    }
    
    //MapView Delegate method
//    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//        
//        manager.stopUpdatingLocation()
//        
//        //User curent location
//        let userLocation:CLLocation = locations[0] as CLLocation
//        
//        let coordinations = CLLocationCoordinate2D(latitude: userLocation.coordinate.latitude,longitude: userLocation.coordinate.longitude)
//        
//        let span = MKCoordinateSpanMake(1,1)
//        
//        let region = MKCoordinateRegion(center: coordinations, span: span)
//        
//        mapViewObject?.setRegion(region, animated: true)
//        
//    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        manager.stopUpdatingLocation()
        
        let userLocation: CLLocation = locations[0] as CLLocation
        
        let coordinates = CLLocationCoordinate2D(latitude: userLocation.coordinate.latitude, longitude: userLocation.coordinate.longitude)
        
        let spanObjct = MKCoordinateSpanMake(1, 1)
        
        //store user location to one variable
//        self.userCurrentLocationegion = MKCoordinateRegionMake(coordinates, spanObjct)
        self.userCurrentLocationegion = MKCoordinateRegion(center: coordinates, span: spanObjct)
        
    }
    
    //MARK:- Helper methods
    func initializeLocationManagerToGetCurrentLocation(mapViewObjectLoadingClass:MKMapView?) -> Void{
        
        //Store mapview object adress
        mapViewObject = mapViewObjectLoadingClass
        
        mapViewObject?.delegate = self
        
        mapViewObject?.showsUserLocation = true
        
        locationManager?.desiredAccuracy = kCLLocationAccuracyBest
        
        locationManager?.delegate = self
        
        //Check for Location Services
        if (CLLocationManager.locationServicesEnabled()) {
            
            locationManager = CLLocationManager()
            
            locationManager?.delegate = self
            
            locationManager?.desiredAccuracy = kCLLocationAccuracyBest
            
            locationManager?.requestAlwaysAuthorization()
            
            locationManager?.requestWhenInUseAuthorization()
            
        }
        
        locationManager?.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            
            locationManager?.startUpdatingLocation()
            
        }
        
        //Crete Annotation View
        self.createAnotationView()
        
    }

    func createAnotationView() -> Void {
        
        if annotation == nil {
            
            self.annotation = MKPointAnnotation()
        }
        
        self.centerAnnotationView =  self.mapView(self.mapViewObject, addInsideAnnotationView: annotation!) as? MKPinAnnotationView
        
        self.mapViewObject?.addSubview(self.centerAnnotationView!)
    }
    
    //initialize centre annotation view
    func mapView(_ mapView: MKMapView?,
                 addInsideAnnotationView: MKAnnotation) -> MKAnnotationView?{
        
        if(self.centerAnnotationView == nil){
            
            self.centerAnnotationView = (MKPinAnnotationView.init(annotation: self.annotation, reuseIdentifier: "centerAnnotationView"))
            
            self.centerAnnotationView?.pinTintColor = UIColor.red
            
        }
        
        return self.centerAnnotationView
    }
    
    //Keep annotation view in the middle of map view
    func moveMapAnnotationToCoordinate(coordinate: CLLocationCoordinate2D) -> Void {
        
        let mapViewPoint: CGPoint = (self.mapViewObject?.convert(coordinate, toPointTo: self.mapViewObject))!
        
        var xOffset: CGFloat = 0.0
        if ((self.centerAnnotationView?.bounds.midX) != nil){
            
            xOffset = ((self.centerAnnotationView?.bounds.midX)! - 15)
        }
        
        var yOffset: CGFloat = 0.0
        if ((self.centerAnnotationView?.bounds.midY) != nil){
            
            yOffset = (-(self.centerAnnotationView?.bounds.midY)! - 10)
        }
        
        self.centerAnnotationView?.center = CGPoint(x: mapViewPoint.x + xOffset, y: mapViewPoint.y + yOffset)
        
    }
    
    func getSelectedLocationAdress() -> Dictionary<String, CLLocationDegrees>? {
        
        let latAndLogdictionary = NSMutableDictionary()
        
        if (self.annotation != nil){
            
            //latitude
//             let latitude : NSNumber? = self.annotation?.coordinate.latitude as NSNumber?
//             latAndLogdictionary.setValue(latitude, forKey: "Latitude")
            
            //Longitude
//            let longitude : NSNumber? = self.annotation?.coordinate.longitude as NSNumber?
//            latAndLogdictionary.setValue(longitude, forKey: "Longitude")
            
            
            //latitude
            latAndLogdictionary.setValue(self.annotation?.coordinate.latitude, forKey: "Latitude")
            
            //Longitude
            latAndLogdictionary.setValue(self.annotation?.coordinate.longitude, forKey: "Longitude")
            
            return latAndLogdictionary as? Dictionary<String,CLLocationDegrees>
            
        }
        else{
            
            return nil

        }
        
    }
    
    func displayUserLocation() -> Void {
        
        if (mapViewObject != nil){
            
            if((userCurrentLocationegion) != nil){
                
                 mapViewObject?.setRegion(self.userCurrentLocationegion!, animated: true)
            }
           
        }
        
    }
    
    func resetMapViewAnnotation() -> Void {
        
        self.annotation = nil
    }
    
}
