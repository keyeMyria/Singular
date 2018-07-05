//
//  EndGameViewController.swift
//  Singular
//
//  Created by dlr4life on 7/15/17.
//  Copyright © 2017 DLR LLC. All rights reserved.
//

import UIKit
import Social
import MessageUI
import RealmSwift

class EndGameViewController: UIViewController, MFMailComposeViewControllerDelegate, UITableViewDataSource, UITableViewDelegate {
    
//    static let pointValue: Int = 0
    static var overallScore = 0
    static var gameMode = String()
    static var scoringStyle = String()
    static var currentStyle: String?
    static var scoreLbl: UILabel!
    static var datasource : Results<WordItem>!
//    static var wordScore: Int = 0
    static var player1Score: UILabel!
    static let pointValue = 0
    
    typealias DictionaryResource = String
    let TWL06: DictionaryResource = "twl06"
    
    var realm : Realm!
    
    @IBOutlet weak var tableview: UITableView!
    
    @IBOutlet weak var label1: UILabel!
    @IBOutlet weak var label2: UILabel!
    @IBOutlet weak var shareFacebook: UIButton!
    @IBOutlet weak var shareEmail: UIButton!
    @IBOutlet weak var shareSms: UIButton!
    @IBOutlet weak var restartBtn: UIButton!
    @IBOutlet weak var resultsBtn: UIButton!
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var popupView: UIView!
    @IBOutlet weak var backgroundButton: UIButton!
    
    @IBOutlet weak var finalscorelbl: UILabel!
    
    var scoreData:String!
    
    let messageComposer = MessageComposer()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    var dictionaries: [DictionaryResource:DictionaryLookup] = [:]
    var resultLabelsForDictionaries: [DictionaryResource:UILabel] = [:]
    var word: String? = nil { didSet {
        
        resultLabelsForDictionaries.keys.forEach {
            if let word = word, let dictionary = dictionaries[$0] {
                resultLabelsForDictionaries[$0]?.text = dictionary.hasWord(word) ? "Yes" : "No"
            } else {
                resultLabelsForDictionaries[$0]?.text = "–" // en-dash
            }
        }
        
        } }
    
    
    fileprivate var currentIndex = 0
    
    fileprivate func loadDictionary(_ resource: DictionaryResource) {
        if let dictionaryPath = Bundle.main.path(forResource: resource, ofType: "txt"),
            let dictionary = DictionaryLookup(path: dictionaryPath) {
            dictionaries[resource] = dictionary
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        showPopup(UIButton.self)
        self.backgroundView.alpha = 1.0
        
        label1.layer.cornerRadius = 5.0
        label2.layer.cornerRadius = 5.0
        shareFacebook.layer.cornerRadius = 5.0
        shareEmail.layer.cornerRadius = 5.0
        shareSms.layer.cornerRadius = 5.0
        restartBtn.layer.cornerRadius = 5.0
        
        finalscorelbl.text!  = scoreData
        
        popupView.layer.cornerRadius = 10
        popupView.layer.masksToBounds = true
        
        self.setupUI()
        reloadTheTable()
        
        loadDictionary(TWL06)
        
        if GameViewController.currentStyle == "Boggle" {
            UserDefaults.standard.set(scoreData, forKey: "b")
        }
        if GameViewController.currentStyle == "Scrabble" {
            UserDefaults.standard.set(scoreData, forKey: "s")
        }
        if GameViewController.currentStyle == "WordswithFriends" {
            UserDefaults.standard.set(scoreData, forKey: "w")
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func resultsBtnPressed(sender: UIButton) {
        UIView.animate(withDuration: 0.2, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0, options: .curveEaseIn, animations: {
            self.popupView.layoutIfNeeded()
        }, completion: nil)
        
        UIView.animate(withDuration: 0.2, animations: {
            self.backgroundButton.alpha = 0.5
            self.backgroundView.alpha = 1.0
            
        })
        
        self.view.addSubview(popupView)
        popupView.center = self.view.center
        popupView.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
        popupView.alpha = 0
        
        UIView.animate(withDuration: 0.2) {
            self.popupView.alpha = 1
            self.popupView.transform = CGAffineTransform.identity
        }
    }
    
    @IBAction func shareFacebookBtnTouched(sender: UIButton) {
        let shareActionSheet: UIAlertController = UIAlertController(title:nil, message:nil, preferredStyle:UIAlertControllerStyle.actionSheet)
        shareActionSheet.addAction(UIAlertAction(title:"Share with Facebook", style:UIAlertActionStyle.default, handler:{ action in
            //            let image: UIImage = UIImage(named: "shareImage2.png")!
            let fbController = SLComposeViewController(forServiceType: SLServiceTypeFacebook)
            fbController?.setInitialText("I scored \(self.scoreData!) in the Singular App! Download now to challenge yourself and friends!")
            //            self.screenShotMethod()
            //            fbController?.add(image)
            //            fbController?.add(URL(string: "http://www.google.com"))
            
            let completionHandler = {(result:SLComposeViewControllerResult) -> () in
                fbController?.dismiss(animated: true, completion:nil)
                switch(result){
                case SLComposeViewControllerResult.cancelled:
                    print("User canceled", terminator: "")
                case SLComposeViewControllerResult.done:
                    print("User posted", terminator: "")
                }
            }
            fbController?.completionHandler = completionHandler
            fbController?.view.backgroundColor = UIColor(red:0.23, green:0.35, blue:0.60, alpha:1.0)
            self.present(fbController!, animated: true, completion:nil)
        }))
        shareActionSheet.addAction(UIAlertAction(title:"Cancel", style:UIAlertActionStyle.cancel, handler:nil))
        self.present(shareActionSheet, animated:true, completion:nil)
    }
    
    @IBAction func shareEmailBtnTouched(sender: UIButton) {
        let mailComposeController = MFMailComposeViewController()
        mailComposeController.mailComposeDelegate = self;
        mailComposeController.setToRecipients([ "singularapp@gmail.com"])
        mailComposeController.setSubject("Share Score")
        mailComposeController.setMessageBody("<p>I scored \(self.scoreData!) in the Singular App! Download now to challenge yourself and friends!</p>", isHTML: true)
        
        // First ask if we can send mail
        if MFMailComposeViewController.canSendMail() {
            self.present(mailComposeController, animated: true, completion: { () -> Void in
                //        print("User can send mail.")
                //        print("The Contact button was clicked.")
            })
        }
    }
    
    func reloadTheTable() {
        do {
            let realm = try Realm()
            EndGameViewController.datasource = realm.objects(WordItem.self)
            tableview?.reloadData()
        }
        catch
        {
        }
    }
    
    func setupUI() {
        tableview.delegate = self
        tableview.dataSource = self
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return EndGameViewController.datasource.count
//        return 1
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Word           Points"
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        if let headerView = view as? UITableViewHeaderFooterView {
            headerView.textLabel?.textAlignment = .center
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let identifier: String = "matchCell"
        
        var cell = tableView.dequeueReusableCell(withIdentifier: identifier)!
        
        let currentPlayerInfo = EndGameViewController.datasource[indexPath.row].word
        cell.textLabel?.text = currentPlayerInfo
        cell.detailTextLabel?.text = EndGameViewController.datasource[indexPath.row].wordScore.description
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        search(self.tableview.cellForRow(at: indexPath)!.textLabel!.text!)
        self.tableview.deselectRow(at: indexPath, animated: true)
        
        if tableView.cellForRow(at: indexPath)?.accessoryType == UITableViewCellAccessoryType.checkmark {
            tableView.cellForRow(at: indexPath)?.accessoryType = UITableViewCellAccessoryType.none
        } else {
            tableView.cellForRow(at: indexPath)?.accessoryType = UITableViewCellAccessoryType.checkmark
        }
        print("Selected row at \(EndGameViewController.datasource[indexPath.row])")
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true) { () -> Void in
        }
    }
    
    func showPopup (_ sender: Any) {
        UIView.animate(withDuration: 0.2, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0, options: .curveEaseIn, animations: {
            self.popupView.layoutIfNeeded()
        }, completion: nil)
        
        UIView.animate(withDuration: 0.2, animations: {
            self.backgroundButton.alpha = 0.5
            self.backgroundView.alpha = 1.0
        })
        
        self.view.addSubview(popupView)
        popupView.center = self.view.center
        popupView.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
        popupView.alpha = 0
        
        UIView.animate(withDuration: 0.2) {
            self.popupView.alpha = 1
            self.popupView.transform = CGAffineTransform.identity
            
            //            self.lastWordTxt.text = "\(EndGameViewController.datasource.description)"
        }
    }
    
    func search(_ word : String) {
        if UIReferenceLibraryViewController.dictionaryHasDefinition(forTerm: word) {
            self.navigationController?.pushViewController(UIReferenceLibraryViewController(term: word), animated: true)
        }
    }
    
    @IBAction func closePopup (_ sender: Any) {
        //        self.dismiss(animated: true, completion: nil)
        UIView.animate(withDuration: 0.1, animations: {
            self.popupView.layoutIfNeeded()
            self.backgroundButton.alpha = 0
            self.backgroundView.alpha = 0.0
        })
        
        UIView.animate(withDuration: 0.3, animations: {
            self.popupView.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
            self.popupView.alpha = 0
        }) { (success:Bool) in
            self.popupView.removeFromSuperview()
        }
    }
    
    @IBAction func shareSmsBtnTouched(sender: UIButton) {
        // Make sure the device can send text messages
        if (messageComposer.canSendText()) {
            // Obtain a configured MFMessageComposeViewController
            let messageComposeVC = messageComposer.configuredMessageComposeViewController()
            
            // Present the configured MFMessageComposeViewController instance
            // Note that the dismissal of the VC will be handled by the messageComposer instance,
            // since it implements the appropriate delegate call-back
            present(messageComposeVC, animated: true, completion: nil)
        } else {
            // Let the user know if his/her device isn't able to send text messages
            //            let errorAlert = UIAlertView(title: "Cannot Send Text Message", message: "Your device is not able to send text messages.", delegate: self, cancelButtonTitle: "OK")
            //            let errorAlert = UIAlertController(title: "Alert", message: "Message", preferredStyle: UIAlertControllerStyle.alert)
            
            
            //Create the AlertController
            let actionSheetController: UIAlertController = UIAlertController(title: "Cannot Send Text Message", message: "Your device is not able to send text messages.", preferredStyle: .alert)
            
            //Create and add the Cancel action
            let cancelAction: UIAlertAction = UIAlertAction(title: "Cancel", style: .cancel) { action -> Void in
                //Do some stuff
            }
            actionSheetController.addAction(cancelAction)
            //Create and an option action
            let nextAction: UIAlertAction = UIAlertAction(title: "OK", style: .default) { action -> Void in
                //Do some other stuff
            }
            actionSheetController.addAction(nextAction)
            
            //Present the AlertController
            self.present(actionSheetController, animated: true, completion: nil)
            
            //            errorAlert.show()
        }
    }
    
    @IBAction func dismissToHomeVC(_ sender: AnyObject) {
        performSegue(withIdentifier: "dismissToHomeVC", sender: nil)
    }

}
