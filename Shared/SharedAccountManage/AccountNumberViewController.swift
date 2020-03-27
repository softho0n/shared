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
    
    var ref: DatabaseReference!
    var bankName : String?
    var firstAccount = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.bankLabel.text = "\(bankName!)은행"
        AccNumberField.keyboardType = .numberPad
//        clickButton.isHidden = true
        ref = Database.database().reference()
        addToolbarToVerifyAuthCode(AccNumberField, "계좌 연동하기")
    }
    
    @IBAction func editingStart(_ sender: Any) {
        
    }
    
//    @IBAction func interlocking(_ sender: Any) {
//        if let uid = Auth.auth().currentUser?.uid, let bankName = bankLabel.text, let account = AccNumberField.text {
//            ref?.child("Accounts/\(uid)").updateChildValues([bankName: account])
//            if firstAccount == true{
//                print("AccountNumberView", self.firstAccount)
//                self.ref?.child("Signiture/\(uid)").setValue([bankName: account])
//            }
//        }
//        AccNumberField.text = ""
//        alertWithHome(message: "계좌가 정상적으로 연동 되었습니다.")
//    }
    
    @objc
    func interlocking() {
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
    
    func addToolbarToVerifyAuthCode(_ textField : Any?, _ message : String?){
        guard let field = textField as? UITextField else {
            fatalError()
        }
        
        guard let msg = message else {
            fatalError()
        }
        
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        toolbar.clipsToBounds = true
        toolbar.barTintColor = UIColor(white: 1, alpha: 0.5)
        
        let doneButton = UIBarButtonItem(title: msg, style: .done, target: nil, action: #selector(interlocking))
        doneButton.tintColor = .systemBlue
        
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        toolbar.setItems([flexibleSpace,doneButton,flexibleSpace], animated: false)
        field.inputAccessoryView = toolbar
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
