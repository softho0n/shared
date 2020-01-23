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
