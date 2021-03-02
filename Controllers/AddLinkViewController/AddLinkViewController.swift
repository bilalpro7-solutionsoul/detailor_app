//
//  AddLinkViewController.swift
//  DailerApp
//
//  Created by Muhammad Bilal on 26/02/2020.
//  Copyright © 2020 Solution Soul. All rights reserved.
//

import UIKit
import Firebase
import Kingfisher
import SVProgressHUD

class AddLinkViewController: UIViewController {
    
    @IBOutlet weak var linkTF: UITextField!
    @IBOutlet weak var linkNameTF: UITextField!
    @IBOutlet weak var privateSwitch: UISwitch!
    @IBOutlet weak var linkImage: UIImageView!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var nameTF: UITextField!
    @IBOutlet weak var numberTF: UITextField!
    @IBOutlet weak var wordNumberTF: UITextField!
    @IBOutlet weak var addLinkPopUpViewContainer: UIView!
    @IBOutlet weak var addressTF: UITextField!
    @IBOutlet weak var tableView: UITableView!
    
    var imagePicker = UIImagePickerController()
    
    var linksArray = [PersonalLinksStructure]()
    
    var editedLink = PersonalLinksStructure(key: "", link: "", name: "", privates: "false")
    var editTrue = false
    
    override func viewWillAppear(_ animated: Bool) {
        fetchUserData()
        fetchUserLinks()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imagePicker.delegate = self
        
        self.profileImage.layer.cornerRadius = 8
        
        self.linkTF.addTarget(self, action: #selector(linkEditFunc), for: .editingChanged)
        
    }
    
    @IBAction func uploadImage(_ sender: Any) {
        imagePicker.sourceType = .photoLibrary
        imagePicker.allowsEditing = true
        present(imagePicker,animated: true,completion: nil)
    }
    
    
    @IBAction func topRightNavigationButtonAction(_ sender: Any) {
        var userID = ""
        if let userid = defaults.string(forKey: userData.id) {
            print(userid) // Another String Value
            userID = userid
        }
        var myName = ""
        var myPhone = ""
        var myWordNumber = ""
        var myAddress = ""
        
        if let name = defaults.string(forKey: userData.name) {
            print(name) // Another String Value
            myName = name
        }
        
        if let number = defaults.string(forKey: userData.phoneNo) {
            print(number) // Another String Value
            myPhone = number
        }
        
        if let address = defaults.string(forKey: userData.address) {
            print(address) // Another String Value
            myAddress = address
        }
        
        if myName != self.nameTF.text! || myPhone != self.numberTF.text! || myAddress != self.addressTF.text {
            print("user profile updated !")
            let ref = Database.database().reference().child("users").child(userID)
            ref.updateChildValues(["name":"\(self.nameTF.text!)","phoneNo":"\(self.numberTF.text!)","address":"\(self.addressTF.text!)"])
           // let stringWordNum = wordNumberTF.text ?? ""
            var personalKey = ""
            if let personalProfileKey = defaults.string(forKey: userData.personalProfileKey) {
                print(personalProfileKey) // Another String Value
                personalKey = personalProfileKey
               
            }
              let refp = Database.database().reference().child("profiles").child("\(personalKey)")
                    refp.updateChildValues(["phoneNo":"\(self.numberTF.text!)","type":"personal","userId":"\(userID)"])
            
            self.navigationController?.popViewController(animated: true)
        }else{
            print("nothing updated !")
        }
        
    }
    
    @objc func linkEditFunc(){
        if self.linkTF.text!.contains("facebook") {
            print("facebook link")
            self.linkImage.image = #imageLiteral(resourceName: "facebook (4)")
        }else if self.linkTF.text!.contains("instagram") {
            print("instagram link")
            self.linkImage.image = #imageLiteral(resourceName: "instagram")
        }else if self.linkTF.text!.contains("linkedin") {
            print("linkedin link")
            self.linkImage.image = #imageLiteral(resourceName: "linkedin")
        }else if self.linkTF.text!.contains("pinterest") {
            print("pinterest link")
            self.linkImage.image = #imageLiteral(resourceName: "pinterest")
        }else if self.linkTF.text!.contains("skype") {
            print("skype link")
            self.linkImage.image = #imageLiteral(resourceName: "skype")
        }else if self.linkTF.text!.contains("snapchat") {
            print("snapchat link")
            self.linkImage.image = #imageLiteral(resourceName: "snapchat")
        }else if self.linkTF.text!.contains("twitter") {
            print("twitter link")
            self.linkImage.image = #imageLiteral(resourceName: "twitter")
        }else if self.linkTF.text!.contains("viber") {
            print("viber link")
            self.linkImage.image = #imageLiteral(resourceName: "viber")
        }else if self.linkTF.text!.contains("whatsapp") {
            print("whatsapp link")
            self.linkImage.image = #imageLiteral(resourceName: "whatsapp")
        }else if self.linkTF.text!.contains("yahoo") {
            print("yahoo link")
            self.linkImage.image = #imageLiteral(resourceName: "yahoo")
        }else if self.linkTF.text!.contains("youtube") {
            print("youtube link")
            self.linkImage.image = #imageLiteral(resourceName: "youtube")
        }else{
            print("chrome link")
            self.linkImage.image = #imageLiteral(resourceName: "chrome")
        }
    }
    
    @IBAction func popUpCrossButtonAction(_ sender: Any) {
        self.addLinkPopUpViewContainer.isHidden = true
    }
    
    @IBAction func popUpAddLinkButtonAction(_ sender: Any) {
        var userID = ""
        if let userid = defaults.string(forKey: userData.id) {
            print(userid) // Another String Value
            userID = userid
        }
        if self.editTrue {
            // edited old link
            let ref = Database.database().reference().child("listing").child("personal").child(userID).child("links")
            let privateStringValue: String = "\(self.privateSwitch.isOn)"
            let data = ["key":"\(self.editedLink.key)","link":"\(self.linkTF.text!)","name":"\(self.linkNameTF.text!)","private":privateStringValue] as [String : Any]
            ref.child(self.editedLink.key).setValue(data)
            self.addLinkPopUpViewContainer.isHidden = true
        }else{
            // add new link
             let privateStringValue: String = "\(self.privateSwitch.isOn)"
            let ref = Database.database().reference().child("listing").child("personal").child(userID).child("links")
            let key = ref.childByAutoId().key!
            let data = ["key":"\(key)","link":"\(self.linkTF.text!)","name":"\(self.linkNameTF.text!)","private":privateStringValue] as [String : Any]
            ref.child(key).setValue(data)
            self.addLinkPopUpViewContainer.isHidden = true
        }
        
        //self.addLinkPopUpViewContainer.isHidden = true
    }
    
    @IBAction func backBarButtonAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
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
                
                self.profileImage.kf.setImage(with: URL(string: imageUrl),placeholder: UIImage(named: "demoImage"))
                self.nameTF.text = name
                self.numberTF.text = phoneNo
                self.addressTF.text = address
                
                if Bool(hasPersonalWordNum)! {
                    self.wordNumberTF.isUserInteractionEnabled = false
                    let ref = Database.database().reference().child("profiles").child(personalProfileKey)
                    ref.observe(DataEventType.value) { (snapshot) in
                        if snapshot.childrenCount>0{
                            
                            let data = snapshot.value as? [String : Any]//.children.allObjects as! DataSnapshot
                            let obj = data//.value as? [String: Any]
                            
                            //                    let phoneNo = obj?["phoneNo"] as! String
                            //                    let type = obj?["type"] as! String
                            //                    let userId = obj?["userId"] as! String
                            let wordNum = obj?["wordNum"] as! String
                            
                            self.wordNumberTF.text = wordNum
                            
                        }
                    }
                }else{
                    self.wordNumberTF.isUserInteractionEnabled = false
                    self.wordNumberTF.text = "Word No: Not Purchased Yet"
                }
                
                
                
                SVProgressHUD.dismiss()
                
            }else{
                SVProgressHUD.dismiss()
                print("getting some error for getting user info for setting desing")
            }
            
        }
    }
    
    func fetchUserLinks(){
        SVProgressHUD.show(withStatus: "Loading...")
        var userID = ""
        if let userid = defaults.string(forKey: userData.id) {
            print(userid) // Another String Value
            userID = userid
        }
        
        let ref = Database.database().reference().child("listing").child("personal").child(userID).child("links")
        ref.observe(DataEventType.value) { (snapshot) in
            if snapshot.childrenCount>0{
                self.linksArray.removeAll()
                for data in snapshot.children.allObjects as! [DataSnapshot]{
                    let obj = data.value as? [String: Any]
                    
                    let key = obj?["key"] as! String
                    let link = obj?["link"] as! String
                    let name = obj?["name"] as! String
                    let privates = obj?["private"] as! String
                    
                    let objLink = PersonalLinksStructure(key: key, link: link, name: name, privates: privates)
                    
                    self.linksArray.append(objLink)
                    self.tableView.reloadData()
                    SVProgressHUD.dismiss()
                }
                
            }else{
                SVProgressHUD.dismiss()
                print("business contact not found")
            }
            
        }
    }
    func resizeImageWithAspect(image: UIImage,scaledToMaxWidth width:CGFloat,maxHeight height :CGFloat)->UIImage? {
        let oldWidth = image.size.width;
        let oldHeight = image.size.height;
        
        let scaleFactor = (oldWidth > oldHeight) ? width / oldWidth : height / oldHeight;
        
        let newHeight = oldHeight * scaleFactor;
        let newWidth = oldWidth * scaleFactor;
        let newSize = CGSize(width: newWidth, height: newHeight)
        
        UIGraphicsBeginImageContextWithOptions(newSize,false,UIScreen.main.scale);
        
        image.draw(in: CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height));
        let newImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        return newImage
    }
}

extension AddLinkViewController: UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.linksArray.count+1
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row < self.linksArray.count {
            let cell = tableView.dequeueReusableCell(withIdentifier: "AddLinkTableViewCell") as! AddLinkTableViewCell
            let item = self.linksArray[indexPath.row]
            
            cell.linkName.text = item.name
            
            if item.link.contains("facebook") {
                print("facebook link")
                cell.linkImage.image = #imageLiteral(resourceName: "facebook (4)")
            }else if item.link.contains("instagram") {
                print("instagram link")
                cell.linkImage.image = #imageLiteral(resourceName: "instagram")
            }else if item.link.contains("linkedin") {
                print("linkedin link")
                cell.linkImage.image = #imageLiteral(resourceName: "linkedin")
            }else if item.link.contains("pinterest") {
                print("pinterest link")
                cell.linkImage.image = #imageLiteral(resourceName: "pinterest")
            }else if item.link.contains("skype") {
                print("skype link")
                cell.linkImage.image = #imageLiteral(resourceName: "skype")
            }else if item.link.contains("snapchat") {
                print("snapchat link")
                cell.linkImage.image = #imageLiteral(resourceName: "snapchat")
            }else if item.link.contains("twitter") {
                print("twitter link")
                cell.linkImage.image = #imageLiteral(resourceName: "twitter")
            }else if item.link.contains("viber") {
                print("viber link")
                cell.linkImage.image = #imageLiteral(resourceName: "viber")
            }else if item.link.contains("whatsapp") {
                print("whatsapp link")
                cell.linkImage.image = #imageLiteral(resourceName: "whatsapp")
            }else if item.link.contains("yahoo") {
                print("yahoo link")
                cell.linkImage.image = #imageLiteral(resourceName: "yahoo")
            }else if item.link.contains("youtube") {
                print("youtube link")
                cell.linkImage.image = #imageLiteral(resourceName: "youtube")
            }else{
                print("chrome link")
                cell.linkImage.image = #imageLiteral(resourceName: "chrome")
            }
            
            cell.editButtonClosure = {() in
                self.editedLink = item
                self.editTrue = true
                self.linkNameTF.text = item.name
                self.linkTF.text = item.link
                let itemPrivateBool:Bool = Bool(item.privates) ?? false
                if itemPrivateBool {
                    self.privateSwitch.isOn = true
                }else{
                    self.privateSwitch.isOn = false
                }
                
                if item.link.contains("facebook") {
                    print("facebook link")
                    self.linkImage.image = #imageLiteral(resourceName: "facebook (4)")
                }else if item.link.contains("instagram") {
                    print("instagram link")
                    self.linkImage.image = #imageLiteral(resourceName: "instagram")
                }else if item.link.contains("linkedin") {
                    print("linkedin link")
                    self.linkImage.image = #imageLiteral(resourceName: "linkedin")
                }else if item.link.contains("pinterest") {
                    print("pinterest link")
                    self.linkImage.image = #imageLiteral(resourceName: "pinterest")
                }else if item.link.contains("skype") {
                    print("skype link")
                    self.linkImage.image = #imageLiteral(resourceName: "skype")
                }else if item.link.contains("snapchat") {
                    print("snapchat link")
                    self.linkImage.image = #imageLiteral(resourceName: "snapchat")
                }else if item.link.contains("twitter") {
                    print("twitter link")
                    self.linkImage.image = #imageLiteral(resourceName: "twitter")
                }else if item.link.contains("viber") {
                    print("viber link")
                    self.linkImage.image = #imageLiteral(resourceName: "viber")
                }else if item.link.contains("whatsapp") {
                    print("whatsapp link")
                    self.linkImage.image = #imageLiteral(resourceName: "whatsapp")
                }else if item.link.contains("yahoo") {
                    print("yahoo link")
                    self.linkImage.image = #imageLiteral(resourceName: "yahoo")
                }else if item.link.contains("youtube") {
                    print("youtube link")
                    self.linkImage.image = #imageLiteral(resourceName: "youtube")
                }else{
                    print("chrome link")
                    self.linkImage.image = #imageLiteral(resourceName: "chrome")
                }
                self.addLinkPopUpViewContainer.isHidden = false
            }
            
            cell.deleteButtonClosure = {() in
                var userID = ""
                if let userid = defaults.string(forKey: userData.id) {
                    print(userid) // Another String Value
                    userID = userid
                }
                print(item.key)
                let ref = Database.database().reference().child("listing").child("personal").child(userID).child("links").child(item.key)
                ref.removeValue()
                self.linksArray.remove(at: indexPath.row)
                self.tableView.reloadData()
            }
           
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "AddLinkButtonTableViewCell") as! AddLinkButtonTableViewCell
            cell.addButtonClosure = {() in
                self.editTrue = false
                self.linkNameTF.text = ""
                self.linkTF.text = ""
                self.addLinkPopUpViewContainer.isHidden = false
            }
            return cell
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row != 3 {
            return 85
        }else{
            return 70
        }
    }
}

extension AddLinkViewController:UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage{
            
            self.profileImage.image = image
            let imgsd = resizeImageWithAspect(image: image, scaledToMaxWidth: 300, maxHeight: 300)
            //self.profileImage.image = imgsd
            
            SVProgressHUD.show(withStatus: "Updating")
            let img = imgsd
            var fileData = Data()
            fileData = (img!.pngData())!
            let ky = Database.database().reference().childByAutoId().key
            let storageRef = Storage.storage().reference().child("images/\(ky!)")//storage.reference().child("images")
            let metadata = StorageMetadata()
            metadata.contentType = "image/jpeg"
            storageRef.putData(fileData, metadata: metadata) { (metadata, error) in
                if error == nil {
                    print("Successfully uploaded")
                    var dwnUrl = ""
                    storageRef.downloadURL(completion: { (url, err) in
                        dwnUrl = "\(url!)"
                        print(url!)
                        
                        // Add Value to firebase
                        var userID = ""
                        if let userid = defaults.string(forKey: userData.id) {
                            print(userid) // Another String Value
                            userID = userid
                        }
                        let ref = Database.database().reference().child("users").child(userID)
                        ref.updateChildValues(["imageUrl":"\(dwnUrl)"])
                        
                    })
                    
                    print(dwnUrl)
                    
                    
                    
                }else{
                    let alert = UIAlertController(title: "Warning", message: "Error While Upload Information", preferredStyle: .alert)
                    let action = UIAlertAction(title: "OK", style: .default, handler: nil)
                    alert.addAction(action)
                    self.present(alert,animated: true,completion: nil)
                }
                
            }
            
            dismiss(animated: true, completion: nil)
            
        }
    }
}
