//
//  SendViewController.swift
//  Shared
//
//  Created by Seunghun Shin on 2020/01/24.
//  Copyright © 2020 SeunghunShin. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class SendViewController: UIViewController {
    
    @IBOutlet var loader: UIActivityIndicatorView!
    @IBOutlet var tableView: UITableView!

    struct payLineInfoStruct {
        var groupKey: String!
        var groupName: String!
        var totalMoney: String!
        var numOfMembers : String!
        var perMoney : String!
        var groupBy : String!
    }
    
    struct searchingInfoStruct {
        var groupKey: String!
        var perMoney: String!
    }
    
    var sendList = [payLineInfoStruct]()
    var ref: DatabaseReference!
    var count = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
        self.tableView.showsVerticalScrollIndicator = false
        self.tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        
        ref = Database.database().reference()
        sendList.removeAll()
        getFBData()
    }

    func getFBData(){
         if let uid = Auth.auth().currentUser?.uid{
             var searchingInfo = [searchingInfoStruct]()
             var madePersonKey : [String] = []
             DispatchQueue.global().sync {
                 // Note: SendBalance에서 내가 내야할 금액과, 그룹의 Key값 가져오기
                 ref.child("SendBalance/\(uid)").observeSingleEvent(of: .value) { (snapshot) in
                    if snapshot.hasChildren() == false{
                        return
                    } else {
                        for mySendData in snapshot.children {
                            let eachGroup = mySendData as! DataSnapshot
                            searchingInfo.append(searchingInfoStruct(groupKey: eachGroup.key , perMoney: eachGroup.value as? String))
                        }
                        print(searchingInfo)
                    }
                 }
                
                 // Note: Sendmetadata애소 가 그룹의 그룹장의 id를 가져오기.
                 ref.child("SendMetaData/\(uid)").observeSingleEvent(of: .value) { (snapshot) in
                    if snapshot.hasChildren() == false {
                        return
                    } else {
                        for mySendData in snapshot.children {
                            let eachgroup = mySendData as! DataSnapshot
                            madePersonKey.append(eachgroup.value as! String)
                        }
                    }
                }
                
                 // Note: 최종적으로 그룹내용 가져오기.
                 ref.child("ReceiveMetaData").observeSingleEvent(of: .value) { (snapshot) in
                     for byMemberUID in madePersonKey {
                        let valueSnapshot = snapshot.childSnapshot(forPath: "\(byMemberUID)")
                        let groupSapshot = valueSnapshot.childSnapshot(forPath: "\(searchingInfo[self.count].groupKey!)")
                        let groupValue = groupSapshot.value
                        let valueDictionary = groupValue as! [String : [String : Any]]
                        let valueGroupInfo = valueDictionary["GroupInfo"]

                        let groupName = valueGroupInfo!["GroupName"] as! String
                        let totalMoney = valueGroupInfo!["TotalMoney"] as! String
                        let numofMembers = valueGroupInfo!["NumOfMembers"] as! String
                        let groupBy = valueGroupInfo!["GroupBy"] as! String
                        
                        self.sendList.append(payLineInfoStruct(groupKey: searchingInfo[self.count].groupKey, groupName: groupName, totalMoney: totalMoney, numOfMembers: numofMembers, perMoney: searchingInfo[self.count].perMoney, groupBy: groupBy))
                        self.count += 1
                     }
                     self.loader.stopAnimating()
                     self.tableView.reloadData()
                    print(self.sendList)
                 }
             }
         }
     }
}


extension SendViewController : UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sendList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "sendCell", for: indexPath) as! SendpayLineTableViewCell
        
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        
        let perMoney = Int(sendList[indexPath.row].perMoney)!
        let result = numberFormatter.string(from: NSNumber(value:perMoney))!
        
        cell.myPhoto.layer.cornerRadius = cell.myPhoto.frame.height/2
        cell.shopPhoto.layer.cornerRadius = cell.shopPhoto.frame.height/2
        cell.groupBy.text = sendList[indexPath.row].groupBy
        cell.groupName.text = sendList[indexPath.row].groupName
        cell.totalMoney.text = "\(numberFormatter.string(from: NSNumber(value:(Int(sendList[indexPath.row].totalMoney)!)))!)/ \(Int(sendList[indexPath.row].numOfMembers)!)"
        cell.perMoney.text = "=\(result)"
        return cell
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let sendAction = UIContextualAction(style: .normal, title: "보내기", handler: { (ac:UIContextualAction, view : UIView, sucess:(Bool) -> Void) in
            self.loader.startAnimating()
            self.removeGroupByKey(indexPath.row)
            self.tableView.reloadData()
            self.loader.stopAnimating()
            sucess(true)
        })
        sendAction.backgroundColor = UIColor.systemBlue
        return UISwipeActionsConfiguration(actions: [sendAction])
    }
    
    func removeGroupByKey(_ row: Int) {
        guard let key = self.sendList[row].groupKey else { return }
        if let uid = Auth.auth().currentUser?.uid {
            let deleteSendBalanceHandler = self.ref.child("SendBalance/\(uid)").child(key)
            let deleteSendMetaDataHandler = self.ref.child("SendMetaData/\(uid)").child(key)
            
            deleteSendBalanceHandler.removeValue()
            deleteSendMetaDataHandler.removeValue()
            self.sendList.remove(at: row)
        }
    }
    
}
