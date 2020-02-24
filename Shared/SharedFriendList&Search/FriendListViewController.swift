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
    @IBOutlet var thereIsNoFriendsView: UIView!
    
    struct myFriendInfoStruct {
        var uid: String!
        var userName: String!
        var userPhoneNum: String!
        var userDate: String!
    }
    
    var myFiendList = [myFriendInfoStruct]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.separatorStyle = UITableViewCell.SeparatorStyle.singleLine
        tableView.cellLayoutMarginsFollowReadableWidth = false
        tableView.tableFooterView = UIView()
        ref = Database.database().reference()
        getDate()
    }
    
    func getDate()
    {
        if let uid = Auth.auth().currentUser?.uid {
            DispatchQueue.global().sync {
                self.loader.startAnimating()
                ref.child("Friends").child(uid).observeSingleEvent(of: .value, with: {(snapshot) in
                    if(!snapshot.exists()) {
                        self.thereIsNoFriendsView.isHidden = false
                        self.loader.stopAnimating()
                    } else {
                        for item in snapshot.children {
                            let value = (item as! DataSnapshot).value
                            let dictionary = value as! [String : Any]
                            print(dictionary)
                            if let userName = dictionary["userName"] as? String, let userPhoneNumber = dictionary["userPhoneNumber"] as? String, let signInDate = dictionary["signInDate"] as? String {
                                let key = (item as! DataSnapshot).key
                                self.myFiendList.append(myFriendInfoStruct(uid: key, userName: userName, userPhoneNum: userPhoneNumber , userDate: signInDate))
                                print(self.myFiendList)
                            }
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
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "삭제", handler: { (ac:UIContextualAction, view : UIView, sucess:(Bool) -> Void) in
            self.loader.startAnimating()
            self.removeFriend(indexPath.row)
            sucess(true)
        })
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
    
    func removeFriend(_ row: Int) {
        if let uid = Auth.auth().currentUser?.uid, let key = self.myFiendList[row].uid {
            let deleteHandler = self.ref.child("Friends/\(uid)/\(key)")
            deleteHandler.removeValue()
            self.myFiendList.remove(at: row)
            if (self.myFiendList.isEmpty) {
                self.thereIsNoFriendsView.isHidden = false
            }
            self.tableView.reloadData()
            self.loader.stopAnimating()
        }
    }
}
