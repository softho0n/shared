//
//  DetailPersonViewController.swift
//  Shared
//
//  Created by softhoon on 2020/02/24.
//  Copyright © 2020 SeunghunShin. All rights reserved.
//

import UIKit

class DetailPersonViewController: UIViewController {

    @IBOutlet var tableView: UITableView!
    
    var detailMemberList = [ReceiveViewController.memberInfoStruct]()
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.cellLayoutMarginsFollowReadableWidth = false
        
    }
}

extension DetailPersonViewController : UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return detailMemberList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "detailMember", for: indexPath) as! DetailPersonTableViewCell
        cell.memberName.text = detailMemberList[indexPath.row].memberName
        cell.memberPhoneNum.text = detailMemberList[indexPath.row].memberPhoneNum
        
        if detailMemberList[indexPath.row].status == "true" {
            cell.accessoryType = .checkmark
        }
        else{
            cell.accessoryType = .none
        }
        
        return cell
    }

        
}
