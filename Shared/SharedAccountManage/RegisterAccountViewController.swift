//
//  RegisterAccountViewController.swift
//  Shared
//
//  Created by Seunghun Shin on 2020/01/24.
//  Copyright © 2020 SeunghunShin. All rights reserved.
//

import UIKit

class RegisterAccountViewController: UIViewController {
    @IBOutlet var collectionView: UICollectionView!
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let cell = sender as? UICollectionViewCell, let indexPath = collectionView.indexPath(for: cell){
            if let vc = segue.destination as? AccountnumberViewController{
                vc.bankName = banklist[indexPath.item]
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.allowsSelection = true
        collectionView.allowsMultipleSelection = false
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
//      cell.bankImage.image = UIImage(named: bankimagelist[indexPath.item])
        return cell
    }
}
