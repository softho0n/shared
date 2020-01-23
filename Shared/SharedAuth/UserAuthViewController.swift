//
//  UserAuthViewController.swift
//  Shared
//
//  Created by Seunghun Shin on 2020/01/04.
//  Copyright © 2020 SeunghunShin. All rights reserved.
//

import UIKit
import FirebaseAuth

class UserAuthViewController: UIViewController {

    var name: String?
    
    @IBOutlet var userNameLabel: UILabel!
    @IBOutlet var userPhoneNumberField: UITextField!
    @IBOutlet var userAuthLabel: UILabel!
    @IBOutlet var userAuthField: UITextField!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        guard let name = name else {
            fatalError()
        }
        userNameLabel.text = name + "님,"
        print(name + " 이름 데이터 받기 완료! ㅎ_ㅎ")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        userPhoneNumberField.keyboardType = .phonePad
        userAuthField.keyboardType = .numberPad
        addToolbarToVerifyPhoneNumber(userPhoneNumberField, "보내기")
        
        Auth.auth().languageCode = "ko"
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let phoneNumber = userPhoneNumberField.text
        if let vc = segue.destination as? ConfirmViewController {
            vc.name = name
            vc.phoneNumber = phoneNumber
            vc.date = Date()
        }
    }
    
    func confirmUserPhoneNumber(_ phoneNumber : String?) {
        PhoneAuthProvider.provider().verifyPhoneNumber(phoneNumber!, uiDelegate: nil) { (verificationID, error) in
            if let error = error {
                print(error)
                return
            }
            UserDefaults.standard.set(verificationID, forKey: "authVerificationID")
            print("인증 ID 생성 완료 했어 ㅎㅎ 그 다음 단계도 진행해야지~?")
        }
    }
    
    func addToolbarToVerifyPhoneNumber(_ textFiled : Any?, _ message : String?){
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
    
    func addToolbarToVerifyAuthCode(_ textFiled : Any?, _ message : String?){
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
        
        let doneButton = UIBarButtonItem(title: msg, style: .done, target: nil, action: #selector(singIn))
        doneButton.tintColor = .systemBlue
        
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        toolbar.setItems([flexibleSpace,doneButton,flexibleSpace], animated: false)
        field.inputAccessoryView = toolbar
    }
    
    @objc func done() {
        self.view.endEditing(true)
        userAuthLabel.isHidden = false
        userAuthField.isHidden = false
        
        if let phoneNumber = userPhoneNumberField.text {
            confirmUserPhoneNumber(phoneNumber)
        }
        
        addToolbarToVerifyAuthCode(userAuthField, "인증하기")
    }
    
    @objc func singIn() {
        self.view.endEditing(true)
        
        if let verificationCode = userAuthField.text {
            guard let verificationID = UserDefaults.standard.string(forKey: "authVerificationID") else { return }
            
            let credential = PhoneAuthProvider.provider().credential(withVerificationID: verificationID, verificationCode: verificationCode)
            
            Auth.auth().signIn(with: credential) { (authResult, error) in
                if let error = error {
                    //self.alert(message: "로그인이 실패했는뎁?!")
                    self.rejectedAlert(message: "인증에 실패하셨네요.")
                    print(#function + " 에서 에러가 발생했네요... 😢")
                }
                else {
                    self.performSegue(withIdentifier: "authDone", sender: nil)
                }
            }
        }
        
    }
}

extension UserAuthViewController {
    func rejectedAlert(title: String = "알림", message: String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "다시 입력", style: .cancel, handler: nil)
        let retryAction = UIAlertAction(title: "재전송", style: .default) { (action) in
            if let phoneNumber = self.userPhoneNumberField.text {
                self.confirmUserPhoneNumber(phoneNumber)
            }
        }
        alert.addAction(cancelAction)
        alert.addAction(retryAction)
        present(alert, animated: true, completion: nil)
    }
}
