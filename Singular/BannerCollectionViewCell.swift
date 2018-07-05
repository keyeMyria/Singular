//
//  BannerCollectionViewCell.swift
//  GridLayout
//
//  Created by Sztanyi Szabolcs on 2017. 05. 17..
//  Copyright © 2017. Sabminder. All rights reserved.
//

import UIKit

class BannerCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var actionButton: UIButton!

    private var bannerToDisplay: Banner?

    static func cellHeight() -> CGFloat {
        return 70.0
    }

    @IBAction func actionButtonPressed() {
        guard let banner = bannerToDisplay, let url = banner.url() else {
            return
        }

        if UIApplication.shared.canOpenURL(url) {
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            } else {
                // Fallback on earlier versions
            }
        }
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        bannerToDisplay = nil
    }

    override func awakeFromNib() {
        super.awakeFromNib()

        actionButton.layer.cornerRadius = 4.0
    }

    func fillWith(_ banner: Banner) {
        titleLabel.text = banner.title
        actionButton.setTitle(banner.buttonTitle, for: .normal)

        bannerToDisplay = banner
    }

}
