//
//  Structures.swift
//  DailerApp
//
//  Created by Muhammad Bilal on 03/03/2020.
//  Copyright © 2020 Solution Soul. All rights reserved.
//

import Foundation

struct userData {
    static var address = "address"
    static var businessProfileKey = "businessProfileKey"
    static var email = "email"
    static var hasBusinessProfile = "hasBusinessProfile"
    static var hasBusinessWordNum = "hasBusinessWordNum"
    static var hasPersonalWordNum = "hasPersonalWordNum"
    static var id = "id"
    static var imageUrl = "imageUrl"
    static var name = "name"
    static var password = "password"
    static var personalProfileKey = "personalProfileKey"
    static var phoneNo = "phoneNo"
    static var userLogin = "false"
}
//Sorry your total budjet is less than budjet amount you are providing.
let defaults = UserDefaults.standard

struct AllBusinesses {
    let image : String
    let key : String
    let keywords : String
    let name : String
    let rating : Int
    let userId : String
    let phoneNo : String
}

struct WordNumbers {
    var catType = "catType"
    var country = "country"
    var key = "key"
    var phoneType = "phoneType"
    var status = 0
    var type = 0
    var uid = "uid"
    var wordNum = "wordNum"
    
}




struct BussinessDetails {
    var logoUrl : String
    var areaCode : String
    var description : String
    var name : String
    var phoneNo : String
}

struct PersonalProfile {
    var phoneNo = "phoneNo"
    var type = "type"
    var userId = "userId"
    var wordNum = "wordNum"
    
}

struct UserProfile {
    var address = "address"
    var businessProfileKey = "businessProfileKey"
    var email = "email"
    var hasBusinessProfile = "hasBusinessProfile"
    var hasBusinessWordNum = "hasBusinessWordNum"
    var hasPersonalWordNum = "hasPersonalWordNum"
    var id = "id"
    var imageUrl = "imageUrl"
    var name = "name"
    var password = "password"
    var personalProfileKey = "personalProfileKey"
    var phoneNo = "phoneNo"
    var userLogin = "false"
}

struct ContactStructure {
    var actionsVisible : String
    var inDatabase : String
    var key : String
    var name : String
    var phoneNo : String
    var userId : String
}

struct BusinessLinksStructure {
    let key : String
    let link : String
    let name : String
    let publics : Bool
}

struct PersonalLinksStructure {
    let key : String
    let link : String
    let name : String
    let privates : String
}

struct KeywordStructure {
    let key : String
    let name : String
}

struct StoresStructure {
    let address : String
    let key : String
    let lat : String
    let lon : String
}

struct LinksStructure {
    let key : String
    let link : String
    let name : String
}

struct OffersStructure {
    let imageUrl : String
    let key : String
    let link : String
    let name : String
}

struct CallLogStruct {
    let id: String
    let name: String
    let phoneNumber: String
    let callType: String
    let callStartTime: String
    let callEndTime: String
}

//struct KeywordsStruct {
//    
//}
