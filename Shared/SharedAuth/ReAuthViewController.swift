//
//  ReAuthViewController.swift
//  Shared
//
//  Created by Seunghun Shin on 2020/01/06.
//  Copyright © 2020 SeunghunShin. All rights reserved.
//

import UIKit
import FirebaseAuth

class ReAuthViewController: UIViewController {

    @IBOutlet var userPhoneNumberField: UITextField!
    @IBOutlet var userAuthLabel: UILabel!
    @IBOutlet var userAuthField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        userPhoneNumberField.keyboardType = .phonePad
        userAuthField.keyboardType = .numberPad
        addToolbarToVerifyPhoneNumber(userPhoneNumberField, "보내기")
        
        Auth.auth().languageCode = "ko"
        // Do any additional setup after loading the view.
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
                    self.performSegue(withIdentifier: "reAuthDone", sender: nil)
                }
            }
        }
        
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

extension ReAuthViewController {
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

