//
//  ChooseLocationViewController.swift
//  Fiturb
//
//  Created by DATAPPS on 4/24/17.
//  Copyright © 2017 Fiturb.DATAPPS. All rights reserved.
//

import UIKit
import GooglePlaces

protocol chooseLocationProtocol:class {
    
    func callFeedActivityApiProtocol(userSelectedCityName:String?) -> Void
    
}

class ChooseLocationViewController: UIViewController,GMSAutocompleteViewControllerDelegate {
    
    //MARK:IBOutlets
    
    //Protocol variable
    var chooseLocationProtocolDelegate:chooseLocationProtocol? = nil
    
    @IBOutlet weak var setLocationButton: UIButton!
    
    @IBOutlet weak var locationImageView: UIImageView!
    
    @IBOutlet weak var userLocationImageView: UIImageView!
    
    @IBOutlet weak var chooseLocationBtn: UIButton!
    
    var cityNameText: String? = ""
    
    var latitudeOfSelectedLocation: Double? = 0.0
    
    var longitudeOfSelectedLocation: Double? = 0.0
    
    //MARK:- ViewLifeCycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.materialDesignPartForChooseLocation()

    }
    
    //MARK:- Api Methods
    func updateLocationApi() -> Void {
        
        //Add Loader
        MBProgressHUD.showAdded(to: self.view, withScreenHeaderHeigth: 0.0, animated: true)
        
        //Update location url
        let urlString = String(format: "%@%@", MyAppConstants.baseUrlString,MyAppConstants.updateLocationUrl)
        
        //Post data
        let postData = ["latitude":self.longitudeOfSelectedLocation ?? 0.0,
                        "longitude":self.longitudeOfSelectedLocation ?? 0.0,
                        "city":self.cityNameText ?? ""] as [String : Any]
        
        ApiDataManager.singleTonObjectForApiManagerClass.updateLocationApiValuesWithUrlString(urlString: urlString, withPostData: postData, callBackBlock: { (apiRecievedResponse:Array?, error: NSError?) in
            
            //Remove Loader
            MBProgressHUD.hide(for: self.view, animated: true)
            
            guard error == nil else{
                
                //Error handling
                print("Error recieved from Update location request api is:\(error!.localizedFailureReason!)")
                
                //Dsiplay alert
                let alertController = singleTon.sharedInstance.displayAlert(message: (error!.localizedFailureReason!), title: "Fiturb")
                self.present(alertController, animated: true, completion: nil)
                
                return
                
            }
            
            var updateLocationApiRecievdResponse:[Any?] = apiRecievedResponse!
            
            if updateLocationApiRecievdResponse.count != 0{
                
                let tempObj = updateLocationApiRecievdResponse[0] as! UpdateLocationModel
                
                print("update location model object values are:\(tempObj.message!)")
                
                //set User Defaults isUserLocationUpdated Key to True
                UserDefaults.standard.set(true, forKey:"isUserLocationUpdated")
                
                //Remove Pop up
                self.view.removeFromSuperview()

                //Call Feed activity api protocol method
                self.chooseLocationProtocolDelegate?.callFeedActivityApiProtocol(userSelectedCityName: self.cityNameText)
                
            }

            
        })
        
    }
    
    //MARK:- IBActions
    
    @IBAction func setLocationButtonPressed(_ sender: Any) {
        
        //Call Update location api
        self.updateLocationApi()
        
    }
    
    @IBAction func chooseLocationAction(_ sender: UIButton) {
        
        //Display Google places search screen
        self.setAutoSearchPlacesDelegateAndPresentView()
    }
    
    //MARK:- GooglePlaces delegate methods
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        
        print("Place name: \(place.name),latitude: \(place.coordinate.latitude),and longitude: \(place.coordinate.longitude)")
        
        //Set City name
        let placeNameText:String? = place.name
        self.cityNameText = placeNameText ?? ""
        
        //Set Latitude
        let latitude : Double? = place.coordinate.latitude
        self.latitudeOfSelectedLocation = latitude ?? 0.0
        
        //Set langitude
        let longitude: Double? = place.coordinate.longitude
        self.longitudeOfSelectedLocation = longitude ?? 0.0
        
        //Set Selected location full adress to btn
        let detailAdress: String? = place.formattedAddress
        self.chooseLocationBtn.setTitle(detailAdress ?? "Enter your location here!", for: .normal)
        
        //Dismiss google place search screen
        dismiss(animated: true, completion: nil)
        
    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {

        print("Error: ", error.localizedDescription)
    }
    
    // User canceled the operation.
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        dismiss(animated: true, completion: nil)
    }
    
    // Turn the network activity indicator on and off again.
    func didRequestAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    
    func didUpdateAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }

    
    //MARK:- Private Methods
    
    func materialDesignPartForChooseLocation() -> Void
    {
        self.locationImageView.image = UIImage.fontAwesomeIcon(name: .mapMarker, textColor: UIColor.black, size: CGSize(width: 300, height: 300))
        
        self.setLocationButton.layer.cornerRadius = 5
        
    }
    
    func setAutoSearchPlacesDelegateAndPresentView() -> Void {
        
        let autocompleteController = GMSAutocompleteViewController()
        autocompleteController.delegate = self
        present(autocompleteController, animated: true, completion: nil)
    }

    //MARK:- UITextField DelegateMethods
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        
        return true
    }


    
}
