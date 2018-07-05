//
//  Banner.swift
//  GridLayout
//
//  Created by Sztanyi Szabolcs on 2017. 05. 17..
//  Copyright © 2017. Sabminder. All rights reserved.
//

import UIKit

class Banner: NSObject {

    var title: String
    var buttonTitle: String
    var urlString: String

    init(title: String, buttonTitle: String, url: String) {
        self.title = title
        self.buttonTitle = buttonTitle
        self.urlString = url

        super.init()
    }

    func url() -> URL? {
        return URL(string: urlString)
    }

}
