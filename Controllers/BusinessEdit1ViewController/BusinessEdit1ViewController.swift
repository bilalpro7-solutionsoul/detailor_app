//
//  BusinessEdit1ViewController.swift
//  DailerApp
//
//  Created by Muhammad Bilal on 27/02/2020.
//  Copyright © 2020 Solution Soul. All rights reserved.
//

import UIKit
import DropDown

class BusinessEdit1ViewController: UIViewController {
    
    let transition = SlideInTransition()
    
    var countriesDataArray = [countriesData]()
    var selectedCountryCode = ""
    var selectedCountryName = ""
    
    var dropDown: DropDown?
    
    // ----------
    
  //  @IBOutlet weak var personalButtonProperty: UIButton!
    @IBOutlet weak var topTF: UITextField!
    @IBOutlet weak var businessButtonProperty: UIButton!
    @IBOutlet weak var mobileButtonProperty: UIButton!
    @IBOutlet weak var landLineButtonProperty: UIButton!
    @IBOutlet weak var selectedCountryLabel: UILabel!
    @IBOutlet weak var areaCodeTF: UITextField!
    @IBOutlet weak var phoneTF: UITextField!
    @IBOutlet weak var wordTF: UITextField!
    @IBOutlet weak var areaCodeViewContainer: UIView!
    @IBOutlet weak var phoneViewContainer: UIView!
    @IBOutlet weak var wordViewContainer: UIView!
    
    // ----------
    
    // Tab Bar Menu Image
    @IBOutlet weak var tab1Image: UIImageView!
    @IBOutlet weak var tab2Image: UIImageView!
    @IBOutlet weak var tab3Image: UIImageView!
    @IBOutlet weak var tab4Image: UIImageView!
    @IBOutlet weak var tab5Image: UIImageView!
    
    var businessName = ""
    
    var catType = ""
    var phoneType = ""
    
    var enteredCountry = ""
    var enteredAreaCode = ""
    var enteredPhoneNo = ""
    var enteredWord = ""
     var checkcaseForNext = true
    
    override func viewWillAppear(_ animated: Bool) {
        getAllCountriesData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = businessName
        self.topTF.isEnabled = false
        
        
        if let number = defaults.string(forKey: "BusinessPhoneNumber") {
            print(number) // Another String Value
            self.phoneTF.text = number
        }
        
        if let areaCode = defaults.string(forKey: "areaCode") {
            print(areaCode) // Another String Value
            self.areaCodeTF.text = areaCode
        }
        
        
        
        
        dropDown = DropDown()
        dropDown?.anchorView = self.selectedCountryLabel
        dropDown?.dataSource =  ["Car","Audi","BMW","SUZUKI","HONDA","TOYOTA"]
        dropDown?.bottomOffset = CGPoint(x: 0, y: (dropDown?.anchorView?.plainView.bounds.height)!)
        dropDown?.selectionAction = { [unowned self] (index: Int, item: String) in
            //self.countryButtonProperty.setTitle(item, for: .normal)
            
            let itemx = self.countriesDataArray[index]
            
            print(item)
            print(itemx.countryFlag)
            
            self.selectedCountryCode = itemx.countryCode
            self.selectedCountryName = itemx.countryName
            self.selectedCountryLabel.text = "\(itemx.countryName) (+\(itemx.countryCode))"
            self.enteredCountry = "\(itemx.countryName) (+\(itemx.countryCode))"
            
        }
        
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
    
    @IBAction func personalButtonAction(_ sender: Any) {
//        self.catType = "Personal"
//        self.personalButtonProperty.setTitleColor(UIColor.white, for: .normal)
//        self.personalButtonProperty.backgroundColor = #colorLiteral(red: 0.153010577, green: 0.2240604758, blue: 0.3633597493, alpha: 1)
//        self.businessButtonProperty.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
//        self.businessButtonProperty.setTitleColor(UIColor.darkGray, for: .normal)
    }
    @IBAction func businessButtonAction(_ sender: Any) {
        self.catType = "Business"
      //  self.personalButtonProperty.setTitleColor(UIColor.darkGray, for: .normal)
      //  self.personalButtonProperty.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        self.businessButtonProperty.backgroundColor = #colorLiteral(red: 0.153010577, green: 0.2240604758, blue: 0.3633597493, alpha: 1)
        self.businessButtonProperty.setTitleColor(UIColor.white, for: .normal)
    }
    @IBAction func mobileButtonAction(_ sender: Any) {
        
        self.phoneType = "Mobile"
        
        self.mobileButtonProperty.setTitleColor(UIColor.white, for: .normal)
        self.mobileButtonProperty.backgroundColor = #colorLiteral(red: 0.153010577, green: 0.2240604758, blue: 0.3633597493, alpha: 1)
        self.landLineButtonProperty.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        self.landLineButtonProperty.setTitleColor(UIColor.darkGray, for: .normal)
        
        self.wordViewContainer.isHidden = true
        self.areaCodeTF.placeholder = "Phone number"
        self.phoneTF.placeholder = "Word"
        self.areaCodeTF.text = ""
        self.phoneTF.text = ""
        self.wordTF.text = ""
        if let number = defaults.string(forKey: "BusinessPhoneNumber") {
            print(number) // Another String Value
            self.areaCodeTF.text = number
        }
        
    }
    @IBAction func landlineButtonAction(_ sender: Any) {
        
        self.phoneType = "Landline"
        
        self.mobileButtonProperty.setTitleColor(UIColor.darkGray, for: .normal)
        self.mobileButtonProperty.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        self.landLineButtonProperty.backgroundColor = #colorLiteral(red: 0.153010577, green: 0.2240604758, blue: 0.3633597493, alpha: 1)
        self.landLineButtonProperty.setTitleColor(UIColor.white, for: .normal)
        
        self.wordViewContainer.isHidden = false
        self.areaCodeTF.placeholder = "Area Code"
        self.phoneTF.placeholder = "Phone number"
        self.wordTF.placeholder = "Word"
        if let number = defaults.string(forKey: "BusinessPhoneNumber") {
            print(number) // Another String Value
            self.phoneTF.text = number
        }
        
        if let areaCode = defaults.string(forKey: "areaCode") {
            print(areaCode) // Another String Value
            self.areaCodeTF.text = areaCode
        }
    }
    
    @IBAction func selectCountryButtonAction(_ sender: Any) {
        dropDownButton()
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
    
    @IBAction func nextButtonAction(_ sender: Any) {
        checkcaseForNext = true
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "BusinessEdit2ViewController") as! BusinessEdit2ViewController
        vc.catType = self.catType
        vc.phoneType = self.phoneType
        vc.enteredCountry = self.enteredCountry
    
        
        if self.phoneType == "Landline" {
            self.enteredWord = self.wordTF.text!
            self.enteredPhoneNo = self.phoneTF.text!
            self.enteredAreaCode = self.areaCodeTF.text!
        }else{
            
            self.enteredWord = self.phoneTF.text!
            self.enteredPhoneNo = self.areaCodeTF.text!
            self.enteredAreaCode = ""
        }
        
        if(self.selectedCountryLabel.text == "Select Country"){
            checkcaseForNext = false
            let alert = UIAlertController(title: "Alert", message: "Please select Country first!", preferredStyle: .alert)
            let action = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(action)
            self.present(alert,animated: true,completion: nil)
        }
         if (self.areaCodeTF.text == ""){
            if(phoneType == "Landline"){
                checkcaseForNext = false
            let alert = UIAlertController(title: "Alert", message: "Please enter area code first!", preferredStyle: .alert)
                       let action = UIAlertAction(title: "OK", style: .default, handler: nil)
                       alert.addAction(action)
                       self.present(alert,animated: true,completion: nil)
            }
        }
        
         if (self.phoneTF.text == ""){
            checkcaseForNext = false
            let alert = UIAlertController(title: "Alert", message: "Please enter Phone Number first!", preferredStyle: .alert)
                       let action = UIAlertAction(title: "OK", style: .default, handler: nil)
                       alert.addAction(action)
                       self.present(alert,animated: true,completion: nil)
            
        }
        if (self.phoneType == "Landline"){
         if (self.wordTF.text == ""){
            checkcaseForNext = false
            
            let alert = UIAlertController(title: "Alert", message: "Please enter name first!", preferredStyle: .alert)
                       let action = UIAlertAction(title: "OK", style: .default, handler: nil)
                       alert.addAction(action)
                       self.present(alert,animated: true,completion: nil)
            
        }
        }
        if (checkcaseForNext == true) {
            if ((self.phoneType == "Landline") && (self.catType == "Business")) {
            print(self.areaCodeTF.text!)
                print(self.phoneTF.text!)
                print(wordTF.text!)
                vc.phoneType1 = self.phoneType
                vc.catType1 = self.catType
            vc.selectedCodeString = self.areaCodeTF.text!
            vc.phoneTFString = self.phoneTF.text!
            vc.enteredWordLabelString = self.wordTF.text!
        self.navigationController?.pushViewController(vc, animated: true)
            }
            else if ((self.phoneType == "Mobile") && (self.catType == "Business")) {
               vc.phoneType1 = self.phoneType
                vc.catType1 = self.catType
                vc.phoneTFString = self.areaCodeTF.text!
                print(vc.phoneTFString)
                           vc.enteredWordLabelString = self.phoneTF.text!
                print(vc.selectedCodeString)
                
                self.navigationController?.pushViewController(vc, animated: true)
            }
            
            else if ((self.phoneType == "Mobile") && (self.catType == "Personal")) {
                vc.phoneType1 = self.phoneType
                vc.catType1 = self.catType
                vc.phoneTFString = self.areaCodeTF.text!
                           vc.enteredWordLabelString = self.phoneTF.text!

                
                self.navigationController?.pushViewController(vc, animated: true)
            }
            
            else if ((self.phoneType == "Landline") && (self.catType == "Personal")) {
                vc.phoneType1 = self.phoneType
                vc.catType1 = self.catType
                print(self.areaCodeTF.text!)
                vc.selectedCodeString = self.areaCodeTF.text!
               vc.phoneTFString = self.phoneTF.text!
            vc.enteredWordLabelString = self.wordTF.text!
                
                self.navigationController?.pushViewController(vc, animated: true)
            }
            
            else{
                
            }
        }
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
    
    
    
    
    
    
}

extension BusinessEdit1ViewController:UIViewControllerTransitioningDelegate{
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.isPresenting = true
        return transition
    }
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.isPresenting = false
        return transition
    }
}

extension BusinessEdit1ViewController{
    func getAllCountriesData(){
        
        self.countriesDataArray.removeAll()
        
        let headers = [
            "User-Agent": "PostmanRuntime/7.19.0",
            "Accept": "*/*",
            "Cache-Control": "no-cache",
            "Postman-Token": "60c6b50b-ac2b-4d4a-babc-7e2d9c89d84f,933a73ad-e0c8-4261-9946-51a167c566e9",
            "Host": "restcountries.eu",
            "Accept-Encoding": "gzip, deflate",
            "Connection": "keep-alive",
            "cache-control": "no-cache"
        ]
        
        let request = NSMutableURLRequest(url: NSURL(string: "https://restcountries.eu/rest/v2/all")! as URL,
                                          cachePolicy: .useProtocolCachePolicy,
                                          timeoutInterval: 10.0)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers
        
        let session = URLSession.shared
        let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
            if (error != nil) {
                print(error)
            } else {
                let httpResponse = response as? HTTPURLResponse
                print(httpResponse)
                
                do{
                    let temp = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as! NSArray
                    //let data = temp["Response"] as! NSDictionary
                    
                    //print(temp)
                    for country in temp{
                        //print(country)
                        
                        let item = country as! [String : Any]
                        print(item["name"]!)
                        print(item["flag"]!)
                        
                        let callingCode = item["callingCodes"] as! NSArray
                        print(callingCode[0])
                        
                        let obj = countriesData(countryName: item["name"]! as! String, countryFlag: item["flag"]! as! String, countryCode: callingCode[0] as! String)
                        
                        self.countriesDataArray.append(obj)
                        
                    }
                    
                }catch{
                    print("error detected")
                }
            }
        })
        
        dataTask.resume()
    }
    @objc func dropDownButton(){
        
        var countryCodeArr = [String]()
        countryCodeArr.removeAll()
        
        for item in self.countriesDataArray{
            countryCodeArr.append(" \(item.countryName)  (+\(item.countryCode)) ")
        }
        
        dropDown?.dataSource = countryCodeArr
        dropDown?.show()
    }
}
