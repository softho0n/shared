//
//  RegisterAccountViewController.swift
//  Shared
//
//  Created by Seunghun Shin on 2020/01/24.
//  Copyright © 2020 SeunghunShin. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import FirebaseAuth

class RegisterAccountViewController: UIViewController {
    @IBOutlet var collectionView: UICollectionView!
    var firstAccount = false
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let cell = sender as? UICollectionViewCell, let indexPath = collectionView.indexPath(for: cell){
            if let vc = segue.destination as? AccountNumberViewController{
                vc.bankName = banklist[indexPath.item]
                print("RegisterView : ", self.firstAccount)
                vc.firstAccount = self.firstAccount
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBackButton()
        collectionView.allowsSelection = true
        collectionView.allowsMultipleSelection = false
        collectionView.showsVerticalScrollIndicator = false
        getdata()
    }
    
    func getdata(){
        let ref = Database.database().reference()
        if let uid = Auth.auth().currentUser?.uid{
            ref.child("Accounts/\(uid)").observeSingleEvent(of: .value) { (snapshot) in
                if snapshot.hasChildren() == false{
                    self.firstAccount.toggle()
                }
            }
        }
    }
}


extension RegisterAccountViewController : UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header =  collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "header", for: indexPath) as! RegisterAccountCollectionReusableView
        return header
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return banklist.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! RegisterAccountCollectionViewCell
        cell.bankLabel.text = banklist[indexPath.item]
        cell.bankImage.image = UIImage(named: bankimagelist[indexPath.item])
        return cell
    }
}
