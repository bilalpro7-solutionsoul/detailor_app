//
//  AddBusinessLocationViewController.swift
//  DailerApp
//
//  Created by Muhammad Bilal on 10/03/2020.
//  Copyright © 2020 Solution Soul. All rights reserved.
//

import UIKit
import Firebase
import GoogleMaps
import SVProgressHUD
import GooglePlaces

class AddBusinessLocationViewController: UIViewController,UITextFieldDelegate, CLLocationManagerDelegate {
    
    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var searchTF: UITextField!
    @IBOutlet weak var selectedLocationLabel: UILabel!
    
    @IBOutlet weak var searchView: CustomView!
    let locationManager = CLLocationManager()
     let placesClient = GMSPlacesClient()
    
    var itemStore = StoresStructure(address: " ", key: " ", lat: " ", lon: " ")
    var lat = ""
    var lon = ""
    var address = ""
    var isEdit = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Search for address"
        
        
        // Ask for Authorisation from the User.
        self.locationManager.requestAlwaysAuthorization()
        setUpSearchView()
        // For use in foreground
        self.locationManager.requestWhenInUseAuthorization()

        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.startUpdatingLocation()
        }
        
        if isEdit {
            self.selectedLocationLabel.text = self.itemStore.address
        }else{
            
        }
        
        let menuUIBarButtonItem = UIBarButtonItem(image: UIImage(named: "left-arrow.png"), style: .plain, target: self, action: #selector(AddBusinessLocationViewController.clickButton))
        menuUIBarButtonItem.tintColor = UIColor.white
        self.navigationItem.leftBarButtonItem  = menuUIBarButtonItem
        self.searchTF.delegate = self
        self.searchTF.addTarget(self, action: #selector(searchEditFunc), for: .editingChanged)
        
    }
    
    func setUpSearchView() {
        
        let gesture = UITapGestureRecognizer(target: self, action:  #selector (self.searchTapped))
        self.searchTF.addGestureRecognizer(gesture)

       
    }
    
    @objc func searchTapped(_ sender:UITapGestureRecognizer){
               print("search was clicked")
        
        let autocompleteController = GMSAutocompleteViewController()
        autocompleteController.delegate = self

        // Specify the place data types to return.
        let fields: GMSPlaceField = GMSPlaceField(rawValue: UInt(GMSPlaceField.name.rawValue) |
          UInt(GMSPlaceField.placeID.rawValue) | UInt(GMSPlaceField.coordinate.rawValue) |
          GMSPlaceField.addressComponents.rawValue |
            GMSPlaceField.formattedAddress.rawValue)
        autocompleteController.placeFields = fields

        // Specify a filter.
        let filter = GMSAutocompleteFilter()
        filter.type = .address
        autocompleteController.autocompleteFilter = filter

        // Display the autocomplete view controller.
        present(autocompleteController, animated: true, completion: nil)
           }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let locValue:CLLocationCoordinate2D = manager.location!.coordinate
        let userLocation :CLLocation = locations[0] as CLLocation

        
        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(userLocation) { (placemarks, error) in
            if (error != nil){
                print("error in reverseGeocode")
            }
            let placemark = placemarks! as [CLPlacemark]
            if placemark.count>0{
                let placemark = placemarks![0]
                print(placemark.locality!)
                print(placemark.administrativeArea!)
                print(placemark.country!)

//                self.labelAdd.text = "\(placemark.locality!), \(placemark.administrativeArea!), \(placemark.country!)"
            }
        }
        

        print("locations = \(locValue.latitude) \(locValue.longitude)")
    }
    
    @IBAction func useLocationButtonAction(_ sender: Any) {
        
        if searchTF.text?.count ?? 0 > 0 {
         
        if isEdit {
            var userID = ""
            if let userid = defaults.string(forKey: userData.id) {
                print(userid) // Another String Value
                userID = userid
            }
            let ref = Database.database().reference().child("listing").child("business").child(userID).child("stores")
            let key = self.itemStore.key
            let data = ["address":"\(self.searchTF.text!)","key":"\(key)","lat":lat,"lon":lon] as [String : Any]
            ref.child(key).setValue(data)
            self.navigationController?.popViewController(animated: true)
        }else{
            var userID = ""
            if let userid = defaults.string(forKey: userData.id) {
                print(userid) // Another String Value
                userID = userid
            }
            let ref = Database.database().reference().child("listing").child("business").child(userID).child("stores")
            let key = ref.childByAutoId().key
            let data = ["address":"\(self.searchTF.text!)","key":"\(key!)","lat":lat,"lon":lon] as [String : Any]
            ref.child(key!).setValue(data)
            self.navigationController?.popViewController(animated: true)
        }
    }
        
        else{
            showAlert(title: "Alert!", message: "Enter Address")
        }
    }
    @objc func searchEditFunc(){
        self.selectedLocationLabel.isHidden = false
        self.selectedLocationLabel.text = self.searchTF.text
    }
    @objc func clickButton(){
        self.navigationController?.popViewController(animated: true)
    }
}


extension AddBusinessLocationViewController:GMSAutocompleteViewControllerDelegate{
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        
        print("Place name: \(place.name)")
        print("Place ID: \(place.placeID)")
        print("Place attributions: \(place.attributions)")
        print("Place location: \(place.coordinate)")
        print("Place lat: \(place.coordinate.latitude)")
        print("Place lon: \(place.coordinate.longitude)")
        print("Place address: \(place.formattedAddress)")
        
        lat = "\(place.coordinate.latitude)"
        lon = "\(place.coordinate.longitude)"
        address = "\(place.name ?? "")"
        searchTF.text = address
        //getPlaceData(placid: place.placeID ?? "")
        mapView.camera = GMSCameraPosition(latitude: place.coordinate.latitude, longitude: place.coordinate.longitude, zoom: 12)
        
        let position = CLLocationCoordinate2DMake(place.coordinate.latitude,place.coordinate.longitude)
        let marker = GMSMarker(position: position)
        //marker.title = "Hello World"
        marker.map = mapView
        
           dismiss(animated: true, completion: nil)
    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
         // TODO: handle the error.
           print("Error: ", error.localizedDescription)
    }
    
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        dismiss(animated: true, completion: nil)
    }
    
    
    func showAlert(title:String,message:String){
        let alert = UIAlertController(title: "\(title)", message: "\(message)", preferredStyle: .actionSheet)
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(action)
        self.present(alert,animated: true,completion: {
            self.navigationController?.popViewController(animated: true)
        })
    }
    
    
//    func getPlaceData(placid:String) {
//
//        let placeID = "ChIJV4k8_9UodTERU5KXbkYpSYs"
//
//        // Specify the place data types to return.
//        let fields: GMSPlaceField = GMSPlaceField(rawValue: UInt(GMSPlaceField.name.rawValue) |
//          UInt(GMSPlaceField.placeID.rawValue))!
//
//        placesClient.fetchPlace(fromPlaceID: placid, placeFields: fields, sessionToken: nil, callback: {
//          (place: GMSPlace?, error: Error?) in
//          if let error = error {
//            print("An error occurred: \(error.localizedDescription)")
//            return
//          }
//          if let place = place {
//            //self.lblName?.text = place.name
//            print(place)
//            print("The selected place is: \(place.name)")
//            print("Place lat: \(place.coordinate.latitude)")
//            print("Place lon: \(place.coordinate.longitude)")
//            print("Place address: \(place.formattedAddress)")
//          }
//        })
//    }
    
}
