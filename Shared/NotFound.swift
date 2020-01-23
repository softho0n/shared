//
//  NotFound.swift
//  Shared
//
//  Created by Seunghun Shin on 2020/01/08.
//  Copyright © 2020 SeunghunShin. All rights reserved.
//

import UIKit

class NotFound: UIView {
    class func instanceFromNib() -> UIView {
        return UINib(nibName: "NotFound", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! UIView
    }
}
