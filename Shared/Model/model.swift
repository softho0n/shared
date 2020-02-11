//
//  model.swift
//  Shared
//
//  Created by Seunghun Shin on 2020/01/04.
//  Copyright © 2020 SeunghunShin. All rights reserved.
//

import Foundation

 class User {
    var name: String
    var phoneNumber: String
    var madeDate: Date
    
    init(name: String, phoneNumber: String) {
        self.name = name
        self.phoneNumber = phoneNumber
        madeDate = Date()
    }
}
public var myName : String?
let banklist : [String] = ["씨티", "IBK기업", "KDB산업", "KB국민" , "NH농협", "신한", "외환" , "우리" , "SC제일"]
let bankimagelist : [String] = ["citi", "IBK", "KDB", "kookmin", "nonghyub", "shinhan", "whyhan","woori", "zeil"]
