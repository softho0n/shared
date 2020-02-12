//
//  AccountListViewController.swift
//  Shared
//
//  Created by Seunghun Shin on 2020/01/24.
//  Copyright © 2020 SeunghunShin. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class AccountListViewController: UIViewController {

    var ref: DatabaseReference!
    @IBOutlet var tableView: UITableView!
    @IBOutlet var loader: UIActivityIndicatorView!
    
    struct accountInfoStruct {
        var bank: String!
        var accountNumber: String!
    }
    
    var accountList = [accountInfoStruct]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBackButton()
        ref = Database.database().reference()
        getDate()
    }
    
    func getDate()
    {
        if let uid = Auth.auth().currentUser?.uid {
            DispatchQueue.global().sync {
                self.loader.startAnimating()
                ref.child("Accounts/\(uid)").observeSingleEvent(of: .value, with: {(snapshot) in
                    for item in snapshot.children {
                        let value = (item as! DataSnapshot).value
                        let key = (item as! DataSnapshot).key
                        if let account = value {
                            self.accountList.append(accountInfoStruct(bank: key, accountNumber: account as! String))
                        }
                    }
                    self.loader.stopAnimating()
                    self.tableView.reloadData()
                })
            }
        }
    }
}

extension AccountListViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return accountList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "accountCell", for: indexPath) as! AccountTableViewCell
        cell.bankName.text = accountList[indexPath.row].bank
        cell.accountNumber.text = accountList[indexPath.row].accountNumber
        return cell
    }
}



