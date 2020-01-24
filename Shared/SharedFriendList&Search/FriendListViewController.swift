//
//  FriendListViewController.swift
//  Shared
//
//  Created by Seunghun Shin on 2020/01/24.
//  Copyright © 2020 SeunghunShin. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import FirebaseAuth

class FriendListViewController: UIViewController {
    @IBOutlet var loader: UIActivityIndicatorView!
    @IBOutlet var tableView: UITableView!
    
    struct myFriendInfoStruct {
        var userName: String!
        var userPhoneNum: String!
        var userDate: String!
    }
    
    var myFiendList = [myFriendInfoStruct]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        getdata()

        // Do any additional setup after loading the view.
    }
    
    func getdata()
    {
        let myUid = Auth.auth().currentUser?.uid
        DispatchQueue.global().sync {
            self.loader.startAnimating()
            Database.database().reference().child("Friends").child(myUid!).observeSingleEvent(of: .value, with: {(snapshot) in
            
            for items in snapshot.children
            {
                let tempo = items as! DataSnapshot
                let value = tempo.value
                let valuetempo = value as! [String : Any]
                let userName = valuetempo["userName"] as! String
                let userPhoneNum = valuetempo["userPhoneNumber"] as! String
                let userDate = valuetempo["signInDate"] as! String
                self.myFiendList.append(myFriendInfoStruct(userName: userName, userPhoneNum: userPhoneNum , userDate: userDate))
                
            }
            print(self.myFiendList)
            self.loader.stopAnimating()
            self.tableView.reloadData()
        })
            
            
    }
}
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
extension FriendListViewController : UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(self.myFiendList.count)
        return myFiendList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "userInfoCell", for: indexPath) as! UserInfoTableViewCell
        
        cell.userNameLabel.text = myFiendList[indexPath.row].userName
        cell.userPhoneNumberLabel.text = myFiendList[indexPath.row].userPhoneNum
        cell.signInDateLabel.text = myFiendList[indexPath.row].userDate
        return cell
    }
    
    
}
