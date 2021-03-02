//
//  CreateAccountViewController.swift
//  DailerApp
//
//  Created by Muhammad Bilal on 02/03/2020.
//  Copyright © 2020 Solution Soul. All rights reserved.
//

import UIKit
import DropDown
import Firebase
import FirebaseAuth
import SVProgressHUD

struct countriesData {
    let countryName : String
    let countryFlag : String
    let countryCode : String
}

class CreateAccountViewController: UIViewController {
    
    @IBOutlet weak var nameTF: TextField_Class!
    @IBOutlet weak var phoneTF: TextField_Class!
    @IBOutlet weak var emailTF: TextField_Class!
    @IBOutlet weak var passwordTF: TextField_Class!
    @IBOutlet weak var confirmPassword: TextField_Class!
    @IBOutlet weak var selectedCountryLabel: UILabel!
    
    var countriesDataArray = [countriesData]()
    var selectedCountryCode = ""
    var selectedCountryName = ""
    
    var dropDown: DropDown?
    
    override func viewWillAppear(_ animated: Bool) {
        getAllCountriesData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dropDown = DropDown()
        dropDown?.anchorView = self.nameTF
        dropDown?.dataSource =  ["Car","Audi","BMW","SUZUKI","HONDA","TOYOTA"]
        dropDown?.bottomOffset = CGPoint(x: 0, y: (dropDown?.anchorView?.plainView.bounds.height)!)
        dropDown?.selectionAction = { [unowned self] (index: Int, item: String) in
            //self.countryButtonProperty.setTitle(item, for: .normal)
            
            let itemx = self.countriesDataArray[index]
            
            print(item)
            print(itemx.countryFlag)
            
            self.selectedCountryCode = itemx.countryCode
            self.selectedCountryName = itemx.countryName
            self.selectedCountryLabel.text = "\(itemx.countryName) +\(itemx.countryCode)"
            
        }
        
    }
    
    @IBAction func selectCountryButtonAction(_ sender: Any) {
        dropDownButton()
    }
    @IBAction func registerButtonAction(_ sender: Any) {
        if nameTF.text != "" {
            if phoneTF.text != "" {
                if emailTF.text != "" {
                    if passwordTF.text != "" {
                        if confirmPassword.text != "" {
                            if passwordTF.text == confirmPassword.text {
                                
                                SVProgressHUD.show(withStatus: "Setting up your account...")
                                

                                var refp1 : DatabaseQuery = Database.database().reference().child("profiles")
                                
                                refp1 = refp1.queryOrdered(byChild: "phoneNo").queryEqual(toValue: phoneTF.text)
                                
                                refp1.observe(DataEventType.value) { (snapshot) in
                                    
                                    if snapshot.exists() {
                                        //value exists
                                        print("yess number exit")
                                        
                                        SVProgressHUD.dismiss()
                                        
                                        let alert = UIAlertController(title: "Warning", message: "Mobile No already Exist", preferredStyle: .alert)
                                        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
                                        alert.addAction(action)
                                        self.present(alert,animated: true,completion: nil)
                                    }
                                    else{
                                         print("no number exit")
                                        
                                        Auth.auth().createUser(withEmail: self.emailTF.text!, password: self.passwordTF.text!) { (user, error) in
                                                                            
                                            print("userrr",user?.user)
                                                                            if user != nil {
                                                                                // Successfully User Created
                                                                                print("User Successfully Created !")
                                                                                let key = (user?.user.uid)!
                                                                                print((user?.user.uid)!)
                                                                                
                                                                                let refp = Database.database().reference().child("profiles")
                                                                                let keyp = refp.childByAutoId().key
                                                                                let datap = ["phoneNo":"\(self.phoneTF.text!)","type":"personal","userId":"\(key)","wordNum":""]
                                                                                refp.child(keyp!).setValue(datap)
                                        //                                        // Second we have to update values in user table
                                        //                                        let refu = Database.database().reference().child("users").child(key)
                                        //                                        refu.updateChildValues(["personalProfileKey":"\(keyp!)","hasPersonalWordNum":true])
                                                                                
                                                                                let ref = Database.database().reference().child("users")
                                                                                
                                                                                let dateString = DateFormatter.sharedDateFormatter.string(from: Date())

                                                                                print("date",dateString)
                                                                                let data = ["address":"\(self.selectedCountryName)","businessProfileKey":"","email":"\(self.emailTF.text!)","hasBusinessProfile":"false","hasBusinessWordNum":"false","hasPersonalWordNum":"false","id":"\(key)","imageUrl":"","name":"\(self.nameTF.text!)","password":"\(self.passwordTF.text!)","personalProfileKey":"\(keyp!)","phoneNo":"\(self.phoneTF.text!)","createdAt":dateString] as [String : Any]
                                                                                ref.child(key).setValue(data)
                                                                                
                                                                                defaults.set("\(self.selectedCountryName)", forKey: userData.address)
                                                                                defaults.set("", forKey: userData.businessProfileKey)
                                                                                defaults.set("\(self.emailTF.text!)", forKey: userData.email)
                                                                                defaults.set("false", forKey: userData.hasBusinessProfile)
                                                                                defaults.set("false", forKey: userData.hasBusinessWordNum)
                                                                                defaults.set("false", forKey: userData.hasPersonalWordNum)
                                                                                defaults.set("\(key)", forKey: userData.id)
                                                                                defaults.set("", forKey: userData.imageUrl)
                                                                                defaults.set("\(self.nameTF.text!)", forKey: userData.name)
                                                                                defaults.set("\(self.passwordTF.text!)", forKey: userData.password)
                                                                                defaults.set("\(keyp!)", forKey: userData.personalProfileKey)
                                                                                defaults.set("\(self.phoneTF.text!)", forKey: userData.phoneNo)
                                                                                defaults.set("true", forKey: userData.userLogin)
                                                                                
                                                                                SVProgressHUD.dismiss()
                                                                                
                                                                                // Perform Segue
                                                                                
                                                                                let vc = self.storyboard?.instantiateViewController(withIdentifier: "TabBarViewController") as! TabBarViewController
                                                                                self.present(vc,animated: true,completion: nil)
                                                                                
                                                                            }else{
                                                                                
                                                                                SVProgressHUD.dismiss()
                                                                                
                                                                                print(error)
                                                                                let alert = UIAlertController(title: "Warning", message: "\(error?.localizedDescription ?? "")", preferredStyle: .alert)
                                                                                let action = UIAlertAction(title: "OK", style: .default, handler: nil)
                                                                                alert.addAction(action)
                                                                                self.present(alert,animated: true,completion: nil)
                                                                            }
                                                                            
                                                                        }
                                    }
                                }
                                
                                
                            }else{
                                
                            }
                        }else{
                            
                        }
                    }else{
                        
                    }
                }else{
                    
                }
            }else{
                
            }
        }else{
            
        }
    }
    @IBAction func backButtonAction(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}

extension CreateAccountViewController{
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

extension DateFormatter {

    static var sharedDateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        // Add your formatter configuration here
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return dateFormatter
    }()
}
