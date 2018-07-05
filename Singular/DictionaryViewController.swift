//
//  DictionaryViewController.swift
//  Singular
//
//  Created by dlr4life on 6/27/17.
//  Copyright © 2017 DLR LLC. All rights reserved.
//

import UIKit
import RealmSwift
import QuartzCore

class DateTextItem: NSObject {
    var text: String = ""
    var insertDate: NSDate = NSDate()
}

class DictionaryViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate {
    
    static let pointValue: Int = 0
    static var overallScore = 0
    
    typealias DictionaryResource = String
    
    let English: DictionaryResource = "english"
    
    @IBOutlet weak var tableview: UITableView!
    @IBOutlet weak var editButton: UIBarButtonItem!
    //    @IBOutlet weak var wordSearchTxt: UITextField!
    @IBOutlet var wordSearchTxt: ShakingTextField!
    @IBOutlet weak var englishResult: UILabel!
    @IBOutlet var clearBtn: UIButton!
    @IBOutlet weak var wordTitle: UILabel!
    
    var datasource: Results<WordItem>!
    var realm : Realm!
    var formattedTimestamp = NSDate()
    
    var testArray = [DateTextItem]()
    
    var sectionTitles = ["#", "A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z"]
    
    var dictionaries: [DictionaryResource:DictionaryLookup] = [:]
    var resultLabelsForDictionaries: [DictionaryResource:UILabel] = [:]
    var word: String? = nil { didSet {
        wordTitle.text = word ?? "No Word"
        
        if (wordSearchTxt.text?.isEmpty)! {
            print("No word entered")
        }
        
        resultLabelsForDictionaries.keys.forEach {
            if let word = word, let dictionary = dictionaries[$0] {
                resultLabelsForDictionaries[$0]?.text = dictionary.hasWord(word) ? "Yes" : "No"
            } else {
                resultLabelsForDictionaries[$0]?.text = "–" // en-dash
            }
        }
        
        wordSearchTxt.text = word ?? ""
        } }
    
    fileprivate var currentIndex = 0
    
    fileprivate func loadDictionary(_ resource: DictionaryResource) {
        if let dictionaryPath = Bundle.main.path(forResource: resource, ofType: "txt"),
            let dictionary = DictionaryLookup(path: dictionaryPath) {
            dictionaries[resource] = dictionary
        }
    }
    
    func textFieldDidChange(_ textField: UITextField) {
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Do any additional setup after loading the view, typically from a nib.
        reloadTheTable()
        animateTable()
        //        search((englishResult.text ?? nil)!)
        //        refresh()
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        wordSearchTxt.delegate = self
        //        wordSearchTxt.becomeFirstResponder()
        
        clearBtn.layer.cornerRadius = 8
        
        //        let userDefaults = Foundation.UserDefaults.standard
        
        //        let currentDate = NSDate()
        //        let timestampFromDate = convertToTimestamp(date: currentDate)
        //        let _ = convertFromTimestamp(seconds: timestampFromDate)
        //        let _ = formatDateTime(timestamp: timestampFromDate)
        //        let _ = userDefaults.string(forKey: "timeStamp")
        //        let timestamp = NSDate().timeIntervalSince1970
        
        self.setupUI()
        reloadTheTable()
        
        wordSearchTxt.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        
        loadDictionary(English)
        
        resultLabelsForDictionaries[English] = englishResult
        
        print(Realm.Configuration.defaultConfiguration.fileURL!)
    }
    
    func keyboardWillShow(sender: NSNotification) {
        self.view.frame.origin.y = -20 // Move view 150 points upward
    }
    
    func keyboardWillHide(sender: NSNotification) {
        self.view.frame.origin.y = 0 // Move view to original position
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        self.wordSearchTxt.resignFirstResponder()
    }
    
    func reloadTheTable() {
//        do {
            let realm = try! Realm()
            EndGameViewController.datasource = realm.objects(WordItem.self)
            self.tableview.reloadData()
//        }
//        catch
//        {
//        }
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
        tableview?.reloadData()
    }
    
    func setupUI() {
        tableview.delegate = self
        tableview.dataSource = self
    }
    
    func saveEntry() {
        let objectToSave = WordItem()
        objectToSave.word = wordSearchTxt.text!
        //        objectToSave.wordScore = wordScore
        objectToSave.count = objectToSave.incrementID()
        
        do {
            let realm = try Realm()
            try realm.write ({ () -> Void in
                realm.add(objectToSave)
                self.tableview?.reloadData()
                print("Word & Date Saved")
            })
        }
        catch
        {
        }
    }
    
    func saveButton(sender: AnyObject) {
        let newItem = DateTextItem()
        newItem.text = "Test \(testArray.count)"
        
        // this is for development only
        // increment the date after 2 records so we can test grouping by date
        if testArray.count >= (testArray.count/2) {
            let incrementDate = TimeInterval(86400*(testArray.count/2))
            newItem.insertDate = NSDate(timeIntervalSinceNow:incrementDate)
        }
        
        testArray.append(newItem)
        
        // this next bit will create a date string and check if it's in the sectionInTable
        let df = DateFormatter()
        df.dateFormat = "MM/dd/yyyy"
        let _ = df.string(from: newItem.insertDate as Date)
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
    
    // format the date using a timestamp
    func formatDateTime(timestamp: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .long
        let date = convertFromTimestamp(seconds: timestamp)
        return dateFormatter.string(from: date as Date)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if (wordSearchTxt.text?.isEmpty)! {
            wordSearchTxt.shake()
            self.view.backgroundColor = .red
            return true
        }
        
        if let word = wordSearchTxt.text, !word.isEmpty {
            self.word = word
        }
        
        // Check the validity of the word for points add
        if englishResult.text == "Yes" {
            self.view.backgroundColor = .green
        }
        
        if englishResult.text == "No" {
            self.view.backgroundColor = .red
            wordSearchTxt.shake()
        }
        
        saveEntry()
        self.wordSearchTxt.text = ""
        return true
    }
    
    func toggleKeyboard() {
        if self.wordSearchTxt.isFirstResponder {
            self.wordSearchTxt.resignFirstResponder()
        } else {
            self.wordSearchTxt.becomeFirstResponder()
        }
    }
    
    func search(_ word : String) {
        if UIReferenceLibraryViewController.dictionaryHasDefinition(forTerm: word) {
            self.navigationController?.pushViewController(UIReferenceLibraryViewController(term: word), animated: true)
        }
    }
    
    func animateTable() {
        self.tableview.reloadData()
        
        let cells = tableview.visibleCells
        let tableHeight: CGFloat = tableview.bounds.size.height
        
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
    
    func numberOfSections(in tableView: UITableView) -> Int {
        //        return datasource.count
        //        return sectionsInTable.count
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return EndGameViewController.datasource.count
        //        return getSectionItems(section).count
        //        return 1
    }
    
    func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        return sectionTitles
    }
    
    func tableView(_ tableView: UITableView, sectionForSectionIndexTitle title: String, at index: Int) -> Int {
        return index
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        //        return "Submissions: " //
        return "Submissions: \(EndGameViewController.datasource.count)"
        //        return sectionTitles[section]
        //        return sectionsInTable[section]
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 0))
        let headerLabel = UILabel(frame: CGRect(x: 10, y: 0, width: 320, height: 30))
        headerLabel.text = "Submissions: \(EndGameViewController.datasource.count)"
        headerLabel.textColor = .white
        headerLabel.textAlignment = .center
        view.addSubview(headerLabel)
        view.backgroundColor = UIColor(red: 99.0/255, green: 65.0/255, blue: 200.0/255, alpha: 1.0)
        return view
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        if let headerView = view as? UITableViewHeaderFooterView {
            headerView.textLabel?.textAlignment = .center
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let identifier: String = "myCell"
        
        var cell = tableView.dequeueReusableCell(withIdentifier: identifier)!
        
        let currentPlayerInfo = EndGameViewController.datasource[indexPath.row].word
        cell.textLabel?.text = currentPlayerInfo
        cell.detailTextLabel?.text = EndGameViewController.datasource[indexPath.row].date.description
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            // Show Alert.
            let title = "Delete item?" // "Delete \(self.datasource[indexPath.row].word!)"
            let message = "Are you sure you want to delete this item?"
            
            let ac = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
            
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            ac.addAction(cancelAction)
            
            let deleteAction = UIAlertAction(title: "Remove", style: .destructive, handler: { (action) in
                let realm = try! Realm()
                let word = self.datasource[indexPath.row]
                try! realm.write({
                    realm.delete(word)
                    self.reloadTheTable()
                })
            })
            ac.addAction(deleteAction)
            
            // Present alert controller.
            self.present(ac, animated: true, completion: nil)
        }
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        if (self.editButtonItem.isEnabled == true) || (self.tableview.isEditing) {
            return UITableViewCellEditingStyle.delete
        }
        return UITableViewCellEditingStyle.none
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //        let alert = UIAlertController(title: "Define entry?", message: "Are you sure you want to get the definition for \(self.datasource[indexPath.row].word!)?", preferredStyle: UIAlertControllerStyle.alert)
        //        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        //        self.present(alert, animated: true, completion: nil)
        
        search(self.tableview.cellForRow(at: indexPath)!.textLabel!.text!)
        self.tableview.deselectRow(at: indexPath, animated: true)
        
        if tableView.cellForRow(at: indexPath)?.accessoryType == UITableViewCellAccessoryType.checkmark {
            tableView.cellForRow(at: indexPath)?.accessoryType = UITableViewCellAccessoryType.none
        } else {
            tableView.cellForRow(at: indexPath)?.accessoryType = UITableViewCellAccessoryType.checkmark
        }
        
        //        print("Selected: \(self.datasource[indexPath.row].word!)")
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
    
    @IBAction func clearBtnPressed (_sender: UIButton) {
        let newWord = WordItem()
        newWord.word = wordSearchTxt.text!
        
        do {
            let realm = try Realm()
            try realm.write ({ () -> Void in
                realm.deleteAll()
                self.tableview.reloadData()
                print("Word Deleted")
            })
        }
        catch
        {
        }
        
        self.view.backgroundColor = .white
        self.wordTitle.text = String("No Word")
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        if (isEditing) {
            isEditing = false
        }
    }
}
