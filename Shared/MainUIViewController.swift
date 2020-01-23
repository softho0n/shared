//
//  MainUIViewController.swift
//  Shared
//
//  Created by Seunghun Shin on 2020/01/05.
//  Copyright © 2020 SeunghunShin. All rights reserved.
//

import UIKit
import Firebase

class MainUIViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let label = UILabel()
        setupBackButton()
        
        label.textColor = UIColor.black
        label.text = "SHARED"
        label.font = UIFont.boldSystemFont(ofSize: 20.0)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem.init(customView: label)
        
        // Do any additional setup after loading the view.
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
