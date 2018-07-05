//
//  CarGroup.swift
//  GridLayout
//
//  Created by Sztanyi Szabolcs on 2017. 05. 17..
//  Copyright © 2017. Sabminder. All rights reserved.
//

import UIKit

class CarGroup: NSObject {

    private var cars: [Car] = []

    init(cars: [Car]) {
        super.init()
        self.cars = cars
    }

    func numberOfCars() -> Int {
        return cars.count
    }

    func carAt(_ indexPath: IndexPath) -> Car {
        return cars[indexPath.item]
    }

}
