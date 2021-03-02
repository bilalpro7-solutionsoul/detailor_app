//
//  ContactUsViewController.swift
//  DailerApp
//
//  Created by Muhammad Bilal on 26/02/2020.
//  Copyright © 2020 Solution Soul. All rights reserved.
//

import UIKit

class ContactUsViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func barBackButtonAction(_ sender: Any) {
        let mainStoryBoard = UIStoryboard(name: "Main", bundle: nil)
        let redViewController = mainStoryBoard.instantiateViewController(withIdentifier: "TabBarViewController") as! TabBarViewController
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.window?.rootViewController = redViewController
    }
    
}
