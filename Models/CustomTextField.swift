//
//  CustomTextFieldl.swift
//  PetStand
//
//  Created by Samyotech on 12/07/18.
//  Copyright © 2018 mac. All rights reserved.
//

import UIKit

class CustomTextField: UITextField {
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.layer.cornerRadius = 0.0
        self.layer.borderColor = UIColor.black.cgColor
        self.layer.borderWidth = 1.0
        
        self.tintColor = UIColor.white
    }
    
    init(frame: CGRect, arg1: CGFloat, arg2: String) {
        super.init(frame: frame)
        
        self.layer.cornerRadius = arg1
        print(arg2)
        print("Instantiated")
    }
    
   
}
