//
//  MakingGroupViewController.swift
//  Shared
//
//  Created by Seunghun Shin on 2020/02/14.
//  Copyright © 2020 SeunghunShin. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class MakingGroupViewController: UIViewController {
    struct myFriendInfoStruct {
        var userName: String!
        var userPhoneNum: String!
        var userDate: String!
    }
    
    var ref: DatabaseReference!
    var checkedCount = 0
    var myFiendList = [myFriendInfoStruct]()
    
    @IBOutlet var loader: UIActivityIndicatorView!
    @IBOutlet var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.separatorStyle = UITableViewCell.SeparatorStyle.singleLine
        tableView.cellLayoutMarginsFollowReadableWidth = false
        tableView.tableFooterView = UIView()
        loader.backgroundColor = UIColor.white
        ref = Database.database().reference()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func getDate()
    {
        if let uid = Auth.auth().currentUser?.uid {
            DispatchQueue.global().sync {
                self.loader.startAnimating()
                ref.child("Friends").child(uid).observeSingleEvent(of: .value, with: {(snapshot) in
                    for item in snapshot.children {
                        let value = (item as! DataSnapshot).value
                        let dictionary = value as! [String : Any]
                        if let userName = dictionary["userName"] as? String, let userPhoneNumber = dictionary["userPhoneNumber"] as? String, let signInDate = dictionary["signInDate"] as? String {
                            self.myFiendList.append(myFriendInfoStruct(userName: userName, userPhoneNum: userPhoneNumber , userDate: signInDate))
                        }
                    }
                    self.loader.stopAnimating()
                    self.loader.backgroundColor = UIColor.clear
                    self.tableView.reloadData()
                })
            }
        }
    }
    
    
    @IBAction func makeGroupBtn(_ sender: Any) {
    }
}

extension MakingGroupViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.myFiendList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        <#code#>
    }
    
    
}
