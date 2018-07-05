//
//  SettingsViewController.swift
//  Singular
//
//  Created by dlr4life on 5/12/17.
//  Copyright © 2017 DLR LLC. All rights reserved.
//

import UIKit
import QuickTableViewController

class SettingsViewController: QuickTableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "Settings"
        
        let globe = UIImage(named: "iconmonstr-globe")!
        
        tableContents = [
            Section(title: "Background", rows: [
                TapActionRow(title: "Red", action: nil),
                TapActionRow(title: "Orange", action: nil),
                TapActionRow(title: "Yellow", action: nil),
                TapActionRow(title: "Green", action: nil),
                TapActionRow(title: "Blue", action: nil),
                TapActionRow(title: "Purple", action: nil),
                TapActionRow(title: "Cyan", action: nil),
                ]),
            
            Section(title: "Sharing", rows: [
                SwitchRow(title: "Facebook", switchValue: false, icon: Icon(image: globe), action: nil),
                SwitchRow(title: "Twitter", switchValue: false, icon: Icon(image: globe), action: nil),
                SwitchRow(title: "Instagram", switchValue: false, icon: Icon(image: globe), action: nil),
                SwitchRow(title: "SMS", switchValue: false, icon: Icon(image: globe), action: nil),
                SwitchRow(title: "Email", switchValue: false, icon: Icon(image: globe), action: nil),
                SwitchRow(title: "Google", switchValue: false, icon: Icon(image: globe), action: nil),
                SwitchRow(title: "Snapchat", switchValue: false, icon: Icon(image: globe), action: nil),
                ]),
            
            Section(title: "Help", rows: [
                NavigationRow(title: "FAQ", subtitle: .none, icon: .none),
                NavigationRow(title: "Bug", subtitle: .none, icon: .none),
                NavigationRow(title: "License", subtitle: .none, icon: .none),
                ]),

            Section(title: "Contact", rows: [
                NavigationRow(title: "Email", subtitle: .rightAligned("singularapp@gmail.com"), icon: Icon(image: globe)),
                NavigationRow(title: "Phone", subtitle: .rightAligned("(555) 555-5555"), icon: Icon(image: globe)),
                ]),
            
//            Section(title: nil, rows: [
//                NavigationRow(title: "Navigation", subtitle: .none),
//                NavigationRow(title: "Navigation", subtitle: .belowTitle("with subtitle")),
//                NavigationRow(title: "Navigation", subtitle: .rightAligned("with detail text"))
//                ], footer: "UITableViewCellStyle.Value2 is not listed."),
//            
//            Section(title: nil, rows: [
//                NavigationRow(title: "Empty section title", subtitle: .none)
//                ])
        ]
    }
    
    // MARK: - UITableViewDataSource
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        if tableContents[indexPath.section].title == nil {
            // Alter the cells created by QuickTableViewController
            cell.imageView?.image = UIImage(named: "iconmonstr-x-mark")
        }
        return cell
    }
    
    // MARK: - Private Methods
    private func showAlert(_ sender: Row) {
        let alert = UIAlertController(title: "Action Triggered", message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel) { [unowned self] _ in
            self.dismiss(animated: true, completion: nil)
        })
        present(alert, animated: true, completion: nil)
    }
    
    private func showDetail(_ sender: Row) {
        let controller = UIViewController()
        controller.view.backgroundColor = UIColor.white
        controller.title = "\(sender.title) " + (sender.subtitle?.text ?? "")
        navigationController?.pushViewController(controller, animated: true)
    }
    
    private func printValue(_ sender: Row) {
        if let row = sender as? SwitchRow {
            print("\(row.title) = \(row.switchValue)")
        }
    }
}
