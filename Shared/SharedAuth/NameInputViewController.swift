//
//  NameInputViewController.swift
//  Shared
//
//  Created by Seunghun Shin on 2020/01/04.
//  Copyright © 2020 SeunghunShin. All rights reserved.
//

import UIKit
import FirebaseAuth
import SwiftyGif

class NameInputViewController: UIViewController{

    @IBOutlet var nameInputField: UITextField!
    
    let logoAnimationView = LogoAnimationView()
    
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
        view.addSubview(logoAnimationView)
        logoAnimationView.pinEdgesToSuperView()
        logoAnimationView.logoGifImageView.delegate = self
        nameInputField.underlined()
        self.navigationController?.isNavigationBarHidden = true
        nameInputField.returnKeyType = .next
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        logoAnimationView.logoGifImageView.startAnimatingGif()
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
extension NameInputViewController: SwiftyGifDelegate {
    func gifDidStop(sender: UIImageView) {
        logoAnimationView.isHidden = true
        
        if Auth.auth().currentUser != nil {
            if #available(iOS 13.0, *) {
                print("hello?")
                let rvc = self.storyboard?.instantiateViewController(identifier: "mainUI")
                self.navigationController?.pushViewController(rvc!, animated: false)
            } else {
                fatalError()
            }
        }
        
        self.navigationController?.isNavigationBarHidden = false
    }
}

