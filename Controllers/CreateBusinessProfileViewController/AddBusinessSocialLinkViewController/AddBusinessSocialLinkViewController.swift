//
//  AddBusinessSocialLinkViewController.swift
//  DailerApp
//
//  Created by Muhammad Bilal on 10/03/2020.
//  Copyright © 2020 Solution Soul. All rights reserved.
//

import UIKit
import Firebase
import SVProgressHUD

class AddBusinessSocialLinkViewController: UIViewController {
    
    @IBOutlet weak var conatinerView: UIView!
    @IBOutlet weak var socialLinkImage: UIImageView!
    @IBOutlet weak var linkTF: UITextField!
    @IBOutlet weak var nameTF: UITextField!
    @IBOutlet weak var switchController: UISwitch!
    
    var isEdit = false
    var linkItem = LinksStructure(key: " ", link: " ", name: " ")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if isEdit {
            self.linkTF.text = linkItem.link
            self.nameTF.text = linkItem.name
            if self.linkItem.link.contains("facebook") {
                print("facebook link")
                self.socialLinkImage.image = #imageLiteral(resourceName: "facebook (4)")
            }else if self.linkItem.link.contains("instagram") {
                print("instagram link")
                self.socialLinkImage.image = #imageLiteral(resourceName: "instagram")
            }else if self.linkItem.link.contains("linkedin") {
                print("linkedin link")
                self.socialLinkImage.image = #imageLiteral(resourceName: "linkedin")
            }else if self.linkItem.link.contains("pinterest") {
                print("pinterest link")
                self.socialLinkImage.image = #imageLiteral(resourceName: "pinterest")
            }else if self.linkItem.link.contains("skype") {
                print("skype link")
                self.socialLinkImage.image = #imageLiteral(resourceName: "skype")
            }else if self.linkItem.link.contains("snapchat") {
                print("snapchat link")
                self.socialLinkImage.image = #imageLiteral(resourceName: "snapchat")
            }else if self.linkItem.link.contains("twitter") {
                print("twitter link")
                self.socialLinkImage.image = #imageLiteral(resourceName: "twitter")
            }else if self.linkItem.link.contains("viber") {
                print("viber link")
                self.socialLinkImage.image = #imageLiteral(resourceName: "viber")
            }else if self.linkItem.link.contains("whatsapp") {
                print("whatsapp link")
                self.socialLinkImage.image = #imageLiteral(resourceName: "whatsapp")
            }else if self.linkItem.link.contains("yahoo") {
                print("yahoo link")
                self.socialLinkImage.image = #imageLiteral(resourceName: "yahoo")
            }else if self.linkItem.link.contains("youtube") {
                print("youtube link")
                self.socialLinkImage.image = #imageLiteral(resourceName: "youtube")
            }else{
                print("chrome link")
                self.socialLinkImage.image = #imageLiteral(resourceName: "chrome")
            }
        }else{
            
        }
        
        self.socialLinkImage.layer.cornerRadius = 8
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.8)
        self.showAnimate()
        self.linkTF.addTarget(self, action: #selector(linkEditFunc), for: .editingChanged)
    }
    
    @IBAction func addButtonAction(_ sender: Any) {
        
        if isEdit {
            
            var userID = ""
            if let userid = defaults.string(forKey: userData.id) {
                print(userid) // Another String Value
                userID = userid
            }
            if self.nameTF.text != "" {
                if self.linkTF.text != "" {
                    if switchController.isOn {
                        let ref = Database.database().reference().child("listing").child("business").child(userID).child("links")
                        let data = ["key":"\(linkItem.key)","link":"\(self.linkTF.text!)","name":"\(self.nameTF.text!)","private":"true"] as [String : Any]
                        ref.child(linkItem.key).setValue(data)
                        removeAnimate()
                    }else{
                        let ref = Database.database().reference().child("listing").child("business").child(userID).child("links")
                        let data = ["key":"\(linkItem.key)","link":"\(self.linkTF.text!)","name":"\(self.nameTF.text!)","public":true] as [String : Any]
                        ref.child(linkItem.key).setValue(data)
                        removeAnimate()
                    }
                }else{
                    self.showAlert(message: "Please Enter Link")
                }
            }else{
                self.showAlert(message: "Please Enter Name")
            }
        }else{
            var userID = ""
            if let userid = defaults.string(forKey: userData.id) {
                print(userid) // Another String Value
                userID = userid
            }
            if self.nameTF.text != "" {
                if self.linkTF.text != "" {
                    if switchController.isOn {
                        let ref = Database.database().reference().child("listing").child("business").child(userID).child("links")
                        let key = ref.childByAutoId().key
                        let data = ["key":"\(key!)","link":"\(self.linkTF.text!)","name":"\(self.nameTF.text!)","private":"true"] as [String : Any]
                        ref.child(key!).setValue(data)
                        removeAnimate()
                    }else{
                        let ref = Database.database().reference().child("listing").child("business").child(userID).child("links")
                        let key = ref.childByAutoId().key
                        let data = ["key":"\(key!)","link":"\(self.linkTF.text!)","name":"\(self.nameTF.text!)","public":true] as [String : Any]
                        ref.child(key!).setValue(data)
                        removeAnimate()
                    }
                }else{
                    self.showAlert(message: "Please Enter Link")
                }
            }else{
                self.showAlert(message: "Please Enter Name")
            }
        }
        
    }
    @IBAction func crossButtonAction(_ sender: Any) {
        self.removeAnimate()
    }
    
    @objc func linkEditFunc(){
        if self.linkTF.text!.contains("facebook") {
            print("facebook link")
            self.socialLinkImage.image = #imageLiteral(resourceName: "facebook (4)")
        }else if self.linkTF.text!.contains("instagram") {
            print("instagram link")
            self.socialLinkImage.image = #imageLiteral(resourceName: "instagram")
        }else if self.linkTF.text!.contains("linkedin") {
            print("linkedin link")
            self.socialLinkImage.image = #imageLiteral(resourceName: "linkedin")
        }else if self.linkTF.text!.contains("pinterest") {
            print("pinterest link")
            self.socialLinkImage.image = #imageLiteral(resourceName: "pinterest")
        }else if self.linkTF.text!.contains("skype") {
            print("skype link")
            self.socialLinkImage.image = #imageLiteral(resourceName: "skype")
        }else if self.linkTF.text!.contains("snapchat") {
            print("snapchat link")
            self.socialLinkImage.image = #imageLiteral(resourceName: "snapchat")
        }else if self.linkTF.text!.contains("twitter") {
            print("twitter link")
            self.socialLinkImage.image = #imageLiteral(resourceName: "twitter")
        }else if self.linkTF.text!.contains("viber") {
            print("viber link")
            self.socialLinkImage.image = #imageLiteral(resourceName: "viber")
        }else if self.linkTF.text!.contains("whatsapp") {
            print("whatsapp link")
            self.socialLinkImage.image = #imageLiteral(resourceName: "whatsapp")
        }else if self.linkTF.text!.contains("yahoo") {
            print("yahoo link")
            self.socialLinkImage.image = #imageLiteral(resourceName: "yahoo")
        }else if self.linkTF.text!.contains("youtube") {
            print("youtube link")
            self.socialLinkImage.image = #imageLiteral(resourceName: "youtube")
        }else{
            print("chrome link")
            self.socialLinkImage.image = #imageLiteral(resourceName: "chrome")
        }
    }
    
    // Show Animation when present Controller
    func showAnimate()
    {
        self.view.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
        self.view.alpha = 0.0;
        UIView.animate(withDuration: 0.25, animations: {
            self.view.alpha = 1.0
            self.view.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        });
    }
    func removeAnimate()
    {
        UIView.animate(withDuration: 0.25, animations: {
            self.view.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
            self.view.alpha = 0.0;
        }, completion:{(finished : Bool)  in
            if (finished)
            {
                self.view.removeFromSuperview()
            }
        });
    }
    func showAlert(message:String){
        let alert = UIAlertController(title: "Alert", message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(action)
        self.present(alert,animated: true,completion: nil)
    }
}
