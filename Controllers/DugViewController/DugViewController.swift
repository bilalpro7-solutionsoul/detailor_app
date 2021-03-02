//
//  DugViewController.swift
//  DailerApp
//
//  Created by Muhammad Bilal on 25/02/2020.
//  Copyright © 2020 Solution Soul. All rights reserved.
//

import UIKit
import Firebase
import SVProgressHUD

class DugViewController: UIViewController {

    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var numberLabel: UILabel!
    @IBOutlet weak var wordNumberLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    
    @IBOutlet weak var freeVanityNumberViewContainer: CustomView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var linksArray = [PersonalLinksStructure]()
    let transition = SlideInTransition()
    var userID = ""
    
    override func viewWillAppear(_ animated: Bool) {
        fetchUserData()
        fetchUserLinks()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let id = defaults.string(forKey: userData.id) {
            print(id) // Another String Value
            self.userID = id
            //self.navigationItem.title = name
        }
        transition.dimmingView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismisFunc)))
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(self.handleGesture(gesture:)))
        swipeLeft.direction = .left
        self.transition.dimmingView.addGestureRecognizer(swipeLeft)
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func freeVanityButtonAction(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "FreeVanityNumber1ViewController") as! FreeVanityNumber1ViewController
        self.navigationController?.pushViewController(vc, animated: true)
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
    func setProfileData(){
        if let name = defaults.string(forKey: userData.name) {
            print(name) // Another String Value
            self.navigationItem.title = name
        }
        if let address = defaults.string(forKey: userData.address) {
            print(address) // Another String Value
            self.addressLabel.text = address
        }
        if let number = defaults.string(forKey: userData.phoneNo) {
            print(number) // Another String Value
            self.numberLabel.text = number
        }
        if let wordNumberKey = defaults.string(forKey: userData.personalProfileKey) {
            print(wordNumberKey) // Another String Value
            let ref = Database.database().reference().child("profiles").child(wordNumberKey)
            ref.observe(DataEventType.value) { (snapshot) in
                if snapshot.childrenCount>0{
                    
                    let data = snapshot.value as? [String : Any]//.children.allObjects as! DataSnapshot
                    let obj = data//.value as? [String: Any]
                    
                    //let phoneNo = obj?["phoneNo"] as! String
                    //let type = obj?["type"] as! String
                    //let userId = obj?["userId"] as! String
                    let wordNum = obj?["wordNum"] as! String
                    print(wordNum)
                    self.wordNumberLabel.text = wordNum
                    
                }
            }
            
        }
        if let image = defaults.string(forKey: userData.imageUrl) {
            print(image) // Another String Value
            
            if image == "" {
                self.questionLabel.isHidden = false
            }else{
                self.questionLabel.isHidden = true
                self.profileImage.kf.setImage(with: URL(string: image),placeholder: UIImage(named: "demoImage"))
            }
            
        }
        
        if let hasPersonalWordNum = defaults.string(forKey: userData.hasPersonalWordNum) {
            print(hasPersonalWordNum) // Another String Value
            if hasPersonalWordNum == "true" {
                self.freeVanityNumberViewContainer.isHidden = false
                // self.freeVanityNumberViewContainer.isHidden = false
               // self.wordNumberLabel.text = ""
            }else{
                self.freeVanityNumberViewContainer.isHidden = false
                self.wordNumberLabel.isHidden = false
            }
        }
        
        
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
                defaults.set("true", forKey: userData.userLogin)
                
                SVProgressHUD.dismiss()
                
                self.setProfileData()
                
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
                    let privates = "false"//obj?["private"] as! Bool
                    
                    let objLink = PersonalLinksStructure(key: key, link: link, name: name, privates: privates)
                    
                    self.linksArray.append(objLink)
                    self.collectionView.reloadData()
                    SVProgressHUD.dismiss()
                }
                
            }else{
                SVProgressHUD.dismiss()
                print("business contact not found")
            }
            
        }
    }
}

extension DugViewController: UICollectionViewDelegate,UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.linksArray.count+1
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(indexPath.row)
        if indexPath.row < self.linksArray.count {
            let item = self.linksArray[indexPath.row]
//            guard let url = URL(string: "\(item.link)") else {
//                return //be safe
//            }
            var urlString = "\(item.link)"
            if(urlString.hasPrefix("http://") || urlString.hasPrefix("https://")){
               
            }
            else{
                urlString = "http://"+urlString
            }
            
            if let url = URL(string: urlString), UIApplication.shared.canOpenURL(url) {
                 print(url)
               if #available(iOS 10.0, *) {
                  UIApplication.shared.open(url, options: [:], completionHandler: nil)
               } else {
                  UIApplication.shared.openURL(url)
               }
            }
            else{
                print("not valid")
            }
//            if #available(iOS 10.0, *) {
//                UIApplication.shared.open(url, options: [:], completionHandler: nil)
//            } else {
//                UIApplication.shared.openURL(url)
//            }
        }
        else{
            print(indexPath.row)
            var personalProfileKey = ""
            if let personalId = defaults.string(forKey: userData.personalProfileKey) {
                                      print(personalId) // Another String Value
                                      personalProfileKey = personalId
                                  }
           
            let activityVC = UIActivityViewController(activityItems: ["http://dailer.coritel.co/welcome/dailer_profile_info/\(personalProfileKey)/\(self.userID)"], applicationActivities: nil)
            activityVC.popoverPresentationController?.sourceView = self.view
            self.present(activityVC,animated: true,completion: nil)
        }
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DugCollectionViewCell", for: indexPath) as! DugCollectionViewCell
        
        if indexPath.row < self.linksArray.count {
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
        }else{
            cell.linkImage.image = #imageLiteral(resourceName: "share")
            cell.linkName.text = "Share"
        }
        
        
        
        return cell
        
//        if indexPath.row != 4 {
//            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DugCollectionViewCell", for: indexPath) as! DugCollectionViewCell
//
//            return cell
//        }else{
//            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DugEditCollectionViewCell", for: indexPath) as! DugEditCollectionViewCell
//
//            return cell
//        }
        
    }
}
extension DugViewController:UICollectionViewDelegateFlowLayout{
    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
//
//        return UIEdgeInsets(top: 2, left: 2, bottom: 2, right: 2)
//
//    }
    
// ======================================================================================
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//
//        if indexPath.row != 4 {
//            return CGSize(width: 100, height: 90)
//        }else{
//            return CGSize(width: 320, height: 90)
//        }
//
//        //let size = self.collectionView.frame.size
//        //return CGSize(width: size.width, height: size.height)
//    }
// ======================================================================================
    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
//        return 2.0
//    }
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
//        return 2.0
//    }
    
}
extension DugViewController: UITableViewDataSource,UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "AddLinkViewController") as! AddLinkViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DugTableViewCell") as! DugTableViewCell
        
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
}

extension DugViewController:UIViewControllerTransitioningDelegate{
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.isPresenting = true
        return transition
    }
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.isPresenting = false
        return transition
    }
}
