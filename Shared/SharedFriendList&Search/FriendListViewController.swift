//
//  FriendListViewController.swift
//  Shared
//
//  Created by Seunghun Shin on 2020/01/24.
//  Copyright © 2020 SeunghunShin. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import FirebaseAuth

class FriendListViewController: UIViewController {
    
    var ref: DatabaseReference!
    @IBOutlet var loader: UIActivityIndicatorView!
    @IBOutlet var tableView: UITableView!
    
    struct myFriendInfoStruct {
        var userName: String!
        var userPhoneNum: String!
        var userDate: String!
    }
    
    var myFiendList = [myFriendInfoStruct]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        ref = Database.database().reference()
        getDate()
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
                    self.tableView.reloadData()
                })
            }
        }
    }
}

extension FriendListViewController : UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(self.myFiendList.count)
        return myFiendList.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "userInfoCell", for: indexPath) as! UserInfoTableViewCell
        
        cell.userNameLabel.text = myFiendList[indexPath.row].userName
        cell.userPhoneNumberLabel.text = myFiendList[indexPath.row].userPhoneNum
        cell.signInDateLabel.text = myFiendList[indexPath.row].userDate
        return cell
    }
}
