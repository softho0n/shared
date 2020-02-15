//
//  HomeViewController.swift
//  Shared
//
//  Created by Seunghun Shin on 2020/01/08.
//  Copyright © 2020 SeunghunShin. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth

class HomeViewController: UIViewController {

    var ref: DatabaseReference!
    var userInfo: [String : Any]! = nil
    
    @IBOutlet var bank: UILabel!
    @IBOutlet var account: UILabel!
    @IBOutlet var balance: UILabel!
    @IBOutlet var sharedMoney: UILabel!
    
    @IBOutlet var loader: UIActivityIndicatorView!
    @IBOutlet var userNameLabel: UILabel!
    @IBOutlet var signitureInfoView: UIView!
    @IBOutlet var setAccountView: UIView!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loader.backgroundColor = UIColor.white
        
        ref = Database.database().reference()
        
        DispatchQueue.global().sync {
            loader.startAnimating()
            if let uid = Auth.auth().currentUser?.uid {
                ref.child("Signiture/\(uid)").observeSingleEvent(of: .value) { (snapshot) in
                    if(!snapshot.exists()) {
                        self.signitureInfoView.isHidden = true
                    }
                    else {
                        self.setAccountView.isHidden = true
                        for item in snapshot.children {
                            let value = (item as! DataSnapshot).value
                            let key = (item as! DataSnapshot).key
                            if let accountNumber = value{
                                self.account.text = accountNumber as! String
                                self.bank.text = key
                                self.balance.text = "서비스 미지원"
                            }
                        }
                    }
                }
                ref.child("SharedMoney/\(uid)").observeSingleEvent(of: .value) { (snapshot) in
                    for item in snapshot.children {
                        let value = (item as! DataSnapshot).value
                        if let sM = value{
                            let intValueofSm = sM as! Int
                            self.sharedMoney.text = "\(intValueofSm.withComma)원"
                        }
                    }
                }
                ref.child("Users").child(uid).observeSingleEvent(of: .value) { (snapshot) in
                    self.userInfo = snapshot.value as? [String : Any]
                    if let name = self.userInfo["userName"] as! String?{
                        self.userNameLabel.text = name + "님,"
                        myName = name
                        self.loader.stopAnimating()
                        self.loader.backgroundColor = UIColor.clear
                    }
                }
            }
        }
    }
}

