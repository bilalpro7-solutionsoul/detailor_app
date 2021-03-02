//
//  MenuViewController.swift
//  DailerApp
//
//  Created by Muhammad Bilal on 25/02/2020.
//  Copyright © 2020 Solution Soul. All rights reserved.
//

import UIKit
import Firebase
import Kingfisher
import SVProgressHUD

class MenuViewController: UIViewController {
    
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var numberLabel: UILabel!
    @IBOutlet weak var wordNumberLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    var hasBusinessProfile = "false"
    
    var titleArray = ["Create Business Profile","Home","About","Help","Contact Us","Logout"]
    var imageArray = [#imageLiteral(resourceName: "personal_listing"),#imageLiteral(resourceName: "home"),#imageLiteral(resourceName: "about"),#imageLiteral(resourceName: "help"),#imageLiteral(resourceName: "contact_us"),#imageLiteral(resourceName: "logout-1")]
    
    override func viewWillAppear(_ animated: Bool) {
        fetchUserData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.profileImage.layer.cornerRadius = self.profileImage.frame.width/2
        
//        if let name = defaults.string(forKey: userData.name) {
//            print(name) // Another String Value
//            self.nameLabel.text = name
//        }
//        if let number = defaults.string(forKey: userData.phoneNo) {
//            print(number) // Another String Value
//            self.numberLabel.text = number
//        }
//        if let wordNumberKey = defaults.string(forKey: userData.personalProfileKey) {
//            print(wordNumberKey) // Another String Value
//            let ref = Database.database().reference().child("profiles").child(wordNumberKey)
//            ref.observe(DataEventType.value) { (snapshot) in
//                if snapshot.childrenCount>0{
//
//                    let data = snapshot.value as? [String : Any]//.children.allObjects as! DataSnapshot
//                    let obj = data//.value as? [String: Any]
//
////                    let phoneNo = obj?["phoneNo"] as! String
////                    let type = obj?["type"] as! String
////                    let userId = obj?["userId"] as! String
//                    let wordNum = obj?["wordNum"] as! String
//
//                    self.wordNumberLabel.text = wordNum
//
//                }
//            }
//
//        }
//        if let image = defaults.string(forKey: userData.imageUrl) {
//            print(image) // Another String Value
//            self.profileImage.kf.setImage(with: URL(string: image),placeholder: UIImage(named: "demoImage"))
//        }
//        if let hasBusinessProfile = defaults.string(forKey: userData.hasBusinessProfile) {
//            print(hasBusinessProfile) // Another String Value
//            if hasBusinessProfile == "true" {
//                self.hasBusinessProfile = true
//                self.titleArray = ["Create Business Profile","Home","About","Help","Contact Us","Logout"]
//            }else{
//                self.titleArray = ["Business Profile","Home","About","Help","Contact Us","Logout"]
//                self.hasBusinessProfile = false
//            }
//        }
        
    }
    
    func fetchUserData(){
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
                
                let address = obj?["address"] as! String
                let businessProfileKey = obj?["businessProfileKey"] as! String
                let email = obj?["email"] as! String
                let hasBusinessProfile = obj?["hasBusinessProfile"] as! String
                let hasBusinessWordNum = obj?["hasBusinessWordNum"] as! String
                let hasPersonalWordNum = obj?["hasPersonalWordNum"] as! String
                let id = obj?["id"] as! String
                let imageUrl = obj?["imageUrl"] as! String
                let name = obj?["name"] as! String
                let password = obj?["password"] as! String
                let personalProfileKey = obj?["personalProfileKey"] as! String
                let phoneNo = obj?["phoneNo"] as! String
                
                defaults.set("\(address)", forKey: userData.address)
                defaults.set("\(businessProfileKey)", forKey: userData.businessProfileKey)
                defaults.set("\(email)", forKey: userData.email)
                defaults.set("\(hasBusinessProfile)", forKey: userData.hasBusinessProfile)
                defaults.set("\(hasBusinessWordNum)", forKey: userData.hasBusinessWordNum)
                defaults.set("\(hasPersonalWordNum)", forKey: userData.hasPersonalWordNum)
                defaults.set("\(id)", forKey: userData.id)
                defaults.set("\(imageUrl)", forKey: userData.imageUrl)
                defaults.set("\(name)", forKey: userData.name)
                defaults.set("\(password)", forKey: userData.password)
                defaults.set("\(personalProfileKey)", forKey: userData.personalProfileKey)
                defaults.set("\(phoneNo)", forKey: userData.phoneNo)
                //defaults.set("true", forKey: userData.userLogin)
                
                self.nameLabel.text = name
                self.numberLabel.text = phoneNo
                
                self.profileImage.kf.setImage(with: URL(string: imageUrl),placeholder: UIImage(named: "demoImage"))
                
                let ref = Database.database().reference().child("profiles").child(personalProfileKey)
                ref.observe(DataEventType.value) { (snapshot) in
                    if snapshot.childrenCount>0{
                        
                        let data = snapshot.value as? [String : Any]//.children.allObjects as! DataSnapshot
                        let obj = data//.value as? [String: Any]
                        
                        //                    let phoneNo = obj?["phoneNo"] as! String
                        //                    let type = obj?["type"] as! String
                        //                    let userId = obj?["userId"] as! String
                        let wordNum = obj?["wordNum"] as! String
                        
                        self.wordNumberLabel.text = wordNum
                        
                    }
                }
                
                if Bool(hasBusinessProfile)! {
                    self.hasBusinessProfile = "true"
                    self.titleArray = ["Business Profile","Home","About","Help","Contact Us","Logout"]
                }else{
                    self.titleArray = ["Create Business Profile","Home","About","Help","Contact Us","Logout"]
                    self.hasBusinessProfile = "false"
                }
                
                
                SVProgressHUD.dismiss()
                
                self.tableView.reloadData()
                
            }
        }
    }
    
}

extension MenuViewController : UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 6
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            
            if Bool(self.hasBusinessProfile)! {
                let mainStoryBoard = UIStoryboard(name: "Main", bundle: nil)
                let redViewController = mainStoryBoard.instantiateViewController(withIdentifier: "BusinessProfileDetailNavigationViewController") as! BusinessProfileDetailNavigationViewController//CreateBusinessNavigationViewController
                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                appDelegate.window?.rootViewController = redViewController
            }else{
                let mainStoryBoard = UIStoryboard(name: "Main", bundle: nil)
                let redViewController = mainStoryBoard.instantiateViewController(withIdentifier: "CreateBusinessNavigationViewController") as! CreateBusinessNavigationViewController//CreateBusinessNavigationViewController
                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                appDelegate.window?.rootViewController = redViewController
            }
            
        }else if indexPath.row == 1 {
            let mainStoryBoard = UIStoryboard(name: "Main", bundle: nil)
            let redViewController = mainStoryBoard.instantiateViewController(withIdentifier: "TabBarViewController") as! TabBarViewController
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            appDelegate.window?.rootViewController = redViewController
        }else if indexPath.row == 2 {
            let mainStoryBoard = UIStoryboard(name: "Main", bundle: nil)
            let redViewController = mainStoryBoard.instantiateViewController(withIdentifier: "AboutNavigationViewController") as! AboutNavigationViewController
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            appDelegate.window?.rootViewController = redViewController
        }else if indexPath.row == 3 {
            let mainStoryBoard = UIStoryboard(name: "Main", bundle: nil)
            let redViewController = mainStoryBoard.instantiateViewController(withIdentifier: "HelpNavigationViewController") as! HelpNavigationViewController
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            appDelegate.window?.rootViewController = redViewController
        }else if indexPath.row == 4 {
            let mainStoryBoard = UIStoryboard(name: "Main", bundle: nil)
            let redViewController = mainStoryBoard.instantiateViewController(withIdentifier: "ContactUsNavigationViewController") as! ContactUsNavigationViewController
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            appDelegate.window?.rootViewController = redViewController
        }else if indexPath.row == 5 {
            defaults.set(nil, forKey: userData.address)
            defaults.set(nil, forKey: userData.businessProfileKey)
            //defaults.set(nil, forKey: userData.email)
            defaults.set(nil, forKey: userData.hasBusinessProfile)
            defaults.set(nil, forKey: userData.hasBusinessWordNum)
            defaults.set(nil, forKey: userData.hasPersonalWordNum)
            defaults.set(nil, forKey: userData.id)
            defaults.set(nil, forKey: userData.imageUrl)
            defaults.set(nil, forKey: userData.name)
            //defaults.set(nil, forKey: userData.password)
            defaults.set(nil, forKey: userData.personalProfileKey)
            defaults.set(nil, forKey: userData.phoneNo)
            defaults.set("false", forKey: userData.userLogin)
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
            self.present(vc,animated: true,completion: nil)
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MenuTableViewCell") as! MenuTableViewCell
        
        cell.menuIcon.image = self.imageArray[indexPath.row]
        cell.menuIcon.image = cell.menuIcon.image?.withRenderingMode(.alwaysTemplate)
        cell.menuIcon.tintColor = UIColor.lightGray
        cell.menuTItile.text = self.titleArray[indexPath.row]
        
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 55
    }
}
