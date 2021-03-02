//
//  LoginViewController.swift
//  DailerApp
//
//  Created by Muhammad Bilal on 25/10/2019.
//  Copyright © 2019 Solution Soul. All rights reserved.
//

import UIKit
import CallKit
import SQLite3
import CoreData
import FirebaseAuth
import SVProgressHUD
import FirebaseDatabase

class LoginViewController: UIViewController {
    
    @IBOutlet weak var emailTF: TextField_Class!
    @IBOutlet weak var passwordTF: TextField_Class!
    @IBOutlet weak var loginButtonProperty: UIButton!
    @IBOutlet weak var createAccountButtonProperty: UIButton!
    
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        DispatchQueue.main.async {
            if let isLogin = defaults.string(forKey: userData.userLogin) {
                print(isLogin) // Another String Value
                if Bool(isLogin)! {
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "TabBarViewController") as! TabBarViewController
                    self.present(vc,animated: true,completion: nil)
                }else{
                    
                }
            }
        }
        
        
        getLoginDetails()
        
        
        
        //sendImageApi(id: "11", image: UIImage(named: "dailerDemo")!)
        
        self.emailTF.layer.cornerRadius = 8
        self.passwordTF.layer.cornerRadius = 8
        
        self.emailTF.layer.borderWidth = 1
        self.passwordTF.layer.borderWidth = 1
        
        self.emailTF.layer.borderColor = UIColor.lightGray.cgColor
        self.passwordTF.layer.borderColor = UIColor.lightGray.cgColor
        
        self.loginButtonProperty.layer.cornerRadius = self.loginButtonProperty.frame.height/2
        self.createAccountButtonProperty.layer.cornerRadius = self.createAccountButtonProperty.frame.height/2
        
        self.createAccountButtonProperty.layer.borderWidth = 1
        self.createAccountButtonProperty.layer.borderColor = UIColor(red: 21/255, green: 37/255, blue: 57/255, alpha: 1).cgColor
        
    }
    
    func getLoginDetails()  {
        
         DispatchQueue.main.async {
            if let email = defaults.string(forKey: userData.email){
            self.emailTF.text = email
            if let password = defaults.string(forKey: userData.password){
                self.passwordTF.text = password
             
            }
        }
      
        }
        
    }
    
    @IBAction func loginButtonAction(_ sender: Any) {
        if emailTF.text != "" {
            if passwordTF.text != "" {
                Auth.auth().signIn(withEmail: self.emailTF.text!, password: self.passwordTF.text!) { (user, error) in
                    if user != nil {
                        print("User Exist and Successfully Login")
                        SVProgressHUD.dismiss()

                        let userID = user?.user.uid

                        print("userID",userID)
                        SVProgressHUD.show(withStatus: "Loading")
                        let ref = Database.database().reference().child("users").child(userID!)
                        ref.observe(DataEventType.value) { (snapshot) in

                            print("refff",ref)
                            print("snapshot",snapshot)
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
                                defaults.set(email, forKey: userData.email)
                                defaults.set("\(hasBusinessProfile)", forKey: userData.hasBusinessProfile)
                                defaults.set("\(hasBusinessWordNum)", forKey: userData.hasBusinessWordNum)
                                defaults.set("\(hasPersonalWordNum)", forKey: userData.hasPersonalWordNum)
                                defaults.set("\(id)", forKey: userData.id)
                                defaults.set("\(imageUrl)", forKey: userData.imageUrl)
                                defaults.set("\(name)", forKey: userData.name)
                                defaults.set("\(password)", forKey: userData.password)
                                defaults.set("\(personalProfileKey)", forKey: userData.personalProfileKey)
                                defaults.set("\(phoneNo)", forKey: userData.phoneNo)
                                defaults.set("true", forKey: userData.userLogin)


                                UserDefaults.standard.setValue(email, forKey: "email")
                                print(email)
                                SVProgressHUD.dismiss()

                                let vc = self.storyboard?.instantiateViewController(withIdentifier: "TabBarViewController") as! TabBarViewController
                                self.present(vc,animated: true,completion: nil)

                            }

                            else{
                                SVProgressHUD.dismiss()
                                print("User data not found in users table")
                                let alert = UIAlertController(title: "Alert!", message: "No Record Found", preferredStyle: .alert)
                                let action = UIAlertAction(title: "OK", style: .default, handler: nil)
                                alert.addAction(action)
                                self.present(alert,animated: true,completion: nil)

                            }

                        }


                    }else{
                        SVProgressHUD.dismiss()
                        print("User not Exist")
                        let alert = UIAlertController(title: "Incorrect Input", message: "Email or Password Incorrect, Try Again", preferredStyle: .alert)
                        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
                        alert.addAction(action)
                        self.present(alert,animated: true,completion: nil)
                    }
                }
            }else{
                let alert = UIAlertController(title: "Alert", message: "Please Enter Password", preferredStyle: .alert)
                let action = UIAlertAction(title: "OK", style: .default, handler: nil)
                alert.addAction(action)
                self.present(alert,animated: true,completion: nil)
            }
        }else{
            let alert = UIAlertController(title: "Alert", message: "Please Enter Email First", preferredStyle: .alert)
            let action = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(action)
            self.present(alert,animated: true,completion: nil)
        }
        
      
    }
    
    @IBAction func createAccountButtonAction(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "CreateAccountViewController") as! CreateAccountViewController
        self.present(vc,animated: true, completion: nil)
    }
    
    @IBAction func forgetPasswordButtonAction(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "ForgetPasswordViewController") as! ForgetPasswordViewController
        self.present(vc,animated: true,completion: nil)
    }
    
}

