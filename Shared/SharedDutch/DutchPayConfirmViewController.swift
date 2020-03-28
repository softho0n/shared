//
//  DutchPayConfirmViewController.swift
//  Shared
//
//  Created by Seunghun Shin on 2020/02/16.
//  Copyright © 2020 SeunghunShin. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class DutchPayConfirmViewController: UIViewController {
    let formatter: DateFormatter = {
        let f = DateFormatter()
        f.dateStyle = .long
        f.timeStyle = .long
        f.locale = Locale(identifier: "Ko_kr")
        return f
    }()
    
    var date = Date()
    var totalCount = 0
    var receiveGroupInfo = [MakingGroupViewController.myFriendInfoStruct]()
    var dutchBalance: String = ""
    var devidedBalance: String = ""
    var ref: DatabaseReference!
    var userMetaData: Any?
    var groupName: String?
    
    @IBOutlet var tableView: UITableView!
    @IBOutlet var dutchInfoLabel: UILabel!
    @IBOutlet var createDutchPayGroupButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference()
        self.navigationItem.title = "더치페이 생성"
        
        tableView.separatorStyle = UITableViewCell.SeparatorStyle.singleLine
        tableView.cellLayoutMarginsFollowReadableWidth = false
        tableView.tableFooterView = UIView()
        
        dutchInfoLabel.text = "총 \(totalCount + 1)명 \(dutchBalance)원"
        createDutchPayGroupButton.addTarget(self, action: #selector(dutchPayConfirm), for: .touchUpInside)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        dutchBalance = (dutchBalance.replacingOccurrences(of: ",", with: ""))
        
        if let intValueOfDutchBalance = Int(dutchBalance) {
            devidedBalance = DecimalWon(value: intValueOfDutchBalance)
        }
    }
    
    @objc
    func dutchPayConfirm() {
        alertWithConfirm()
    }

    func setDutchPayData() {
        if let uid = Auth.auth().currentUser?.uid {
            ref.child("Users/\(uid)").observeSingleEvent(of: .value) { (snapshot) in
                self.userMetaData = snapshot.value
            }
            
            ref.child("ReceiveBalance/\(uid)").observeSingleEvent(of: .value) { (snapshot) in
                let totalMoney = (Int(self.dutchBalance)! - (Int(self.dutchBalance)! / (self.totalCount + 1)))
                if snapshot.value is NSNull {
                    self.ref.child("ReceiveBalance/\(uid)").setValue("\(totalMoney)")
                } else {
                    let totalMoney = Int(snapshot.value as! String)! + totalMoney
                    self.ref.child("ReceiveBalance/\(uid)").setValue("\(totalMoney)")
                }
            }
            
            
            if let uniquekey = self.ref.child("ReceiveMetaData").child(uid).childByAutoId().key {
                var groupDictionary : [String : String] = [:]
                if self.groupName == nil {
                    groupDictionary.updateValue(myName!, forKey: "GroupBy")
                    groupDictionary.updateValue(" ", forKey: "GroupName")
                    groupDictionary.updateValue(self.dutchBalance, forKey: "TotalMoney")
                } else {
                    groupDictionary.updateValue(myName!, forKey: "GroupBy")
                    groupDictionary.updateValue(self.groupName!, forKey: "GroupName")
                    groupDictionary.updateValue(self.dutchBalance, forKey: "TotalMoney")
                    groupDictionary.updateValue("\(self.receiveGroupInfo.count + 1)", forKey: "NumOfMembers")
                }
                self.ref.child("ReceiveMetaData/\(uid)/\(uniquekey)").child("GroupInfo").setValue(groupDictionary)

                ref.child("Friends/\(uid)").observeSingleEvent(of: .value) { (snapshot) in
                    let dictionary = (snapshot.value) as! [String: [String:Any]]
                    for index in dictionary {
                        for groupInfo in self.receiveGroupInfo {
                            if (index.value["userName"] as! String == groupInfo.userName) {
                                var members: [String : String] = [:]
                                members.updateValue(index.value["userName"] as! String, forKey: "userName")
                                members.updateValue(index.value["userPhoneNumber"] as! String, forKey: "userPhoneNumber")
                                members.updateValue("false", forKey: "status")
                                self.ref.child("ReceiveMetaData/\(uid)/\(uniquekey)/Members/\(index.key)").setValue(members)
                                
                                var eachMemberInfo: [String : String] = [:]
                                eachMemberInfo.updateValue("\(uid)", forKey: "groupBy")
                                eachMemberInfo.updateValue("\(Int(self.dutchBalance)! / (self.totalCount + 1))", forKey: "eachBalance")
                                self.ref.child("SendMetaData/\(index.key)/\(uniquekey)/").setValue(eachMemberInfo)
                            }
                        }
                    }
                }
            }
        }
    }
    
    func DecimalWon(value: Int) -> String{
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        let result = numberFormatter.string(from: NSNumber(value: value / (totalCount + 1)))! + "원"
        return result
    }
}

extension DutchPayConfirmViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return receiveGroupInfo.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "InfoOfDutchPayCell", for: indexPath) as! DutchInfoTableViewCell
        cell.dutchMoneyLabel.text = devidedBalance
        cell.userNameLabel.text = receiveGroupInfo[indexPath.row].userName
        cell.userPhoneNumberLabel.text = receiveGroupInfo[indexPath.row].userPhoneNum
        return cell
    }
}

extension DutchPayConfirmViewController {
    func alertWithConfirm(title: String = "알림"){
        let alert = UIAlertController(title: title, message: "더치페이 생성완료!", preferredStyle: .alert)
        let action = UIAlertAction(title: "확인", style: .default) { (action) in
                if #available(iOS 13.0, *) {
                    self.setDutchPayData()
                    let vc = self.storyboard?.instantiateViewController(identifier: "mainUI")
                    self.navigationController?.pushViewController(vc!, animated: true)
                } else {
                    fatalError()
                }
            
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
}
