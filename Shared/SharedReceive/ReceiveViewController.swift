//
//  ReceiveViewController.swift
//  Shared
//
//  Created by Seunghun Shin on 2020/01/24.
//  Copyright © 2020 SeunghunShin. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class ReceiveViewController: UIViewController {
    var ref = DatabaseReference()
    @IBOutlet var tableView: UITableView!
    
    struct payLineInfoStruct {
        var groupKey: String!
        var groupName: String!
        var totalMoney: String!
        var membername : [String] = []
        var memberuid : [String] = []
    }
    var receiveList = [payLineInfoStruct]()
    
    //임시코드
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
        ref = Database.database().reference()
        //getFBData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.alert(message: "Receive View Will Appear")
    }
    
//    func getFBData(){
//
//            if let uid = Auth.auth().currentUser?.uid{
//                DispatchQueue.global().sync {
//                    ref.child("ReceiveMetaData/\(uid)").observeSingleEvent(of: .value) { (snapshot) in
//
//                    if snapshot.hasChildren() == false{
//                        return
//                    }
//                    else{
//                        for eachgroup in snapshot.children{
//                            let new = eachgroup as! DataSnapshot
//                            let values = new.value
//                            let valueDictionary = values as! [String : [String : Any]]
//                            let valuegroupinfo = valueDictionary["GroupInfo"]
//
//                            let valuememinfo = valueDictionary["Members"]
//
//                            let groupName = valuegroupinfo!["GroupName"] as! String
//                            let totalMoney = valuegroupinfo!["TotalMoney"] as! String
//
//
//                            var membername : [String] = []
//                            var memberuid : [String] = [] // 나중에 알람 보낼때 쓸 각 uid
//                            for eachgroupmembers in valuememinfo!
//                            {
//                                let eachmember = eachgroupmembers.value as! [String : Any]
//                                membername.append(eachmember["userName"] as! String)
//                                memberuid.append(eachgroupmembers.key)
//
//                            }
//
//                            self.sendList.append(payLineInfoStruct(groupKey: new.key ,groupName: groupName, totalMoney: totalMoney, membername: membername, memberuid: memberuid))
//                        }
//                        self.loader.stopAnimating()
//                        self.tableView.reloadData()
//                    }
//                }
//            }
//        }
//    }

}
