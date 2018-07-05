//
//  RecordsDetailViewController.swift
//  Singular
//
//  Created by dlr4life on 7/29/17.
//  Copyright © 2017 DLR LLC. All rights reserved.
//

import UIKit
import Crashlytics

class RecordsDetailViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    static var selectedCategory = ""
    static var categories = ""
    
//    var list = [Words]()
//    var listFiltered = [Words]()
//    var detailInfoObj: WordObject!
    
    @IBOutlet var tableView: UITableView!
    
    var searchController = UISearchController()
    
    let favoriteBtn = UIBarButtonItem!.self
    let deleteBtn = UIBarButtonItem!.self
    
    var favoritesEditSetting = false
    
    func createSearchController() {
        self.searchController = UISearchController(searchResultsController: nil)
        self.searchController.searchResultsUpdater = self as? UISearchResultsUpdating
        self.searchController.hidesNavigationBarDuringPresentation = false
        self.searchController.dimsBackgroundDuringPresentation = false
        self.searchController.searchBar.sizeToFit()
        self.searchController.searchBar.placeholder = "Search"
        
        let allowToCreateSearchBar = UserDefaults.standard.bool(forKey: "hideSearchBarSetting")
        if allowToCreateSearchBar {
            self.tableView.tableHeaderView = nil
        } else {
            self.tableView.tableHeaderView = self.searchController.searchBar
        }
        
        self.definesPresentationContext = true
        //        self.searchController.searchBar.scopeButtonTitles = ["💰Link", "⭐️", "🗺HQ"] // if Link or Grid
        self.tableView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        createSearchController()
        animateTable()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        _ = ["house", "town"]

        favoritesEditSetting = UserDefaults.standard.bool(forKey: "favoritesEditSetting")
    }
    
    //MARK: - Tableview Instructions
    
    func animateTable() {
        tableView.reloadData()
        
        let cells = tableView.visibleCells
        let tableHeight: CGFloat = tableView.bounds.size.height
        
        for i in cells {
            let cell: UITableViewCell = i as UITableViewCell
            cell.transform = CGAffineTransform(translationX: 0, y: tableHeight)
        }
        
        var index = 0
        
        for a in cells {
            let cell: UITableViewCell = a as UITableViewCell
            UIView.animate(withDuration: 1, delay: 0.05 * Double(index), usingSpringWithDamping: 0.8, initialSpringVelocity: 0, animations: {
                cell.transform = CGAffineTransform(translationX: 0, y: 0);
            }, completion: nil)
            
            index += 1
        }
    }
    
    // MARK: - Table view data source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if self.searchController.isActive && searchController.searchBar.text != "" {
            return 1
        }
        return 1
    }
    
    func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        return nil
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.searchController.isActive && searchController.searchBar.text != "" {
//            return listFiltered.count
        }
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 55
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if self.searchController.isActive && searchController.searchBar.text != "" {
            let cell = tableView.dequeueReusableCell(withIdentifier: "gridCell") as UITableViewCell!
            
            let nightThemeState = UserDefaults.standard.bool(forKey: "nightModeSetting")
            if nightThemeState {
                cell?.backgroundColor = UIColor(red:0.13, green:0.13, blue:0.13, alpha:1.0)
                cell?.textLabel?.textColor = .white
            } else {
                cell?.backgroundColor = .white
                cell?.textLabel?.textColor = .black
            }
            
//            let result = listFiltered[indexPath.row]
//            cell?.textLabel?.text = result.name
//            cell?.textLabel?.font = UIFont(name: "HelveticaNeue-Light", size: 15)
//            result.isFavorite ? (cell?.imageView?.image = #imageLiteral(resourceName: "Heart-Fav")) : (cell?.imageView?.image = #imageLiteral(resourceName: "Heart-NoFav"))
//            cell?.detailTextLabel?.text = result.category
            return cell!
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "gridCell") as UITableViewCell!
            
            let nightThemeState = UserDefaults.standard.bool(forKey: "nightModeSetting")
            if nightThemeState {
                cell?.backgroundColor = UIColor(red:0.13, green:0.13, blue:0.13, alpha:1.0)
                cell?.textLabel?.textColor = .white
            } else {
                cell?.backgroundColor = .white
                cell?.textLabel?.textColor = .black
            }
            
//            cell?.textLabel?.text = RecordsDetailViewController.list[indexPath.row]
//            cell?.textLabel?.font = UIFont(name: "HelveticaNeue-Light", size: 15)
//            list[indexPath.row].isFavorite ? (cell?.imageView?.image = #imageLiteral(resourceName: "Heart-Fav")) : (cell?.imageView?.image = #imageLiteral(resourceName: "Heart-NoFav"))
//            cell?.detailTextLabel?.text = list[indexPath.row].category
            return cell!
        }
    }
    
    // Add "Favorite" button on right swipe
    func tableView(_ tableView: UITableView, editActionsForRowAt: IndexPath) -> [UITableViewRowAction]? {
        let favorite = UITableViewRowAction(style: .normal, title: "\u{2764}\n Favorite") { action, index in
            //            print("A new favorite has been added")
            _ = UserDefaults.standard
//            let nameWithoutSpace = self.list[index.row].name.replacingOccurrences(of: " ", with: "")
//            defaults.set(true, forKey: nameWithoutSpace)
            //            print(nameWithoutSpace)
            
            //  If the cell being swiped is not a favorite,
//            if self.list[index.row].isFavorite {
//                //                print("Already added to Favorites")
//                
//                                let alertController = UIAlertController(title: "You've already added \(self.list[index.row].name) to Favorites!", message: "", preferredStyle: .alert)
//                                let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
//                                alertController.addAction(defaultAction)
//                                self.present(alertController, animated: true, completion: nil)
//                return
//            }
            
            self.isEditing = false
//            self.list[index.row].isFavorite = true
            self.tableView.reloadData()
            
            
//                        let alertController = UIAlertController(title: "You've added \(self.list[index.row].name) to Favorites!", message: "", preferredStyle: .alert)
//                        let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
//                        alertController.addAction(defaultAction)
//                        self.present(alertController, animated: true, completion: nil)
        }
        
        let img: UIImage = UIImage(named: "Heart-Fav")!
        let imgSize: CGSize = tableView.frame.size
        UIGraphicsBeginImageContext(imgSize)
        img.draw(in: CGRect(x: 40, y: 0, width: 20, height: 20))
        let _: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        favorite.backgroundColor = UIColor(patternImage: img)
        favorite.backgroundColor = UIColor.lightGray
        
        let delete = UITableViewRowAction(style: .destructive, title: "\u{2715}\n Remove") { action, index in
//            let nameWithoutSpace = self.list[index.row].name.replacingOccurrences(of: " ", with: "")
//            UserDefaults.standard.removeObject(forKey: nameWithoutSpace)
            
            //  If the cell being swiped is not a favorite,
//            if !self.list[index.row].isFavorite {
//                
//                
//                                let alertController = UIAlertController(title: "You've already removed \(self.list[index.row].name) from Favorites!", message: "", preferredStyle: .alert)
//                                let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
//                                alertController.addAction(defaultAction)
//                                self.present(alertController, animated: true, completion: nil)
//                return
//            }
            
//            let nameToRemove = self.list[index.row].name
//            self.isEditing = true
//            self.list[index.row].isFavorite = false
            tableView.reloadData()

//                        let alertController = UIAlertController(title: "You've deleted \(nameToRemove) from Favorites!", message: "", preferredStyle: .alert)
//                        let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
//                        alertController.addAction(defaultAction)
//                        self.present(alertController, animated: true, completion: nil)
        }
        
        let img1: UIImage = UIImage(named: "Heart-NoFav")!
        let _: CGSize = tableView.frame.size
        UIGraphicsBeginImageContext(imgSize)
        img1.draw(in: CGRect(x: 40, y: 0, width: 20, height: 20))
        let _: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        delete.backgroundColor = UIColor.darkGray
        
        if favoritesEditSetting {
            UIGraphicsBeginImageContext(imgSize)
            img.draw(in: CGRect(x: 40, y: 0, width: 20, height: 20))
            let _: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
            favorite.backgroundColor = UIColor.lightGray
            UIGraphicsEndImageContext()
            favorite.backgroundColor = UIColor.lightGray
            
            UIGraphicsBeginImageContext(imgSize)
            img1.draw(in: CGRect(x: 40, y: 0, width: 20, height: 20))
            let _: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
            UIGraphicsEndImageContext()
            delete.backgroundColor = UIColor.darkGray
            return [delete, favorite]
        }
        return [favorite]
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if self.searchController.isActive && searchController.searchBar.text != "" {
//            RecordsDetailViewController.detailInfoObj = listFiltered[indexPath.row]
            
            let secondViewController = self.storyboard?.instantiateViewController(withIdentifier: "RecordsDetailViewController") as! RecordsDetailViewController
            self.navigationController?.pushViewController(secondViewController, animated: true)
        } else {
//            RecordsDetailViewController.detailInfoObj = list[indexPath.row]
            
            let secondViewController = self.storyboard?.instantiateViewController(withIdentifier: "RecordsDetailViewController") as! RecordsDetailViewController
            self.navigationController?.pushViewController(secondViewController, animated: true)
        }
    }
}
