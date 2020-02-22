//
//  SendTableViewCell.swift
//  Shared
//
//  Created by softhoon on 2020/02/21.
//  Copyright © 2020 SeunghunShin. All rights reserved.
//

import UIKit

class SendpayLineTableViewCell: UITableViewCell {
    @IBOutlet var myPhoto: UIImageView!
    @IBOutlet var shopPhoto: UIImageView!
    @IBOutlet var groupBy: UILabel!
    @IBOutlet var groupName: UILabel!
    @IBOutlet var totalMoney: UILabel!
    @IBOutlet var perMoney: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
