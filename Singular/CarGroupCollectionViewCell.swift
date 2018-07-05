//
//  CarGroupCollectionViewCell.swift
//  GridLayout
//
//  Created by Sztanyi Szabolcs on 2017. 05. 17..
//  Copyright © 2017. Sabminder. All rights reserved.
//

import UIKit

class CarGroupCollectionViewCell: UICollectionViewCell, UICollectionViewDelegateFlowLayout {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var leftArrowImageView: UIImageView!
    @IBOutlet weak var rightArrowImageView: UIImageView!

    private var datasource: CarGroupDatasource?

    static func cellHeight() -> CGFloat {
        return 180.0
    }

    override func prepareForReuse() {
        super.prepareForReuse()

        collectionView.dataSource = nil
        datasource = nil
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        leftArrowImageView.isHidden = true

        pageControl.currentPageIndicatorTintColor = UIColor.rgbColor(r: 15.0, g: 101.0, b: 180.0)
        pageControl.pageIndicatorTintColor = UIColor.rgbColor(r: 255.0, g: 247.0, b: 249.0, a: 0.6)
    }

    func fillWith(_ group: CarGroup) {
        let datasource = CarGroupDatasource(carGroup: group)
        collectionView.dataSource = datasource
        collectionView.delegate = self
        pageControl.numberOfPages = datasource.numberOfCars()

        self.datasource = datasource
    }

    // MARK: collectionView methods
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return collectionView.frame.size
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1.0
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1.0
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let indexOfPage = Int(scrollView.contentOffset.x / scrollView.frame.width)
        pageControl.currentPage = indexOfPage

        if indexOfPage == 0 {
            leftArrowImageView.isHidden = true
        } else {
            leftArrowImageView.isHidden = false
        }

        if let carsCount = datasource?.numberOfCars() {
            if indexOfPage >= carsCount-1 {
                rightArrowImageView.isHidden = true
            } else {
                rightArrowImageView.isHidden = false
            }
        }
    }

}
