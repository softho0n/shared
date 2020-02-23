//
//  chargeSharedMoneyViewController.swift
//  Shared
//
//  Created by Seunghun Shin on 2020/02/12.
//  Copyright © 2020 SeunghunShin. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class chargeSharedMoneyViewController: UIViewController {

    @IBOutlet var greetingLabel: UILabel!
    @IBOutlet var wonLabel: UILabel!
    @IBOutlet var chargeMoneyField: UITextField!
    @IBOutlet var thereIsNoSigniture: UIView!
    var ref: DatabaseReference!
    var currentMoney: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        greetingLabel.isHidden = true
        wonLabel.isHidden = true
        chargeMoneyField.isHidden = true
        
        ref = Database.database().reference()
        chargeMoneyField.adjustsFontSizeToFitWidth = false
        addToolbarToCharge(chargeMoneyField, "충전하기")
        checkSignitureAccount()
        // Do any additional setup after loading the view.
    }
    
    func checkSignitureAccount() {
        if let uid = Auth.auth().currentUser?.uid {
            DispatchQueue.global().sync {
                ref.child("Signiture/\(uid)").observeSingleEvent(of: .value, with: {(snapshot) in
                    if (!snapshot.exists()) {
                        self.thereIsNoSigniture.isHidden = false
                    } else {
                        self.thereIsNoSigniture.isHidden = true
                        self.greetingLabel.isHidden = false
                        self.wonLabel.isHidden = false
                        self.chargeMoneyField.isHidden = false
                    }
                })
            }
        }
    }
    
    func addToolbarToCharge(_ textField: Any?, _ message: String?) {
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
        
        let doneButton = UIBarButtonItem(title: msg, style: .done, target: nil, action: #selector(done))
        doneButton.tintColor = .systemBlue
        
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        toolbar.setItems([flexibleSpace,doneButton,flexibleSpace], animated: false)
        field.inputAccessoryView = toolbar
    }
    
    @objc func done() {
        chargeMoney()
        self.view.endEditing(true)
    }
    
    func chargeMoney() {
        DispatchQueue.global().sync {
                if let uid = Auth.auth().currentUser?.uid {
                    ref.child("SharedMoney/\(uid)").observeSingleEvent(of: .value) { (snapshot) in
                        for item in snapshot.children {
                            let value = (item as! DataSnapshot).value
                            self.currentMoney = Int(value as! String)!
                            let modifiedString = self.chargeMoneyField.text?.replacingOccurrences(of: ",", with: "")
                            if let mS = modifiedString {
                                if let intValueOfmS = Int(mS), let cM = self.currentMoney {
                                    self.setData(intValueOfmS + cM)
                                }
                            }
                    }
                    self.chargeMoneyField.text = ""
                }
            }
        }
    }
    
    func setData(_ newData: Int!) {
        if let uid = Auth.auth().currentUser?.uid {
            let sharedMoney = ["balance" : "\(newData!)"] as [String : String]
            ref.child("SharedMoney/\(uid)").updateChildValues(sharedMoney)
            alertWithConfirm()
        } else {
            fatalError()
        }
    }
}

extension chargeSharedMoneyViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.locale = Locale.current
        formatter.maximumFractionDigits = 0

        if let removeAllSeprator = textField.text?.replacingOccurrences(of: formatter.groupingSeparator, with: ""){
          var beforeForemattedString = removeAllSeprator + string
          if formatter.number(from: string) != nil {
            if let formattedNumber = formatter.number(from: beforeForemattedString), let formattedString = formatter.string(from: formattedNumber){
              textField.text = formattedString
              return false
            }
          }else{
            if string == "" {
              let lastIndex = beforeForemattedString.index(beforeForemattedString.endIndex, offsetBy: -1)
              beforeForemattedString = String(beforeForemattedString[..<lastIndex])
              if let formattedNumber = formatter.number(from: beforeForemattedString), let formattedString = formatter.string(from: formattedNumber){
                textField.text = formattedString
                return false
              }
            }else{
              return false
            }
          }
        }
        return true
    }
}

extension chargeSharedMoneyViewController {
    func alertWithConfirm(title: String = "알림"){
        let alert = UIAlertController(title: title, message: "충전되었습니다.", preferredStyle: .alert)
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
