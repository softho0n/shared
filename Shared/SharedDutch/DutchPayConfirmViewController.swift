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
    
    @IBOutlet var tableView: UITableView!
    @IBOutlet var dutchInfoLabel: UILabel!
    @IBOutlet var groupName: UITextField!
    @IBAction func dutchPayConfirmBtn(_ sender: Any) {
        alertWithConfirm()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.separatorStyle = UITableViewCell.SeparatorStyle.singleLine
        tableView.cellLayoutMarginsFollowReadableWidth = false
        tableView.tableFooterView = UIView()
        ref = Database.database().reference()
        print("hello")
        print(receiveGroupInfo)
        dutchInfoLabel.text = "총 \(totalCount + 1)명 \(dutchBalance)원"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        dutchBalance = (dutchBalance.replacingOccurrences(of: ",", with: ""))
        
        if let intValueOfDutchBalance = Int(dutchBalance) {
            devidedBalance = DecimalWon(value: intValueOfDutchBalance)
        }
        
    }

    func getCurrentDate() -> String {
        return formatter.string(from: date)
    }
    
    func setDutchPayData() {
        if let uid = Auth.auth().currentUser?.uid {
            ref.child("Users/\(uid)").observeSingleEvent(of: .value) { (snapshot) in
                self.userMetaData = snapshot.value
            }
            
            ref.child("ReceiveBalance/\(uid)").observeSingleEvent(of: .value) { (snapshot) in
                let totalMoney = (Int(self.dutchBalance)! - (Int(self.dutchBalance)! / (self.totalCount + 1)))
                if snapshot.value is NSNull{
                    self.ref.child("ReceiveBalance/\(uid)").setValue("\(totalMoney)")
                }
                else{
                    let totalMoney = Int(snapshot.value as! String)! + totalMoney

                     self.ref.child("ReceiveBalance/\(uid)").setValue("\(totalMoney)")
                }
            }
            if let uniquekey = self.ref.child("ReceiveMetaData").child(uid).childByAutoId().key {
                
                var groupdic : [String : String] = [:]
                
                if self.groupName.text == nil{
                    groupdic.updateValue(myName!, forKey: "GroupBy")
                    groupdic.updateValue(" ", forKey: "GroupName")
                    groupdic.updateValue(self.dutchBalance, forKey: "TotalMoney")
                }
                else{
                    groupdic.updateValue(myName!, forKey: "GroupBy")
                    groupdic.updateValue(self.groupName.text!, forKey: "GroupName")
                    groupdic.updateValue(self.dutchBalance, forKey: "TotalMoney")
                    groupdic.updateValue("\(self.receiveGroupInfo.count)", forKey: "NumOfMembers")
                }
                
                self.ref.child("ReceiveMetaData/\(uid)/\(uniquekey)").child("GroupInfo").setValue(groupdic)
                
                

                
            ref.child("Friends/\(uid)").observeSingleEvent(of: .value) { (snapshot) in
                let dictionary = (snapshot.value) as! [String: [String:Any]]
                            
                for index in dictionary {
                    for groupInfo in self.receiveGroupInfo {
                        if (index.value["userName"] as! String == groupInfo.userName) {
                            var memberdic : [String : String] = [:]
                            memberdic.updateValue(index.value["userName"] as! String, forKey: "userName")
                            memberdic.updateValue(index.value["userPhoneNumber"] as! String, forKey: "userPhoneNumber")
                            
                            self.ref.child("ReceiveMetaData/\(uid)/\(uniquekey)/Members/\(index.key)").setValue(memberdic)
//                            self.ref.child("AllReceiveBalance/\(uid)/\(uniquekey)").setValue(Int(self.dutchBalance)! / (self.totalCount + 1))
                            self.ref.child("SendMetaData/\(index.key)/\(uniquekey)/").setValue(uid)
                            self.ref.child("SendBalance/\(index.key)/\(uniquekey)/").setValue("\(Int(self.dutchBalance)! / (self.totalCount + 1))")
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
