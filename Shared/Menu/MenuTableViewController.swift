//
//  MenuTableViewController.swift
//  Shared
//
//  Created by softhoon on 2020/02/03.
//  Copyright © 2020 SeunghunShin. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class MenuTableViewController: UITableViewController {
    @IBOutlet var myPhoto: UIImageView!
    @IBOutlet var nameLabel: UILabel!
    @IBAction func logOutButton(_ sender: Any) {
            do{
                try Auth.auth().signOut()
            }
            catch let error as NSError
            {
                print(error.localizedDescription)
            }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        myPhoto.layer.cornerRadius = myPhoto.frame.height/2
        nameLabel.text = "\(myName!)님"
        tableView.cellLayoutMarginsFollowReadableWidth = false
        tableView.tableFooterView = UIView()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 2
    }
}
