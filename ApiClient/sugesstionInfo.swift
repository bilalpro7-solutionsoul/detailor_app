//
//  sugesstionInfo.swift
//  DailerApp
//
//  Created by Bilal on 19/11/2020.
//  Copyright © 2020 Solution Soul. All rights reserved.
//

import Foundation
class sugesstionInfo :NSObject{
    
    var name : String = ""
    var price : String = ""
    var type : Int = 0
  
    
    required init(dic :Dictionary <String , Any>){
        
        self.name = dic["name"] as? String ?? ""
        self.price = dic["price"] as? String ?? ""
        self.type = dic["type"] as? Int ?? 0
      
    }
    
   
}

