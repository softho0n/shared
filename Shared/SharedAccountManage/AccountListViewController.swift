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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(accountList[indexPath.row])
        alertWithConfirm(bank: accountList[indexPath.row].bank, account: accountList[indexPath.row].accountNumber)
    }
}

extension AccountListViewController {
    func alertWithConfirm(title: String = "알림", bank: String, account: String){
        let alert = UIAlertController(title: title, message: "\(bank) 계좌를 출금계좌로 등록합니다.", preferredStyle: .alert)
        let action = UIAlertAction(title: "등록하기", style: .default) { (action) in
            if let uid = Auth.auth().currentUser?.uid{
                self.ref?.child("Signiture/\(uid)").setValue([bank: account])
                if #available(iOS 13.0, *) {
                    let vc = self.storyboard?.instantiateViewController(identifier: "mainUI")
                    self.navigationController?.pushViewController(vc!, animated: true)
                } else {
                    fatalError()
                }
            }
        }
        let cancel = UIAlertAction(title: "취소", style: .destructive, handler: nil)
        alert.addAction(action)
        alert.addAction(cancel)
        present(alert, animated: true, completion: nil)
    }
}



