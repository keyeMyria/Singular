//
//  ViewController.swift
//  GridLayout
//
//  Created by Sztanyi Szabolcs on 2016. 11. 01..
//  Copyright © 2016. Sabminder. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {

    @IBOutlet weak var collectionView: UICollectionView!

    var gridLayout: GridLayout!
    var dataSource: Datasource!

    // MARK: view methods
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Records"

        dataSource = Datasource()
        collectionView.dataSource = dataSource

        gridLayout = GridLayout(numberOfColumns: 2)
        collectionView.collectionViewLayout = gridLayout
        collectionView.delegate = self
        collectionView.reloadData()
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)

        if let selectedCar = dataSource.itemAt(indexPath) as? Car {
            performSegue(withIdentifier: "selectCar", sender: selectedCar)
        }

        // 2. Do it manually
//        if let destinationController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "detailVC") as? DetailViewController {
//            destinationController.selectedCar = selectedCar
//            navigationController?.pushViewController(destinationController, animated: true)
//        }
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let item = dataSource.itemAt(indexPath)
        if item is Banner {
            return gridLayout.itemSizeFor(1, with: BannerCollectionViewCell.cellHeight())
        } else if item is CarGroup {
            return gridLayout.itemSizeFor(1, with: CarGroupCollectionViewCell.cellHeight())
        } else {
            return gridLayout.itemSizeFor(2)
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "selectCar" {
            if let selectedCar = sender as? Car, let destinationViewController = segue.destination as? DetailViewController {
                destinationViewController.selectedCar = selectedCar
            }
        }
    }

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        collectionView.collectionViewLayout.invalidateLayout()
    }
    
}
