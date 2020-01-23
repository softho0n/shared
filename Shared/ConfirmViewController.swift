//
//  ConfirmViewController.swift
//  Shared
//
//  Created by Seunghun Shin on 2020/01/06.
//  Copyright © 2020 SeunghunShin. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

class ConfirmViewController: UIViewController {

    let formatter: DateFormatter = {
        let f = DateFormatter()
        f.dateStyle = .long
        f.timeStyle = .short
        f.locale = Locale(identifier: "Ko_kr")
        return f
    }()
    
    var date: Date?
    var name: String?
    var phoneNumber: String?
    var ref: DatabaseReference?
    
    @IBOutlet var userNameLabel: UILabel!
    @IBOutlet var signInDateLabel: UILabel!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        guard let name = name else {
            fatalError()
        }
        userNameLabel.text = name + "님,"
        guard let date = date else {
            fatalError()
        }
        signInDateLabel.text = "가입 일자: " + formatter.string(from: date)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference()
        
        if let uid = Auth.auth().currentUser?.uid {
            let storedData = ["userName" : name ?? "Novalue", "userPhoneNumber" : phoneNumber ?? "Novalue", "signInDate" : formatter.string(from: date!) ] as [String : Any]
            ref?.child("Users").child(uid).setValue(storedData)
            print("데이터베이스에 저장 성공! 어떤 값이 저장되었냐면 \(storedData)")
        } else {
            fatalError()
        }
        
        // Do any additional setup after loading the view.
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

