//
//  AccountnumberViewController.swift
//  Shared
//
//  Created by softhoon on 2020/02/07.
//  Copyright © 2020 SeunghunShin. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth

class AccountNumberViewController: UIViewController {
    @IBOutlet var bankLabel: UILabel!
    @IBOutlet var AccNumberField: UITextField!
    @IBOutlet var clickButton: UIButton!
    var ref: DatabaseReference!
    var bankName : String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.bankLabel.text = "\(bankName!)은행"
        AccNumberField.keyboardType = .numberPad
        clickButton.isHidden = true
        ref = Database.database().reference()
    }
    
    @IBAction func editingStart(_ sender: Any) {
        clickButton.isHidden = false
    }
    
    @IBAction func interlocking(_ sender: Any) {
        if let uid = Auth.auth().currentUser?.uid, let bankName = bankLabel.text, let account = AccNumberField.text {
            ref?.child("Accounts/\(uid)").updateChildValues([bankName: account])
        }
        
    }
}
