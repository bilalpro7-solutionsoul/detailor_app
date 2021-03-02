//
//  HistoryViewController.swift
//  DailerApp
//
//  Created by Muhammad Bilal on 25/02/2020.
//  Copyright © 2020 Solution Soul. All rights reserved.
//

import UIKit
import Firebase
import SVProgressHUD

class HistoryViewController: UIViewController {

    @IBOutlet weak var chatWhiteLabel: UILabel!
    @IBOutlet weak var callWhitelabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    let transition = SlideInTransition()
    
    var clickArray = [0,0,0,0,0,0,0,0,0,0]
    
    var callLogDataArray = [CallLogStruct]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getCallLogs()
        
        self.chatWhiteLabel.isHidden = false
        self.callWhitelabel.isHidden = true
        
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
    
    @IBAction func chatButtonAction(_ sender: Any) {
        self.chatWhiteLabel.isHidden = false
        self.callWhitelabel.isHidden = true
        self.tableView.isHidden = true
    }
    @IBAction func callButtonAction(_ sender: Any) {
        self.chatWhiteLabel.isHidden = true
        self.callWhitelabel.isHidden = false
        self.tableView.isHidden = false
    }
    func getCallLogs(){
        
        self.callLogDataArray.removeAll()
        
        var userID = ""
        if let userid = defaults.string(forKey: userData.id) {
            print(userid) // Another String Value
            userID = userid
        }
        SVProgressHUD.show(withStatus: "Loading")
        let ref = Database.database().reference().child("callsLog").child("\(userID)")
        ref.observe(DataEventType.value) { (snapshot) in
            if snapshot.childrenCount>0{
                self.callLogDataArray.removeAll()
                for data in snapshot.children.allObjects as! [DataSnapshot]{
                    let obj = data.value as? [String: Any]
                    
                    let id = obj?["id"] as! String
                    let name = obj?["name"] as! String
                    let phoneNumber = obj?["phoneNumber"] as! String
                    let callType = obj?["callType"] as! String
                    let callStartTime = obj?["callStartTime"] as! String
                    let callEndTime = obj?["callEndTime"] as! String
                    
                    let callLogObj = CallLogStruct(id: id, name: name, phoneNumber: phoneNumber, callType: callType, callStartTime: callStartTime, callEndTime: callEndTime)
                    
                    self.callLogDataArray.append(callLogObj)
                    
                }
                self.clickArray.removeAll()
                for _ in self.callLogDataArray{
                    self.clickArray.append(0)
                }
                
                self.callLogDataArray.sort(by: { (message1, message2) -> Bool in

                    (message1.callStartTime) > (message2.callStartTime)

                })
                
                SVProgressHUD.dismiss()
                self.tableView.reloadData()
                
            }else{
                SVProgressHUD.dismiss()
                print("Call logs not found")
            }
        }
        
    }
}

extension HistoryViewController : UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.callLogDataArray.count
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "HistoryCallTableViewCell") as! HistoryCallTableViewCell
        
        let item = self.callLogDataArray[indexPath.row]
        
        cell.wordLabel.text = item.name.first?.uppercased()
        cell.wordViewContainer.backgroundColor = UIColor.random()
        cell.nameLabel.text = item.name
        cell.numberLabel.text = item.phoneNumber
        if item.callType == "incoming" {
            cell.callTypeLabel.text = "INCOMING"
        }else{
            cell.callTypeLabel.text = "OUTGOING"
        }
        
        let timeInterval  = Double(item.callStartTime)//1415639000.67457
        print("time interval is \(timeInterval)")
        
        //Convert to Date
        let date = NSDate(timeIntervalSince1970: timeInterval ?? 0.0)
        
        //Date formatting
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM dd,yyyy hh:mm:a"
        dateFormatter.timeZone = NSTimeZone.local //dateFormatter.timeZone = NSTimeZone(name: "UTC") as TimeZone?
        let dateString = dateFormatter.string(from: date as Date)
        print("formatted date is =  \(dateString)")
        cell.timeLabel.text = "\(dateString)"
        
        if self.clickArray[indexPath.row] == 1 {
            cell.buttonsStackContainer.isHidden = false
        }else{
            cell.buttonsStackContainer.isHidden = true
        }
        
        cell.infoButtonClosure = {() in
            print("info pressed")
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "SearchDetailViewController") as! SearchDetailViewController
            //vc.contactsUser = item
            //if self.defaultShow == "business" {
            //    vc.contactType = "business"
            //}else{
                vc.contactType = "personal"
            //}
            vc.previousViewCheck = "contact"
            //vc.businessUserID = item.id
            
            SVProgressHUD.show(withStatus: "Loading...")
            let ref = Database.database().reference().child("listing").child("business").queryOrdered(byChild: "details/phoneNo").queryEqual(toValue: item.phoneNumber)
            ref.observe(DataEventType.value) { (snapshot) in
                if snapshot.childrenCount>0{
                    
                    for data in snapshot.children.allObjects as! [DataSnapshot]{
                        //let obj = data.value as? [String: Any]
                        
                        let key = data.key
                        let id = key
                        
                        print(id)
                        
                        vc.businessUserID = id
                        break
                    }
                    
                    //let data = snapshot.value as? [String : Any]//.children.allObjects as! DataSnapshot
                    //let obj = data//.value as? [String: Any]
                    
                    //print(obj?["id"] as! String)
                    
                    //let id = obj?["id"] as! String
                    
                    
                    SVProgressHUD.dismiss()
                    self.navigationController?.pushViewController(vc, animated: true)
                }else{
                    print("result not found")
                    SVProgressHUD.dismiss()
                    let alert = UIAlertController(title: "OOPS!", message: "Results not found", preferredStyle: .actionSheet)
                    let action = UIAlertAction(title: "OK", style: .default, handler: nil)
                    alert.addAction(action)
                    self.present(alert,animated: true,completion: nil)
                    
                }
            }
            
            //self.navigationController?.pushViewController(vc, animated: true)
        }
        
        cell.saveButtonClosure = {() in
            print("save pressed")
            // Personal profile
            var userExist = false
            var userID = ""
            if let userid = defaults.string(forKey: userData.id) {
                print(userid) // Another String Value
                userID = userid
            }
            SVProgressHUD.show(withStatus: "Loading")
            let ref = Database.database().reference().child("contacts").child("\(userID)").child("personal")
            ref.observe(DataEventType.value) { (snapshot) in
                if snapshot.childrenCount>0{
                    
                    for data in snapshot.children.allObjects as! [DataSnapshot]{
                        let obj = data.value as? [String: Any]
                        
                        let phoneNo = obj?["phoneNo"] as! String
                        
                        if phoneNo == item.phoneNumber {
                            userExist = true
                            break
                        }
                        
                    }
                    
                    if userExist {
                        // user exist
                        let alert = UIAlertController(title: "Already Exist!", message: "User Already exist in your contact!", preferredStyle: .actionSheet)
                        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
                        alert.addAction(action)
                        self.present(alert,animated: true,completion: nil)
                        
                    }else{
                        // user not exist
                        
                        let refg = Database.database().reference().child("contacts").child("\(userID)").child("personal")
                        let key = refg.childByAutoId().key
                        let data = ["actionsVisible":"false","inDatabase":"true","key":"\(key!)","name":"\(item.name)","phoneNo":"\(item.phoneNumber)","userId":"\(userID)"] as [String : Any]
                        refg.child(key!).setValue(data)
                        
                        let alert = UIAlertController(title: "Successfully!", message: "Successfully Added In Personal Contact!", preferredStyle: .actionSheet)
                        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
                        alert.addAction(action)
                        self.present(alert,animated: true,completion: nil)
                        
                    }
                    
                    SVProgressHUD.dismiss()
                    //self.tableView.reloadData()
                    
                }else{
                    SVProgressHUD.dismiss()
                    print("personal contact not found")
                    let refg = Database.database().reference().child("contacts").child("\(userID)").child("personal")
                    let key = refg.childByAutoId().key
                    let data = ["actionsVisible":"false","inDatabase":"true","key":"\(key!)","name":"\(item.name)","phoneNo":"\(item.phoneNumber)","userId":"\(userID)"] as [String : Any]
                    refg.child(key!).setValue(data)
                    
                    let alert = UIAlertController(title: "Successfully!", message: "Successfully Added In Personal Contact!", preferredStyle: .actionSheet)
                    let action = UIAlertAction(title: "OK", style: .default, handler: nil)
                    alert.addAction(action)
                    self.present(alert,animated: true,completion: nil)
                }
            }
        }
        
        cell.blockButtonClosure = {() in
            print("blocked pressed")
            
            var userID = ""
            if let userid = defaults.string(forKey: userData.id) {
                print(userid) // Another String Value
                userID = userid
            }
            
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "BlockViewController") as! BlockViewController
            vc.blockContact.actionsVisible = "false"
            vc.blockContact.inDatabase = "false"
            vc.blockContact.key = "\(item.id)"
            vc.blockContact.name = "\(item.name)"
            vc.blockContact.phoneNo = "\(item.phoneNumber)"
            vc.blockContact.userId = "\(userID)"
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
        cell.callButtonClosure = {() in
            print("call pressed")
            print("Demo Number: 3328890878")
            
            callerNumber = item.phoneNumber
            callerName = item.name
            dailerCheck = true
            
            if let url = URL(string: "tel://\(item.phoneNumber)"),
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
            return 130
        }else{
            return 80
        }
    }
}

extension HistoryViewController:UIViewControllerTransitioningDelegate{
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.isPresenting = true
        return transition
    }
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.isPresenting = false
        return transition
    }
}
