//
//  Datasource.swift
//  GridLayout
//
//  Created by Sztanyi Szabolcs on 2016. 12. 04..
//  Copyright © 2016. Sabminder. All rights reserved.
//

import UIKit

class Datasource: NSObject, UICollectionViewDataSource {

    private var itemsToDisplay: [Any] = []

    override init() {
        super.init()
        
        let carsArray = [Car(objectID: "12", name: "Leaderboards", count: nil, backgroundColor: .green, salePrice: nil, carDescription: "Text", image: UIImage(named: "leaderboardImage3")!),
                         Car(objectID: "13", name: "", count: nil, backgroundColor: .blue, salePrice: nil, carDescription: "Text", image: UIImage(named: "profileImage4")!)]
        
        let carGroup = CarGroup(cars: carsArray)
        
        itemsToDisplay = [carGroup, Banner(title: "Submitted Word History ->", buttonTitle: "History", url: "http://google.com"),
                          Car(objectID: "12", name: "Leaderboards", count: "1st, 2nd, 3rd, 4th", backgroundColor: .orange, salePrice: nil, carDescription: "Text", image: UIImage(named: "leaderboardsImage")!),
                          Car(objectID: "13", name: "Profile", count: "PlayerName", backgroundColor: .blue, salePrice: nil, carDescription: "Text", image: UIImage(named: "profileImage")!),
                          Car(objectID: "14", name: "Accepted Words", count: "####", backgroundColor: .purple, salePrice: nil, carDescription: "Text", image: UIImage(named: "acceptedImage")!),
                          Car(objectID: "15", name: "Rejected Words", count: "####", backgroundColor: .cyan, salePrice: nil, carDescription: "Text", image: UIImage(named: "rejectedImage")!),
                          Car(objectID: "16", name: "Matches Played", count: "####", backgroundColor: .white, salePrice: nil, carDescription: "Text", image: UIImage(named: "matchesPlayedImage")!),
                          Car(objectID: "17", name: "Words per Match", count: "####", backgroundColor: .yellow, salePrice: nil, carDescription: "Text", image: UIImage(named: "wordsPerMatchImage")!),
                          Car(objectID: "18", name: "Points per Word", count: "##", backgroundColor: .red, salePrice: nil, carDescription: "Text", image: UIImage(named: "pointsPerWordImage")!),
                          Car(objectID: "19", name: "Longest Word", count: "# characters", backgroundColor: .blue,  salePrice: nil, carDescription: "Text", image: UIImage(named: "longestWordImage")!),
                          Car(objectID: "20", name: "Longest Streak", count: "0:00", backgroundColor: .orange, salePrice: nil, carDescription: "Text", image: UIImage(named: "longestStreakImage")!),
                          Car(objectID: "21", name: "Personal Best", count: "0:00", backgroundColor: .cyan, salePrice: nil, carDescription: "Text", image: UIImage(named: "personalBestImage")!),]
    }
    
    func itemAt(_ indexPath: IndexPath) -> Any {
        return itemsToDisplay[indexPath.item]
    }

    // MARK: collectionView methods
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return itemsToDisplay.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let item = itemsToDisplay[indexPath.item]
        if let car = item as? Car {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! ImageCollectionViewCell
            cell.fillWith(car)
            return cell
        } else if let banner = item as? Banner {
            let bannerCell = collectionView.dequeueReusableCell(withReuseIdentifier: "bannerCell", for: indexPath) as! BannerCollectionViewCell
            bannerCell.fillWith(banner)
            return bannerCell
        } else if let carGroup = item as? CarGroup {
            let carGroupCell = collectionView.dequeueReusableCell(withReuseIdentifier: "carGroupCell", for: indexPath) as! CarGroupCollectionViewCell
            carGroupCell.fillWith(carGroup)
            return carGroupCell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! ImageCollectionViewCell
            return cell
        }
    }

}

