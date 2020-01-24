//
//  searchUserViewController.swift
//  Shared
//
//  Created by Seunghun Shin on 2020/01/08.
//  Copyright © 2020 SeunghunShin. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth

class SearchUserViewController: UIViewController {

    var ref: DatabaseReference!
    var key: String!
    var alreadyExists: Bool = false
    var storedData: [String : Any]!
    var userInfo: [String : Any]! = nil
    
    @IBOutlet var firstView: UIView!
    @IBOutlet var secondView: UIView!
    @IBOutlet var notFoundView: UIView!
    
    @IBOutlet var loader: UIActivityIndicatorView!
    @IBOutlet var userPhoneNumberField: UITextField!
    @IBOutlet var userInfoLabel: UILabel!
    @IBOutlet var signInDateLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ref = Database.database().reference()
        userPhoneNumberField.keyboardType = .phonePad
        addToolbar(userPhoneNumberField, "찾기")
        
        secondView.isHidden = true
        loader.backgroundColor = UIColor.white
    }
    
    func addToolbar(_ textFiled : Any?, _ message : String?){
        guard let field = textFiled as? UITextField else {
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
        self.view.endEditing(true)
        
        DispatchQueue.global().sync {
            loader.startAnimating()
            if let userPhoneNumber = self.userPhoneNumberField.text {
                ref.child("Users").observeSingleEvent(of: .value) { (snapshot) in
                    let values = snapshot.value
                    let userDictionary = values as! [String : [String : Any]]
                    
                    for index in userDictionary {
                        if index.value["userPhoneNumber"] as! String == userPhoneNumber {
                            self.storedData = ["userName" : index.value["userName"] ?? "Novalue", "userPhoneNumber" : userPhoneNumber ?? "Novalue", "signInDate" : index.value["signInDate"]]
                            self.key = index.key
                            
                            let userName = index.value["userName"] as! String
                            let signInDate = index.value["signInDate"] as! String
                            self.userInfoLabel.text = "\(userName)님, \(userPhoneNumber)"
                            self.signInDateLabel.text = "가입 일자 : \(signInDate)"
                            break
                        }
                    }
                    
                    self.userPhoneNumberField.text = ""
                    self.loader.stopAnimating()
                    self.loader.backgroundColor = UIColor.clear
                    
                    if self.storedData == nil {
                        self.notFoundView.isHidden = false
                    }
                    else {
                        self.alreadyExistUser()
                        self.secondView.isHidden = false
                    }
                }
            }
        }
    }

    @IBAction func addFriendButton(_ sender: Any) {
        if let uid = Auth.auth().currentUser?.uid {
            if uid == self.key { // 자기 자신을 추가하려는 경우
                destructiveAlertInSearchUserViewController(title: "잠깐!", message: "자기 자신은 추가할 수 없습니다.")
            }
            else if self.alreadyExists {
                destructiveAlertInSearchUserViewController(title: "알림", message: "이미 추가된 사용자입니다.")
                self.alreadyExists = false
            }
            else {
                ref.child("Friends").child(uid).child(self.key).setValue(self.storedData)
                defaultAlertInSearchUserViewController(message: "정상적으로 추가되었습니다.")
            }
        }
    }
    
    func alreadyExistUser() {
        if let uid = Auth.auth().currentUser?.uid {
            ref.child("Friends").child(uid).observeSingleEvent(of: .value) { (snapshot) in
                let values = snapshot.value
                let userDictionary = values as! [String : [String : Any]]
                for index in userDictionary {
                    if index.value["userPhoneNumber"] as! String == self.storedData["userPhoneNumber"] as! String {
                        self.alreadyExists = true
                        break
                    }
                }
            }
        }
    }
}

extension SearchUserViewController {
    func defaultAlertInSearchUserViewController(title: String = "알림", message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "확인", style: .default) { (action) in
            self.secondView.isHidden = true
            self.userInfoLabel.text = ""
            self.signInDateLabel.text = ""
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    func destructiveAlertInSearchUserViewController(title: String = "알림", message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "확인", style: .destructive) { (action) in
            self.secondView.isHidden = true
            self.userInfoLabel.text = ""
            self.signInDateLabel.text = ""
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
}

extension SearchUserViewController: UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        self.notFoundView.isHidden = true
        return true
    }
}
