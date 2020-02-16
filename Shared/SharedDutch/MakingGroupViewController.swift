//
//  MakingGroupViewController.swift
//  Shared
//
//  Created by Seunghun Shin on 2020/02/14.
//  Copyright © 2020 SeunghunShin. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class MakingGroupViewController: UIViewController {
    struct myFriendInfoStruct {
        var userName: String!
        var userPhoneNum: String!
        var userDate: String!
    }
    
    var ref: DatabaseReference!
    var checkedCount = 0
    var myFiendList = [myFriendInfoStruct]()
    var filteredList = [myFriendInfoStruct]()
    
    @IBOutlet var loader: UIActivityIndicatorView!
    @IBOutlet var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBackButton()
        tableView.separatorStyle = UITableViewCell.SeparatorStyle.singleLine
        tableView.cellLayoutMarginsFollowReadableWidth = false
        tableView.tableFooterView = UIView()
        ref = Database.database().reference()
        getDate()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.checkedCount = 0
        self.filteredList.removeAll()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        resetChecks()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc = segue.destination as! DutchBalanceViewController
        vc.groupInfoList = filteredList
        vc.totalCount = checkedCount
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func getDate()
    {
        if let uid = Auth.auth().currentUser?.uid {
            DispatchQueue.global().sync {
                self.loader.startAnimating()
                ref.child("Friends").child(uid).observeSingleEvent(of: .value, with: {(snapshot) in
                    for item in snapshot.children {
                        let value = (item as! DataSnapshot).value
                        let dictionary = value as! [String : Any]
                        if let userName = dictionary["userName"] as? String, let userPhoneNumber = dictionary["userPhoneNumber"] as? String, let signInDate = dictionary["signInDate"] as? String {
                            self.myFiendList.append(myFriendInfoStruct(userName: userName, userPhoneNum: userPhoneNumber , userDate: signInDate))
                        }
                    }
                    self.loader.stopAnimating()
                    print(self.myFiendList)
                    self.tableView.reloadData()
                })
            }
        }
    }
    
    func resetChecks(){
       for i in 0 ..< tableView.numberOfRows(inSection: 0){
           let indexPath = IndexPath(row: i, section: 0)
           if let cell = tableView.cellForRow(at: indexPath){
               cell.accessoryType = .none
           }
       }
    }
    
    func filterData() {
        for i in 0 ..< tableView.numberOfRows(inSection: 0){
            let indexPath = IndexPath(row: i, section: 0)
            if let cell = tableView.cellForRow(at: indexPath){
                if(cell.accessoryType == .checkmark) {
                    self.checkedCount += 1
                    self.filteredList.append(self.myFiendList[i])
                }
            }
        }
    }
    
    @IBAction func makeGroupBtn(_ sender: Any) {
        filterData()
        if(self.checkedCount == 0) {
            self.alert(message: "한 명 이상 선택해주세요.")
        } else {
            self.performSegue(withIdentifier: "segueForSetMoney", sender: nil)
        }
    }
}

extension MakingGroupViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.myFiendList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "userInfoCell", for: indexPath) as! UserInfoTableViewCell
        
        cell.userNameLabel.text = self.myFiendList[indexPath.row].userName
        cell.userPhoneNumberLabel.text = self.myFiendList[indexPath.row].userPhoneNum
        cell.signInDateLabel.text = self.myFiendList[indexPath.row].userDate
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView.cellForRow(at: indexPath)?.accessoryType == UITableViewCell.AccessoryType.checkmark{
            tableView.cellForRow(at: indexPath)?.accessoryType = UITableViewCell.AccessoryType.none
        }
        else{
            tableView.cellForRow(at: indexPath)?.accessoryType = UITableViewCell.AccessoryType.checkmark
        }
    }
}
