//
//  BlockViewController.swift
//  DailerApp
//
//  Created by Muhammad Bilal on 07/03/2020.
//  Copyright © 2020 Solution Soul. All rights reserved.
//

import UIKit
import Firebase
import SVProgressHUD

class BlockViewController: UIViewController {
    
    @IBOutlet weak var topNumberLabel: UILabel!
    @IBOutlet weak var notesLabel: UILabel!
    @IBOutlet weak var telemarketerCircleView: CustomView!
    @IBOutlet weak var fraudCircleView: CustomView!
    @IBOutlet weak var taxCircleView: CustomView!
    
    var blockContact = ContactStructure(actionsVisible: "false", inDatabase: "false", key: "", name: "", phoneNo: "", userId: "")
    var reportAs = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        
        self.topNumberLabel.text = self.blockContact.phoneNo
        
    }
    
    func setupNavigationBar(){
        
        // Set title
        navigationItem.title = "Block Number"
        
        // Set up Left Button
        let menuUIBarButtonItem = UIBarButtonItem(image: UIImage(named: "left-arrow.png"), style: .plain, target: self, action: #selector(BlockViewController.clickButton))
        menuUIBarButtonItem.tintColor = UIColor.white
        self.navigationItem.leftBarButtonItem  = menuUIBarButtonItem
    }
    @objc func clickButton(){
        print("button click")
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func telemarketerButtonAction(_ sender: Any) {
        reportAs = "Telemarketer"
        self.telemarketerCircleView.backgroundColor = .darkGray
        self.fraudCircleView.backgroundColor = .clear
        self.taxCircleView.backgroundColor = .clear
    }
    @IBAction func fraudButtonAction(_ sender: Any) {
        reportAs = "Fraud OR Scam"
        self.telemarketerCircleView.backgroundColor = .clear
        self.fraudCircleView.backgroundColor = .darkGray
        self.taxCircleView.backgroundColor = .clear
    }
    @IBAction func taxScamButtonAction(_ sender: Any) {
        reportAs = "Tax Office Scam"
        self.telemarketerCircleView.backgroundColor = .clear
        self.fraudCircleView.backgroundColor = .clear
        self.taxCircleView.backgroundColor = .darkGray
    }
    
    @IBAction func reportButtonAction(_ sender: Any) {
        if reportAs != "" {
            let ref = Database.database().reference().child("reports")
            let key = ref.childByAutoId().key
            let data = ["key":"\(key!)","phoneNo":"\(self.blockContact.phoneNo)","reportAs":""] as [String : Any]
            ref.child(key!).setValue(data)
            showAlert(title: "Report And Blocked",message: "Report added against the User!")
        }else{
            let alert = UIAlertController(title: "Alert", message: "Please Select an option", preferredStyle: .actionSheet)
            let action = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(action)
            self.present(alert,animated: true,completion: nil)
        }
    }
    
    @IBAction func blockNumberButtonAction(_ sender: Any) {
        var userID = ""
        if let userid = defaults.string(forKey: userData.id) {
            print(userid) // Another String Value
            userID = userid
        }
        let ref = Database.database().reference().child("block_numbers").child("\(userID)")
        let key = ref.childByAutoId().key
        let data = ["key":"\(key!)","phoneNo":"\(self.blockContact.phoneNo)"] as [String : Any]
        ref.child(key!).setValue(data)
        showAlert(title: "Blocked",message: "User Successfully Blocked!")
    }
    func showAlert(title:String,message:String){
        let alert = UIAlertController(title: "\(title)", message: "\(message)", preferredStyle: .actionSheet)
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(action)
        self.present(alert,animated: true,completion: {
            self.navigationController?.popViewController(animated: true)
        })
    }
    
}
