//
//  DailerViewController.swift
//  DailerApp
//
//  Created by Muhammad Bilal on 25/02/2020.
//  Copyright © 2020 Solution Soul. All rights reserved.
//

import UIKit
import Firebase
import MessageUI
import Kingfisher
import SVProgressHUD
import IQKeyboardManagerSwift
import SQLite3

var callerName = ""
var callerNumber = ""

class DailerViewController: UIViewController,UITextFieldDelegate,MFMessageComposeViewControllerDelegate {
    
    @IBOutlet var mainView: UIView!
    @IBOutlet weak var profileViewContainer: UIView!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var numberLabel: UILabel!
    
    @IBOutlet weak var buttonsViewContainer: UIView!
    @IBOutlet weak var phoneTF: UITextField!
    
    @IBOutlet weak var dailerTableView: UITableView!
    
    var businessPhone = ""
    var businessUserID = ""
    var profileName = ""
    var wordNumber = ""
    var personalCountry = ""
    
    let transition = SlideInTransition()
    
    var searchArray = [String]()
     var isBussinessProfileFound = false
    
    var allBusinessesDataArray = [AllBusinesses]()
    var allBusinessesDataArrayNewFiltered = [AllBusinesses]()
    var allBusinessesFilteredDataArray = [AllBusinesses]()
    var allUsers = [UserProfile]()
    var allProfileData = [PersonalProfile]()
    
    override func viewWillAppear(_ animated: Bool) {
        CATransaction.begin()
        CATransaction.setDisableActions(true)

        // change layer properties that you don't want to animate

        CATransaction.commit()
        mainView.layer.removeAllAnimations()
        self.view.layer.removeAllAnimations()
        //self.phoneTF.layer.removeAnimation(forKey: <#T##String#>)
        self.phoneTF.layer.removeAllAnimations()
        self.phoneTF.becomeFirstResponder()
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // =======================================
        //let address: String? = nil
        //let userId: String? = nil
        //let name: String? = nil
        //let ROWID: String? = nil
        //let date: String? = nil
        //let aNSDictionary: String? = nil
        //let country_code: String? = nil
        // =======================================
        
        //phoneTF.becomeFirstResponder()
//        dailerTableView.delegate = self
//        dailerTableView.dataSource = self
//        dailerTableView.tableFooterView = UIView()
        
        getAllBusiness()
        
        phoneTF.delegate = self
        phoneTF?.addTarget(self, action: #selector(searchRecords(_ :)), for: .editingChanged)
        
        transition.dimmingView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismisFunc)))
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(self.handleGesture(gesture:)))
        swipeLeft.direction = .left
        self.transition.dimmingView.addGestureRecognizer(swipeLeft)
        
        self.buttonsViewContainer.layer.cornerRadius = self.buttonsViewContainer.frame.height/2
        self.buttonsViewContainer.layer.borderWidth = 1
        self.buttonsViewContainer.layer.borderColor = #colorLiteral(red: 0.1762222946, green: 0.2514033616, blue: 0.4118424356, alpha: 1)
        setUpUIview()
        
    }
    
    
    func setUpUIview()  {
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))

        profileViewContainer.addGestureRecognizer(tap)

        profileViewContainer.isUserInteractionEnabled = true


       
    }
    
    // function which is triggered when handleTap is called
           @objc func handleTap(_ sender: UITapGestureRecognizer) {
            
            if self.profileName == "business" {
               print("Hello World")
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "SearchDetailViewController") as! SearchDetailViewController
            vc.businessUserID = businessUserID
           // vc.isBusinessProfile = true
                //self.businessProfile == "business"
                vc.businessProfile = "business"
                vc.isBusinessProfile = true
            self.navigationController?.pushViewController(vc, animated: true)
    }
            else{
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "SearchDetailViewController") as! SearchDetailViewController
                vc.personalUserID = businessUserID
                vc.wordNumberPersonal = self.wordNumber
                vc.businessProfile = "personal"
                vc.isBusinessProfile = false
                //vc.isBusinessProfile = false
                vc.personalPhoneNumber = numberLabel.text ?? ""
                vc.userName = nameLabel.text ?? ""
                vc.personalCountry = self.personalCountry
                self.navigationController?.pushViewController(vc, animated: true)
            }
           }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        //self.profileViewContainer.isHidden = true
        self.allBusinessesDataArrayNewFiltered.removeAll()
        self.businessPhone = ""
        return true
    }
    
    @objc func searchRecords(_ textField:UITextField){
        
        if phoneTF.text?.count ?? 0 > 0{
        allBusinessesDataArrayNewFiltered.removeAll()
            let no:String = phoneTF.text!
            var userID = ""
            var userType = ""
            var word = ""
     for item in self.allProfileData{
                print(item.type)
                print(item.userId)
       
        
               //1 if (item.phoneNo == no || item.wordNum == no){
                    if(item.phoneNo.caseInsensitiveCompare(no) == .orderedSame || item.wordNum.caseInsensitiveCompare(no) == .orderedSame){
                       
                    
                print("exists",item.phoneNo)
                    print(item.userId)
                    userID = item.userId
                    
                    userType = item.type
                    
                    word = item.wordNum
                    self.profileViewContainer.isHidden = false
                   break
        }
        
                else {
                 self.profileViewContainer.isHidden = true
        }
            }
                
                    if(userType == "business"){

                let ref = Database.database().reference().child("listing").child("business").child(userID)
                                ref.observe(DataEventType.value) { (snapshot) in
                                    if snapshot.childrenCount>0{
                
                                        let data = snapshot.value as? [String : Any]//.children.allObjects as! DataSnapshot
                                       // print(item.userId,no)
                                        let obj = data?["details"]  as? [String: Any]
                                            print(obj)
//                                        let address = obj?["address"] as! String
//                                        let businessProfileKey = obj?["businessProfileKey"] as! String
//                                        let email = obj?["email"] as! String
//                                        let hasBusinessProfile = obj?["hasBusinessProfile"] as! Bool
//                                        let hasBusinessWordNum = obj?["hasBusinessWordNum"] as! Bool
//                                        let hasPersonalWordNum = obj?["hasPersonalWordNum"] as! Bool
//                                        let id = obj?["id"] as! String
                                        let imageUrl = obj?["logoUrl"] as? String
                                        let name = obj?["name"] as? String
                                        //let password = obj?["password"] as! String
                                        let slogan = obj?["slogan"] as? String
                                        let phoneNo = obj?["phoneNo"] as! String
                
                                        self.profileImage.kf.setImage(with: URL(string: imageUrl ?? ""),placeholder: UIImage(named: "demoImage"))
                                        self.nameLabel.text = name
                                        self.numberLabel.text = slogan
                                        self.businessPhone = phoneNo
                                        self.businessUserID = userID
                                        callerName = name ?? ""
                                        //self.isBussinessProfileFound = true
                                        self.profileName = "business"
                                        self.wordNumber = word
                                        SVProgressHUD.dismiss()
                                    
                
                                    }
                                }
                           
                
                }
                    else if (userType == "personal")  {
                         print(userID)
                     //   print("exists",item.phoneNo)
                                                      self.profileViewContainer.isHidden = false
                                                      
                        let ref = Database.database().reference().child("users").child(userID)
                                                                      ref.observe(DataEventType.value) { (snapshot) in
                                                                          if snapshot.childrenCount>0{
                                                      
                                                                              let data = snapshot.value as? [String : Any]//.children.allObjects as! DataSnapshot
                                                                          //  print(item.userId,profileNumber!)
                                                                             // let obj = data?["details"]  as? [String: Any]
                                                                              
                                     
                                                                              let imageUrl = data?["imageUrl"] as? String
                                                                              let name = data?["name"] as? String
                                                                              //let password = obj?["password"] as! String
                                                                              //let slogan = obj?["slogan"] as? String
                                                                              let phoneNo = data?["phoneNo"] as! String
                                                                            let country = data?["address"] as! String
                                                      
                                                                              self.profileImage.kf.setImage(with: URL(string: imageUrl ?? ""),placeholder: UIImage(named: "demoImage"))
                                                                              self.nameLabel.text = name
                                                                              self.numberLabel.text = phoneNo
                                                                            self.personalCountry = country
                                                                             // self.businessPhone = phoneNo
                                                                            self.businessUserID = userID
                                                                              callerName = name ?? ""
                                                                             // self.isBussinessProfileFound = false
                                                                            self.profileName = "personal"
                                                                            self.wordNumber = word
                                                                              SVProgressHUD.dismiss()
                                                      
                                                                          }
                                                                      }
                    }//else personal
                    else{}
                    
                
                
            
            
            
       
        } //if empty textfield
        else{
            self.profileViewContainer.isHidden = true
        }
        
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
    @IBAction func barButtonAction(_ sender: Any) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "MenuViewController") as! MenuViewController
        vc.modalPresentationStyle = .overCurrentContext
        vc.transitioningDelegate = self
        present(vc,animated: true)
    }

    @IBAction func callButtonAction(_ sender: Any) {
        
        if businessPhone != "" {
            callerNumber = self.businessPhone
            dailerCheck = true
            if let url = URL(string: "tel://\(self.businessPhone)"),
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
        }else{
            if self.phoneTF.text != "" {
                callerName = "unknown"
                callerNumber = self.phoneTF.text!
                dailerCheck = true
                if let url = URL(string: "tel://\(self.phoneTF.text!)"),
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
        
    }
    
    @IBAction func messageButtonAction(_ sender: Any) {
        
        if businessPhone != "" {
            if (MFMessageComposeViewController.canSendText()) {
                let controller = MFMessageComposeViewController()
                controller.body = "Type Here"
                controller.recipients = [self.businessPhone]
                controller.messageComposeDelegate = self
                self.present(controller, animated: true, completion: nil)
            }
        }else{
            if self.phoneTF.text != "" {
                if (MFMessageComposeViewController.canSendText()) {
                    let controller = MFMessageComposeViewController()
                    controller.body = "Type Here"
                    controller.recipients = [self.phoneTF.text!]
                    controller.messageComposeDelegate = self
                    self.present(controller, animated: true, completion: nil)
                }
            }
        }
        
    }
    
    func messageComposeViewController(_ controller: MFMessageComposeViewController!, didFinishWith result: MessageComposeResult) {
        //... handle sms screen actions
        self.dismiss(animated: true, completion: nil)
    }
    
    func getAllBusiness(){
        var index = 0
        SVProgressHUD.show(withStatus: "Loading")

        
        
        
        SVProgressHUD.show(withStatus: "Loading")
        let reff1 = Database.database().reference().child("profiles")
        reff1.observe(DataEventType.value) { (snapshot) in
            if snapshot.childrenCount>0{
                self.allProfileData.removeAll()
                for data in snapshot.children.allObjects as! [DataSnapshot]{
                    let obj = data.value as? [String: Any]
                    
//                    let type = obj?["type"] as! String
                   
                    //if type == "business"{
                        let phoneNo = obj?["phoneNo"] as! String
                        let type = obj?["type"] as! String
                        let userId = obj?["userId"] as! String
                        let wordNum = obj?["wordNum"] as! String
                    
                    let profile = PersonalProfile(phoneNo: phoneNo, type: type, userId: userId, wordNum: wordNum)
                        
                    self.allProfileData.append(profile)
                       // self.allBusinessesDataArray.append(businessData)
                        //self.allBusinessesFilteredDataArray.append(businessData)
                   // }
             
                }
                
                SVProgressHUD.dismiss()
                
            }
        
        }
   
        
         SVProgressHUD.dismiss()
        
        
}
        
}

extension DailerViewController:UIViewControllerTransitioningDelegate{
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.isPresenting = true
        return transition
    }
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.isPresenting = false
        return transition
    }
}


extension DailerViewController : UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
         return allBusinessesDataArrayNewFiltered.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DailerCell") as! DailerCell
        
        if  indexPath.row < allBusinessesDataArrayNewFiltered.count{
        let item = allBusinessesDataArrayNewFiltered[indexPath.row]
        
        cell.profileImage.kf.setImage(with: URL(string: item.image),placeholder: UIImage(named: "demoImage"))
        cell.nameLabel.text = item.name
        cell.sloganLabel.text = item.keywords
            
        }
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if  indexPath.row < allBusinessesDataArrayNewFiltered.count{
        let item = allBusinessesDataArrayNewFiltered[indexPath.row]
        print(item)
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "SearchDetailViewController") as! SearchDetailViewController
        vc.businessUserID = item.userId
        vc.isBusinessProfile = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
    
    
}
