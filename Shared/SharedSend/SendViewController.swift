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
        var madePersonKey : String!
    }
    
    struct searchingInfoStruct {
        var groupKey: String!
        var perMoney: String!
        var madePersonKey : String!
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
             DispatchQueue.global().sync {
                
                 // Note: Sendmetadata에서 그룹장Id, 그룹hash값, 각 금액 가져오기. ,uid로 바꾸기
                
                ref.child("SendMetaData/\(uid)").observeSingleEvent(of: .value) { (snapshot) in
                    if snapshot.hasChildren() == false {
                        self.loader.stopAnimating()
                        self.tableView.reloadData()
                        //데이터가 비어있을때의 상황
                        return
                    } else {
                        for mySendData in snapshot.children {
                            let rawEachGroup = mySendData as! DataSnapshot
                            let eachGroupInfo = rawEachGroup.value as! [String: String]
                            searchingInfo.append(searchingInfoStruct(groupKey: rawEachGroup.key, perMoney: eachGroupInfo["eachBalance"], madePersonKey: eachGroupInfo["groupBy"]))
                        }
                    }
                }
                 // Note: 최종적으로 그룹내용 가져오기.
                 ref.child("ReceiveMetaData").observeSingleEvent(of: .value) { (snapshot) in
                     for eachGroupInfo in searchingInfo {
                        let groupSnapshot = snapshot.childSnapshot(forPath: "\(eachGroupInfo.madePersonKey!)/\(eachGroupInfo.groupKey!)")
                        if groupSnapshot.hasChildren() == false{
                            self.loader.stopAnimating()
                            self.tableView.reloadData()
                            //데이터가 비어있을때의 상황
                            return
                        }
                        else{
                            let groupValue = groupSnapshot.value
                            let valueDictionary = groupValue as! [String : [String : Any]]
                            let valueGroupInfo = valueDictionary["GroupInfo"]

                            let groupName = valueGroupInfo!["GroupName"] as! String
                            let totalMoney = valueGroupInfo!["TotalMoney"] as! String
                            let numofMembers = valueGroupInfo!["NumOfMembers"] as! String
                            let groupBy = valueGroupInfo!["GroupBy"] as! String
                            
                            self.sendList.append(payLineInfoStruct(groupKey: searchingInfo[self.count].groupKey, groupName: groupName, totalMoney: totalMoney, numOfMembers: numofMembers, perMoney: searchingInfo[self.count].perMoney, groupBy: groupBy, madePersonKey: searchingInfo[self.count].madePersonKey))

                            self.count += 1
                        }
                     }
                     self.loader.stopAnimating()
                     self.tableView.reloadData()
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
            let deleteSendMetaDataHandler = self.ref.child("SendMetaData/\(uid)").child(key)
            guard let madePersonKey = self.sendList[row].madePersonKey else {return}
            let toggleSendStatusHandler = self.ref.child("ReceiveMetaData/\(madePersonKey)/\(key)/Members/\(uid)")
            let trueHandler : [String : String] = ["status" : "true"]

            deleteSendMetaDataHandler.removeValue()
            toggleSendStatusHandler.updateChildValues(trueHandler)
            
            self.sendList.remove(at: row)
        }
    }
    
}
