//
//  SearchDetailViewController.swift
//  DailerApp
//
//  Created by Muhammad Bilal on 27/02/2020.
//  Copyright © 2020 Solution Soul. All rights reserved.
//

import UIKit
import Firebase
import Kingfisher
import SVProgressHUD
import CoreLocation



class SearchDetailViewController: UIViewController {
    
    @IBOutlet weak var profileViewContainer: CustomView!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var questionMarkLabel: UILabel!
    @IBOutlet weak var numberLabel: UILabel!
    @IBOutlet weak var wordNumberLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var linksArray = [BusinessLinksStructure]()
    
    var contactsUser = ContactStructure(actionsVisible: "false", inDatabase: "false", key: "", name: "", phoneNo: "", userId: "")
    var contactType = ""
    var previousViewCheck = ""
    
    var isBusinessProfile = true
    var personalUserID = ""
    var personalPhoneNumber = ""
    
    var businessProfile = ""
    
    let transition = SlideInTransition()
    var businessUserID = ""
    
    var businessDescription = ""
    var businessPhoneNo = ""
     var wordNumberPersonal = ""
    var userName = ""
    var personalCountry = ""
    
    var userBusinessProfile = UserProfile(address: "", businessProfileKey: "", email: "", hasBusinessProfile: "", hasBusinessWordNum: "", hasPersonalWordNum: "", id: "", imageUrl: "", name: "", password: "", personalProfileKey: "", phoneNo: "", userLogin: "")
    
    var userBusiness = BussinessDetails(logoUrl: "", areaCode: "", description: "", name: "", phoneNo: "")
    
    override func viewWillAppear(_ animated: Bool) {
        self.numberLabel.text = self.personalPhoneNumber
        self.addressLabel.text = self.personalCountry
        if previousViewCheck == "contact" {
            
        }else{
            
        }
        
        if (self.businessProfile == "business"){
        getBusinessUserData()
        //getBusinessData()
    }
        else {
            
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
      
              getBusinessUserData()
              //getBusinessData()
          
             
      
           fetchUserLinks()
        
        
       
        if (self.businessProfile == "business"){
        self.wordNumberLabel.text = ""
        }
        else {
            self.wordNumberLabel.text = self.wordNumberPersonal
        }
        
        self.profileImage.layer.cornerRadius = 8
        
        self.navigationItem.title = "\(userName)"
        
        let menuUIBarButtonItem = UIBarButtonItem(image: UIImage(named: "menuWhite.png"), style: .plain, target: self, action: #selector(FreeVanityNumber1ViewController.clickButton))
        menuUIBarButtonItem.tintColor = UIColor.white
        self.navigationItem.leftBarButtonItem  = menuUIBarButtonItem
        
        transition.dimmingView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismisFunc)))
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(self.handleGesture(gesture:)))
        swipeLeft.direction = .left
        self.transition.dimmingView.addGestureRecognizer(swipeLeft)
        
    }
    
    @objc func handleGesture(gesture: UISwipeGestureRecognizer) -> Void {
        if gesture.direction == UISwipeGestureRecognizer.Direction.left {
            print("Swipe Left")
            dismiss(animated: true, completion: nil)
            //swipeDirectionLabel.text = "Swiped Right"
        }
        
    }
    
    @objc func dismisFunc(){
        dismiss(animated: true, completion: nil)
    }
    
    @objc func clickButton(){
        let vc = storyboard?.instantiateViewController(withIdentifier: "MenuViewController") as! MenuViewController
        vc.modalPresentationStyle = .overCurrentContext
        vc.transitioningDelegate = self
        present(vc,animated: true)
    }
    
    @IBAction func dailyOrderButtonAction(_ sender: Any) {

//        var userID = ""
//        if let userid = defaults.string(forKey: userData.id) {
//            print(userid) // Another String Value
//            userID = userid
//        }
//
//        let ref = Database.database().reference().child("listing").child("business").child(userID).child("offers")
//        ref.observe(DataEventType.value) { (snapshot) in
//            if snapshot.childrenCount>0{
//
//                for data in snapshot.children.allObjects as! [DataSnapshot]{
//                    let obj = data.value as? [String: Any]
//
//                    //let actionsVisible = obj?["actionsVisible"] as! Bool
//
//                }
//
//            }else{
//                SVProgressHUD.dismiss()
//                print("business contact not found")
//            }
//
//        }
        
        let alert = UIAlertController(title: "Error", message: "Website is in devvelopment please come soon again", preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(action)
        self.present(alert,animated: true,completion: nil)
    }
    
    func fetchUserDescription(){
        if(isBusinessProfile == true) {
        SVProgressHUD.show(withStatus: "Loading...")
        
        print(businessUserID)
        
        let ref = Database.database().reference().child("listing").child("business").child(businessUserID).child("details")
        ref.observe(DataEventType.value) { (snapshot) in
            if snapshot.childrenCount>0{
                
                let data = snapshot.value as? [String : Any]//.children.allObjects as! DataSnapshot
                let obj = data//.value as? [String: Any]
                
                let description = obj?["description"] as! String
                let phoneNo = obj?["phoneNo"] as! String
                
                self.businessDescription = description
                self.businessPhoneNo = phoneNo
                
                let logoUrl = obj?["logoUrl"] as? String
                let name = obj?["name"] as! String
                let slogan = obj?["slogan"] as! String
                
                self.userBusiness.logoUrl = logoUrl ?? ""
                self.userBusiness.name = name
                self.userBusiness.phoneNo = phoneNo
                
                self.profileImage.kf.setImage(with: URL(string: logoUrl ?? ""),placeholder: UIImage(named: ""))
                self.navigationItem.title = name
                self.addressLabel.text = slogan
                self.numberLabel.text = phoneNo
                SVProgressHUD.dismiss()
                
            }
            SVProgressHUD.dismiss()
        }
    }
        
        
        else{
            if(personalUserID == ""){
                           personalUserID = businessUserID
                       }
            SVProgressHUD.show(withStatus: "Loading...")
                   
                   print(businessUserID)
                   
            let ref = Database.database().reference().child("listing").child("personal").child(personalUserID)
                    
                    //.child(businessUserID).child("details")
                   ref.observe(DataEventType.value) { (snapshot) in
                       if snapshot.childrenCount>0{
                           
                           let data = snapshot.value as? [String : Any]//.children.allObjects as! DataSnapshot
                           let obj = data//.value as? [String: Any]
                           
                          // let description = obj?["description"] as! String
                          // let phoneNo = obj?["phoneNo"] as! String
                           
                           //self.businessDescription = description
                           self.businessPhoneNo = self.personalPhoneNumber
                           
                           //let logoUrl = obj?["logoUrl"] as? String
                           let name = obj?["name"] as! String
                          // let slogan = obj?["slogan"] as! String
                           
                          // self.userBusiness.logoUrl = logoUrl ?? ""
                           self.userBusiness.name = name
                           self.userBusiness.phoneNo = self.personalPhoneNumber
                           
                         //  self.profileImage.kf.setImage(with: URL(string: logoUrl ?? ""),placeholder: UIImage(named: ""))
                           self.navigationItem.title = name
                          // self.addressLabel.text = slogan
                        self.numberLabel.text = self.personalPhoneNumber
                           SVProgressHUD.dismiss()
                           
                       }
                       SVProgressHUD.dismiss()
                   }
        }
}
    
    func fetchUserLinks(){
        if(isBusinessProfile == true) {
        SVProgressHUD.show(withStatus: "Loading...")
//        var userID = ""
//        if let userid = defaults.string(forKey: userData.id) {
//            print(userid) // Another String Value
//            userID = userid
//        }
        print(businessUserID)
        
        let ref = Database.database().reference().child("listing").child("business").child(businessUserID).child("links")//.queryOrdered(byChild: "public").queryEqual(toValue: true)
        ref.observe(DataEventType.value) { (snapshot) in
            if snapshot.childrenCount>0{
                self.linksArray.removeAll()
                for data in snapshot.children.allObjects as! [DataSnapshot]{
                    let obj = data.value as? [String: Any]
                    
                    let key = obj?["key"] as? String
                    let link = obj?["link"] as! String
                    let name = obj?["name"] as! String
                    let publics = true//obj?["public"] as! Bool
                    
                    let objLink = BusinessLinksStructure(key: key ?? "" , link: link, name: name, publics: publics)
                    
                    self.linksArray.append(objLink)
                    self.collectionView.reloadData()
                    SVProgressHUD.dismiss()
                }
                
            }else{
                SVProgressHUD.dismiss()
                print("business contact not found")
            }
            
        }
    }
        else {
            self.linksArray.removeAll()
            SVProgressHUD.show(withStatus: "Loading...")
            if(personalUserID == ""){
                personalUserID = businessUserID
            }
                    print(personalUserID)
                    let ref = Database.database().reference().child("listing").child("personal").child(personalUserID).child("links")//.queryOrdered(byChild: "public").queryEqual(toValue: true)
                    ref.observe(DataEventType.value) { (snapshot) in
                        if snapshot.childrenCount>0{
                            self.linksArray.removeAll()
                            for data in snapshot.children.allObjects as! [DataSnapshot]{
                                let obj = data.value as? [String: Any]
                                
                                let key = obj?["key"] as? String
                                let link = obj?["link"] as! String
                                let name = obj?["name"] as! String
                                let publics = true//obj?["public"] as! Bool
                                
                                let objLink = BusinessLinksStructure(key: key ?? "" , link: link, name: name, publics: publics)
                                
                                self.linksArray.append(objLink)
                                self.collectionView.reloadData()
                                SVProgressHUD.dismiss()
                            }
                            
                        }else{
                            SVProgressHUD.dismiss()
                            print("personal contact not found")
                        }
                        
                    }
        }
}
    
    func fetchWordNumber(uid:String){
        SVProgressHUD.show(withStatus: "Loading...")
        
        print(uid)
        
        let ref = Database.database().reference().child("profiles").queryOrdered(byChild: "userId").queryEqual(toValue: uid)
        ref.observe(DataEventType.value) { (snapshot) in
            if snapshot.childrenCount>0{
                
                for data in snapshot.children.allObjects as! [DataSnapshot]{
                    let obj = data.value as? [String: Any]
                    
                    let type = obj?["type"] as! String
                    let wordNum = obj?["wordNum"] as! String
                    
                    if type == "business" {
                        if (self.businessProfile == "business"){
                        self.wordNumberLabel.text = wordNum
                        }
                        else {
                            self.wordNumberLabel.text = self.wordNumberPersonal
                        }
                    }
                    else {
                        if (self.businessProfile == "business"){
                                    self.wordNumberLabel.text = wordNum
                            }
                            else {
                            self.wordNumberLabel.text = self.wordNumberPersonal
                                }
                    }
                    
                    SVProgressHUD.dismiss()
                }
                
            }else{
                SVProgressHUD.dismiss()
                print("fetch word number not found")
            }
            
        }
        
    }
    
    
     func getBusinessData(){
         if(isBusinessProfile == true) {
        
        SVProgressHUD.show(withStatus: "Loading...")
        let ref = Database.database().reference().child("listing").child("business").child(businessUserID)
        ref.observe(DataEventType.value) { (snapshot) in
            if snapshot.childrenCount>0{
                
                print("snapshotbussiness",snapshot)
                let data = snapshot.value as? [String : Any]//.children.allObjects as! DataSnapshot
                let obj = data//.value as? [String: Any]
                
                let detail = obj?["details"] as? [String: Any]
               
                //let id = self.businessUserID
                let imageUrl = detail?["logoUrl"] as? String
                let name = detail?["name"] as! String
                let phoneNo = detail?["phoneNo"] as! String
                
               
              
                self.userBusiness.logoUrl = imageUrl ?? ""
                self.userBusiness.name = name
                self.userBusiness.phoneNo = phoneNo
            
            }
            SVProgressHUD.dismiss()
            
        }
        
    }
         else {
            if(personalUserID == ""){
                personalUserID = businessUserID
            }
            SVProgressHUD.show(withStatus: "Loading...")
            let ref = Database.database().reference().child("listing").child("personal").child(personalUserID).child("links")
                  ref.observe(DataEventType.value) { (snapshot) in
                      if snapshot.childrenCount>0{
                        
                        
                        self.linksArray.removeAll()
                        for data in snapshot.children.allObjects as! [DataSnapshot]{
                            let obj = data.value as? [String: Any]
                            
                            let key = obj?["key"] as? String
                            let link = obj?["link"] as! String
                            let name = obj?["name"] as! String
                            let publics = true//obj?["public"] as! Bool
                            
                            let objLink = BusinessLinksStructure(key: key ?? "" , link: link, name: name, publics: publics)
                            
                            self.linksArray.append(objLink)
                            self.collectionView.reloadData()
                            SVProgressHUD.dismiss()
                        }
                        
                        
                        
                          
                          print("snapshotbussiness",snapshot)
                          let data = snapshot.value as? [String : Any]//.children.allObjects as! DataSnapshot
                          let obj = data//.value as? [String: Any]
                          
                          let detail = obj?["details"] as? [String: Any]
                         
                          //let id = self.businessUserID
                          let imageUrl = detail?["logoUrl"] as? String
                          let name = detail?["name"] as! String
                          let phoneNo = detail?["phoneNo"] as! String
                          
                         
                        
                          self.userBusiness.logoUrl = imageUrl ?? ""
                          self.userBusiness.name = name
                          self.userBusiness.phoneNo = phoneNo
                      
                      }
                      SVProgressHUD.dismiss()
                      
                  }
        }
}
    func getBusinessUserData(){
        SVProgressHUD.show(withStatus: "Loading...")
        var ref: DatabaseReference
        if (self.businessProfile == "business"){
             ref = Database.database().reference().child("users").child(businessUserID)
        }
        else {
            if(personalUserID == ""){
                           personalUserID = businessUserID
                       }
            ref = Database.database().reference().child("users").child(personalUserID)
        }
        ref.observe(DataEventType.value) { (snapshot) in
            if snapshot.childrenCount>0{
                
                let data = snapshot.value as? [String : Any]//.children.allObjects as! DataSnapshot
                let obj = data//.value as? [String: Any]
                
                let address = obj?["address"] as! String
                let businessProfileKey = obj?["businessProfileKey"] as! String
                let email = obj?["email"] as! String
                let hasBusinessProfile = obj?["hasBusinessProfile"] as? String
                let hasBusinessWordNum = obj?["hasBusinessWordNum"] as? String
                let hasPersonalWordNum = obj?["hasPersonalWordNum"] as! String
                let id = obj?["id"] as! String
                let imageUrl = obj?["imageUrl"] as! String
                let name = obj?["name"] as! String
                let password = obj?["password"] as! String
                let personalProfileKey = obj?["personalProfileKey"] as! String
                let phoneNo = obj?["phoneNo"] as! String
                
                if Bool(hasPersonalWordNum)! {
                    self.fetchWordNumber(uid:id)
                }
                
                self.userBusinessProfile.address = address
                self.userBusinessProfile.businessProfileKey = businessProfileKey
                self.userBusinessProfile.email = email
                self.userBusinessProfile.hasBusinessProfile = "\(hasBusinessProfile)"
                self.userBusinessProfile.hasBusinessWordNum = "\(hasBusinessWordNum)"
                self.userBusinessProfile.hasPersonalWordNum = "\(hasPersonalWordNum)"
                self.userBusinessProfile.id = id
                self.userBusinessProfile.imageUrl = imageUrl
                self.userBusinessProfile.name = name
                self.userBusinessProfile.password = password
                self.userBusinessProfile.personalProfileKey = personalProfileKey
                self.userBusinessProfile.phoneNo = phoneNo
                self.userBusinessProfile.userLogin = ""
                
                //self.numberLabel.text = self.userBusinessProfile.phoneNo
                //self.addressLabel.text = self.userBusinessProfile.address
                
                DispatchQueue.main.asyncAfter(deadline: .now()+2, execute: {
                    if self.profileImage.image == UIImage(named: "") {
                        self.questionMarkLabel.isHidden = false
                    }else{
                        self.questionMarkLabel.isHidden = true
                    }
                })
                
                if self.userBusinessProfile.hasPersonalWordNum == "false"{
                    self.wordNumberLabel.text = ""
                }else{
                    // Fetch from firebase wordnumber details
                }
                if (self.businessProfile == "business"){
                self.fetchUserDescription()
                }
                SVProgressHUD.dismiss()
                
            }
            SVProgressHUD.dismiss()
        }
    }
    
}

extension SearchDetailViewController: UICollectionViewDelegate,UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if(isBusinessProfile == true){
        return self.linksArray.count+3
        }
        else{
            return self.linksArray.count+2
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if indexPath.row < self.linksArray.count {
            let item = self.linksArray[indexPath.row]
            var urlString = "\(item.link)"
            if(urlString.hasPrefix("http://") || urlString.hasPrefix("https://")){
               
            }
            else{
                urlString = "http://"+urlString
            }
            
            if let url = URL(string: urlString), UIApplication.shared.canOpenURL(url) {
                 print(url)
               if #available(iOS 10.0, *) {
                  UIApplication.shared.open(url, options: [:], completionHandler: nil)
               } else {
                  UIApplication.shared.openURL(url)
               }
            }
            else{
                print("not valid")
            }
            
        }
        else{
             if isBusinessProfile {
            if indexPath.row == self.linksArray.count {
                // info functionality
                if(isBusinessProfile == true){
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "BusinessInfoViewController") as! BusinessInfoViewController
                vc.businessPhone = self.userBusiness.phoneNo
                vc.businessDescription = "\(self.businessDescription)"
                vc.businessUserID = self.businessUserID
                vc.businessName = self.userBusiness.name
                
                self.navigationController?.pushViewController(vc, animated: true)
                }
                
            }else if indexPath.row == self.linksArray.count+1 {
                // Save functionality
                
                if isBusinessProfile {
                    // Business profile
                    var userExist = false
                    var userID = ""
                    if let userid = defaults.string(forKey: userData.id) {
                        print(userid) // Another String Value
                        userID = userid
                    }
                    SVProgressHUD.show(withStatus: "Loading")
                    let ref = Database.database().reference().child("contacts").child("\(userID)").child("business")
                    ref.observe(DataEventType.value) { (snapshot) in
                        if snapshot.childrenCount>0{
                            for data in snapshot.children.allObjects as! [DataSnapshot]{
                                let obj = data.value as? [String: Any]

                                let phoneNo = obj?["phoneNo"] as! String

                                if phoneNo == self.userBusiness.phoneNo {
                                    userExist = true
                                    break
                                }
                            }
                            if userExist {
                                // user exist
                                let alert = UIAlertController(title: "Already Exist!", message: "User Already exist in your contact!", preferredStyle: .actionSheet)
                                let action = UIAlertAction(title: "OK", style: .default, handler: nil)
                                alert.addAction(action)
                                self.present(alert,animated: true,completion: nil)
                                
                            }else{
                                // user not exist
                                let refg = Database.database().reference().child("contacts").child("\(userID)").child("business")
                                let key = refg.childByAutoId().key
                                let data = ["actionsVisible":"false","inDatabase":"true","key":"\(key!)","name":"\(self.userBusiness.name)","phoneNo":"\(self.userBusiness.phoneNo)","userId":"\(self.userBusinessProfile.id)"] as [String : Any]
                                refg.child(key!).setValue(data)
                                
                                print("repeat")
                                let alert = UIAlertController(title: "Successfully!", message: "Contact Successfully Added!", preferredStyle: .actionSheet)
                                let action = UIAlertAction(title: "OK", style: .default, handler: nil)
                                alert.addAction(action)
                                self.present(alert,animated: true,completion: nil)
                            }
                            SVProgressHUD.dismiss()
                            //self.tableView.reloadData()
                        }else{
                            
                            print("business contact not found")
                            let refg = Database.database().reference().child("contacts").child("\(userID)").child("business")
                            let key = refg.childByAutoId().key
                            let data = ["actionsVisible":"false","inDatabase":"true","key":"\(key!)","name":"\(self.userBusiness.name)","phoneNo":"\(self.userBusiness.phoneNo)","userId":"\(self.userBusinessProfile.id)"] as [String : Any]
                            refg.child(key!).setValue(data)
                            
                            //print("repeat")
                            let alert = UIAlertController(title: "Successfully!", message: "Contact Successfully Added!", preferredStyle: .actionSheet)
                            let action = UIAlertAction(title: "OK", style: .default, handler: nil)
                            alert.addAction(action)
                            self.present(alert,animated: true,completion: nil)
                            SVProgressHUD.dismiss()
                        }
                    }
                    
                }else{
                    
                }
                
            }else if indexPath.row == self.linksArray.count+2 {
                // Share functionality
                let activityVC = UIActivityViewController(activityItems: ["Hey there. I'm using the Cori.Tel App. Click the link to view profile."], applicationActivities: nil)
                activityVC.popoverPresentationController?.sourceView = self.view
                self.present(activityVC,animated: true,completion: nil)
            }
            
            } // if business
            
             else {
                //personal
                
                if indexPath.row == self.linksArray.count {
                    var userExist = false
                                       var userID = ""
                                       if let userid = defaults.string(forKey: userData.id) {
                                           print(userid) // Another String Value
                                           userID = userid
                                       }
                                       SVProgressHUD.show(withStatus: "Loading")
                                       let ref = Database.database().reference().child("contacts").child("\(userID)").child("personal")
                                       ref.observe(DataEventType.value) { (snapshot) in
                                           if snapshot.childrenCount>0{

                                               for data in snapshot.children.allObjects as! [DataSnapshot]{
                                                   let obj = data.value as? [String: Any]

                                                   let phoneNo = obj?["phoneNo"] as! String
                                                if phoneNo != "" {
                                                    if phoneNo == self.userBusinessProfile.phoneNo {
                                                       userExist = true
                                                       break
                                                   }
                                                }
                                               }
                                               
                                               if userExist {
                                                   // user exist
                                                   let alert = UIAlertController(title: "Already Exist!", message: "User Already exist in your contact!", preferredStyle: .actionSheet)
                                                   let action = UIAlertAction(title: "OK", style: .default, handler: nil)
                                                   alert.addAction(action)
                                                   self.present(alert,animated: true,completion: nil)
                                                   
                                               }else{
                                                   // user not exist
                                                   
                                                   let refg = Database.database().reference().child("contacts").child("\(userID)").child("personal")
                                                   let key = refg.childByAutoId().key
                                                let data = ["actionsVisible":"false","inDatabase":"true","key":"\(key!)","name":"\(self.userBusinessProfile.name)","phoneNo":"\(self.userBusinessProfile.phoneNo)","userId":"\(self.userBusinessProfile.id)"] as [String : Any]
                                                   refg.child(key!).setValue(data)
                                                   
                                                   print("repeat")
                                                   let alert = UIAlertController(title: "Successfully!", message: "Contact Successfully Added!", preferredStyle: .actionSheet)
                                                   let action = UIAlertAction(title: "OK", style: .default, handler: nil)
                                                   alert.addAction(action)
                                                   self.present(alert,animated: true,completion: nil)
                                                   
                                               }

                                               SVProgressHUD.dismiss()
                                               //self.tableView.reloadData()

                                           }else{
                                               
                                               print("business contact not found")
                                               let refg = Database.database().reference().child("contacts").child("\(userID)").child("personal")
                                               let key = refg.childByAutoId().key
                                               let data = ["actionsVisible":"false","inDatabase":"true","key":"\(key!)","name":"\(self.userBusinessProfile.name)","phoneNo":"\(self.userBusinessProfile.phoneNo)","userId":"\(self.userBusinessProfile.id)"] as [String : Any]
                                               refg.child(key!).setValue(data)
                                               
                                               //print("repeat")
                                               let alert = UIAlertController(title: "Successfully!", message: "Contact Successfully Added!", preferredStyle: .actionSheet)
                                               let action = UIAlertAction(title: "OK", style: .default, handler: nil)
                                               alert.addAction(action)
                                               self.present(alert,animated: true,completion: nil)
                                               SVProgressHUD.dismiss()
                                           }
                                       }
                }// if indexpath
                
                else if indexPath.row == self.linksArray.count+1 {
                    // Share functionality
                                   let activityVC = UIActivityViewController(activityItems: ["Hey there. I'm using the Cori.Tel App. Click the link to view profile."], applicationActivities: nil)
                                   activityVC.popoverPresentationController?.sourceView = self.view
                                   self.present(activityVC,animated: true,completion: nil)
                }
                
                
            } // else personal
            
        }//top else
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SearchDetailCollectionViewCell", for: indexPath) as! SearchDetailCollectionViewCell
        
        if indexPath.row < self.linksArray.count {
            let item = self.linksArray[indexPath.row]
            if item.link.contains("facebook") {
                print("facebook link")
                cell.linkImage.image = #imageLiteral(resourceName: "facebook (4)")
            }else if item.link.contains("instagram") {
                print("instagram link")
                cell.linkImage.image = #imageLiteral(resourceName: "instagram")
            }else if item.link.contains("linkedin") {
                print("linkedin link")
                cell.linkImage.image = #imageLiteral(resourceName: "linkedin")
            }else if item.link.contains("pinterest") {
                print("pinterest link")
                cell.linkImage.image = #imageLiteral(resourceName: "pinterest")
            }else if item.link.contains("skype") {
                print("skype link")
                cell.linkImage.image = #imageLiteral(resourceName: "skype")
            }else if item.link.contains("snapchat") {
                print("snapchat link")
                cell.linkImage.image = #imageLiteral(resourceName: "snapchat")
            }else if item.link.contains("twitter") {
                print("twitter link")
                cell.linkImage.image = #imageLiteral(resourceName: "twitter")
            }else if item.link.contains("viber") {
                print("viber link")
                cell.linkImage.image = #imageLiteral(resourceName: "viber")
            }else if item.link.contains("whatsapp") {
                print("whatsapp link")
                cell.linkImage.image = #imageLiteral(resourceName: "whatsapp")
            }else if item.link.contains("yahoo") {
                print("yahoo link")
                cell.linkImage.image = #imageLiteral(resourceName: "yahoo")
            }else if item.link.contains("youtube") {
                print("youtube link")
                cell.linkImage.image = #imageLiteral(resourceName: "youtube")
            }else{
                print("chrome link")
                cell.linkImage.image = #imageLiteral(resourceName: "chrome")
            }
            cell.linkName.text = item.name
        }else{
            if(isBusinessProfile == true){
            print(indexPath.row)
            print(self.linksArray.count)
            if indexPath.row == self.linksArray.count {
        
                cell.linkImage.image = #imageLiteral(resourceName: "ic_info")
                cell.linkName.text = "info"
            
        }
            
            else if indexPath.row == self.linksArray.count+1 {
                cell.linkImage.image = #imageLiteral(resourceName: "savee")
                cell.linkName.text = "Save"
            }else if indexPath.row == self.linksArray.count+2 {
                cell.linkImage.image = #imageLiteral(resourceName: "share")
                cell.linkName.text = "Share"
            }
            }
            else{
                if indexPath.row == self.linksArray.count {
                
                       cell.linkImage.image = #imageLiteral(resourceName: "savee")
                       cell.linkName.text = "Save"
                    
                }
                    
                    else if indexPath.row == self.linksArray.count+1 {
                       cell.linkImage.image = #imageLiteral(resourceName: "share")
                       cell.linkName.text = "Share"
                    }
            }
            
        }
        
        return cell
        
        //        if indexPath.row != 4 {
        //            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DugCollectionViewCell", for: indexPath) as! DugCollectionViewCell
        //
        //            return cell
        //        }else{
        //            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DugEditCollectionViewCell", for: indexPath) as! DugEditCollectionViewCell
        //
        //            return cell
        //        }
        
    }
}
extension SearchDetailViewController:UICollectionViewDelegateFlowLayout{
    
    //    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
    //
    //        return UIEdgeInsets(top: 2, left: 2, bottom: 2, right: 2)
    //
    //    }
    
    // ======================================================================================
    //    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    //
    //        if indexPath.row != 4 {
    //            return CGSize(width: 100, height: 90)
    //        }else{
    //            return CGSize(width: 320, height: 90)
    //        }
    //
    //        //let size = self.collectionView.frame.size
    //        //return CGSize(width: size.width, height: size.height)
    //    }
    // ======================================================================================
    
    //    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
    //        return 2.0
    //    }
    //    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
    //        return 2.0
    //    }
    
}
extension SearchDetailViewController: UITableViewDataSource,UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let vc = self.storyboard?.instantiateViewController(withIdentifier: "AddLinkViewController") as! AddLinkViewController
//        self.navigationController?.pushViewController(vc, animated: true)
//    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        callerNumber = userBusiness.phoneNo
        callerName = self.userBusiness.name
        
        print(callerNumber,callerName)
        dailerCheck = true
        if let url = URL(string: "tel://\(self.businessPhoneNo)"),
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
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SearchDetailTableViewCell") as! SearchDetailTableViewCell
        
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
}

extension SearchDetailViewController:UIViewControllerTransitioningDelegate{
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.isPresenting = true
        return transition
    }
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.isPresenting = false
        return transition
    }
}
