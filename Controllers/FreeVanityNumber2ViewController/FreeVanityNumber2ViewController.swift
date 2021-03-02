//
//  FreeVanityNumber2ViewController.swift
//  DailerApp
//
//  Created by Muhammad Bilal on 26/02/2020.
//  Copyright © 2020 Solution Soul. All rights reserved.
//

import UIKit
import Firebase
import SVProgressHUD
import Braintree

class FreeVanityNumber2ViewController: UIViewController {
    
    @IBOutlet weak var selectedCountryTF: UITextField!
    @IBOutlet weak var userNumber: UITextField!
    @IBOutlet weak var selectedWordLabel: UILabel!
    @IBOutlet weak var oneWordLabel: UILabel!
    @IBOutlet weak var secondWordLabel: UILabel!
    @IBOutlet weak var thirdWordLabel: UILabel!
    
    @IBOutlet weak var fourthWordLabel: UILabel!
    @IBOutlet weak var thirdWordPricelabel: UILabel!
    
    @IBOutlet weak var oneWordPriceLabel: UILabel!
    @IBOutlet weak var secondWordPriceLabel: UILabel!
    
    @IBOutlet weak var secondView: UIView!
    
    @IBOutlet weak var thirdView: UIView!
    @IBOutlet weak var fourthView: UIView!
    
    @IBOutlet weak var oneWordBtn: UIButton!
    @IBOutlet weak var secondWordBtn: UIButton!
    @IBOutlet weak var thirdWordBtn: UIButton!
    @IBOutlet weak var fourthWordBtn: UIButton!
    
    var braintreeClient: BTAPIClient?
    
    let free = 0
    let silver = 1
    let platinum = 2
    let gold = 3
    
    let sold = 0
    let available = 1
    let needContact = 2
    
    var typeCount = 0
    
    var selectedCounter = ""
    var selectedWord = ""
    var myPhoneNumber = ""
    
    var match = false
    var wordMatch = false
    
    let transition = SlideInTransition()
    var allSuggestions = [sugesstionInfo]()
    var allWordNumbers = [WordNumbers]()
    
    
    
    
//    var environment:String = PayPalEnvironmentNoNetwork {
//           willSet(newEnvironment) {
//               if (newEnvironment != environment) {
//                   PayPalMobile.preconnect(withEnvironment: newEnvironment)
//               }
//           }
//       }
//
//       var payPalConfig = PayPalConfiguration() // default
    
//    var acceptCreditCards:Bool = true {
//        didSet{
//            payPalConfig.acceptCreditCards = acceptCreditCards
//        }
//    }
    
    
//    override func viewWillAppear(_ animated: Bool) {
//
//         PayPalMobile.preconnect(withEnvironment: environment)
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //self.navigationItem.title = "Dug"
        
         braintreeClient = BTAPIClient(authorization: "sandbox_cszh73wt_sd29gtvp28tc3zf5")!
       
//
//
//        payPalConfig.acceptCreditCards = acceptCreditCards;
//       // payPalConfig.merchantName = "check"
//        payPalConfig.merchantPrivacyPolicyURL = URL(string : "https://www.paypal.com/webapps/mpp/ua/privacy-full")
//        payPalConfig.merchantUserAgreementURL = URL(string : "https://www.paypal.com/webapps/mpp/ua/useragreement-full")
//        payPalConfig.languageOrLocale = Locale.preferredLanguages[0]
//        payPalConfig.languageOrLocale = NSLocale.preferredLanguages[0] as String
//        payPalConfig.payPalShippingAddressOption = .both
//
//        PayPalMobile.preconnect(withEnvironment: enviroment)
        
      //  payPalConfig.acceptCreditCards = false
               //payPalConfig.merchantName = "BREWIT 9"  //Give your company name here.
             //  payPalConfig.merchantPrivacyPolicyURL = URL(string: "https://www.paypal.com/webapps/mpp/ua/privacy-full") //Give your company's privacy policy url here.
              // payPalConfig.merchantUserAgreementURL = URL(string: "https://www.paypal.com/webapps/mpp/ua/useragreement-full") //Give UserAgreement URL here.
               
               //This is the language in which your paypal sdk will be shown to users.
               
             //  payPalConfig.languageOrLocale = Locale.preferredLanguages[0]
               
               //Here you can set the shipping address. You can choose either the address associated with PayPal account or different address. We'll use .both here.
        
        
       // payPalConfig.payPalShippingAddressOption = .none;
        
        
        
        
        
        
       
        
        if let name = defaults.string(forKey: userData.name) {
            print(name) // Another String Value
            self.navigationItem.title = name
        }
        if let number = defaults.string(forKey: userData.phoneNo) {
            print(number) // Another String Value
            self.userNumber.text = number
            self.myPhoneNumber = number
            self.oneWordLabel.text = "\(number.prefix(4))\(selectedWord)"
           // self.secondWordLabel.text = "\(number.prefix(3))\(selectedWord)"
          
        }
        self.fourthWordLabel.text = "123\(selectedWord)"
         self.getSuggestionWordList()
        
        
        
        self.selectedCountryTF.text = self.selectedCounter
        self.selectedWordLabel.text = self.selectedWord
        
        let menuUIBarButtonItem = UIBarButtonItem(image: UIImage(named: "menuWhite.png"), style: .plain, target: self, action: #selector(FreeVanityNumber2ViewController.clickButton))
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
        secondWordLabel.text = "\(self.myPhoneNumber.prefix(3))\(selectedWord)"
        thirdWordLabel.text = "\(self.myPhoneNumber.prefix(2))\(selectedWord)"
        getWordNumbers()
        
    }
    func getWordNumbers()  {
                self.allWordNumbers.removeAll()
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
        
                            if(catType == "Personal"){
                            self.allWordNumbers.append(wordNumbersData)
                            }
                          
        
                        }
                         SVProgressHUD.dismiss()
                        self.setupViewForButtons()
                       
        
        
                }
        
           }
        
    }
    
    
    
    func checkMatch(){
        let total = self.allWordNumbers.count - 1
        let country = self.selectedCountryTF.text
        let first = self.oneWordLabel.text
        let second = self.secondWordLabel.text
        let third = self.thirdWordLabel.text
        let fourth = self.fourthWordLabel.text
        if(typeCount == 0){
            for item in 0...total{
                if(item == 64){
                    
                }
                if(allWordNumbers[item].wordNum.caseInsensitiveCompare(first!) == .orderedSame){
                    if (allWordNumbers[item].country.caseInsensitiveCompare(country!) == .orderedSame){
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
                     if(allWordNumbers[item].wordNum.caseInsensitiveCompare(second!) == .orderedSame){
                         if (allWordNumbers[item].country.caseInsensitiveCompare(country!) == .orderedSame){
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
                     if(allWordNumbers[item].wordNum.caseInsensitiveCompare(third!) == .orderedSame){
                         if (allWordNumbers[item].country.caseInsensitiveCompare(country!) == .orderedSame){
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
                     if(allWordNumbers[item].wordNum.caseInsensitiveCompare(fourth!) == .orderedSame){
                         if (allWordNumbers[item].country.caseInsensitiveCompare(country!) == .orderedSame){
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
         oneWordBtn.setTitle("Buy", for: .normal)
         }
        else if(self.typeCount == 1){
         secondWordBtn.setTitle("Buy", for: .normal)
         }
        else if(self.typeCount == 2){
         thirdWordBtn.setTitle("Buy", for: .normal)
         }
         else {
             fourthWordBtn.setTitle("Contact Us", for: .normal)
         }
    }
    
    func onSold()  {
        if(self.typeCount == 0){
        oneWordBtn.setTitle("Sold", for: .normal)
        }
       else if(self.typeCount == 1){
        secondWordBtn.setTitle("Sold", for: .normal)
        }
       else if(self.typeCount == 2){
        thirdWordBtn.setTitle("Sold", for: .normal)
        }
        else {
            fourthWordBtn.setTitle("Contact Us", for: .normal)
        }
    }
    
    
    
    func setupViewForButtons()  {
        print(self.allWordNumbers.count)
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
    
    
    func checking() {
      var check = 0
        print(selectedWord)
        for index in allSuggestions{
            print(index.name)
            //if (selectedWord == index.name) {
                
            if(selectedWord.caseInsensitiveCompare(index.name) == .orderedSame){
                    print("voila")
                
                check = 1
                self.fourthView.isHidden = true
                self.secondView.isHidden = false
                
            }
            
        }
        if(check == 0) {
            self.fourthView.isHidden = false
            self.secondView.isHidden = true
            self.fourthWordLabel.text = selectedWord
        }
        
        for index in allSuggestions{
                  // if (selectedWord == index.name) {
            if(selectedWord.caseInsensitiveCompare(index.name) == .orderedSame){
                    self.secondWordLabel.text = index.name
                    self.secondWordPriceLabel.text = index.price
                       
                   }
                   
               }
    }
    
    func showAlert(title:String,message:String){
        let alert = UIAlertController(title: "\(title)", message: "\(message)", preferredStyle: .actionSheet)
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(action)
        self.present(alert,animated: true,completion: {
            self.navigationController?.popViewController(animated: true)
        })
    }
    
    
    
    @IBAction func oneWordLabelButtonAction(_ sender: Any) {
        if (oneWordBtn.currentTitle == "Buy" || oneWordBtn.currentTitle == "BUY") {
        SVProgressHUD.show()
        // First we have to enter data in profiles table
        var personalKey = ""
        var userID = ""
        if let userid = defaults.string(forKey: userData.id) {
            print(userid) // Another String Value
            userID = userid
        }
        
            if let personalProfileKey = defaults.string(forKey: userData.personalProfileKey) {
                        print(personalProfileKey) // Another String Value
                        personalKey = personalProfileKey
                              
                }

                           
            let refp = Database.database().reference().child("profiles").child("\(personalKey)")
                refp.updateChildValues(["phoneNo":"\(self.myPhoneNumber)","type":"personal","userId":"\(userID)","wordNum":"\(self.oneWordLabel.text!)"])
            
            
       // let refp = Database.database().reference().child("profiles")
      //  let keyp = refp.childByAutoId().key
       // let datap = ["phoneNo":"\(self.myPhoneNumber)","type":"personal","userId":"\(userID)","wordNum":"\(self.oneWordLabel.text!)"]
       // refp.child(keyp!).setValue(datap)
        // Second we have to update values in user table
        let refu = Database.database().reference().child("users").child(userID)
        refu.updateChildValues(["personalProfileKey":"\(personalKey)","hasPersonalWordNum":"true"])
        // Third we have to add word number data into word_nums table
        let refw = Database.database().reference().child("word_nums")
        let keyw = refp.childByAutoId().key
        let dataw = ["catType":"Personal","country":"\(self.selectedCounter)","key":"\(keyw!)","phoneType":"Mobile","status":0,"type":0,"uid":"\(userID)","wordNum":"\(self.oneWordLabel.text!)"] as [String : Any]
        refw.child(keyw!).setValue(dataw)
        SVProgressHUD.dismiss()
        for controller in self.navigationController!.viewControllers as Array {
            if controller.isKind(of: DugViewController.self) {
                _ =  self.navigationController!.popToViewController(controller, animated: true)
                break
            }
        }
        }// if top
        else{
               self.showAlert(title: "Alert!", message: "Sorry this is already sold you have to choose other option to proceed")
        }
    }
    
    @IBAction func secondWordLabelButtonAction(_ sender: Any) {
        if (secondWordBtn.currentTitle == "Buy" || secondWordBtn.currentTitle == "BUY") {
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
                    var personalKey = ""
                    var userID = ""
                           if let userid = defaults.string(forKey: userData.id) {
                               print(userid) // Another String Value
                               userID = userid
                           }
                    
                    if let personalProfileKey = defaults.string(forKey: userData.personalProfileKey) {
                                print(personalProfileKey) // Another String Value
                                personalKey = personalProfileKey
                                      
                        }

                                   
                    let refp = Database.database().reference().child("profiles").child("\(personalKey)")
                refp.updateChildValues(["phoneNo":"\(self.myPhoneNumber)","type":"personal","userId":"\(userID)","wordNum":"\(self.secondWordLabel.text!)"])
                    
                    
                    
                    
                          // let refp = Database.database().reference().child("profiles")
                         //  let keyp = refp.childByAutoId().key
                        //   let datap = ["phoneNo":"\(self.myPhoneNumber)","type":"personal","userId":"\(userID)","wordNum":"\(self.secondWordLabel.text!)"]
                        //   refp.child(keyp!).setValue(datap)
                           // Second we have to update values in user table
                           let refu = Database.database().reference().child("users").child(userID)
                           refu.updateChildValues(["personalProfileKey":"\(personalKey)","hasPersonalWordNum":"true"])
                           // Third we have to add word number data into word_nums table
                           let refw = Database.database().reference().child("word_nums")
                           let keyw = refp.childByAutoId().key
                           let dataw = ["catType":"Personal","country":"\(self.selectedCounter)","key":"\(keyw!)","phoneType":"Mobile","status":0,"type":0,"uid":"\(userID)","wordNum":"\(self.fourthWordLabel.text!)"] as [String : Any]
                           refw.child(keyw!).setValue(dataw)
                           SVProgressHUD.dismiss()
                           for controller in self.navigationController!.viewControllers as Array {
                               if controller.isKind(of: DugViewController.self) {
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
        
        
        
        
        
        
        
        
        
    
//        let item1 = PayPalItem(name: "Brewit-tshirt", withQuantity: 2, withPrice: NSDecimalNumber(string: "84.99"), withCurrency: "USD", withSku: "BREWIT-0011")
//        let item2 = PayPalItem(name: "Free Brewit cards", withQuantity: 1, withPrice: NSDecimalNumber(string: "0.00"), withCurrency: "USD", withSku: "BREWIT-0012")
//               let item3 = PayPalItem(name: "Brewit-cup", withQuantity: 1, withPrice: NSDecimalNumber(string: "37.99"), withCurrency: "USD", withSku: "BREWIT-0091")
//
//       // let items = [item1, item2, item3]
//        let items = [item1, item2, item3]
//       let subtotal = PayPalItem.totalPrice(forItems: items) //This is the total price of all the items
//
//       // Optional: include payment details
//       let shipping = NSDecimalNumber(string: "5.99")
//       let tax = NSDecimalNumber(string: "2.50")
//       let paymentDetails = PayPalPaymentDetails(subtotal: subtotal, withShipping: shipping, withTax: tax)
//
//       let total = subtotal.adding(shipping).adding(tax) //This is the total price including shipping and tax
//
//       let payment = PayPalPayment(amount: total, currencyCode: "USD", shortDescription: "BREWIT 9", intent: .sale)
//
//       payment.items = items
//       payment.paymentDetails = paymentDetails
//        print(paymentDetails)
//        print(payment.processable)
//       if (payment.processable) {
//           let paymentViewController = PayPalPaymentViewController(payment: payment, configuration: payPalConfig, delegate: self)
//           present(paymentViewController!, animated: true, completion: nil)
//       }
//       else {
//           // This particular payment will always be processable. If, for
//           // example, the amount was negative or the shortDescription was
//           // empty, this payment wouldn't be processable, and you'd want
//           // to handle that here.
//           print("Payment not processalbe: \(payment)")
//       }
        
        } // if top
        
        else {
           self.showAlert(title: "Alert!", message: "Sorry this is already sold you have to choose other option to proceed")
        }
        
    }
    
    
    @IBAction func thirdWordbuttonAction(_ sender: Any) {
        if (thirdWordBtn.currentTitle == "Buy" || thirdWordBtn.currentTitle == "BUY") {
            SVProgressHUD.show()
        let payPalDriver = BTPayPalDriver(apiClient: braintreeClient!)
                      payPalDriver.viewControllerPresentingDelegate = self
                      payPalDriver.appSwitchDelegate = self // Optional
        // Specify the transaction amount here. "2.32" is used in this example.
        let request = BTPayPalRequest(amount: "55")
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
                    var personalKey = ""
                    var userID = ""
                           if let userid = defaults.string(forKey: userData.id) {
                               print(userid) // Another String Value
                               userID = userid
                           }
                    
                    if let personalProfileKey = defaults.string(forKey: userData.personalProfileKey) {
                                                   print(personalProfileKey) // Another String Value
                                                   personalKey = personalProfileKey
                                                         
                                           }

                                                      
                                       let refp = Database.database().reference().child("profiles").child("\(personalKey)")
                                   refp.updateChildValues(["phoneNo":"\(self.myPhoneNumber)","type":"personal","userId":"\(userID)","wordNum":"\(self.thirdWordLabel.text!)"])
                    
                    
                        //   let refp = Database.database().reference().child("profiles")
                          // let keyp = refp.childByAutoId().key
                 //   let datap = ["phoneNo":"\(self.myPhoneNumber)","type":"personal","userId":"\(userID)","wordNum":"\(self.thirdWordLabel.text!)"]
                           //refp.child(keyp!).setValue(datap)
                           // Second we have to update values in user table
                           let refu = Database.database().reference().child("users").child(userID)
                           refu.updateChildValues(["personalProfileKey":"\(personalKey)","hasPersonalWordNum":"true"])
                           // Third we have to add word number data into word_nums table
                           let refw = Database.database().reference().child("word_nums")
                           let keyw = refp.childByAutoId().key
                           let dataw = ["catType":"Personal","country":"\(self.selectedCounter)","key":"\(keyw!)","phoneType":"Mobile","status":0,"type":0,"uid":"\(userID)","wordNum":"\(self.thirdWordLabel.text!)"] as [String : Any]
                           refw.child(keyw!).setValue(dataw)
                           SVProgressHUD.dismiss()
                           for controller in self.navigationController!.viewControllers as Array {
                               if controller.isKind(of: DugViewController.self) {
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
        }// if top
        
        else{
            self.showAlert(title: "Alert!", message: "Sorry this is already sold you have to choose other option to proceed")
        }
    }
    
    
    @IBAction func contactUsButtonAction(_ sender: Any) {
    }
    
    @IBAction func backButtonAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
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

extension FreeVanityNumber2ViewController:UIViewControllerTransitioningDelegate{
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.isPresenting = true
        return transition
    }
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.isPresenting = false
        return transition
    }
}

//extension FreeVanityNumber2ViewController:PayPalPaymentDelegate {
//    func payPalPaymentDidCancel(_ paymentViewController: PayPalPaymentViewController) {
//        print("PayPal Payment Cancelled")
//        paymentViewController.dismiss(animated: true, completion: nil)
//    }
//
//    func payPalPaymentViewController(_ paymentViewController: PayPalPaymentViewController, didComplete completedPayment: PayPalPayment) {
//        print("PayPal Payment Success")
//        paymentViewController.dismiss(animated: true, completion: nil)
//    }
//
//
//}
extension FreeVanityNumber2ViewController : BTViewControllerPresentingDelegate {
    func paymentDriver(_ driver: Any, requestsPresentationOf viewController: UIViewController) {
        
    }
    
    func paymentDriver(_ driver: Any, requestsDismissalOf viewController: UIViewController) {
        
    }
    
    
}
extension FreeVanityNumber2ViewController : BTAppSwitchDelegate {
    func appSwitcherWillPerformAppSwitch(_ appSwitcher: Any) {
        
    }
    
    func appSwitcher(_ appSwitcher: Any, didPerformSwitchTo target: BTAppSwitchTarget) {
        
    }
    
    func appSwitcherWillProcessPaymentInfo(_ appSwitcher: Any) {
        
    }
    
    
}
