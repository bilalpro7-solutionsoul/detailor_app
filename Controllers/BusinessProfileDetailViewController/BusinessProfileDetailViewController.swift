//
//  BusinessProfileDetailViewController.swift
//  DailerApp
//
//  Created by Muhammad Bilal on 27/02/2020.
//  Copyright © 2020 Solution Soul. All rights reserved.
//

import UIKit
import Firebase
import SVProgressHUD

class BusinessProfileDetailViewController: UIViewController {
    // On android and iOS apps please add keyboard like it was a while back.(iphone defualt keyboard)
    let transition = SlideInTransition()
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var numberLabel: UILabel!
    @IBOutlet weak var wordNumberLabel: UILabel!
    @IBOutlet weak var sloganLabel: UILabel!
    @IBOutlet weak var collectionViewContainer: UIView!
    @IBOutlet weak var createYourOwnLabel: UILabel!
    @IBOutlet weak var startButtonViewContainer: CustomView!
    
    // Tab Bar Menu Image
    @IBOutlet weak var tab1Image: UIImageView!
    @IBOutlet weak var tab2Image: UIImageView!
    @IBOutlet weak var tab3Image: UIImageView!
    @IBOutlet weak var tab4Image: UIImageView!
    @IBOutlet weak var tab5Image: UIImageView!
    
    var linksArr = [LinksStructure]()
    
    var businessPhoneNo = ""
    var businessDescription = ""
    var userBusinessProfileName = ""
    var businessName = ""
    
    override func viewWillAppear(_ animated: Bool) {
        setupProfile()
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //self.navigationItem.title = "Dug"
        
        self.profileImage.layer.cornerRadius = 8
        
        self.getUserBusinessData()
        
        self.tab1Image.image = self.tab1Image.image?.withRenderingMode(.alwaysTemplate)
        self.tab1Image.tintColor = #colorLiteral(red: 0.3333333433, green: 0.3333333433, blue: 0.3333333433, alpha: 1)
        self.tab2Image.image = self.tab2Image.image?.withRenderingMode(.alwaysTemplate)
        self.tab2Image.tintColor = #colorLiteral(red: 0.3333333433, green: 0.3333333433, blue: 0.3333333433, alpha: 1)
        self.tab3Image.image = self.tab3Image.image?.withRenderingMode(.alwaysTemplate)
        self.tab3Image.tintColor = #colorLiteral(red: 0.1538252234, green: 0.2240419388, blue: 0.3633548617, alpha: 1)
        self.tab4Image.image = self.tab4Image.image?.withRenderingMode(.alwaysTemplate)
        self.tab4Image.tintColor = #colorLiteral(red: 0.3333333433, green: 0.3333333433, blue: 0.3333333433, alpha: 1)
        self.tab5Image.image = self.tab5Image.image?.withRenderingMode(.alwaysTemplate)
        self.tab5Image.tintColor = #colorLiteral(red: 0.3333333433, green: 0.3333333433, blue: 0.3333333433, alpha: 1)
        
        let menuUIBarButtonItem = UIBarButtonItem(image: UIImage(named: "menuWhite.png"), style: .plain, target: self, action: #selector(FreeVanityNumber1ViewController.clickButton))
        menuUIBarButtonItem.tintColor = UIColor.white
        self.navigationItem.leftBarButtonItem  = menuUIBarButtonItem
        
        transition.dimmingView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismisFunc)))
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(self.handleGesture(gesture:)))
        swipeLeft.direction = .left
        self.transition.dimmingView.addGestureRecognizer(swipeLeft)
    }
    
    func setupProfile() {
        
        if let wordNumberKey = defaults.string(forKey: userData.businessProfileKey) {
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

        
        
        
        if let hasPersonalWordNum = defaults.string(forKey: userData.hasBusinessWordNum) {
            print(hasPersonalWordNum) // Another String Value
            if hasPersonalWordNum == "true" {
                self.collectionViewContainer.isHidden = true
                // self.freeVanityNumberViewContainer.isHidden = false
                self.wordNumberLabel.text = ""
            }else{
                self.collectionViewContainer.isHidden = false
                self.wordNumberLabel.isHidden = false
            }
        }

    }
    
    
    
    
    
    @IBAction func tab1ButtonAction(_ sender: Any) {
        let mainStoryBoard = UIStoryboard(name: "Main", bundle: nil)
        let redViewController = mainStoryBoard.instantiateViewController(withIdentifier: "TabBarViewController") as! TabBarViewController
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.window?.rootViewController = redViewController
    }
    @IBAction func tab2ButtonAction(_ sender: Any) {
        let mainStoryBoard = UIStoryboard(name: "Main", bundle: nil)
        let redViewController = mainStoryBoard.instantiateViewController(withIdentifier: "TabBarViewController") as! TabBarViewController
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.window?.rootViewController = redViewController
    }
    @IBAction func tab3ButtonAction(_ sender: Any) {
        let mainStoryBoard = UIStoryboard(name: "Main", bundle: nil)
        let redViewController = mainStoryBoard.instantiateViewController(withIdentifier: "TabBarViewController") as! TabBarViewController
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.window?.rootViewController = redViewController
    }
    @IBAction func tab4ButtonAction(_ sender: Any) {
        let mainStoryBoard = UIStoryboard(name: "Main", bundle: nil)
        let redViewController = mainStoryBoard.instantiateViewController(withIdentifier: "TabBarViewController") as! TabBarViewController
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.window?.rootViewController = redViewController
    }
    @IBAction func tab5ButtonAction(_ sender: Any) {
        let mainStoryBoard = UIStoryboard(name: "Main", bundle: nil)
        let redViewController = mainStoryBoard.instantiateViewController(withIdentifier: "TabBarViewController") as! TabBarViewController
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.window?.rootViewController = redViewController
    }
    
    @IBAction func startHereButtonAction(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "BusinessEdit1ViewController") as! BusinessEdit1ViewController
        vc.businessName = businessName
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
    
    @objc func clickButton(){
        let vc = storyboard?.instantiateViewController(withIdentifier: "MenuViewController") as! MenuViewController
        vc.modalPresentationStyle = .overCurrentContext
        vc.transitioningDelegate = self
        present(vc,animated: true)
    }
    
    @IBAction func businessProfileEditButtonAction(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "CreateBusinessProfileViewController") as! CreateBusinessProfileViewController
        vc.editChk = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func getUserBusinessData(){
         
        var userID = ""
        if let userid = defaults.string(forKey: userData.id) {
            print(userid) // Another String Value
            userID = userid
        }
        SVProgressHUD.show(withStatus: "Loading")
        let ref = Database.database().reference().child("listing").child("business").child(userID).child("details")
        ref.observe(DataEventType.value) { (snapshot) in
            if snapshot.childrenCount>0{
                
                let data = snapshot.value as? [String : Any]//.children.allObjects as! DataSnapshot
                let obj = data//.value as? [String: Any]
                
                let description = obj?["description"] as! String
                let logoUrl = obj?["logoUrl"] as! String
                let name = obj?["name"] as! String
                let paid = obj?["paid"] as! String
                let phoneNo = obj?["phoneNo"] as! String
                let slogan = obj?["slogan"] as! String
                
                self.profileImage.kf.setImage(with: URL(string: logoUrl),placeholder: UIImage(named: "demoImage"))
                self.navigationItem.title = name
                self.businessName = name
                self.numberLabel.text = phoneNo
                self.sloganLabel.text = slogan
                
                self.businessPhoneNo = phoneNo
                self.businessDescription = description
                self.userBusinessProfileName = name
                let paidBool:Bool = Bool(paid) ?? false
                if paidBool {
                   // self.collectionViewContainer.isHidden = true
                    self.collectionView.isHidden = false
                    self.getMyBusinessLinks()
                }else{
                   // self.collectionViewContainer.isHidden = false
                    self.collectionView.isHidden = true
                }
                
                SVProgressHUD.dismiss()
                
            }
        }
    }
    @IBAction func dailySpecialOrdersButtonAction(_ sender: Any) {
        
    }
    func getMyBusinessLinks(){
        var userID = ""
        if let userid = defaults.string(forKey: userData.id) {
            print(userid) // Another String Value
            userID = userid
        }
        SVProgressHUD.show(withStatus: "Loading")
        let ref = Database.database().reference().child("listing").child("business").child("\(userID)").child("links")
        ref.observe(DataEventType.value) { (snapshot) in
            if snapshot.childrenCount>0{
                self.linksArr.removeAll()
                for data in snapshot.children.allObjects as! [DataSnapshot]{
                    let obj = data.value as? [String: Any]
                    
                    let key = obj?["key"] as? String
                    let link = obj?["link"] as! String
                    let name = obj?["name"] as? String
                    
                    let keyObj = LinksStructure(key: key ?? "", link: link, name: name ?? "")
                    
                    self.linksArr.append(keyObj)
                }
                SVProgressHUD.dismiss()
                self.collectionView.reloadData()
            }else{
                SVProgressHUD.dismiss()
                print("business contact not found")
            }
        }
    }
    
}

extension BusinessProfileDetailViewController:UICollectionViewDelegate,UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.linksArr.count+2
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.row < self.linksArr.count {
            let item = self.linksArr[indexPath.row]
            
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
            
        }else{
            if indexPath.row == self.linksArr.count {
                // info functionality
                
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "BusinessInfoViewController") as! BusinessInfoViewController
                
                var userID = ""
                if let userid = defaults.string(forKey: userData.id) {
                    print(userid) // Another String Value
                    userID = userid
                }
                
                vc.businessPhone = self.businessPhoneNo
                vc.businessDescription = "\(self.businessDescription)"
                vc.businessUserID = userID
                vc.businessName = self.userBusinessProfileName
                
                self.navigationController?.pushViewController(vc, animated: true)
                
            }else if indexPath.row == self.linksArr.count+1 {
                // Share functionality
                var businessProfileKey = ""
                if let businessId = defaults.string(forKey: userData.businessProfileKey) {
                           print(businessId) // Another String Value
                           businessProfileKey = businessId
                       }
                
                
                let activityVC = UIActivityViewController(activityItems: ["http://dailer.coritel.co/welcome/dailer_bussines_info/\(businessProfileKey)"], applicationActivities: nil)
                activityVC.popoverPresentationController?.sourceView = self.view
                self.present(activityVC,animated: true,completion: nil)
            }
        }
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MyBusinessProfileLinksCollectionViewCell", for: indexPath) as! MyBusinessProfileLinksCollectionViewCell
        
        if indexPath.row < self.linksArr.count {
            let item = self.linksArr[indexPath.row]
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
            cell.linkName.text = item.name
        }else{
            if indexPath.row == self.linksArr.count {
                cell.linkImage.image = #imageLiteral(resourceName: "ic_info")
                cell.linkName.text = "info"
            }else if indexPath.row == self.linksArr.count+1 {
                cell.linkImage.image = #imageLiteral(resourceName: "share")
                cell.linkName.text = "Share"
            }
        }
        return cell
    }
}

extension BusinessProfileDetailViewController:UIViewControllerTransitioningDelegate{
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.isPresenting = true
        return transition
    }
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.isPresenting = false
        return transition
    }
}
