//
//  ContactsViewController.swift
//  DailerApp
//
//  Created by Muhammad Bilal on 25/02/2020.
//  Copyright © 2020 Solution Soul. All rights reserved.
//

import UIKit
import Firebase
import SVProgressHUD

class ContactsViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var businessWhiteLabel: UILabel!
    @IBOutlet weak var personalWhiteLabel: UILabel!
    
    var personalContactDataArray = [ContactStructure]()
    var businessContactDataArray = [ContactStructure]()
    
    let transition = SlideInTransition()
    
    var clickArray = [0,0,0,0]
    
    var businessContactCounter = 4
    var defaultShow = "business"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getPersonalAndBusinessContacts()
        
        self.businessWhiteLabel.isHidden = false
        self.personalWhiteLabel.isHidden = true
        
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
    @IBAction func barButtonAction(_ sender: Any) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "MenuViewController") as! MenuViewController
        vc.modalPresentationStyle = .overCurrentContext
        vc.transitioningDelegate = self
        present(vc,animated: true)
    }
    
    @IBAction func businessButtonAction(_ sender: Any) {
        
        defaultShow = "business"
        self.clickArray.removeAll()
        for _ in self.businessContactDataArray{
            self.clickArray.append(0)
        }
        
        self.businessWhiteLabel.isHidden = false
        self.personalWhiteLabel.isHidden = true
        self.tableView.isHidden = false
        self.tableView.reloadData()
    }
    @IBAction func personalButtonAction(_ sender: Any) {
        
        defaultShow = "personal"
        self.clickArray.removeAll()
        for _ in self.personalContactDataArray{
            self.clickArray.append(0)
        }
        
        self.businessWhiteLabel.isHidden = true
        self.personalWhiteLabel.isHidden = false
        self.tableView.isHidden = false
        self.tableView.reloadData()
    }
    
    func getPersonalAndBusinessContacts(){
        
        self.personalContactDataArray.removeAll()
        self.businessContactDataArray.removeAll()
        
        var userID = ""
        if let userid = defaults.string(forKey: userData.id) {
            print(userid) // Another String Value
            userID = userid
        }
        SVProgressHUD.show(withStatus: "Loading")
        let ref = Database.database().reference().child("contacts").child("\(userID)").child("business")
        ref.observe(DataEventType.value) { (snapshot) in
            if snapshot.childrenCount>0{
                self.businessContactDataArray.removeAll()
                for data in snapshot.children.allObjects as! [DataSnapshot]{
                    let obj = data.value as? [String: Any]
                    
                    let actionsVisible = obj?["actionsVisible"] as! String
                    let inDatabase = obj?["inDatabase"] as? String ?? "false"
                    let key = obj?["key"] as! String
                    let name = obj?["name"] as! String
                    let phoneNo = obj?["phoneNo"] as! String
                    let userId = obj?["userId"] as! String
                    
                    let businessContactData = ContactStructure(actionsVisible: actionsVisible, inDatabase: inDatabase, key: key, name: name, phoneNo: phoneNo, userId: userId)
                    
                    self.businessContactDataArray.append(businessContactData)
                    
                    
                }
                self.clickArray.removeAll()
                for _ in self.businessContactDataArray{
                    self.clickArray.append(0)
                }
                
                SVProgressHUD.dismiss()
                self.tableView.reloadData()
                
            }else{
                SVProgressHUD.dismiss()
                print("business contact not found")
            }
        }
        
        
        SVProgressHUD.show(withStatus: "Loading")
        let refe = Database.database().reference().child("contacts").child("\(userID)").child("personal")
        refe.observe(DataEventType.value) { (snapshot) in
            if snapshot.childrenCount>0{
                self.personalContactDataArray.removeAll()
                for data in snapshot.children.allObjects as! [DataSnapshot]{
                    let obj = data.value as? [String: Any]
                    
                    let actionsVisible = obj?["actionsVisible"] as! String
                    let inDatabase = obj?["inDatabase"] as? String ?? "false"
                    let key = obj?["key"] as! String
                    let name = obj?["name"] as! String
                    let phoneNo = obj?["phoneNo"] as! String
                    let userId = obj?["userId"] as! String
                    
                    let personalContactData = ContactStructure(actionsVisible: actionsVisible, inDatabase: inDatabase, key: key, name: name, phoneNo: phoneNo, userId: userId)
                    
                    self.personalContactDataArray.append(personalContactData)
                    
                    
                }
                SVProgressHUD.dismiss()
                self.tableView.reloadData()
                
            }else{
                SVProgressHUD.dismiss()
                print("personal contact not found")
                self.tableView.reloadData()
            }
        }
    }
    
}

extension ContactsViewController : UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if defaultShow == "business" {
            return self.businessContactDataArray.count
        }else{
            return self.personalContactDataArray.count
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if self.clickArray[indexPath.row] == 0 {
            self.clickArray[indexPath.row] = 1
        }else{
            self.clickArray[indexPath.row] = 0
        }
        self.tableView.reloadData()
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ContactsTableViewCell") as! ContactsTableViewCell
        
        var userID = ""
        if let userid = defaults.string(forKey: userData.id) {
            print(userid) // Another String Value
            userID = userid
        }
        
        var item = ContactStructure(actionsVisible: "false", inDatabase: "false", key: "", name: "", phoneNo: "", userId: "")
        if defaultShow == "business" {
            item = self.businessContactDataArray[indexPath.row]
        }else{
            item = self.personalContactDataArray[indexPath.row]
        }
        
        cell.contactNameLabel.text = item.name
        cell.contactNumberLabel.text = item.phoneNo
        
        cell.wordLabel.text = item.name.first?.uppercased()
        cell.wordViewContainer.backgroundColor = UIColor.random()
        
        if self.clickArray[indexPath.row] == 1 {
            cell.buttonsStackContainer.isHidden = false
        }else{
            cell.buttonsStackContainer.isHidden = true
        }
        
        cell.infoButtonClosure = {() in
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "SearchDetailViewController") as! SearchDetailViewController
            vc.contactsUser = item
            vc.previousViewCheck = "contact"
            vc.businessUserID = item.userId
            if self.defaultShow == "business" {
                vc.contactType = "business"
                vc.businessProfile = "business"
                self.navigationController?.pushViewController(vc, animated: true)
            }else{
                vc.contactType = "personal"
                vc.businessProfile = "personal"
                vc.isBusinessProfile = false
                self.navigationController?.pushViewController(vc, animated: true)
//                let alert = UIAlertController(title: "Alert!", message: "Informatoin not found!", preferredStyle: .actionSheet)
//                let action = UIAlertAction(title: "OK", style: .default, handler: nil)
//                alert.addAction(action)
//                self.present(alert,animated: true,completion: nil)
                
            }
            
            
        }
        
        cell.deleteButtonClosure = {() in
            if self.defaultShow == "business" {
                // delete business
                let ref = Database.database().reference().child("contacts").child(userID).child("business").child(item.key)
                
                ref.removeValue()
               // self.tableView.reloadData()
            }else{
                // delete personal
                let ref = Database.database().reference().child("contacts").child(userID).child("personal").child(item.key)
                
                ref.removeValue()
               // self.tableView.reloadData()
                
            }
        }
        
        cell.blockButtonClosure = {() in
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "BlockViewController") as! BlockViewController
            vc.blockContact = item
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
        cell.callButtonClosure = {() in
            callerNumber = item.phoneNo
            callerName = item.name
            dailerCheck = true
            if let url = URL(string: "tel://\(item.phoneNo)"),
                UIApplication.shared.canOpenURL(url) {
                if #available(iOS 10, *) {
                    UIApplication.shared.open(url, options: [:], completionHandler:nil)
                } else {
                    UIApplication.shared.openURL(url)
                }
            } else {
                // add error message here
            }
        }
        
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if self.clickArray[indexPath.row] == 1 {
            return 110
        }else{
            return 70
        }
    }
}

extension ContactsViewController:UIViewControllerTransitioningDelegate{
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.isPresenting = true
        return transition
    }
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.isPresenting = false
        return transition
    }
}

extension UIColor {
    static func random() -> UIColor {
        return UIColor(red: .random(in: 0...1),
                       green: .random(in: 0...1),
                       blue: .random(in: 0...1),
                       alpha: 1.0)
    }
}
