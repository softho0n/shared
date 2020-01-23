//
//  ReConfirmViewController.swift
//  Shared
//
//  Created by Seunghun Shin on 2020/01/06.
//  Copyright © 2020 SeunghunShin. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class ReConfirmViewController: UIViewController {

    var ref: DatabaseReference!
    var userInfo: [String : Any]! = nil
    @IBOutlet var loader: UIActivityIndicatorView!
    @IBOutlet var userNameLabel: UILabel!
    @IBOutlet var userComeBackLabel: UILabel!
    @IBOutlet var signInDateLabel: UILabel!
    @IBOutlet var serviceStartButton: UIButton!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        ref = Database.database().reference()
        
        DispatchQueue.global().sync {
            loader.startAnimating()
            if let uid = Auth.auth().currentUser?.uid {
                ref.child("Users").child(uid).observeSingleEvent(of: .value) { (snapshot) in
                    self.userInfo = snapshot.value as? [String : Any]
                    print("\(uid) 의 데이터 로딩 완료 \(self.userInfo!)")

                    if let name = self.userInfo["userName"] as! String?, let date = self.userInfo["signInDate"] as! String? {
                        self.userNameLabel.text = name + "님,"
                        self.signInDateLabel.text = "가입 일자 : " + date
                        
                        self.loader.stopAnimating()
                        
                        self.userNameLabel.isHidden = false
                        self.userComeBackLabel.isHidden = false
                        self.signInDateLabel.isHidden = false
                        self.serviceStartButton.isHidden = false
                    }
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
