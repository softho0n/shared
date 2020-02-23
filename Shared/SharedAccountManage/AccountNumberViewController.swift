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
    var firstAccount = false
    
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
            if firstAccount == true{
                print("AccountNumberView", self.firstAccount)
                self.ref?.child("Signiture/\(uid)").setValue([bankName: account])
            }
        }
        AccNumberField.text = ""
        alertWithHome(message: "계좌가 정상적으로 연동 되었습니다.")
    }
}

extension AccountNumberViewController {
    func alertWithHome(title: String = "알림", message: String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "확인", style: .default) { (action) in
            if #available(iOS 13.0, *) {
                let vc = self.storyboard?.instantiateViewController(identifier: "mainUI")
                self.navigationController?.pushViewController(vc!, animated: true)
            } else {
                fatalError()
            }
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
}
