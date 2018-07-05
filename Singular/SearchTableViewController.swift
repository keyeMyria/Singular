//
//  SearchTableViewController.swift
//  Singular
//
//  Created by dlr4life on 8/22/17.
//  Copyright © 2017 dlr4life. All rights reserved.
//

import UIKit
import RealmSwift

class SearchTableViewController: UITableViewController, UITextFieldDelegate {
    
    static let pointValue: Int = 0
//    static var datasource : Results<RecordsItem>!
    
    @IBOutlet weak var firstRealmTableView: UITableView!
    @IBOutlet weak var editButton: UIBarButtonItem!
    @IBOutlet weak var duplicatesButton: UIBarButtonItem!
    @IBOutlet weak var nameTxt: UISearchBar!

//    var datasource: Results<RecordsItem>!
    var datasource: Results<WordItem>!
    var realm : Realm!
    var formattedTimestamp = NSDate()

    var sectionTitles = ["#", "A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z"]

    var word: String? = nil { didSet {
        nameTxt.text = word ?? ""
        } }
    
    fileprivate var currentIndex = 0
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        animateTable()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
//        nameTxt.delegate = self as! UISearchBarDelegate
//        nameTxt.becomeFirstResponder()
        
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: Selector(("reloadData:")), name: NSNotification.Name(rawValue: "query"), object: nil)
        
        firstRealmTableView.delegate = self
        firstRealmTableView.dataSource = self
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func reloadData(notification: NSNotification) {
        firstRealmTableView.reloadData()
    }
    
    func reloadTheTable() {
        do {
            let realm = try Realm()
            EndGameViewController.datasource = realm.objects(WordItem.self)
            firstRealmTableView.reloadData()
        }
        catch
        {
        }
    }

    func refresh() {
        sectionTitles[0].removeAll()
        sectionTitles[1].removeAll()
        sectionTitles[2].removeAll()
        sectionTitles[3].removeAll()
        sectionTitles[4].removeAll()
        sectionTitles[5].removeAll()
        sectionTitles[6].removeAll()
        sectionTitles[7].removeAll()
        sectionTitles[8].removeAll()
        sectionTitles[9].removeAll()
        sectionTitles[10].removeAll()
        sectionTitles[11].removeAll()
        sectionTitles[12].removeAll()
        sectionTitles[13].removeAll()
        sectionTitles[14].removeAll()
        sectionTitles[15].removeAll()
        sectionTitles[16].removeAll()
        sectionTitles[17].removeAll()
        sectionTitles[18].removeAll()
        sectionTitles[19].removeAll()
        sectionTitles[20].removeAll()
        sectionTitles[21].removeAll()
        sectionTitles[22].removeAll()
        sectionTitles[23].removeAll()
        sectionTitles[24].removeAll()
        sectionTitles[25].removeAll()
        sectionTitles[26].removeAll()
        firstRealmTableView.reloadData()
    }
    
    func saveName() {
        let newWord = WordItem()
        newWord.word = nameTxt.text!
        
        do {
            let realm = try Realm()
            try realm.write ({ () -> Void in
                realm.add(newWord)
                firstRealmTableView.reloadData()
                print("Word Saved")
            })
        }
        catch
        {
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if (nameTxt.text?.isEmpty)! {
            return false
        }
        
        if let word = nameTxt.text, !word.isEmpty {
            self.word = word
        } else {
            self.word = nil
        }
        
        saveName()
        self.nameTxt.text = ""
        return false
    }
    
    func animateTable() {
        self.firstRealmTableView.reloadData()
        
        let cells = firstRealmTableView.visibleCells
        let tableHeight: CGFloat = firstRealmTableView.bounds.size.height
        
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
    
    func formatDateTime(timestamp: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .long
        let date = convertFromTimestamp(seconds: timestamp)
        return dateFormatter.string(from: date as Date)
    }
    
    // convert an NSDate object to a timestamp string
    func convertToTimestamp(date: NSDate) -> String {
        return String(Int64(date.timeIntervalSince1970 * 1000))
    }
    
    // Convert the timestamp string to an NSDate object
    func convertFromTimestamp(seconds: String) -> NSDate {
        let time = (seconds as NSString).doubleValue/1000.0
        return NSDate(timeIntervalSince1970: TimeInterval(time))
    }
    
    func toggleKeyboard() {
        if self.nameTxt.isFirstResponder {
            self.nameTxt.resignFirstResponder()
        } else {
            self.nameTxt.becomeFirstResponder()
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
//        return datasource.count
//        return sectionsInTable.count
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return datasource.count
//        return SearchViewController.datasource.count
//        return 500000
        return 1
    }

    override func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        return sectionTitles
    }
    
    override func tableView(_ tableView: UITableView, sectionForSectionIndexTitle title: String, at index: Int) -> Int {
        return index
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//        return "Search Queries: 500,000"
//        return "Search Queries: \(datasource.count)"
        return "Search Queries: #,###,###"
    }
    
//    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        let view = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 0))
//        let headerLabel = UILabel(frame: CGRect(x: 10, y: 0, width: 320, height: 30))
////        headerLabel.text = "Search Queries: 500,000"
//        headerLabel.text = "Search Queries:: \(datasource.count)"
//        headerLabel.textColor = .white
//        headerLabel.textAlignment = .center
//        view.addSubview(headerLabel)
//        view.backgroundColor = UIColor(red:0.00, green:0.00, blue:0.00, alpha:1.0)
//        return view
//    }
    
    override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        if let headerView = view as? UITableViewHeaderFooterView {
            headerView.textLabel?.textAlignment = .center
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "myCell")
        
        let currentDate = NSDate()
        let timestampFromDate = convertToTimestamp(date: currentDate)
//        let dateFromTimestamp = convertFromTimestamp(seconds: timestampFromDate)
        let _ = convertFromTimestamp(seconds: timestampFromDate)
//        let formattedTimestamp = formatDateTime(timestamp: timestampFromDate)
        let _ = formatDateTime(timestamp: timestampFromDate)

//        let currentPlayerInfo = "\(datasource[indexPath.row].word!)"
//        cell?.textLabel?.text = currentPlayerInfo
//        cell?.textLabel?.text = "\(datasource[indexPath.row].word!)"
//        cell?.detailTextLabel?.text = "Worth x pts"
//        cell?.detailTextLabel?.text = "Worth \(String(SearchTableViewController.pointValue.description)!) pts"

//        let cell = tableView.dequeueReusableCell(withIdentifier: "myCell")
//
////        cell?.textLabel?.text = "\(datasource[indexPath.row].word!)"
        cell?.textLabel?.text = "Singular"
        cell?.detailTextLabel?.text = "\(formatDateTime(timestamp: timestampFromDate))"
//        cell?.detailTextLabel?.text = "\(TCPOPT_TIMESTAMP)"
        return cell!
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            // Show Alert.
            let title = "Delete  item?" // "Delete \(datasource[indexPath.row].word!)"
            let message = "Are you sure you want to delete this item?"
            
            let ac = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
            
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            ac.addAction(cancelAction)
            
            let deleteAction = UIAlertAction(title: "Remove", style: .destructive, handler: { (action) in
                let realm = try! Realm()
                let word = self.datasource[indexPath.row]
                try! realm.write({
                    realm.delete(word)
//                    self.reloadTheTable()
                    self.firstRealmTableView.reloadData()
                })
            })
            ac.addAction(deleteAction)
            
            // Present alert controller.
            self.present(ac, animated: true, completion: nil)
        }
    }
    
    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        if (self.editButtonItem.isEnabled == true) || (self.firstRealmTableView.isEditing) {
            return UITableViewCellEditingStyle.delete
        }
        return UITableViewCellEditingStyle.none
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let alert = UIAlertController(title: "Define entry?", message: "Are you sure you want to get the definition for \(datasource[indexPath.row].word!)?", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
        
//        self.firstRealmTableView.deselectRow(at: indexPath, animated: true)
        
//        self.firstRealmTableView.deselectRow(at: indexPath, animated: true)
        
        if tableView.cellForRow(at: indexPath)?.accessoryType == UITableViewCellAccessoryType.checkmark {
            tableView.cellForRow(at: indexPath)?.accessoryType = UITableViewCellAccessoryType.none
        } else {
            tableView.cellForRow(at: indexPath)?.accessoryType = UITableViewCellAccessoryType.checkmark
        }
    }
    
    @IBAction func toggleEditingMode(_ sender: UIBarButtonItem) {
        // If you are currently editing
        if isEditing {
            // Change text of button to inform user of state.
            editButton.title = "Edit"
            // Turn off editing mode.
            setEditing(false, animated: true)
        } else {
            // Change text of button to inform user of state.
            editButton.title = "Done"
            // Turn on editing mode.
            setEditing(true, animated: true)
        }
    }
    
    @IBAction func duplicatesButtonPressed(_ sender: UIBarButtonItem) {
    
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        if (isEditing) {
            isEditing = false
        }
    }
}
