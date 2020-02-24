//
//  DetailPersonViewController.swift
//  Shared
//
//  Created by softhoon on 2020/02/24.
//  Copyright © 2020 SeunghunShin. All rights reserved.
//

import UIKit

class DetailPersonViewController: UIViewController {

  
    var detailMemberList = [ReceiveViewController.memberInfoStruct]()
    override func viewDidLoad() {
        super.viewDidLoad()
    }

}
extension DetailPersonViewController : UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(detailMemberList)
        return detailMemberList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "detailMember", for: indexPath) as! DetailPersonTableViewCell
        cell.memberName.text = detailMemberList[indexPath.row].memberName
        cell.memberPhoneNum.text = detailMemberList[indexPath.row].memberPhoneNum
        return cell
    }
    
        
}
