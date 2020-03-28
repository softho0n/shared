//
//  DutchBalanceViewController.swift
//  Shared
//
//  Created by Seunghun Shin on 2020/02/15.
//  Copyright © 2020 SeunghunShin. All rights reserved.
//

import UIKit

class DutchBalanceViewController: UIViewController {
    
    var groupInfoList = [MakingGroupViewController.myFriendInfoStruct]()
    var totalCount = 0
    
    @IBOutlet var groupField: UITextField!
    @IBOutlet var moneyField: UITextField!
    @IBOutlet var moneyInfoLabel: UILabel!
    @IBOutlet var wonLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBackButton()
        moneyField.adjustsFontSizeToFitWidth = false
        groupField.adjustsFontSizeToFitWidth = false
        
        moneyInfoLabel.isHidden = true
        moneyField.isHidden = true
        wonLabel.isHidden = true
        
        addToolbarToSetMoney(groupField, "금액입력하기")
        addToolbarToConfirm(moneyField, "다음으로")
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(true)
        self.groupField.text = ""
        self.moneyField.text = ""
        
        moneyInfoLabel.isHidden = true
        moneyField.isHidden = true
        wonLabel.isHidden = true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc = segue.destination as! DutchPayConfirmViewController
        vc.totalCount = totalCount
        vc.receiveGroupInfo = groupInfoList
        vc.dutchBalance = moneyField.text!
        vc.groupName = groupField.text!
    }
    
    func addToolbarToSetMoney(_ textField: Any?, _ message: String?) {
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
        
        let doneButton = UIBarButtonItem(title: msg, style: .done, target: nil, action: #selector(openMoneyField))
        doneButton.tintColor = .systemBlue
        
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        toolbar.setItems([flexibleSpace,doneButton,flexibleSpace], animated: false)
        field.inputAccessoryView = toolbar
    }
    
    func addToolbarToConfirm(_ textField: Any?, _ message: String?) {
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
    
    @objc func openMoneyField() {
        self.view.endEditing(true)
        moneyInfoLabel.isHidden = false
        moneyField.isHidden = false
        wonLabel.isHidden = false
        
        moneyField.becomeFirstResponder()
    }
    
    @objc func done() {
        self.performSegue(withIdentifier: "segueForConfirm", sender: nil)
        self.view.endEditing(true)
    }
    
}

extension DutchBalanceViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.locale = Locale.current
        formatter.maximumFractionDigits = 0

        
        switch textField
        {
        case moneyField:
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
        default: break
            
        }
        return true
    }
}
