//
//  BusinessEdit2ViewController.swift
//  DailerApp
//
//  Created by Muhammad Bilal on 27/02/2020.
//  Copyright © 2020 Solution Soul. All rights reserved.
//

import UIKit
import Firebase
import Kingfisher
import SVProgressHUD
import Braintree

class BusinessEdit2ViewController: UIViewController {
    
    
    @IBOutlet weak var firstPriceLbl: UILabel!
    @IBOutlet weak var thirdPriceLbl: UILabel!
    
    @IBOutlet weak var secondPriceLabel: UILabel!
    
    
    
    
    
    @IBOutlet weak var secondBtn: UIButton!
    @IBOutlet weak var thirdBtn: UIButton!
    @IBOutlet weak var fourthBtn: UIButton!
    @IBOutlet weak var firstBtn: UIButton!
    
    @IBOutlet weak var catTypeButtonProperty: UIButton!
    @IBOutlet weak var phoneTypeButtonProperty: UIButton!
    @IBOutlet weak var countryTF: UITextField!
    @IBOutlet weak var phoneTF: UITextField!
    @IBOutlet weak var enteredWordLabel: UILabel!
    
    @IBOutlet weak var firstWordLabel: UILabel!
    @IBOutlet weak var secondWordLabel: UILabel!
    @IBOutlet weak var thirdWordLabel: UILabel!
    @IBOutlet weak var fourthWordLabel: UILabel!
    @IBOutlet weak var selectedCode: UILabel!
   
    var allWordNumbers2 = [WordNumbers]()
    let transition = SlideInTransition()
    var selectedCodeString = ""
    var enteredWordLabelString = ""
    var phoneTFString = ""
    
    var businessName = ""
    
    var typeCount = 0
    var match = false
    
    var catType = ""
    var phoneType = ""
    
    var enteredCountry = ""
    var enteredAreaCode = ""
    var enteredPhoneNo = ""
    var enteredWord = ""
    
    var phoneType1 = ""
    var catType1 = ""
    var braintreeClient: BTAPIClient?
    
    
    // Tab Bar Menu Image
    @IBOutlet weak var tab1Image: UIImageView!
    @IBOutlet weak var tab2Image: UIImageView!
    @IBOutlet weak var tab3Image: UIImageView!
    @IBOutlet weak var tab4Image: UIImageView!
    @IBOutlet weak var tab5Image: UIImageView!
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Dug"
        braintreeClient = BTAPIClient(authorization: "sandbox_cszh73wt_sd29gtvp28tc3zf5")!
        self.selectedCode.text = self.selectedCodeString
        self.enteredWordLabel.text = self.enteredWordLabelString
        self.phoneTF.text = self.phoneTFString
        print(self.phoneTFString)
        self.catTypeButtonProperty.setTitle(self.catType, for: .normal)
        self.phoneTypeButtonProperty.setTitle(self.phoneType, for: .normal)
        self.countryTF.text = self.enteredCountry
       // self.phoneTF.text = self.enteredPhoneNo
       // self.enteredWordLabel.text = self.enteredWord
        self.firstWordLabel.text = self.enteredWord
        self.secondWordLabel.text = self.enteredWord
        self.thirdWordLabel.text = self.enteredWord
        self.fourthWordLabel.text = self.enteredWord
        
        
                  
        if ((self.phoneType1 == "Landline") && (self.catType1 == "Business")){
        self.firstWordLabel.text = "\(self.phoneTFString.prefix(3))\(self.enteredWordLabelString)"
            fourthWordLabel.text = "\(self.phoneTFString.prefix(2))\(self.enteredWordLabelString)"
            
        }
        
        else if ((self.phoneType1 == "Mobile") && (self.catType1 == "Business")) {
            self.firstWordLabel.text = "\(self.phoneTFString.prefix(4))\(self.enteredWordLabelString)"
                       fourthWordLabel.text = "\(self.phoneTFString.prefix(3))\(self.enteredWordLabelString)"
        }
        
        else if ((self.phoneType1 == "Mobile") && (self.catType1 == "Personal")) {
            self.firstWordLabel.text = "\(self.phoneTFString.prefix(4))\(self.enteredWordLabelString)"
                                  fourthWordLabel.text = "\(self.phoneTFString.prefix(3))\(self.enteredWordLabelString)"
           
        }
        
        else if ((self.phoneType1 == "Landline") && (self.catType1 == "Personal")){
            self.firstWordLabel.text = "\(self.phoneTFString.prefix(3))\(self.enteredWordLabelString)"
                       fourthWordLabel.text = "\(self.phoneTFString.prefix(2))\(self.enteredWordLabelString)"
        }
        else{
            print("nothing")
        }
              
                self.getSuggestionWordList()
        
        self.tab1Image.image = self.tab1Image.image?.withRenderingMode(.alwaysTemplate)
        self.tab1Image.tintColor = #colorLiteral(red: 0.3333333433, green: 0.3333333433, blue: 0.3333333433, alpha: 1)
        self.tab2Image.image = self.tab2Image.image?.withRenderingMode(.alwaysTemplate)
        self.tab2Image.tintColor = #colorLiteral(red: 0.3333333433, green: 0.3333333433, blue: 0.3333333433, alpha: 1)
        self.tab3Image.image = self.tab3Image.image?.withRenderingMode(.alwaysTemplate)
        self.tab3Image.tintColor = #colorLiteral(red: 0.1538252234, green: 0.2240419388, blue: 0.3633548617, alpha: 1)
        self.tab4Image.image = self.tab4Image.image?.withRenderingMode(.alwaysTemplate)
        self.tab4Image.tintColor = #colorLiteral(red: 0.3333333433, green: 0.3333333433, blue: 0.3333333433, alpha: 1)
        self.tab5Image.image = self.tab5Image.image?.withRenderingMode(.alwaysTemplate)
        self.tab5Image.tintColor = #colorLiteral(red: 0.3333333433, green: 0.3333333433, blue: 0.3333333433, alpha: 1)
        
        let menuUIBarButtonItem = UIBarButtonItem(image: UIImage(named: "menuWhite.png"), style: .plain, target: self, action: #selector(FreeVanityNumber1ViewController.clickButton))
        menuUIBarButtonItem.tintColor = UIColor.white
        self.navigationItem.leftBarButtonItem  = menuUIBarButtonItem
        
        transition.dimmingView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismisFunc)))
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(self.handleGesture(gesture:)))
        swipeLeft.direction = .left
        self.transition.dimmingView.addGestureRecognizer(swipeLeft)
    }
    
    
    func getSuggestionWordList()
         {
          //self.oneWordLabel.text = "\(self.myPhoneNumber.prefix(4))\(selectedWord)"
             if ((self.phoneType1 == "Landline") && (self.catType1 == "Business")){
             self.secondWordLabel.text = "123\(self.enteredWordLabelString)"
          thirdWordLabel.text = "\(self.selectedCodeString)\(self.enteredWordLabelString)"
          getWordNumbers()
            }
            
            else if ((self.phoneType1 == "Mobile") && (self.catType1 == "Business")) {
                       self.secondWordLabel.text = "123\(self.enteredWordLabelString)"
                                thirdWordLabel.text = "\(self.phoneTFString.prefix(2))\(self.enteredWordLabelString)"
                                getWordNumbers()
                   }
                   
                   else if ((self.phoneType1 == "Mobile") && (self.catType1 == "Personal")) {
                       secondWordLabel.text = "123\(self.enteredWordLabelString)"
                       thirdWordLabel.text = "\(self.phoneTFString.prefix(2))\(self.enteredWordLabelString)"
                if ((self.phoneType1 == "Mobile") && (self.catType1 == "Personal")) {
                    self.firstPriceLbl.text = "Free"
                        self.secondPriceLabel.text = "33"
                     self.thirdPriceLbl.text = "55"
                    
                }
                       getWordNumbers()
                   }
                   
                   else if ((self.phoneType1 == "Landline") && (self.catType1 == "Personal")){
                       self.secondWordLabel.text = "123\(self.enteredWordLabelString)"
                       thirdWordLabel.text = "\(self.selectedCodeString)\(self.enteredWordLabelString)"
                       getWordNumbers()
                   }
                   else{
                       print("nothing")
                   }
          
      }
    
    func getWordNumbers() {
                self.allWordNumbers2.removeAll()
        SVProgressHUD.show(withStatus: "Loading")
                let ref = Database.database().reference().child("word_nums")
                ref.observe(DataEventType.value) { (snapshot) in
                    if snapshot.childrenCount>0{
        
                        for data in snapshot.children.allObjects as! [DataSnapshot]{
                            let obj = data.value as? [String: Any]
        
                            let catType = obj?["catType"] as! String
                            let country = obj?["country"] as! String
                            let key = obj?["key"] as! String
                            let phoneType = obj?["phoneType"] as! String
                            let status = obj?["status"] as! Int
                            let type = obj?["type"] as! Int
                            let uid = obj?["uid"] as! String
                            let wordNum = obj?["wordNum"] as? String
        
                            let wordNumbersData = WordNumbers(catType: catType, country: country, key: key, phoneType: phoneType, status: status, type: type, uid: uid, wordNum: wordNum ?? "")
                             
                            if (self.catType1 == "Business") {
                            if(catType == "Business"){
                            self.allWordNumbers2.append(wordNumbersData)
                            }
                            }
                            
                            else{
                                if(catType == "Personal"){
                                  self.allWordNumbers2.append(wordNumbersData)
                                }
                            }
                          
        
                        }
                         SVProgressHUD.dismiss()
                        self.setupViewForButtons()
                       
        
        
                }
        
           }
        
    }
    
    func checkMatch(){
           let total = self.allWordNumbers2.count - 1
        let country = self.self.enteredCountry
           let first = self.firstWordLabel.text
           let second = self.fourthWordLabel.text
           let third = self.thirdWordLabel.text
           let fourth = self.secondWordLabel.text
           if(typeCount == 0){
               for item in 0...total{
                   if(item == 64){
                       
                   }
                   if(allWordNumbers2[item].wordNum.caseInsensitiveCompare(first!) == .orderedSame){
                    if (allWordNumbers2[item].country.caseInsensitiveCompare(country) == .orderedSame){
                           self.match = false
                           self.setupButtons()
                        
                           break
                       }
                       else{
                           self.match = true
                           self.setupButtons()
                           break
                       }
                       
                   }
                   
                   
                   
               }
               self.typeCount = 1
               self.setupViewForButtons()
           }
           
          else if(typeCount == 1){
                    for item in 0...total{
                        if(item == 64){
                            
                        }
                        if(allWordNumbers2[item].wordNum.caseInsensitiveCompare(second!) == .orderedSame){
                            if (allWordNumbers2[item].country.caseInsensitiveCompare(country) == .orderedSame){
                                self.match = false
                                self.setupButtons()
                                break
                            }
                            else{
                                self.match = true
                                self.setupButtons()
                                break
                            }
                            
                        }
                        
                        
                        
                    }
                    self.typeCount = 2
                    self.setupViewForButtons()
                }
           if(typeCount == 2){
                    for item in 0...total{
                        if(item == 64){
                            
                        }
                        if(allWordNumbers2[item].wordNum.caseInsensitiveCompare(third!) == .orderedSame){
                            if (allWordNumbers2[item].country.caseInsensitiveCompare(country) == .orderedSame){
                                self.match = false
                                self.setupButtons()
                                break
                            }
                            else{
                                self.match = true
                                self.setupButtons()
                                break
                            }
                            
                        }
                        
                        
                        
                    }
                    self.typeCount = 3
                    self.setupViewForButtons()
                }
           
                    else {
                    for item in 0...total{
                        if(item == 64){
                            
                        }
                        if(allWordNumbers2[item].wordNum.caseInsensitiveCompare(fourth!) == .orderedSame){
                            if (allWordNumbers2[item].country.caseInsensitiveCompare(country) == .orderedSame){
                                self.match = false
                                self.setupButtons()
                                break
                            }
                            else{
                                self.match = true
                                self.setupButtons()
                                break
                            }
                            
                        }
                        
                        
                        
                    }
                    self.typeCount = 0
                   // self.setupViewForButtons()
                }
           
           
       }
    
    
    func setupButtons()  {
        if (typeCount == 0){
            
            if(self.match == true){
                self.onAvailable()
            }
            else{
                self.onSold()
            }
        }
        
        else if (typeCount == 1){
            
            
                   if(self.match == true){
                       self.onAvailable()
                   }
                   else{
                       self.onSold()
                   }
               }
        else if (typeCount == 2){
           
               
            
            if(self.match == true){
                self.onAvailable()
            }
            else{
                self.onSold()
            }
        }
        else {
           
            if(self.match == true){
                self.onAvailable()
            }
            else{
                self.onSold()
            }
        }
    }
    func onAvailable()  {
        if(self.typeCount == 0){
         firstBtn.setTitle("Buy", for: .normal)
         }
        else if(self.typeCount == 1){
         secondBtn.setTitle("Buy", for: .normal)
         }
        else if(self.typeCount == 2){
         thirdBtn.setTitle("Buy", for: .normal)
         }
         else {
             fourthBtn.setTitle("Contact Us", for: .normal)
         }
    }
    
    func onSold()  {
        if(self.typeCount == 0){
        firstBtn.setTitle("Sold", for: .normal)
        }
       else if(self.typeCount == 1){
        secondBtn.setTitle("Sold", for: .normal)
        }
       else if(self.typeCount == 2){
        thirdBtn.setTitle("Sold", for: .normal)
        }
        else {
            fourthBtn.setTitle("Contact Us", for: .normal)
        }
    }
    
    
    
    
    
    
    
    
        func setupViewForButtons()  {
            print(self.allWordNumbers2.count)
            switch self.typeCount {
            case 0:
                self.match = false
                self.checkMatch()
                break
                case 1:
                   self.match = false
                   self.checkMatch()
                break
                case 2:
                    self.match = false
                    self.checkMatch()
                break
                case 3:
                    self.match = false
                    self.checkMatch()
                break
            default:
                break
            }
            
    //        for item in 0...3{
    //            if(item == 0){
    //                self.match = false
    //                typeCount = 0
    //                self.checkMatch()
    //
    //
    //            }
    //            else if(item == 1){
    //                self.match = false
    //                typeCount = 1
    //            }
    //            else if(item == 2){
    //                self.match = false
    //                typeCount = 2
    //            }
    //            else {
    //                self.match = false
    //                typeCount = 3
    //            }
    //        }
        }
    
    
    func showAlert(title:String,message:String){
        let alert = UIAlertController(title: "\(title)", message: "\(message)", preferredStyle: .actionSheet)
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(action)
        self.present(alert,animated: true,completion: {
            self.navigationController?.popViewController(animated: true)
        })
    }
    
    
    
    
    
    
    @IBAction func firstBuyButtonAction(_ sender: Any) {
        if (firstBtn.currentTitle == "Buy" || firstBtn.currentTitle == "BUY") {
         //   if (firstPriceLbl.text == "Free") {
            if ((self.phoneType1 == "Mobile") && (self.catType1 == "Personal")) {
        SVProgressHUD.show()
        // First we have to enter data in profiles table
        var businessKey = ""
        var userID = ""
        if let userid = defaults.string(forKey: userData.id) {
            print(userid) // Another String Value
            userID = userid
        }
                
            if let businessProfileKey = defaults.string(forKey: userData.businessProfileKey) {
                    print(businessProfileKey) // Another String Value
                    businessKey = businessProfileKey
                          
            }

                       
        let refp = Database.database().reference().child("profiles").child("\(businessKey)")
            refp.updateChildValues(["phoneNo":"\(self.phoneTF.text!)","type":"business","userId":"\(userID)","wordNum":"\(self.enteredWordLabel.text!)"])
      //  let keyp = refp.childByAutoId().key
                
                
                
        //let refp = Database.database().reference().child("profiles")
       // let keyp = refp.childByAutoId().key
        //let datap = ["phoneNo":"\(self.phoneTF.text!)","type":"business","userId":"\(userID)","wordNum":"\(self.enteredWordLabel.text!)"]
                defaults.set("\(self.phoneTF.text!)", forKey: "BusinessPhoneNumber")
        //refp.child(keyp!).setValue(datap)
        // Second we have to update values in user table
        let refu = Database.database().reference().child("users").child(userID)
        refu.updateChildValues(["businessProfileKey":"\(businessKey)","hasBusinessProfile":"true"])
                 defaults.set("true", forKey: userData.hasBusinessWordNum)
                
        // Third we have to add word number data into word_nums table
        let refw = Database.database().reference().child("word_nums")
        let keyw = refp.childByAutoId().key
        let dataw = ["catType":"\(self.catType)","country":"\(self.enteredCountry)","key":"\(keyw!)","phoneType":"\(self.phoneType)","status":0,"type":0,"uid":"\(userID)","wordNum":"\(self.enteredWordLabel.text!)"] as [String : Any]
        refw.child(keyw!).setValue(dataw)
        SVProgressHUD.dismiss()
        for controller in self.navigationController!.viewControllers as Array {
            if controller.isKind(of: BusinessProfileDetailViewController.self) {
                _ =  self.navigationController!.popToViewController(controller, animated: true)
                break
            }
        }
    }// free
            
          else  {
                SVProgressHUD.show()
                let payPalDriver = BTPayPalDriver(apiClient: braintreeClient!)
                                     payPalDriver.viewControllerPresentingDelegate = self
                                     payPalDriver.appSwitchDelegate = self // Optional
                       // Specify the transaction amount here. "2.32" is used in this example.
                       let request = BTPayPalRequest(amount: "33")
                              request.currencyCode = "USD" // Optional; see BTPayPalRequest.h for more options

                              payPalDriver.requestOneTimePayment(request) { (tokenizedPayPalAccount, error) in
                                  if let tokenizedPayPalAccount = tokenizedPayPalAccount {
                                      print("Got a nonce: \(tokenizedPayPalAccount.nonce)")
                                       SVProgressHUD.dismiss()
                                      // Access additional information
                                      let email = tokenizedPayPalAccount.email
                                      let firstName = tokenizedPayPalAccount.firstName
                                      let lastName = tokenizedPayPalAccount.lastName
                                      let phone = tokenizedPayPalAccount.phone

                                      // See BTPostalAddress.h for details
                                      let billingAddress = tokenizedPayPalAccount.billingAddress
                                      let shippingAddress = tokenizedPayPalAccount.shippingAddress
                                   var businessKey = ""
                                   var userID = ""
                                   if let userid = defaults.string(forKey: userData.id) {
                                       print(userid) // Another String Value
                                       userID = userid
                                   }
                                    
                                    if let businessProfileKey = defaults.string(forKey: userData.businessProfileKey) {
                                                print(businessProfileKey) // Another String Value
                                                businessKey = businessProfileKey
                                                      
                                        }

                                                   
                                    let refp = Database.database().reference().child("profiles").child("\(businessKey)")
                                        refp.updateChildValues(["phoneNo":"\(self.phoneTF.text!)","type":"business","userId":"\(userID)","wordNum":"\(self.firstWordLabel.text!)"])
                                    
                                    
                                   //let refp = Database.database().reference().child("profiles")
                                  // let keyp = refp.childByAutoId().key
                                  // let datap = ["phoneNo":"\(self.phoneTF.text!)","type":"business","userId":"\(userID)","wordNum":"\(self.firstWordLabel.text!)"]
                                    defaults.set("\(self.phoneTF.text!)", forKey: "BusinessPhoneNumber")
                                  // refp.child(keyp!).setValue(datap)
                                   // Second we have to update values in user table
                                   let refu = Database.database().reference().child("users").child(userID)
                                   refu.updateChildValues(["businessProfileKey":"\(businessKey)","hasBusinessProfile":"true"])
                                    defaults.set("true", forKey: userData.hasBusinessWordNum)
                                   // Third we have to add word number data into word_nums table
                                   let refw = Database.database().reference().child("word_nums")
                                   let keyw = refp.childByAutoId().key
                                    let dataw = ["catType":"\(self.catType)","country":"\(self.enteredCountry)","key":"\(keyw!)","phoneType":"\(self.phoneType)","status":0,"type":0,"uid":"\(userID)","wordNum":"\(self.firstWordLabel.text!)"] as [String : Any]
                                   refw.child(keyw!).setValue(dataw)
                                   SVProgressHUD.dismiss()
                                   for controller in self.navigationController!.viewControllers as Array {
                                       if controller.isKind(of: BusinessProfileDetailViewController.self) {
                                           _ =  self.navigationController!.popToViewController(controller, animated: true)
                                           break
                                       }
                                   }
                                   
                                  } else if let error = error {
                                      // Handle error here...
                                   print(error)
                                  } else {
                                    SVProgressHUD.dismiss()
                                      // Buyer canceled payment approval
                                  }
                              }
            }
            
            
} // firstBtn
        else {
            self.showAlert(title: "Alert!", message: "Sorry this is already sold you have to choose other option to proceed")
            
        }
}
    
    @IBAction func contactusButtonAction(_ sender: Any) {
    }
    
    @IBAction func thirdBuyButtonAction(_ sender: Any) {
        if (thirdBtn.currentTitle == "Buy" || thirdBtn.currentTitle == "BUY") {
        // if ((self.phoneType1 == "Mobile") && (self.catType1 == "Personal")) {
            SVProgressHUD.show()
        let payPalDriver = BTPayPalDriver(apiClient: braintreeClient!)
                      payPalDriver.viewControllerPresentingDelegate = self
                      payPalDriver.appSwitchDelegate = self // Optional
        // Specify the transaction amount here. "2.32" is used in this example.
            var request: BTPayPalRequest!
                       if ((self.phoneType1 == "Mobile") && (self.catType1 == "Personal")) {
                           request = BTPayPalRequest(amount: "55")
                           
                       }
                       else if ((self.phoneType1 == "Landline") && (self.catType1 == "Personal")) {
                        request = BTPayPalRequest(amount: "99")
                       }
                      else if ((self.phoneType1 == "Landline") && (self.catType1 == "Business")) {
                       request = BTPayPalRequest(amount: "99")
                      }
                    else{
                            request = BTPayPalRequest(amount: "99")
                           }
        
               request.currencyCode = "USD" // Optional; see BTPayPalRequest.h for more options

               payPalDriver.requestOneTimePayment(request) { (tokenizedPayPalAccount, error) in
                   if let tokenizedPayPalAccount = tokenizedPayPalAccount {
                       print("Got a nonce: \(tokenizedPayPalAccount.nonce)")
                       SVProgressHUD.dismiss()
                       // Access additional information
                       let email = tokenizedPayPalAccount.email
                       let firstName = tokenizedPayPalAccount.firstName
                       let lastName = tokenizedPayPalAccount.lastName
                       let phone = tokenizedPayPalAccount.phone

                       // See BTPostalAddress.h for details
                       let billingAddress = tokenizedPayPalAccount.billingAddress
                       let shippingAddress = tokenizedPayPalAccount.shippingAddress
                    var businessKey = ""
                    var userID = ""
                    if let userid = defaults.string(forKey: userData.id) {
                        print(userid) // Another String Value
                        userID = userid
                    }
                    
                    if let businessProfileKey = defaults.string(forKey: userData.businessProfileKey) {
                                print(businessProfileKey) // Another String Value
                                businessKey = businessProfileKey
                                      
                        }

                                   
                    let refp = Database.database().reference().child("profiles").child("\(businessKey)")
                        refp.updateChildValues(["phoneNo":"\(self.phoneTF.text!)","type":"business","userId":"\(userID)","wordNum":"\(self.thirdWordLabel.text!)"])
                    
                    
                    
                    //let refp = Database.database().reference().child("profiles")
                  //  let keyp = refp.childByAutoId().key
                   // let datap = ["phoneNo":"\(self.phoneTF.text!)","type":"business","userId":"\(userID)","wordNum":"\(self.thirdWordLabel.text!)"]
                    defaults.set("\(self.phoneTF.text!)", forKey: "BusinessPhoneNumber")
                    //refp.child(keyp!).setValue(datap)
                    // Second we have to update values in user table
                    let refu = Database.database().reference().child("users").child(userID)
                    refu.updateChildValues(["businessProfileKey":"\(businessKey)","hasBusinessProfile":"true"])
                    defaults.set("true", forKey: userData.hasBusinessWordNum)
                    // Third we have to add word number data into word_nums table
                    let refw = Database.database().reference().child("word_nums")
                    let keyw = refp.childByAutoId().key
                    let dataw = ["catType":"\(self.catType)","country":"\(self.enteredCountry)","key":"\(keyw!)","phoneType":"\(self.phoneType)","status":0,"type":0,"uid":"\(userID)","wordNum":"\(self.enteredWordLabel.text!)"] as [String : Any]
                    refw.child(keyw!).setValue(dataw)
                    SVProgressHUD.dismiss()
                    for controller in self.navigationController!.viewControllers as Array {
                        if controller.isKind(of: BusinessProfileDetailViewController.self) {
                            _ =  self.navigationController!.popToViewController(controller, animated: true)
                            break
                        }
                    }
                    
                   } else if let error = error {
                       // Handle error here...
                    print(error)
                   } else {
                       // Buyer canceled payment approval
                    SVProgressHUD.dismiss()
                   }
               }
       // }//mob&Per
        }//if top
        else {
            self.showAlert(title: "Alert!", message: "Sorry this is already sold you have to choose other option to proceed")
            
        }
    }
    
    @IBAction func fourthBuyButtonAction(_ sender: Any) {
         if (secondBtn.currentTitle == "Buy" || secondBtn.currentTitle == "BUY") {
       // if ((self.phoneType1 == "Mobile") && (self.catType1 == "Personal")) {
            print(fourthBtn.currentTitle)
            SVProgressHUD.show()
        
        let payPalDriver = BTPayPalDriver(apiClient: braintreeClient!)
                      payPalDriver.viewControllerPresentingDelegate = self
                      payPalDriver.appSwitchDelegate = self // Optional
        // Specify the transaction amount here. "2.32" is used in this example.
            var request: BTPayPalRequest!
            if ((self.phoneType1 == "Mobile") && (self.catType1 == "Personal")) {
                request = BTPayPalRequest(amount: "33")
                
            }
            else if ((self.phoneType1 == "Landline") && (self.catType1 == "Personal")) {
             request = BTPayPalRequest(amount: "55")
            }
         else if ((self.phoneType1 == "Landline") && (self.catType1 == "Business")) {
          request = BTPayPalRequest(amount: "55")
         }
            else{
             request = BTPayPalRequest(amount: "55")
        }
            
               request.currencyCode = "USD" // Optional; see BTPayPalRequest.h for more options

               payPalDriver.requestOneTimePayment(request) { (tokenizedPayPalAccount, error) in
                   if let tokenizedPayPalAccount = tokenizedPayPalAccount {
                       print("Got a nonce: \(tokenizedPayPalAccount.nonce)")
                       SVProgressHUD.dismiss()
                       // Access additional information
                       let email = tokenizedPayPalAccount.email
                       let firstName = tokenizedPayPalAccount.firstName
                       let lastName = tokenizedPayPalAccount.lastName
                       let phone = tokenizedPayPalAccount.phone

                       // See BTPostalAddress.h for details
                       let billingAddress = tokenizedPayPalAccount.billingAddress
                       let shippingAddress = tokenizedPayPalAccount.shippingAddress
                    var businessKey = ""
                    var userID = ""
                    if let userid = defaults.string(forKey: userData.id) {
                        print(userid) // Another String Value
                        userID = userid
                    }
                    
                    if let businessProfileKey = defaults.string(forKey: userData.businessProfileKey) {
                                print(businessProfileKey) // Another String Value
                                businessKey = businessProfileKey
                                      
                        }

                                   
                    let refp = Database.database().reference().child("profiles").child("\(businessKey)")
                    refp.updateChildValues(["phoneNo":"\(self.phoneTF.text!)","type":"business","userId":"\(userID)","wordNum":"\(self.fourthWordLabel.text!)"])
                    
                    
                   // let refp = Database.database().reference().child("profiles")
                  //  let keyp = refp.childByAutoId().key
                   // let datap = ["phoneNo":"\(self.phoneTF.text!)","type":"business","userId":"\(userID)","wordNum":"\(self.fourthWordLabel.text!)"]
                    defaults.set("\(self.phoneTF.text!)", forKey: "BusinessPhoneNumber")
                  //  refp.child(keyp!).setValue(datap)
                    // Second we have to update values in user table
                    let refu = Database.database().reference().child("users").child(userID)
                    refu.updateChildValues(["businessProfileKey":"\(businessKey)","hasBusinessProfile":"true"])
                    defaults.set("true", forKey: userData.hasBusinessWordNum)
                    // Third we have to add word number data into word_nums table
                    let refw = Database.database().reference().child("word_nums")
                    let keyw = refp.childByAutoId().key
                    let dataw = ["catType":"\(self.catType)","country":"\(self.enteredCountry)","key":"\(keyw!)","phoneType":"\(self.phoneType)","status":0,"type":0,"uid":"\(userID)","wordNum":"\(self.enteredWordLabel.text!)"] as [String : Any]
                    refw.child(keyw!).setValue(dataw)
                    SVProgressHUD.dismiss()
                    for controller in self.navigationController!.viewControllers as Array {
                        if controller.isKind(of: BusinessProfileDetailViewController.self) {
                            _ =  self.navigationController!.popToViewController(controller, animated: true)
                            break
                        }
                    }
                    
                   } else if let error = error {
                       // Handle error here...
                    print(error)
                   } else {
                       // Buyer canceled payment approval
                    SVProgressHUD.dismiss()
                   }
               }
       // }//mob&Per
        }// if top
         else  {
           self.showAlert(title: "Alert!", message: "Sorry this is already sold you have to choose other option to proceed")
        }
    }
    
    @IBAction func backButtonAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func tab1ButtonAction(_ sender: Any) {
        let mainStoryBoard = UIStoryboard(name: "Main", bundle: nil)
        let redViewController = mainStoryBoard.instantiateViewController(withIdentifier: "TabBarViewController") as! TabBarViewController
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.window?.rootViewController = redViewController
    }
    @IBAction func tab2ButtonAction(_ sender: Any) {
        let mainStoryBoard = UIStoryboard(name: "Main", bundle: nil)
        let redViewController = mainStoryBoard.instantiateViewController(withIdentifier: "TabBarViewController") as! TabBarViewController
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.window?.rootViewController = redViewController
    }
    @IBAction func tab3ButtonAction(_ sender: Any) {
        let mainStoryBoard = UIStoryboard(name: "Main", bundle: nil)
        let redViewController = mainStoryBoard.instantiateViewController(withIdentifier: "TabBarViewController") as! TabBarViewController
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.window?.rootViewController = redViewController
    }
    @IBAction func tab4ButtonAction(_ sender: Any) {
        let mainStoryBoard = UIStoryboard(name: "Main", bundle: nil)
        let redViewController = mainStoryBoard.instantiateViewController(withIdentifier: "TabBarViewController") as! TabBarViewController
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.window?.rootViewController = redViewController
    }
    @IBAction func tab5ButtonAction(_ sender: Any) {
        let mainStoryBoard = UIStoryboard(name: "Main", bundle: nil)
        let redViewController = mainStoryBoard.instantiateViewController(withIdentifier: "TabBarViewController") as! TabBarViewController
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.window?.rootViewController = redViewController
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
    
}

extension BusinessEdit2ViewController:UIViewControllerTransitioningDelegate{
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.isPresenting = true
        return transition
    }
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.isPresenting = false
        return transition
    }
}

extension BusinessEdit2ViewController : BTViewControllerPresentingDelegate {
    func paymentDriver(_ driver: Any, requestsPresentationOf viewController: UIViewController) {
        
    }
    
    func paymentDriver(_ driver: Any, requestsDismissalOf viewController: UIViewController) {
        
    }
    
    
}
extension BusinessEdit2ViewController : BTAppSwitchDelegate {
    func appSwitcherWillPerformAppSwitch(_ appSwitcher: Any) {
        
    }
    
    func appSwitcher(_ appSwitcher: Any, didPerformSwitchTo target: BTAppSwitchTarget) {
        
    }
    
    func appSwitcherWillProcessPaymentInfo(_ appSwitcher: Any) {
        
    }
    
    
}
