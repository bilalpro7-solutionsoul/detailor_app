//
//  BusinessInfoViewController.swift
//  DailerApp
//
//  Created by Muhammad Bilal on 09/03/2020.
//  Copyright © 2020 Solution Soul. All rights reserved.
//

import UIKit
import Firebase
import GoogleMaps
import SVProgressHUD

class BusinessInfoViewController: UIViewController {
    
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var numberLabel: UILabel!
    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var nameLabel: UILabel!
    var businessPhone = ""
    var businessDescription = ""
    var businessUserID = ""
    var businessName = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        markPinBusiness()
        
        
        self.nameLabel.text = businessName
        self.numberLabel.text = businessPhone
        self.descriptionLabel.text = businessDescription
        
        self.navigationItem.title = "Info"
        
        let menuUIBarButtonItem = UIBarButtonItem(image: UIImage(named: "left-arrow.png"), style: .plain, target: self, action: #selector(BusinessInfoViewController.clickButton))
        menuUIBarButtonItem.tintColor = UIColor.white
        self.navigationItem.leftBarButtonItem  = menuUIBarButtonItem
        
        
    }
    
    func markPinBusiness(){
        SVProgressHUD.show(withStatus: "Loading...")
        
        print(businessUserID)
        
        let ref = Database.database().reference().child("listing").child("business").child(businessUserID).child("stores")
        ref.observe(DataEventType.value) { (snapshot) in
            if snapshot.childrenCount>0{
                
                for data in snapshot.children.allObjects as! [DataSnapshot]{
                    let obj = data.value as? [String: Any]
                    
                    let lat = obj?["lat"] as? String
                    let lon = obj?["lon"] as? String
                    
                    if lat?.count ?? 0 > 0 && lon?.count ?? 0 > 0{
                    let marker = GMSMarker()
                    marker.position = CLLocationCoordinate2D(latitude: Double(lat ?? "") as! CLLocationDegrees, longitude: Double(lon ?? "") as! CLLocationDegrees)
                    let startingPoint = CLLocationCoordinate2D(latitude: Double(lat ?? "") as! CLLocationDegrees, longitude: Double(lon ?? "") as! CLLocationDegrees)
                    //self.mapView.camera = GMSCameraPosition(latitude: startingPoint.latitude, longitude: startingPoint.longitude, zoom: 12)
                    self.mapView.animate(to: GMSCameraPosition(latitude: startingPoint.latitude, longitude: startingPoint.longitude, zoom: 12))
                    marker.map = self.mapView
                    
                    }
                    SVProgressHUD.dismiss()
                }
                
            }else{
                SVProgressHUD.dismiss()
                print("fetch word number not found")
            }
            
        }
    }
    
    @objc func clickButton(){
       self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func callButtonAction(_ sender: Any) {
        
        callerName = businessName
        callerNumber = businessPhone
        if let url = URL(string: "tel://\(businessPhone)"),
            UIApplication.shared.canOpenURL(url) {
            if #available(iOS 10, *) {
                UIApplication.shared.open(url, options: [:], completionHandler:nil)
            } else {
                UIApplication.shared.openURL(url)
            }
        } else {
            // add error message here
            print("error connecting with phone number")
        }
    }
    
}
