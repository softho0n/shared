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

let banklist : [String] = ["NH농협", "KB국민", "신한", "외환", "우리", "하나", "IBK기업", "외한", "SC제일", "KDB산업", "SBI저축은행", "새마을", "대구", "광주", "우체국", "신협", "전북", "경남", "부산", "수협", "제주", "케이뱅크"]

let bankimagelist : [String] = ["citi", "IBK", "KDB", "kookmin", "nonghyub", "shinhan", "whyhan", "woori", "zeil"]
