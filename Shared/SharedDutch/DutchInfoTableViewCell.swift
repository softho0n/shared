//
//  DutchInfoTableViewCell.swift
//  Shared
//
//  Created by Seunghun Shin on 2020/02/16.
//  Copyright © 2020 SeunghunShin. All rights reserved.
//

import UIKit

class DutchInfoTableViewCell: UITableViewCell {

    @IBOutlet var userNameLabel: UILabel!
    @IBOutlet var userPhoneNumberLabel: UILabel!
    @IBOutlet var dutchMoneyLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
