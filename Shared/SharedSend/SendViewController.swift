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
        var groupName: String!
        var totalMoney: String!
        var membername : [String] = []
        var memberuid : [String] = []
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
                DispatchQueue.global().sync {
                    ref.child("ReceiveMetaData/\(uid)").observeSingleEvent(of: .value) { (snapshot) in
                        
                    if snapshot.hasChildren() == false{
                        return
                    }
                    else{
                        for eachgroup in snapshot.children{
                            let new = eachgroup as! DataSnapshot
                            let values = new.value
                            let valueDictionary = values as! [String : [String : Any]]
                            let valuegroupinfo = valueDictionary["GroupInfo"]

                            let valuememinfo = valueDictionary["Members"]

                            let groupName = valuegroupinfo!["GroupName"] as! String
                            let totalMoney = valuegroupinfo!["TotalMoney"] as! String


                            var membername : [String] = []
                            var memberuid : [String] = [] // 나중에 알람 보낼때 쓸 각 uid
                            for eachgroupmembers in valuememinfo!
                            {
                                let eachmember = eachgroupmembers.value as! [String : Any]
                                membername.append(eachmember["userName"] as! String)
                                memberuid.append(eachgroupmembers.key)

                            }

                            self.sendList.append(payLineInfoStruct(groupName: groupName, totalMoney: totalMoney, membername: membername, memberuid: memberuid))
                        }
                        self.loader.stopAnimating()
                        self.tableView.reloadData()
                    }
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
        cell.myName.text = myName
        cell.groupName.text = sendList[indexPath.row].groupName
        
        
        cell.totalMoney.text = "\(numberFormatter.string(from: NSNumber(value:(Int(sendList[indexPath.row].totalMoney)!)))!)/ \(sendList[indexPath.row].membername.count+1)"
        
       
        
       
        
        let permoney = (Int(sendList[indexPath.row].totalMoney)!) / (sendList[indexPath.row].membername.count+1)
        let result = numberFormatter.string(from: NSNumber(value:permoney))!

        cell.perMoney.text = "=\(result)"
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        <#code#>
    }
    
    
}
