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
    var ref: DatabaseReference!
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
    
    var sendList = [payLineInfoStruct]()
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
        ref = Database.database().reference()
        tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        sendList.removeAll()
        getFBData()

        
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
    }
    
    func getFBData(){

         
         if let uid = Auth.auth().currentUser?.uid{
             
             struct searchingInfoStruct {
                 var groupKey: String!
                 var perMoney: String!
             }
             var searchingInfo = [searchingInfoStruct]()
             var madePersonKey : [String] = []
             
             DispatchQueue.global().sync {
                 //SendBalance에서 내가 내야할 금액과, 그룹의 Key값 가져오기
                 ref.child("SendBalance/\(uid)").observeSingleEvent(of: .value) { (snapshot) in
                     
                 if snapshot.hasChildren() == false{
                     return
                 }
                 else{
                     for mySendData in snapshot.children{
                         let eachgroup = mySendData as! DataSnapshot
                         searchingInfo.append(searchingInfoStruct(groupKey: eachgroup.key , perMoney: eachgroup.value as? String))
                     }
                     print(searchingInfo)
                     }
                     
                 }
                 //sendmetadata애소 가 그룹의 그룹장의 id를 가져오기.
                 ref.child("SendMetaData/\(uid)").observeSingleEvent(of: .value) { (snapshot) in
                     
                 if snapshot.hasChildren() == false{
                     return
                 }
                 else{
                     for mySendData in snapshot.children{
                         let eachgroup = mySendData as! DataSnapshot
                         madePersonKey.append(eachgroup.value as! String)
                     }
                     
                     }
                     
                 }
                 //최종적으로 그룹내용 가져오기.
                 ref.child("ReceiveMetaData").observeSingleEvent(of: .value) { (snapshot) in
                     var count = 0
                     for bymemberuid in madePersonKey{
                        let valueSnapshot = snapshot.childSnapshot(forPath: "\(bymemberuid)")
                        let groupSapshot = valueSnapshot.childSnapshot(forPath: "\(searchingInfo[count].groupKey!)")
                        let groupValue = groupSapshot.value
                        let valueDictionary = groupValue as! [String : [String : Any]]
                        let valuegroupinfo = valueDictionary["GroupInfo"]

                        let groupName = valuegroupinfo!["GroupName"] as! String
                        let totalMoney = valuegroupinfo!["TotalMoney"] as! String
                        let numofMembers = valuegroupinfo!["NumOfMembers"] as! String
                        let groupBy = valuegroupinfo!["GroupBy"] as! String
                        
                        self.sendList.append(payLineInfoStruct(groupKey: searchingInfo[count].groupKey, groupName: groupName, totalMoney: totalMoney, numOfMembers: numofMembers, perMoney: searchingInfo[count].perMoney, groupBy: groupBy))
                        
                         count = count + 1
                        
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
        
        cell.myPhoto.layer.cornerRadius = cell.myPhoto.frame.height/2
        cell.shopPhoto.layer.cornerRadius = cell.shopPhoto.frame.height/2
        cell.groupBy.text = sendList[indexPath.row].groupBy
        cell.groupName.text = sendList[indexPath.row].groupName
        
        
        cell.totalMoney.text = "\(numberFormatter.string(from: NSNumber(value:(Int(sendList[indexPath.row].totalMoney)!)))!)/ \(Int(sendList[indexPath.row].numOfMembers)!)"
        
       
        
       
        
        let permoney = Int(sendList[indexPath.row].perMoney)!
        let result = numberFormatter.string(from: NSNumber(value:permoney))!

        cell.perMoney.text = "=\(result)"
        return cell
    }
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let sendAction = UIContextualAction(style: .normal, title: "보내기", handler: { (ac:UIContextualAction, view : UIView, sucess:(Bool) -> Void) in
            self.loader.startAnimating()
            self.sendList.remove(at: indexPath.row)
            self.removegroupinDB()
            tableView.reloadData()
            self.loader.stopAnimating()
            sucess(true)
        })
        sendAction.backgroundColor = UIColor.systemBlue
        return UISwipeActionsConfiguration(actions: [sendAction])
    }
    
    func removegroupinDB(){
        
    }
    
}
