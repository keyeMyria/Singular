//
//  Car.swift
//  GridLayout
//
//  Created by Sztanyi Szabolcs on 2016. 12. 04..
//  Copyright © 2016. Sabminder. All rights reserved.
//

import UIKit

class Car: NSObject {

    var objectID: String!
    var name: String!
    var count: String!
    var salePrice: NSNumber?
    var carDescription: String?
    var backgroundColor: UIColor!
    var image: UIImage!

    init(objectID: String!, name: String?, count: String?, backgroundColor: UIColor! , salePrice: NSNumber?, carDescription: String?, image: UIImage!) {
        self.objectID = objectID
        self.name = name
        self.count = count
        self.salePrice = salePrice
        self.carDescription = carDescription
        self.backgroundColor = backgroundColor
        self.image = image
    }

}
