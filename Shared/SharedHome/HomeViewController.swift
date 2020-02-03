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
    
    @IBOutlet var loader: UIActivityIndicatorView!
    @IBOutlet var userNameLabel: UILabel!
    
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
