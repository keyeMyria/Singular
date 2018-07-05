//
//  CarGroupDatasource.swift
//  GridLayout
//
//  Created by Sztanyi Szabolcs on 2017. 05. 17..
//  Copyright © 2017. Sabminder. All rights reserved.
//

import UIKit

class CarGroupDatasource: NSObject, UICollectionViewDataSource {

    private var carGroup: CarGroup!

    init(carGroup: CarGroup) {
        super.init()
        self.carGroup = carGroup
    }

    func numberOfCars() -> Int {
        return carGroup.numberOfCars()
    }

    // MARK: collectionView methods
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return carGroup.numberOfCars()
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "swipeCell", for: indexPath) as! ImageCollectionViewCell

        let car = carGroup.carAt(indexPath)
        cell.fillWith(car)

        return cell
    }

}
