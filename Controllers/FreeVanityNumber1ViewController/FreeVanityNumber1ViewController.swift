//
//  FreeVanityNumber1ViewController.swift
//  DailerApp
//
//  Created by Muhammad Bilal on 26/02/2020.
//  Copyright © 2020 Solution Soul. All rights reserved.
//

import UIKit
import DropDown
import SVProgressHUD

class FreeVanityNumber1ViewController: UIViewController {
    
    @IBOutlet weak var phoneTF: UITextField!
    @IBOutlet weak var wordTF: UITextField!
    @IBOutlet weak var mobileButtonProperty: UIButton!
    @IBOutlet weak var selectedCountryLabel: UILabel!
    
    let transition = SlideInTransition()
    
    var countriesDataArray = [countriesData]()
    var selectedCountryCode = ""
    var selectedCountryName = ""
    var selectedCountry = ""
    
    var dropDown: DropDown?
    
    override func viewWillAppear(_ animated: Bool) {
        getAllCountriesData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dropDown = DropDown()
        dropDown?.anchorView = self.mobileButtonProperty
        dropDown?.dataSource =  ["Car","Audi","BMW","SUZUKI","HONDA","TOYOTA"]
        dropDown?.bottomOffset = CGPoint(x: 0, y: (dropDown?.anchorView?.plainView.bounds.height)!)
        dropDown?.selectionAction = { [unowned self] (index: Int, item: String) in
            //self.countryButtonProperty.setTitle(item, for: .normal)
            
            let itemx = self.countriesDataArray[index]
            
            print(item)
            print(itemx.countryFlag)
            
            self.selectedCountryCode = itemx.countryCode
            self.selectedCountryName = itemx.countryName
            self.selectedCountryLabel.text = "\(itemx.countryName)  (+\(itemx.countryCode))"
            self.selectedCountry = "\(itemx.countryName)  (+\(itemx.countryCode))"
        }
        
        //self.navigationItem.title = "Dug"
        if let name = defaults.string(forKey: userData.name) {
            print(name) // Another String Value
            self.navigationItem.title = name
        }
        if let number = defaults.string(forKey: userData.phoneNo) {
            print(number) // Another String Value
            self.phoneTF.text = number
        }
        
        let menuUIBarButtonItem = UIBarButtonItem(image: UIImage(named: "menuWhite.png"), style: .plain, target: self, action: #selector(FreeVanityNumber1ViewController.clickButton))
        menuUIBarButtonItem.tintColor = UIColor.white
        self.navigationItem.leftBarButtonItem  = menuUIBarButtonItem
        
        transition.dimmingView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismisFunc)))
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(self.handleGesture(gesture:)))
        swipeLeft.direction = .left
        self.transition.dimmingView.addGestureRecognizer(swipeLeft)
    }
    
    @IBAction func selectCountryButtonAction(_ sender: Any) {
        dropDownButton()
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
    
    @IBAction func nextButtonAction(_ sender: Any) {
        
        if self.selectedCountry != "" {
            if self.wordTF.text!.count > 2 {
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "FreeVanityNumber2ViewController") as! FreeVanityNumber2ViewController
                vc.selectedCounter = self.selectedCountry
                vc.selectedWord = self.wordTF.text!
                self.navigationController?.pushViewController(vc, animated: true)
            }else{
                let alert = UIAlertController(title: "Alert", message: "Word mest be 3 characters long!", preferredStyle: .alert)
                let action = UIAlertAction(title: "OK", style: .default, handler: nil)
                alert.addAction(action)
                self.present(alert,animated: true,completion: nil)
            }
        }else{
            let alert = UIAlertController(title: "Alert", message: "Please Select Country First!", preferredStyle: .alert)
            let action = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(action)
            self.present(alert,animated: true,completion: nil)
        }
    }
    
}

extension FreeVanityNumber1ViewController:UIViewControllerTransitioningDelegate{
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.isPresenting = true
        return transition
    }
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.isPresenting = false
        return transition
    }
}

extension FreeVanityNumber1ViewController{
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
