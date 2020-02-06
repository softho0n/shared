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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        collectionView.collectionViewLayout = layout
    

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
