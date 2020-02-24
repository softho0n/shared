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
    @IBOutlet var loader: UIActivityIndicatorView!
    

    struct memberInfoStruct {
        var memberName : String!
        var memberUid : String!
        var memberPhoneNum : String!
    }
    
    struct receivePayLineInfoStruct {
        var groupName: String!
        var numOfMembers: String!
        var totalMoney: String!
    }
    var receiveList = [receivePayLineInfoStruct]()
    var memberList = [memberInfoStruct]()
    
    //임시코드
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
        tableView.showsVerticalScrollIndicator = false
        tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        ref = Database.database().reference()
        getFBData()
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
                            let groupName = valuegroupinfo!["GroupName"] as! String
                            let totalMoney = valuegroupinfo!["TotalMoney"] as! String
                            let numOfMembers = valuegroupinfo!["NumOfMembers"] as! String

                            let valueMemInfo = valueDictionary["Members"]

                            for eachGroupMember in valueMemInfo!
                            {
                                let eachmember = eachGroupMember.value as! [String : Any]
                                let status = eachmember["status"] as! String
                                if status == "false"{
                                    let userName = eachmember["userName"] as! String
                                    let userPhoneNumber = eachmember["userPhoneNumber"] as! String
                                    self.memberList.append(memberInfoStruct(memberName: userName, memberUid: eachGroupMember.key, memberPhoneNum: userPhoneNumber))
                                }
                            }

                            self.receiveList.append(receivePayLineInfoStruct(groupName: groupName, numOfMembers: numOfMembers, totalMoney: totalMoney))
                        }
                        self.loader.stopAnimating()
                        self.tableView.reloadData()
                    }
                }
            }
        }
    }

}
extension ReceiveViewController : UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return receiveList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "receiveCell", for: indexPath) as! ReceivePayLineTableViewCell
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        let perMoney = (Int(receiveList[indexPath.row].totalMoney)! / (Int(receiveList[indexPath.row].numOfMembers)!))
        let result = numberFormatter.string(from: NSNumber(value:perMoney))!
        
        cell.receivePersonPhoto.layer.cornerRadius = cell.receivePersonPhoto.frame.height/2
        cell.shopPhoto.layer.cornerRadius = cell.shopPhoto.frame.height/2
        cell.receivePerson.text = myName
        cell.groupName.text = receiveList[indexPath.row].groupName
        cell.perMoney.text = "= \(result) 원"
        cell.totalMoney.text = "\(numberFormatter.string(from: NSNumber(value:(Int(receiveList[indexPath.row].totalMoney)!)))!)/ \(Int(receiveList[indexPath.row].numOfMembers)!)"
        return cell
    }
    
    
}
