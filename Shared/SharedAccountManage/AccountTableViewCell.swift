//
//  AccountTableViewCell.swift
//  Shared
//
//  Created by Seunghun Shin on 2020/02/12.
//  Copyright © 2020 SeunghunShin. All rights reserved.
//

import UIKit

class AccountTableViewCell: UITableViewCell {

    @IBOutlet var bankName: UILabel!
    @IBOutlet var accountNumber: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
