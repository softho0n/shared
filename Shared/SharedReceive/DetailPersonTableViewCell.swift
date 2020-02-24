//
//  DetailPersonTableViewCell.swift
//  Shared
//
//  Created by softhoon on 2020/02/24.
//  Copyright © 2020 SeunghunShin. All rights reserved.
//

import UIKit

class DetailPersonTableViewCell: UITableViewCell {
    @IBOutlet var memberName: UILabel!
    @IBOutlet var memberPhoneNum: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
