//
//  RecordsViewController.swift
//  Singular
//
//  Created by dlr4life on 7/27/17.
//  Copyright © 2017 DLR LLC. All rights reserved.
//

import UIKit
import RealmSwift

class RecordsViewController: UIViewController, UICollectionViewDataSource {
    
    @IBOutlet weak var layoutCollectionView: UICollectionView!
    @IBOutlet weak var allWordsBtn: UIBarButtonItem!
    @IBOutlet weak var toggleBtn: UIBarButtonItem!

    var datasource: Results<WordItem>!
    var realm : Realm!
    var categories = [String]()

//    let data = ["10","9","8","7","6","5","4","3","2","1","10","9","8","7","6","5","4","3","2","1"]
    
    var imageView: [UIImage] = [UIImage(named: "1")!, UIImage(named: "2")!, UIImage(named: "3")!, UIImage(named: "4")!, UIImage(named: "5")!, UIImage(named: "6")!, UIImage(named: "7")!, UIImage(named: "8")!, UIImage(named: "9")!, UIImage(named: "10")!]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        categories = ["Matches Played", "Most MatchesPlayed", "Max Words Entered", "Accepted Words", "Rejected Words" , "Personal Bests",  "Longest Accepted Streak", "Longest Word", "Most Points/Word", "Leaderboards"]

        layoutCollectionView.dataSource = self
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageView.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = layoutCollectionView.dequeueReusableCell(withReuseIdentifier: "layoutCollectionViewCell", for: indexPath) as! layoutCollectionViewCell
        let image = imageView[indexPath.item]
        
        cell.label1.text = "\(categories[indexPath.item])"
        cell.label2.text = "Row : \(indexPath.row)"
        cell.label3.text = "Digit : \(indexPath.row)"
        cell.imageView.image = image
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
//        if let selectedRecord = datasource.(indexPath) as? LeaderboardItem {
//            performSegue(withIdentifier: "layoutCollectionViewCell", sender: selectedRecord)
//        }
    }


    func setLayout(layout:UICollectionViewLayout) {
        UIView.animate(withDuration: 0.5) { () -> Void in
            self.layoutCollectionView.collectionViewLayout.invalidateLayout()
            self.layoutCollectionView.setCollectionViewLayout(layout, animated: true)
        }
    }
    
    @IBAction func toggleBtnClicked(_ sender: UIBarButtonItem) {
        var layout = ListFlowLayout() as UICollectionViewLayout
        if layoutCollectionView.collectionViewLayout.classForCoder == layout.classForCoder {
            layout = GridFlowLayout() as UICollectionViewLayout
            
        }else{
            layout = ListFlowLayout() as UICollectionViewLayout
        }
        self.setLayout(layout: layout)
    }
    
}
