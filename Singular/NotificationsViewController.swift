//
//  NotificationsViewController.swift
//  Singular
//
//  Created by dlr4life on 5/12/17.
//  Copyright © 2017 DLR LLC. All rights reserved.
//

import UIKit

class NotificationsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet var tableView: UITableView!
    
    let section = ["Default", "Custom", "Favorites"]
    let notificationItems = ["Challenges", "Posts", "Leaderboard Changes", "New Longest Word", "New High Score", "Backgrounds"]
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        animateTable()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Notifications"
        
        self.tableView.dataSource = self
        self.tableView.delegate = self
    
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
    
    func toggleButton(button: UIButton, onImage: UIImage, offImage: UIImage) {
        if button.currentImage == offImage {
            button.setImage(onImage, for: .normal)
        } else {
            button.setImage(offImage, for: .normal)
        }
    }
    
    // MARK: - Table view data source
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.backgroundColor = UIColor.clear
        cell.textLabel?.textAlignment = .center
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.section.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.notificationItems.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return self.section[section]
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 30))
        let headerLabel = UILabel(frame: CGRect(x: 10, y: 0, width: 150, height: 30))
        headerLabel.text = "\(self.section[section]): \(notificationItems.count - 1)"
        headerLabel.textColor = .white
        view.addSubview(headerLabel)
        view.backgroundColor = UIColor(red: 99.0/255, green: 65.0/255, blue: 200.0/255, alpha: 1.0)
        return view
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:UITableViewCell = self.tableView.dequeueReusableCell(withIdentifier: "notificationMenuItemCell")! as UITableViewCell
        
        cell.backgroundColor = UIColor.clear
        cell.textLabel?.textColor = UIColor.darkGray
        
        cell.textLabel?.text = String(notificationItems[indexPath.row])
        cell.textLabel?.font = UIFont(name: "HelveticaNeue-Light", size: 15)
        
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let _:UITableViewCell = self.tableView.dequeueReusableCell(withIdentifier: "notificationMenuItemCell")! as UITableViewCell
        let indexPath = tableView.indexPathForSelectedRow
        let _ = tableView.cellForRow(at: indexPath!)! as UITableViewCell
    }
    
    //MARK: - Buttons   

}
