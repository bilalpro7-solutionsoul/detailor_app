//
//  CreateBusinessProfileViewController.swift
//  DailerApp
//
//  Created by Muhammad Bilal on 26/02/2020.
//  Copyright © 2020 Solution Soul. All rights reserved.
//

import UIKit
import Firebase
import Kingfisher
import SVProgressHUD

class CreateBusinessProfileViewController: UIViewController {
    
    @IBOutlet weak var mobileCellBtn: UIButton!
    @IBOutlet weak var landLineBtn: UIButton!
    @IBOutlet weak var areaCodeContainer: UIView!
    @IBOutlet weak var phoneNumberContainer: UIView!
    @IBOutlet weak var descriptionTV: UITextView!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var nameTF: UITextField!
    @IBOutlet weak var numberTF: UITextField!
    @IBOutlet weak var areaCodeTF: UITextField!
    @IBOutlet weak var sloganTF: UITextField!
    @IBOutlet weak var bottomViewContainer: UIView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var tagTF: UITextField!
    @IBOutlet weak var locationTBV: UITableView!
    @IBOutlet weak var otherLinksTBV: UITableView!
    @IBOutlet weak var socialLinksTBV: UITableView!
    @IBOutlet weak var upgradeView: CustomView!
    
    @IBOutlet weak var wordNumTF: UITextField!
    
    var phoneType = ""
    var isUpgrade = false
    var editChk = false
    var wordNumCheck  = false
    
    var imagePicker = UIImagePickerController()
    
    var imageUploadURL = ""
    var prevNumber = ""
    var dateString = ""
    
    var keywordsArr = [KeywordStructure]()
    var storesArr = [StoresStructure]()
    var linksArr = [LinksStructure]()
    var offersArr = [OffersStructure]()
    
    var firtTimeCheck:Bool!
    
    override func viewDidLoad() {
        super.viewDidLoad()
      //  defaults.set(false, forKey: "firstTimeUpdate")
        if let businessProfileKey = defaults.string(forKey: userData.businessProfileKey) {
                print(businessProfileKey) // Another String Value
               // businessKey = businessProfileKey
            if businessProfileKey.count > 0{
                firtTimeCheck = true
            }
            else{
                firtTimeCheck = false
            }
                      
        }
    
        
        self.LandlineAction()
        if editChk {
            self.getUserBusinessData()
            self.getUserData()
            
        }else{
            dateString = DateFormatter.sharedDateFormatter.string(from: Date())
            print("date",dateString)
            upgradeView.isHidden = true
        }
        
        self.getKeywords()
        self.getUserLinks()
        self.getUserOffere()
        self.getUserStores()
        
        self.locationTBV.delegate = self
        self.locationTBV.dataSource = self
        
        self.otherLinksTBV.delegate = self
        self.otherLinksTBV.dataSource = self
        
        self.socialLinksTBV.delegate = self
        self.socialLinksTBV.dataSource = self
        
        self.bottomViewContainer.isHidden = true
        imagePicker.delegate = self
        
        self.profileImage.layer.cornerRadius = 8
        
        print("Persss")
    }
    
    @IBAction func landLineAction(_ sender: Any) {
        self.LandlineAction()

    }
    
    
    func LandlineAction()  {
          self.phoneType = "Landline"
                
                self.mobileCellBtn.setTitleColor(UIColor.darkGray, for: .normal)
                self.mobileCellBtn.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
                self.landLineBtn.backgroundColor = #colorLiteral(red: 0.153010577, green: 0.2240604758, blue: 0.3633597493, alpha: 1)
                self.landLineBtn.setTitleColor(UIColor.white, for: .normal)
                
                self.areaCodeContainer.isHidden = false
        //        self.areaCodeTF.placeholder = "Area Code"
        //        self.phoneTF.placeholder = "Phone number"
        //        self.wordTF.placeholder = "Word"
    }
    
    @IBAction func mobileCellAction(_ sender: Any) {
        self.phoneType = "Mobile"
        
        self.mobileCellBtn.setTitleColor(UIColor.white, for: .normal)
        self.mobileCellBtn.backgroundColor = #colorLiteral(red: 0.153010577, green: 0.2240604758, blue: 0.3633597493, alpha: 1)
        self.landLineBtn.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        self.landLineBtn.setTitleColor(UIColor.darkGray, for: .normal)
        
        self.areaCodeContainer.isHidden = true
//        self.areaCodeTF.placeholder = "Phone number"
//        self.phoneTF.placeholder = "Word"
        
    }
    
    
    
    
    
    
    
    
    
    func getUserData(){

                var userID = ""
                if let userid = defaults.string(forKey: userData.id) {
                    print(userid) // Another String Value
                    userID = userid
                }
                SVProgressHUD.show(withStatus: "Loading")
                let ref = Database.database().reference().child("users").child(userID)
                ref.observe(DataEventType.value) { (snapshot) in
                    if snapshot.childrenCount>0{
                        
                        let data = snapshot.value as? [String : Any]//.children.allObjects as! DataSnapshot
                        let obj = data//.value as? [String: Any]
                        
                        let businessProfileKey = obj?["businessProfileKey"] as? String
                        let hasBusinessWordNum = obj?["hasBusinessWordNum"] as! String
                        
                      
                        if Bool(hasBusinessWordNum)!{
                            self.getProfileData(businessProfileKey: businessProfileKey ?? "")
                        }
                        
                        else{
                            self.upgradeView.isHidden = true
                        }
                        SVProgressHUD.dismiss()
                        
                    }
                }

    }
    
    func getProfileData(businessProfileKey:String) {
        
        
        if businessProfileKey.count > 0{
            
            SVProgressHUD.show(withStatus: "Loading")
            let ref = Database.database().reference().child("profiles").child(businessProfileKey)
            ref.observe(DataEventType.value) { (snapshot) in
                if snapshot.childrenCount>0{
                    
                    let data = snapshot.value as? [String : Any]//.children.allObjects as! DataSnapshot
                    let obj = data//.value as? [String: Any]
                    
                    let wordNum = obj?["wordNum"] as? String
                    
                    if wordNum?.count ?? 0 > 0 {
                        self.wordNumTF.text = wordNum
                        self.upgradeView.isHidden = false
                    }
                    else{
                        self.upgradeView.isHidden = true
                    }
                    
                    
                    
                  
                    SVProgressHUD.dismiss()
                    
                }
            }

            
        }
        
        
    }
    func getUserBusinessData(){
        var userID = ""
        if let userid = defaults.string(forKey: userData.id) {
            print(userid) // Another String Value
            userID = userid
        }
        SVProgressHUD.show(withStatus: "Loading")
        let ref = Database.database().reference().child("listing").child("business").child(userID).child("details")
        ref.observe(DataEventType.value) { (snapshot) in
            if snapshot.childrenCount>0{
                
                let data = snapshot.value as? [String : Any]//.children.allObjects as! DataSnapshot
                let obj = data//.value as? [String: Any]
                
                let description = obj?["description"] as! String
                let logoUrl = obj?["logoUrl"] as? String
                let name = obj?["name"] as! String
                let paid = obj?["paid"] as! String
                let phoneNo = obj?["phoneNo"] as! String
                let areaCode = obj?["areaCode"] as? String
                let slogan = obj?["slogan"] as! String
                let prevdate = obj?["createdAt"] as? String
                
                self.profileImage.kf.setImage(with: URL(string: logoUrl ?? ""),placeholder: UIImage(named: "demoImage"))
                self.imageUploadURL = logoUrl ?? ""
                self.prevNumber = phoneNo
                self.nameTF.text = name
                self.numberTF.text = phoneNo
                self.areaCodeTF.text = areaCode
                self.sloganTF.text = slogan
                self.descriptionTV.text = description
                self.dateString = prevdate ?? ""
                
                if self.dateString != ""{
                    self.dateString = prevdate ?? ""
                }
                else{
                    self.dateString = DateFormatter.sharedDateFormatter.string(from: Date())
                }
                
                
//                if paid {
//                    self.bottomViewContainer.isHidden = false
//                }else{
//                    self.bottomViewContainer.isHidden = true
//                }
                
                SVProgressHUD.dismiss()
                
            }
        }
    }
    
    @IBAction func addKeywordsButtonAction(_ sender: Any) {
        if self.tagTF.text != "" {
            var userID = ""
            if let userid = defaults.string(forKey: userData.id) {
                print(userid) // Another String Value
                userID = userid
            }
            // Entry In Listing -> Business -> userid -> keywords
            let refK = Database.database().reference().child("listing").child("business").child("\(userID)").child("keywords")
            let keyK = refK.childByAutoId().key
            let dataK = ["name":"\(self.tagTF.text!)"] as [String: Any]
            refK.child("\(keyK!)").setValue(dataK)
            //self.keywordsArr.append(self.tagTF.text!)
            
            self.tagTF.text = ""
            //self.collectionView.reloadData()
        }else{
            let alert = UIAlertController(title: "Alert", message: "Please Enter Keyword", preferredStyle: .alert)
            let action = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(action)
            self.present(alert,animated: true,completion: nil)
        }
    }
    
    @IBAction func uploadImageButtonAction(_ sender: Any) {
        imagePicker.sourceType = .photoLibrary
        imagePicker.allowsEditing = true
        present(imagePicker,animated: true,completion: nil)
    }
    
    @IBAction func upgradeButtonAction(_ sender: Any) {
        isUpgrade = true
        self.bottomViewContainer.isHidden = false
    }
    @IBAction func topRightNavigationSaveButtonAction(_ sender: Any) {
      //   firtTimeCheck = defaults.bool(forKey: "firstTimeUpdate")
        if isUpgrade {
            // Upgraded Business Profile and add keywords, offers, social links
           
            if self.descriptionTV.text != "" {
                
                if self.nameTF.text != "" {
                    if self.numberTF.text != "" {
                        
                       // if self.areaCodeTF.text != "" {
                            if self.sloganTF.text != "" {
                                if self.imageUploadURL != "" {
                                    
                                    if editChk {
                                        
                                        if prevNumber == numberTF.text{
                                            if (self.phoneType == "Landline"){
                                                if self.areaCodeTF.text != "" {
                                                    sendDataToFireBaseUpgrade()
                                                }
                                                
                                                else{
                                                    self.showAlert(message: "Please Enter Area Code Of Your Business!")
                                                }
                                            }
                                            
                                            else{
                                                self.areaCodeTF.text = ""
                                                sendDataToFireBaseUpgrade()
                                            }
                                            
                                        }
                                        else{
                                            if (self.phoneType == "Landline"){
                                                if self.areaCodeTF.text != "" {
                                                    checkAlreadyExitNumberUpgrade()
                                                }
                                                                                           
                                                else{
                                                self.showAlert(message: "Please Enter Area Code Of Your Business!")
                                                    }
                                            }
                                                                                       
                                            else{
                                                    self.areaCodeTF.text = ""
                                                    checkAlreadyExitNumberUpgrade()
                                                }
                                            
                                        }
                                        
                                    }
                                    else{
                                        
                                        if (self.phoneType == "Landline"){
                                            if self.areaCodeTF.text != "" {
                                                checkAlreadyExitNumberUpgrade()
                                            }
                                                                                       
                                            else{
                                            self.showAlert(message: "Please Enter Area Code Of Your Business!")
                                                }
                                        }
                                                                                   
                                        else{
                                                self.areaCodeTF.text = ""
                                                checkAlreadyExitNumberUpgrade()
                                            }

                                    }
                                    
                                }else{
                                    self.showAlert(message: "Please Upload Image For Business Profile.")
                                }
                            }else{
                                self.showAlert(message: "Please Enter Slogan Of Your Business!")
                            }
                       // }//else{
                           // self.showAlert(message: "Please Enter Area Code Of Your Business!")
                        //}
                    }else{
                        self.showAlert(message: "Please Enter Your Business Number!")
                    }
                }else{
                    self.showAlert(message: "Please Enter Name First!")
                }
            }else{
                self.showAlert(message: "Please Enter Description")
            }
        }else{
            // Not upgrade business profile and add simple information to firebase
            
            if self.nameTF.text != "" {
                if self.numberTF.text != "" {
                  //  if self.areaCodeTF.text != "" {
                        if self.sloganTF.text != "" {
                            if self.imageUploadURL != "" {
                                
                                if editChk {
                                    if prevNumber == numberTF.text{
                                        if (self.phoneType == "Landline"){
                                            if self.areaCodeTF.text != "" {
                                                if firtTimeCheck {
                                                    sendDataToFireBaseUpgrade()
                                                }
                                                else {
                                                sendDataToFireBase()
                                                }
                                            }
                                            
                                            else{
                                                self.showAlert(message: "Please Enter Area Code Of Your Business!")
                                            }
                                        }
                                        
                                        else{
                                            self.areaCodeTF.text = ""
                                            
                                            if firtTimeCheck {
                                                sendDataToFireBaseUpgrade()
                                                }
                                                else {
                                                        sendDataToFireBase()
                                                    }
                                        }
                                    }
                                    else{
                                        if (self.phoneType == "Landline"){
                                            if self.areaCodeTF.text != "" {
                                                if firtTimeCheck {
                                                checkAlreadyExitNumberUpgrade()
                                                }
                                                else {
                                                        checkAlreadyExitNumber()
                                                    }
                                               // checkAlreadyExitNumber()
                                            }
                                                                                       
                                            else{
                                            self.showAlert(message: "Please Enter Area Code Of Your Business!")
                                                }
                                        }
                                                                                   
                                        else{
                                                self.areaCodeTF.text = ""
                                            if firtTimeCheck {
                                            checkAlreadyExitNumberUpgrade()
                                            }
                                            else {
                                                    checkAlreadyExitNumber()
                                                }

                                               // checkAlreadyExitNumber()
                                            }
                                        
                                    }
                                }
                                else{
                                    if (self.phoneType == "Landline"){
                                        if self.areaCodeTF.text != "" {
                                            
                                            if firtTimeCheck {
                                                    checkAlreadyExitNumberUpgrade()
                                                    }
                                              else {
                                                    checkAlreadyExitNumber()
                                                    }
                                                }
                                            
                                                                                                                          
                                            else{
                                                self.showAlert(message: "Please Enter Area Code Of Your Business!")
                                                }
                                        }
                                                                                                                      
                                        else{
                                            self.areaCodeTF.text = ""
                                        if firtTimeCheck {
                                                checkAlreadyExitNumberUpgrade()
                                                }
                                          else {
                                                checkAlreadyExitNumber()
                                                }
//                                            checkAlreadyExitNumber()
                                            }
                                }
                                
                            }//upload image
                            else{
                                self.showAlert(message: "Please Upload Image For Business Profile.")
                            }
                        }//slogan
                        else{
                            self.showAlert(message: "Please Enter Slogan Of Your Business!")
                        }
                    //}
//                        else{
//                        self.showAlert(message: "Please Enter Area Code Of Your Business!")
                   // }
                }// number
                else{
                    self.showAlert(message: "Please Enter Your Business Number!")
                }
            }// if name
            else{
                self.showAlert(message: "Please Enter Name First!")
            }
        }//else top
    }
    
    
    func checkAlreadyExitNumberUpgrade() {
        
        SVProgressHUD.show()
        var refp1 : DatabaseQuery = Database.database().reference().child("listing").child("business")
        refp1 = refp1.queryOrdered(byChild: "details/phoneNo").queryEqual(toValue: numberTF.text)
        
        refp1.observe(DataEventType.value) { (snapshot) in
            
            print(snapshot)
            if snapshot.exists() {
                //value exists
                
                print("yess number exit")
                
                SVProgressHUD.dismiss()
                
                let alert = UIAlertController(title: "Warning", message: "Mobile No already Exist", preferredStyle: .alert)
                let action = UIAlertAction(title: "OK", style: .default, handler: nil)
                alert.addAction(action)
                self.present(alert,animated: true,completion: nil)
            }
            else{
                SVProgressHUD.dismiss()
                print("no number exit")
                
                
                var refpp : DatabaseQuery = Database.database().reference().child("profiles")
                
                refpp = refpp.queryOrdered(byChild: "phoneNo").queryEqual(toValue: self.numberTF.text)
                
                refpp.observe(DataEventType.value) { (snapshot) in
                    
                    if snapshot.exists() {
                        //value exists
                        print("yess number exit")
                        
                        let alert = UIAlertController(title: "Warning", message: "Mobile No already Exist", preferredStyle: .alert)
                        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
                        alert.addAction(action)
                        self.present(alert,animated: true,completion: nil)
                    }
                    else{
                        print("no number exit")
                        self.sendDataToFireBaseUpgrade()
                    }
                    
                }
                
            }
            
        }
       
    }
    
    func sendDataToFireBaseUpgrade(){
        
        // 1st Entry in Profiles
        var userID = ""
        var businessKey = ""
        var allBusinesskey = ""
        if let userid = defaults.string(forKey: userData.id) {
            print(userid) // Another String Value
            userID = userid
        }
       
         let stringWordNum = wordNumTF.text ?? ""
        if let businessProfileKey = defaults.string(forKey: userData.businessProfileKey) {
            print(businessProfileKey) // Another String Value
            businessKey = businessProfileKey
           
        }
        if let allBusinessKey = defaults.string(forKey: "allBusinessKey") {
            print(allBusinessKey) // Another String Value
            allBusinesskey = allBusinessKey
           
        }
       
      //  let refp = Database.database().reference().child("profiles").child("\(businessKey)")
       //  refp.updateChildValues(["phoneNo":"\(number1)","type":"business","userId":"\(userID)","wordNum":stringWordNum])
       // let keyp = refp.childByAutoId().key
       // let datap = ["phoneNo":"\(self.numberTF.text!)","type":"business","userId":"\(userID)","wordNum":stringWordNum]
        //refp.child(keyp!).setValue(datap)
        
        // 2nd Entry or update values in Users Table
        if stringWordNum.count > 0 {
          let refU = Database.database().reference().child("users").child("\(userID)")
            refU.updateChildValues(["businessProfileKey":"\(businessKey)","hasBusinessProfile":"true","hasBusinessWordNum":"true"])
           // defaults.set("\(keyp!)", forKey: userData.businessProfileKey)
        }
        
        else{
            let refU = Database.database().reference().child("users").child("\(userID)")
            refU.updateChildValues(["businessProfileKey":"\(businessKey)","hasBusinessProfile":"true"])
            
        }

        
        // 3rd All Business Entry
     //   if isUpgrade {
        let refAB = Database.database().reference().child("all_businesses").child("\(allBusinesskey)")
       // let keyAB = refAB.childByAutoId().key
     //   let dataAB = ["image":"\(self.imageUploadURL)","key":"\(keyAB!)","keywords":"\(self.nameTF.text!)","name":"\(self.nameTF.text!)","rating":0,"userId":"\(userID)"] as [String : Any]
        refAB.updateChildValues(["image":"\(self.imageUploadURL)","keywords":"\(self.nameTF.text!)","name":"\(self.nameTF.text!)","rating":0,"userId":"\(userID)"])
        
        // 4th Entry In Listing -> Business -> userid -> details
        let refLi = Database.database().reference().child("listing").child("business").child("\(userID)").child("details")
        let dataLi = ["description":"\(self.descriptionTV.text!)","logoUrl":"\(self.imageUploadURL)","name":"\(self.nameTF.text!)","paid":"true","phoneNo":"\(self.numberTF.text!)","slogan":"\(self.sloganTF.text!)","areaCode":"\(self.areaCodeTF.text!)","createdAt":dateString] as [String: Any]
        defaults.set("\(self.areaCodeTF.text!)", forKey: "areaCode")
        defaults.set("\(self.numberTF.text!)", forKey: "BusinessPhoneNumber")
        
       
        
        refLi.setValue(dataLi)
        
          let refp = Database.database().reference().child("profiles").child("\(businessKey)")
           refp.updateChildValues(["phoneNo":"\(self.numberTF.text!)","type":"business","userId":"\(userID)","wordNum":stringWordNum])
        
        let mainStoryBoard = UIStoryboard(name: "Main", bundle: nil)
        let redViewController = mainStoryBoard.instantiateViewController(withIdentifier: "BusinessProfileDetailNavigationViewController") as! BusinessProfileDetailNavigationViewController
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.window?.rootViewController = redViewController
      //  }
        
    }
    
    
    func checkAlreadyExitNumber() {
        
        
        SVProgressHUD.show()
        var refp1 : DatabaseQuery = Database.database().reference().child("listing").child("business")
        refp1 = refp1.queryOrdered(byChild: "details/phoneNo").queryEqual(toValue: numberTF.text)
        
        refp1.observe(DataEventType.value) { (snapshot) in
            
            print(snapshot)
            if snapshot.exists() {
                //value exists
                print("yess number exit")
                
                SVProgressHUD.dismiss()
                
                let alert = UIAlertController(title: "Warning", message: "Mobile No already Exist", preferredStyle: .alert)
                let action = UIAlertAction(title: "OK", style: .default, handler: nil)
                alert.addAction(action)
                self.present(alert,animated: true,completion: nil)
            }
            else{
                SVProgressHUD.dismiss()
                print("no number exit")
                
                
                var refpp : DatabaseQuery = Database.database().reference().child("profiles")
                
                refpp = refpp.queryOrdered(byChild: "phoneNo").queryEqual(toValue: self.numberTF.text)
                
                refpp.observe(DataEventType.value) { (snapshot) in
                    
                    if snapshot.exists() {
                        //value exists
                        if self.firtTimeCheck {
                            let mainStoryBoard = UIStoryboard(name: "Main", bundle: nil)
                            let redViewController = mainStoryBoard.instantiateViewController(withIdentifier: "BusinessProfileDetailNavigationViewController") as! BusinessProfileDetailNavigationViewController
                            let appDelegate = UIApplication.shared.delegate as! AppDelegate
                            appDelegate.window?.rootViewController = redViewController
                        }
                        else{
                        print("yess number exit")
                        
                        let alert = UIAlertController(title: "Warning", message: "Mobile No already Exist", preferredStyle: .alert)
                        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
                        alert.addAction(action)
                        self.present(alert,animated: true,completion: nil)
                        }
                    }
                    else{
                        print("no number exit")
                        if self.firtTimeCheck {
                            self.sendDataToFireBaseUpgrade()
                            }
                            else {
                            self.sendDataToFireBase()
                                }

                        
                    }
                    
                }
                
                
            }
            
        }
        
    }
    func sendDataToFireBase()  {
        
        
        var userID = ""
        if let userid = defaults.string(forKey: userData.id) {
            print(userid) // Another String Value
            userID = userid
        }
        
        let stringWordNum = wordNumTF.text ?? ""
      
        // 1st Entry in Profiles
        let refp = Database.database().reference().child("profiles")
        let keyp = refp.childByAutoId().key
        defaults.set("\(keyp!)", forKey: userData.businessProfileKey)
        let datap = ["phoneNo":"\(self.numberTF.text!)","type":"business","userId":"\(userID)","wordNum":stringWordNum]
        refp.child(keyp!).setValue(datap)
        
        // 2nd Entry or update values in Users Table
        if stringWordNum.count > 0 {
          let refU = Database.database().reference().child("users").child("\(userID)")
            refU.updateChildValues(["businessProfileKey":"\(keyp!)","hasBusinessProfile":"true","hasBusinessWordNum":"true"])
             defaults.set("\(keyp!)", forKey: userData.businessProfileKey)
            
        }
        
        else{
            let refU = Database.database().reference().child("users").child("\(userID)")
            refU.updateChildValues(["businessProfileKey":"\(keyp!)","hasBusinessProfile":"true"])
            defaults.set("\(keyp!)", forKey: userData.businessProfileKey)
            
        }
        
        
        // 3rd All Business Entry
        let refAB = Database.database().reference().child("all_businesses")
        let keyAB = refAB.childByAutoId().key
        let dataAB = ["image":"\(self.imageUploadURL)","key":"\(keyAB!)","keywords":"\(self.nameTF.text!)","name":"\(self.nameTF.text!)","rating":0,"userId":"\(userID)"] as [String : Any]
        refAB.child(keyAB!).setValue(dataAB)
        defaults.set("\(keyAB!)", forKey: "allBusinessKey")
        
        // 4th Entry In Listing -> Business -> userid -> details
        let refLi = Database.database().reference().child("listing").child("business").child("\(userID)").child("details")
        let dataLi = ["description":"","logoUrl":"\(self.imageUploadURL)","name":"\(self.nameTF.text!)","paid":"false","phoneNo":"\(self.numberTF.text!)","slogan":"\(self.sloganTF.text!)","areaCode":"\(self.areaCodeTF.text!)","createdAt":dateString] as [String: Any]
        defaults.set("\(self.areaCodeTF.text!)", forKey: "areaCode")
         defaults.set("\(self.numberTF.text!)", forKey: "BusinessPhoneNumber")
        //firtTimeCheck = defaults.bool(forKey: "firstTimeUpdate")
       // defaults.removeObject(forKey: "firstTimeUpdate")
       // defaults.set(true, forKey: "firstTimeUpdate")
        refLi.setValue(dataLi)
        
        
        
        let mainStoryBoard = UIStoryboard(name: "Main", bundle: nil)
        let redViewController = mainStoryBoard.instantiateViewController(withIdentifier: "BusinessProfileDetailNavigationViewController") as! BusinessProfileDetailNavigationViewController
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.window?.rootViewController = redViewController
        
    }
    
    func getKeywords(){
        var userID = ""
        if let userid = defaults.string(forKey: userData.id) {
            print(userid) // Another String Value
            userID = userid
        }
        SVProgressHUD.show(withStatus: "Loading")
        let ref = Database.database().reference().child("listing").child("business").child("\(userID)").child("keywords")
        ref.observe(DataEventType.value) { (snapshot) in
            if snapshot.childrenCount>0{
                self.keywordsArr.removeAll()
                for data in snapshot.children.allObjects as! [DataSnapshot]{
                    let obj = data.value as? [String: Any]
                    let name = obj?["name"] as! String
                    let key = data.key
                    
                    let keyObj = KeywordStructure(key: key, name: name)
                    
                    self.keywordsArr.append(keyObj)
                }
                SVProgressHUD.dismiss()
                self.collectionView.reloadData()
            }else{
                SVProgressHUD.dismiss()
                print("business contact not found")
            }
        }
    }
    
    @IBAction func barBackButtonAction(_ sender: Any) {
        let mainStoryBoard = UIStoryboard(name: "Main", bundle: nil)
        let redViewController = mainStoryBoard.instantiateViewController(withIdentifier: "TabBarViewController") as! TabBarViewController
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.window?.rootViewController = redViewController
    }
    func resizeImageWithAspect(image: UIImage,scaledToMaxWidth width:CGFloat,maxHeight height :CGFloat)->UIImage? {
        let oldWidth = image.size.width;
        let oldHeight = image.size.height;
        
        let scaleFactor = (oldWidth > oldHeight) ? width / oldWidth : height / oldHeight;
        
        let newHeight = oldHeight * scaleFactor;
        let newWidth = oldWidth * scaleFactor;
        let newSize = CGSize(width: newWidth, height: newHeight)
        
        UIGraphicsBeginImageContextWithOptions(newSize,false,UIScreen.main.scale);
        
        image.draw(in: CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height));
        let newImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        return newImage
    }
    func showAlert(message: String){
        let alert = UIAlertController(title: "Alert", message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(action)
        self.present(alert,animated: true,completion: nil)
    }
    
    @IBAction func addLocationButtonAction(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "AddBusinessLocationViewController") as! AddBusinessLocationViewController
        vc.isEdit = false
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func addNewOfferButtonAction(_ sender: Any) {
        let popOverVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AddBusinessOfferViewController") as! AddBusinessOfferViewController
        popOverVC.isEdit = false
        self.addChild(popOverVC)
        popOverVC.view.frame = self.view.frame
        self.view.addSubview(popOverVC.view)
        popOverVC.didMove(toParent: self)
    }
    
    @IBAction func addSocialLinksButtonAction(_ sender: Any) {
        let popOverVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AddBusinessSocialLinkViewController") as! AddBusinessSocialLinkViewController
        popOverVC.isEdit = false
        self.addChild(popOverVC)
        popOverVC.view.frame = self.view.frame
        self.view.addSubview(popOverVC.view)
        popOverVC.didMove(toParent: self)
    }
    
    func getUserLinks(){
        var userID = ""
        if let userid = defaults.string(forKey: userData.id) {
            print(userid) // Another String Value
            userID = userid
        }
        SVProgressHUD.show(withStatus: "Loading")
        let ref = Database.database().reference().child("listing").child("business").child("\(userID)").child("links")
        ref.observe(DataEventType.value) { (snapshot) in
            if snapshot.childrenCount>0{
                self.linksArr.removeAll()
                for data in snapshot.children.allObjects as! [DataSnapshot]{
                    let obj = data.value as? [String: Any]
                    
                    let key = obj?["key"] as? String
                    let link = obj?["link"] as! String
                    let name = obj?["name"] as! String
                    
                    let keyObj = LinksStructure(key: key ?? "", link: link, name: name)
                    
                    self.linksArr.append(keyObj)
                }
                SVProgressHUD.dismiss()
                self.socialLinksTBV.reloadData()
            }else{
                SVProgressHUD.dismiss()
                print("business contact not found")
            }
        }
    }
    func getUserOffere(){
        var userID = ""
        if let userid = defaults.string(forKey: userData.id) {
            print(userid) // Another String Value
            userID = userid
        }
        SVProgressHUD.show(withStatus: "Loading")
        let ref = Database.database().reference().child("listing").child("business").child("\(userID)").child("offers")
        ref.observe(DataEventType.value) { (snapshot) in
            if snapshot.childrenCount>0{
                self.offersArr.removeAll()
                for data in snapshot.children.allObjects as! [DataSnapshot]{
                    let obj = data.value as? [String: Any]
                    
                    let imageUrl = obj?["imageUrl"] as! String
                    let key = obj?["key"] as! String
                    let link = obj?["link"] as! String
                    let name = obj?["name"] as! String
                    
                    let keyObj = OffersStructure(imageUrl: imageUrl, key: key, link: link, name: name)
                    
                    self.offersArr.append(keyObj)
                }
                SVProgressHUD.dismiss()
                self.otherLinksTBV.reloadData()
            }else{
                SVProgressHUD.dismiss()
                print("business contact not found")
            }
        }
    }
    func getUserStores(){
        var userID = ""
        if let userid = defaults.string(forKey: userData.id) {
            print(userid) // Another String Value
            userID = userid
        }
        SVProgressHUD.show(withStatus: "Loading")
        let ref = Database.database().reference().child("listing").child("business").child("\(userID)").child("stores")
        ref.observe(DataEventType.value) { (snapshot) in
            if snapshot.childrenCount>0{
                self.storesArr.removeAll()
                for data in snapshot.children.allObjects as! [DataSnapshot]{
                    let obj = data.value as? [String: Any]
                    
                    let address = obj?["address"] as! String
                    let key = obj?["key"] as! String
                    let lat = obj?["lat"] as! String
                    let lon = obj?["lon"] as? String
                    
                    let storesArrObj = StoresStructure(address: address, key: key, lat: lat, lon: lon ?? "")
                    
                    self.storesArr.append(storesArrObj)
                }
                SVProgressHUD.dismiss()
                self.locationTBV.isHidden = false
                self.locationTBV.reloadData()
            }else{
                SVProgressHUD.dismiss()
                 self.locationTBV.isHidden = true
                print("business contact not found")
            }
        }
    }
    
}

extension CreateBusinessProfileViewController : UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == self.locationTBV {
            return self.storesArr.count
        }else if tableView == self.otherLinksTBV {
            return self.offersArr.count
        }else if tableView == self.socialLinksTBV {
            return self.linksArr.count
        }
        return 0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == self.locationTBV {
            let cell = tableView.dequeueReusableCell(withIdentifier: "AddLocationTableViewCell") as! AddLocationTableViewCell
            let item = self.storesArr[indexPath.row]
            cell.addresslabel.text = item.address
            
            cell.editButtonClosure = {() in
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "AddBusinessLocationViewController") as! AddBusinessLocationViewController
                vc.isEdit = true
                vc.itemStore = item
                self.navigationController?.pushViewController(vc, animated: true)
            }
            
            cell.deleteButtonClosure = {() in
                var userID = ""
                if let userid = defaults.string(forKey: userData.id) {
                    print(userid) // Another String Value
                    userID = userid
                }
                let ref = Database.database().reference().child("listing").child("business").child(userID).child("stores").child(item.key)
                ref.removeValue()
                self.getUserStores()
            }
            print(item)
            return cell
        }else if tableView == self.otherLinksTBV {
            let cell = tableView.dequeueReusableCell(withIdentifier: "OtherLinksTableViewCell") as! OtherLinksTableViewCell
            let item = self.offersArr[indexPath.row]
            cell.linkName.text = item.name
            cell.linkImage.kf.setImage(with: URL(string: item.link),placeholder: UIImage(named: ""))
            
            cell.editButtonClosure = {() in
                
                let popOverVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AddBusinessOfferViewController") as! AddBusinessOfferViewController
                       popOverVC.isEdit = true
                popOverVC.offerItem = item
                       self.addChild(popOverVC)
                       popOverVC.view.frame = self.view.frame
                       self.view.addSubview(popOverVC.view)
                       popOverVC.didMove(toParent: self)
            }
            

            cell.deleteButtonClosure = {() in
                var userID = ""
                if let userid = defaults.string(forKey: userData.id) {
                    print(userid) // Another String Value
                    userID = userid
                }
                let ref = Database.database().reference().child("listing").child("business").child(userID).child("offers").child(item.key)
                ref.removeValue()
            }
            print(item)
            return cell
        }else if tableView == self.socialLinksTBV {
            let cell = tableView.dequeueReusableCell(withIdentifier: "SocialLinksTableViewCell") as! SocialLinksTableViewCell
            let item = self.linksArr[indexPath.row]
            cell.linkName.text = item.name
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
            cell.editButtonClosure = {() in
                let popOverVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AddBusinessSocialLinkViewController") as! AddBusinessSocialLinkViewController
                popOverVC.isEdit = true
                popOverVC.linkItem = item
                self.addChild(popOverVC)
                popOverVC.view.frame = self.view.frame
                self.view.addSubview(popOverVC.view)
                popOverVC.didMove(toParent: self)
            }
            
            cell.deleteButtonClosure = {() in
                var userID = ""
                if let userid = defaults.string(forKey: userData.id) {
                    print(userid) // Another String Value
                    userID = userid
                }
                let ref = Database.database().reference().child("listing").child("business").child(userID).child("links").child(item.key)
                ref.removeValue()
            }
            print(item)
            return cell
        }
        return UITableViewCell()
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableView == self.locationTBV {
            return 60
        }else if tableView == self.otherLinksTBV {
            return 60
        }else if tableView == self.socialLinksTBV {
            return 70
        }
        return 60
    }
}

extension CreateBusinessProfileViewController:UICollectionViewDelegate,UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.keywordsArr.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CreateBusinessKeywordCollectionViewCell", for: indexPath) as! CreateBusinessKeywordCollectionViewCell
        let item = self.keywordsArr[indexPath.row]
        var userID = ""
        if let userid = defaults.string(forKey: userData.id) {
            print(userid) // Another String Value
            userID = userid
        }
        
        cell.keywordLabel.text = item.name
        
        cell.deleteButtonClosure = {() in
            //self.keywordsArr.remove(at: indexPath.row)
            
            let refK = Database.database().reference().child("listing").child("business").child("\(userID)").child("keywords")
            refK.child("\(item.key)").removeValue()
            //self.collectionView.reloadData()
            
        }
        
        return cell
    }
}

extension CreateBusinessProfileViewController:UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage{
            
            self.profileImage.image = image
            let imgsd = resizeImageWithAspect(image: image, scaledToMaxWidth: 300, maxHeight: 300)
            //self.profileImage.image = imgsd
            
            SVProgressHUD.show(withStatus: "Updating")
            let img = imgsd
            var fileData = Data()
            fileData = (img!.pngData())!
            let ky = Database.database().reference().childByAutoId().key
            let storageRef = Storage.storage().reference().child("images/\(ky!)")//storage.reference().child("images")
            let metadata = StorageMetadata()
            metadata.contentType = "image/jpeg"
            storageRef.putData(fileData, metadata: metadata) { (metadata, error) in
                if error == nil {
                    print("Successfully uploaded")
                    var dwnUrl = ""
                    storageRef.downloadURL(completion: { (url, err) in
                        dwnUrl = "\(url!)"
                        print(url!)
                        self.imageUploadURL = dwnUrl
                        //                        // Add Value to firebase
                        //                        var userID = ""
                        //                        if let userid = defaults.string(forKey: userData.id) {
                        //                            print(userid) // Another String Value
                        //                            userID = userid
                        //                        }
                        //                        let ref = Database.database().reference().child("users").child(userID)
                        //                        ref.updateChildValues(["imageUrl":"\(dwnUrl)"])
                        
                    })
                    
                    print(dwnUrl)
                    
                    SVProgressHUD.dismiss()
                    
                }else{
                    SVProgressHUD.dismiss()
                    let alert = UIAlertController(title: "Warning", message: "Error While Upload Information", preferredStyle: .alert)
                    let action = UIAlertAction(title: "OK", style: .default, handler: nil)
                    alert.addAction(action)
                    self.present(alert,animated: true,completion: nil)
                }
                
            }
            
            dismiss(animated: true, completion: nil)
            
        }
    }
}
