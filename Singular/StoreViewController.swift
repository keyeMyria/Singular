//
//  StoreViewController.swift
//  Singular
//
//  Created by dlr4life on 5/12/17.
//  Copyright © 2017 DLR LLC. All rights reserved.
//

import UIKit
import InAppPurchaseButton

class StoreViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet var tableView: UITableView!
    @IBOutlet weak var editButton: UIBarButtonItem!

    var storeItems = ["Product 1", "Product 2", "Product 3", "Product 4", "Product 5", "Product 6", "Product 7", "Product 8", "Product 9", "Product 10"]

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        animateTable()
//        tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "Store"
        animateTable()

        tableView.dataSource = self
        tableView.delegate = self
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        if (isEditing) {
            isEditing = false
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func refresh() {
        self.tableView.reloadData()
    }

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
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.backgroundColor = UIColor.clear
//        cell.textLabel?.textAlignment = .center
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.storeItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let identifier: String = "myCell"
        var cell = tableView.dequeueReusableCell(withIdentifier: identifier)
        
        cell?.backgroundColor = UIColor.clear
        cell?.textLabel?.textColor = UIColor.darkGray
        
//        cell?.textLabel?.text = "Item \(indexPath.row)" //String(storeItems[indexPath.row])
        cell?.textLabel?.text = String(storeItems[indexPath.row])
        cell?.textLabel?.font = UIFont(name: "HelveticaNeue-Light", size: 15)
        cell?.detailTextLabel?.text = "Purchased: \(NSDate())"
        
        if cell == nil {
            cell = UITableViewCell(style: .default, reuseIdentifier: identifier)
        }
        return cell!
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 30))
        let headerLabel = UILabel(frame: CGRect(x: 10, y: 0, width: 150, height: 30))
        headerLabel.text = "In Stock: \(storeItems.count - 1)"
        headerLabel.textColor = .white
        view.addSubview(headerLabel)
        view.backgroundColor = UIColor(red: 99.0/255, green: 65.0/255, blue: 200.0/255, alpha: 1.0)
        return view
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Show Alert.
            let title = "Delete \(self.storeItems[indexPath.row])"
            let message = "Are you sure you want to delete this item?"
            
            let ac = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
            
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            ac.addAction(cancelAction)
            
            let deleteAction = UIAlertAction(title: "Remove", style: .destructive, handler: { (action) in
                let nameWithoutSpace = self.storeItems[indexPath.row].replacingOccurrences(of: " ", with: "")
                UserDefaults.standard.removeObject(forKey: nameWithoutSpace)
                
                self.storeItems.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .fade)

            })
            ac.addAction(deleteAction)

            // Present alert controller.
            present(ac, animated: true, completion: nil)
        }
        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        if (self.editButtonItem.isEnabled == true) || (self.tableView.isEditing) {
            return UITableViewCellEditingStyle.delete
        }
        return UITableViewCellEditingStyle.none
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let _: String = "myCell"

        let indexPath = tableView.indexPathForSelectedRow
        let _ = tableView.cellForRow(at: indexPath!)! as UITableViewCell
    }
    
    //MARK: - Buttons
    
    //MARK: - setEditing
    override func setEditing(_ editing: Bool, animated: Bool) {
        if editButton.isEnabled == false {
            self.tableView.isEditing = false
        } else {
            self.tableView.isEditing = editing
            super.setEditing(editing, animated: true)
        }
    }
    
    @IBAction func toggleEditingMode(_ sender: UIButton) {
        // If you are currently editing
        if isEditing {
            // Change text of button to inform user of state.
            editButton.title = "Edit"
            // editButton.setTitle("Edit", for: .normal)
            
            // Turn off editing mode.
            setEditing(false, animated: true)
        } else {
            // Change text of button to inform user of state.
            editButton.title = "Done"
            
            //  sender.setTitle("Done", for: .normal)
            
            // Turn on editing mode.
            setEditing(true, animated: true)
        }
    }
    
    @IBOutlet weak var inAppPurchaseButton1: InAppPurchaseButton! {
        didSet {
            let activeColor = UIColor(red: 141 / 255, green: 19 / 255, blue: 81 / 255, alpha: 1)
            let inactiveColor = UIColor(red: 89 / 255, green: 89 / 255, blue: 94 / 255, alpha: 1)
            
            inAppPurchaseButton1.attributedTextForInactiveState = generateAttributedString("$9.99", fontColor: .white)
            inAppPurchaseButton1.attributedTextForActiveState = generateAttributedString("Open", fontColor: .white)
            inAppPurchaseButton1.cornerRadiusForExpandedBorder = 0
            inAppPurchaseButton1.backgroundColorForInactiveState = inactiveColor
            inAppPurchaseButton1.backgroundColorForActiveState = activeColor
            inAppPurchaseButton1.borderColorForInactiveState = inactiveColor
            inAppPurchaseButton1.borderColorForActiveState = activeColor
            inAppPurchaseButton1.ringColorForProgressView = activeColor
            inAppPurchaseButton1.minExpandedSize = .zero
            inAppPurchaseButton1.prefferedTitleMargins = .zero
            inAppPurchaseButton1.widthForBusyView = 20
        }
    }
    
    // MARK: - Actions
    
    @IBAction func inAppPurchaseButton1Touched(_ sender: InAppPurchaseButton) {
        switch sender.buttonState {
        case .regular(animate: _, intermediateState: .inactive):
            sender.buttonState = .busy(animate: true)
        case .busy(animate: _):
            sender.buttonState = .downloading(progress: 0.25)
        case .downloading(progress: 0.25):
            sender.buttonState = .downloading(progress: 0.5)
        case .downloading(progress: 0.5):
            sender.buttonState = .downloading(progress: 0.75)
        case .downloading(progress: 0.75):
            sender.buttonState = .downloading(progress: 1)
        case .downloading(progress: _):
            sender.buttonState = .regular(animate: true, intermediateState: .active)
        case .regular(animate: _, intermediateState: .active):
            sender.buttonState = .regular(animate: false, intermediateState: .inactive)
        }
    }
    
    // MARK: - Helpers
    
    func generateAttributedString(_ string: String, fontColor: UIColor = .white) -> NSAttributedString {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center
        return NSAttributedString(string: string, attributes: [NSFontAttributeName: UIFont(name: "Helvetica", size: 12)!, NSForegroundColorAttributeName: fontColor, NSParagraphStyleAttributeName: paragraphStyle])
    }
    
    var defaultInactiveColor: UIColor {
        return UIColor(red: 198 / 255, green: 107 / 255, blue: 160 / 255, alpha: 1)
    }
    
    var defaultActiveColor: UIColor {
        return UIColor(red: 129 / 255, green: 209 / 255, blue: 216 / 255, alpha: 1)
    }

}
