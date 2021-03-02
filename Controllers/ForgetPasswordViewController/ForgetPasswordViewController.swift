//
//  ForgetPasswordViewController.swift
//  DailerApp
//
//  Created by Muhammad Bilal on 02/03/2020.
//  Copyright © 2020 Solution Soul. All rights reserved.
//

import UIKit
import Firebase
import SVProgressHUD

class ForgetPasswordViewController: UIViewController {
    
    @IBOutlet weak var emailTF: TextField_Class!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    @IBAction func submitButtonAction(_ sender: Any) {
        if self.emailTF.text != "" {
            SVProgressHUD.show(withStatus: "Reseting! Please wait")
            Auth.auth().sendPasswordReset(withEmail: "\(self.emailTF.text!)") { error in
                // Your code here
                if error == nil {
                    SVProgressHUD.dismiss()
                    print("Successfully Reset Password, Kindly check your email inbox")
                    let alert = UIAlertController(title: "Reset", message: "Successfully Reset Password, Kindly check your email inbox", preferredStyle: .alert)
                    let action = UIAlertAction(title: "OK", style: .default, handler: { (res) in
                        self.dismiss(animated: true, completion: nil)
                    })
                    alert.addAction(action)
                    self.present(alert,animated: true,completion: nil)
                }else{
                    SVProgressHUD.dismiss()
                    print("error occurs : \(error!)")
                }
            }
        }else{
            let alert = UIAlertController(title: "Alert", message: "Please enter email to reset password", preferredStyle: .alert)
            let action = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(action)
            self.present(alert,animated: true,completion: nil)
        }
    }
    
    @IBAction func backButtonAction(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}
