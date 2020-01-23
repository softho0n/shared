//
//  NameInputViewController.swift
//  Shared
//
//  Created by Seunghun Shin on 2020/01/04.
//  Copyright © 2020 SeunghunShin. All rights reserved.
//

import UIKit
import FirebaseAuth

class NameInputViewController: UIViewController {

    @IBOutlet var nameInputField: UITextField!
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // let backItem = UIBarButtonItem()
        // backItem.title = ""
        // navigationItem.backBarButtonItem = backItem
        setupBackButton()
        
        let name = nameInputField.text
        if let vc = segue.destination as? UserAuthViewController {
            vc.name = name
        }
    }
        
    override func viewDidLoad() {
        super.viewDidLoad()
        nameInputField.underlined()
        nameInputField.returnKeyType = .next
        
        if Auth.auth().currentUser != nil {
            if #available(iOS 13.0, *) {
                let rvc = self.storyboard?.instantiateViewController(identifier: "mainUI")
                self.navigationController?.pushViewController(rvc!, animated: false)
            } else {
                fatalError()
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        nameInputField.text = ""
    }
    
    @IBAction func reAuthentication(_ sender: Any) {
        setupBackButton()
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

extension NameInputViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        performSegue(withIdentifier: "toAuth", sender: nil)
        return true
    }
}

