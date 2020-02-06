//
//  AccountnumberViewController.swift
//  Shared
//
//  Created by softhoon on 2020/02/07.
//  Copyright © 2020 SeunghunShin. All rights reserved.
//

import UIKit

class AccountnumberViewController: UIViewController {
    @IBOutlet var bankLabel: UILabel!
    @IBOutlet var AccNumberField: UITextField!
    @IBOutlet var clickButton: UIButton!
    
    
    var bankName : String?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.bankLabel.text = "\(bankName!) 은행"
        AccNumberField.keyboardType = .numberPad
        clickButton.isHidden = true

        // Do any additional setup after loading the view.
    }
    
    @IBAction func editingStart(_ sender: Any) {
        clickButton.isHidden = false
    }
    
    

    
    /*
     // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
