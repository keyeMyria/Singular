//
//  GameViewController.swift
//  Singular
//
//  Created by dlr4life on 5/11/17.
//  Copyright © 2017 DLR LLC. All rights reserved.
//

import UIKit
import Splitflap
import AVFoundation
import BetterSegmentedControl
import RealmSwift
import GameKit
import Pulsar
import Crashlytics

class GameViewController: UIViewController, UITextFieldDelegate {
    
    static var tableview: UITableView!
    static var datasource : Results<WordItem>!
    static var wordTxt: UITextField!
    //    static var count = Int = 0(index)
    
    static var gameMode = String()
    static var currentMode: String?
    static var currentCount: String?
    static var currentStyle: String?
    static var scoringStyle = String()
    
    var seconds = 60
    var timer = Timer()
    var startInt = 4
    var startTimer = Timer()
    var gameInt = 60
    var gameTimer = Timer()
    var timeRemaining: Int = 0
    var recordData:String!
    var bogglerecordData:String!
    var scrabblerecordData:String!
    var wwfrecordData:String!
    //var strikesInt: Int = 3
    var overallStrikes = 3
    var wordScore: Int = 0
    var overallScore = 0
    var index:Int = 0
    var decisionSound: AVAudioPlayer!
    
    let pointValue: Int = 0
    let step: Float = 10
    
    // IMPORTANT: replace the red string below with your own Leaderboard ID (the one you've set in iTunes Connect)
    let LEADERBOARD_ID = "grp.MShighscores"
    
    typealias DictionaryResource = String
    let SOWPODS: DictionaryResource = "sowpods"
    let TWL06: DictionaryResource = "twl06"
    let English: DictionaryResource = "english"
    
    @IBOutlet weak var startView: UIView!
    @IBOutlet var correctLbl: UILabel!
    @IBOutlet var wrongLbl: UILabel!
    @IBOutlet var readyLbl: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var progressView: UIProgressView!
    @IBOutlet weak var progressLabel: UILabel!
    @IBOutlet weak var wordTitle: UILabel!
    @IBOutlet weak var sowpodsResult: UILabel!
    @IBOutlet weak var twl06Result: UILabel!
    @IBOutlet weak var englishResult: UILabel!
    @IBOutlet var scoreLbl: UILabel!
    @IBOutlet var strikesLbl: UILabel!
    @IBOutlet var wordScoreLbl: UILabel!
    //    @IBOutlet var wordTxt: UITextField!
    @IBOutlet var wordTxt: ShakingTextField!
    @IBOutlet var activityIndicatorViewPoints: UIActivityIndicatorView!
    @IBOutlet var activityIndicatorViewStrikes: UIActivityIndicatorView!
    
    var dictionaries: [DictionaryResource:DictionaryLookup] = [:]
    var resultLabelsForDictionaries: [DictionaryResource:UILabel] = [:]
    var word: String? = nil { didSet {
        wordTitle.text = word ?? "No Word"
        
        if (wordTxt.text?.isEmpty)! {
            updateStrikeLabel()
            print("No word entered")
        }
        
        resultLabelsForDictionaries.keys.forEach {
            if let word = word, let dictionary = dictionaries[$0] {
                resultLabelsForDictionaries[$0]?.text = dictionary.hasWord(word) ? "Yes" : "No"
            } else {
                resultLabelsForDictionaries[$0]?.text = "–" // en-dash
            }
        }
        
        wordTxt.text = word ?? ""
        } }
    
    fileprivate var currentIndex = 0
    
    fileprivate func loadDictionary(_ resource: DictionaryResource) {
        if let dictionaryPath = Bundle.main.path(forResource: resource, ofType: "txt"),
            let dictionary = DictionaryLookup(path: dictionaryPath) {
            dictionaries[resource] = dictionary
        }
    }
    
    // MARK: Model
    
    func getBoggleScore(letter: Int) -> Int {
        if letter > 8 {
            return 11
        }
        var table = [Int : Int]()
        table[3] = 1
        table[4] = 1
        table[5] = 2
        table[6] = 3
        table[7] = 5
        table[8] = 11
        print("Using Boggle Scoring")
        //        print("Added \(String(describing: table[letter]!))points")
        return table[letter] ?? 0
    }
    
    func getScrabbleScore(letter: String) -> Int {
        var table = [String : Int]()
        table["a"] = 1
        table["b"] = 3
        table["c"] = 3
        table["d"] = 2
        table["e"] = 1
        table["f"] = 4
        table["g"] = 2
        table["h"] = 4
        table["i"] = 1
        table["j"] = 10
        table["k"] = 5
        table["l"] = 1
        table["m"] = 3
        table["n"] = 1
        table["o"] = 1
        table["p"] = 3
        table["q"] = 10
        table["r"] = 1
        table["s"] = 1
        table["t"] = 1
        table["u"] = 1
        table["v"] = 4
        table["w"] = 4
        table["x"] = 8
        table["y"] = 4
        table["z"] = 10
        //        table["1"] = 0
        //        table["2"] = 0
        //        table["3"] = 0
        //        table["4"] = 0
        //        table["5"] = 0
        //        table["6"] = 0
        //        table["7"] = 0
        //        table["8"] = 0
        //        table["9"] = 0
        //        table["0"] = 0
        //        table["~"] = 0
        //        table["`"] = 0
        //        table["!"] = 0
        //        table["@"] = 0
        //        table["#"] = 0
        //        table["$"] = 0
        //        table["%"] = 0
        //        table["^"] = 0
        //        table["&"] = 0
        //        table["*"] = 0
        //        table["("] = 0
        //        table[")"] = 0
        //        table["+"] = 0
        //        table["="] = 0
        //        table["{"] = 0
        //        table["}"] = 0
        //        table["["] = 0
        //        table["]"] = 0
        //        table["|"] = 0
        //        table[":"] = 0
        //        table[";"] = 0
        //        table["'"] = 0
        //        table[","] = 0
        //        table["<"] = 0
        //        table["."] = 0
        //        table[">"] = 0
        //        table["?"] = 0
        //        table["/"] = 0
        let _ = Int(String(describing: table[letter]))
        print("Using Scrabble Scoring")
        //        print ("\(table[letter]?.description ?? nil)")
        //        print("Added \(String(describing: table[letter]!)) points")
        //        print("Added \(pointValue!) points for \(String(describing: self.wordTxt.text?.characters))")
        //        do {
        //
        //        } catch let err as NSError {
        //
        //        }
        return table[letter] ?? 0
    }
    
    func getWWFScore(letter: String) -> Int {
        var table = [String : Int]()
        table["a"] = 1
        table["b"] = 3
        table["c"] = 4
        table["d"] = 4
        table["e"] = 2
        table["f"] = 1
        table["g"] = 4
        table["h"] = 3
        table["i"] = 1
        table["j"] = 8
        table["k"] = 5
        table["l"] = 2
        table["m"] = 4
        table["n"] = 2
        table["o"] = 1
        table["p"] = 4
        table["q"] = 10
        table["r"] = 1
        table["s"] = 1
        table["t"] = 1
        table["u"] = 2
        table["v"] = 5
        table["w"] = 4
        table["x"] = 8
        table["y"] = 3
        table["z"] = 10
        let _ = Int(String(describing: table[letter]))
        print("Using WWF Scoring")
        //        print("Added \(String(describing: table[letter]!)) points")
        //        print("Added \(pointValue!) points for \(String(describing: self.wordTxt.text?.characters))")
        return table[letter] ?? 0
    }
    
    func textFieldDidChange(_ textField: UITextField) {
        //        wordScore = 0
        if GameViewController.currentStyle == "Boggle" {
            boggleScoreStyle()
        } else if GameViewController.currentStyle == "Scrabble" {
            scrabbleScoreStyle()
        } else if GameViewController.currentStyle == "WordswithFriends"{
            wWFScoreStyle()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(GameViewController.keyboardWillShow(sender:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(GameViewController.keyboardWillHide(sender:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        showPopup(UIButton.self)
        
        progressLabel.isHidden = true
        
        setProgress(0)
        
        wordTxt.delegate = self
        
        scoreLbl.text = overallScore.description
        
        startTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(GameViewController.startGameTimer), userInfo: nil, repeats: true)
        
        gameInt = 60
        
        timeLabel.text = String(gameInt)
        
        let userDefaults = UserDefaults.standard
        let value = userDefaults.string(forKey: "record")
        let bogglevalue = userDefaults.string(forKey: "bogglerecord")
        let scrabblevalue = userDefaults.string(forKey: "scrabblerecord")
        let wwfvalue = userDefaults.string(forKey: "wwfrecord")
        
        let progressView = UIView(frame: CGRect(x: 0, y: 0, width: 1, height: 50))
        progressView.backgroundColor = .blue
        
        recordData = value
        bogglerecordData = bogglevalue
        scrabblerecordData = scrabblevalue
        wwfrecordData = wwfvalue
        
        wordTxt.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        
        self.addRepeatingPulseToProgressIndicatorPoints()
        self.addRepeatingPulseToProgressIndicatorStrikes()
        self.activityIndicatorViewPoints.startAnimating()
        self.activityIndicatorViewStrikes.startAnimating()
        
        loadDictionary(English)
        
        resultLabelsForDictionaries[English] = englishResult
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    // MARK: - Functions
    
    func keyboardWillShow(sender: NSNotification) {
        self.view.frame.origin.y = -20 // Move view 150 points upward
    }
    
    func keyboardWillHide(sender: NSNotification) {
        self.view.frame.origin.y = 0 // Move view to original position
    }
    
    func search(_ word : String) {
        if UIReferenceLibraryViewController.dictionaryHasDefinition(forTerm: word) {
            self.navigationController?.pushViewController(UIReferenceLibraryViewController(term: word), animated: true)
        }
    }
    
    func boggleScoreStyle() {
        wordScore = 0
        wordScore = getBoggleScore(letter: (wordTxt.text?.characters.count)!)
        wordScoreLbl.text = String("\(getBoggleScore(letter: (wordTxt.text?.characters.count)!))")
        wordScoreLbl.text = String(wordScore)
        scoreLbl.text = "\(overallScore)"
    }

    func scrabbleScoreStyle() {
        wordScore = 0
        for i in (wordTxt.text?.characters)! {
            let someString = String(i)
            
            wordScore += getScrabbleScore(letter: someString)
            wordScoreLbl.text = "\(overallScore)"
            wordScoreLbl.text = String(wordScore)
        }
        wordScoreLbl.text = String(wordScore)
        scoreLbl.text = "\(overallScore)"
    }
    
    func wWFScoreStyle() {
        wordScore = 0
        for i in (wordTxt.text?.characters)! {
            let someString = String(i)
            
            wordScore += getWWFScore(letter: someString)
            wordScoreLbl.text = "\(overallScore)"
            wordScoreLbl.text = String(wordScore)
        }
        wordScoreLbl.text = String(wordScore)
        scoreLbl.text = "\(overallScore)"
    }
    
    func setProgress(_ progress: CGFloat) {
        UIView.animate(withDuration: 1.5) {
        }
        
        if gameInt == 0{
            gameTimer.invalidate()
            ending()
        }
    }
    
    func updateProgress() {
        let progressValue = self.progressView?.progress
        progressView?.progress = 0.0
        progressLabel?.text = "0 %"
        progressLabel.isHidden = true
        //        progressView.progress += 0.015873
        progressView.progress += 0.0140
        
        progressView?.setProgress(Float(gameInt), animated: true)
        progressLabel?.text = "\(progressValue! / 100) %"
        
        if seconds == 0{
            Timer.scheduledTimer(timeInterval: 0, target: self, selector: #selector(GameViewController.ending), userInfo: nil, repeats: false)
        }
    }
    
    func colorsWithHalfOpacity(_ colors: [CGColor]) -> [CGColor] {
        return colors.map({ $0.copy(alpha: $0.alpha * 0.5)! })
    }
    
    func updateScoreLabel() {
        
        if englishResult.text == "Yes" {
            correctLbl.backgroundColor = .white
            wrongLbl.backgroundColor = .clear
            
            // Submit score to GC leaderboard
            let bestScoreInt = GKScore(leaderboardIdentifier: LEADERBOARD_ID)
            bestScoreInt.value = Int64(overallScore)
            GKScore.report([bestScoreInt]) { (error) in
                if error != nil {
                    print(error!.localizedDescription)
                } else {
                    print("Best Score submitted to your Leaderboard!")
                }
            }
            
            scoreLbl.transform = CGAffineTransform(scaleX: 0.3, y: 2)
            
            UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.3,  initialSpringVelocity: 0, options: .allowUserInteraction, animations: { self.scoreLbl.transform =  .identity
                self.overallScore += self.wordScore
                self.scoreLbl.text = self.wordScoreLbl.text
                
            }) { (success) in
            }
        }
        
        let _ = scoreLbl.layer.addPulse { pulse in
            pulse.borderColors = [
                UIColor(hue: CGFloat(arc4random()) / CGFloat(RAND_MAX), saturation: 1.0, brightness: 1.0, alpha: 1.0).cgColor
            ]
            pulse.backgroundColors = self.colorsWithHalfOpacity(pulse.borderColors)
        }
        scoreLbl.text = self.wordScoreLbl.text
        scoreLbl.text = "\(overallScore)"
    }
    
    func addRepeatingPulseToProgressIndicatorStrikes() {
        let _ = self.activityIndicatorViewStrikes.layer.addPulse { pulse in
            pulse.borderColors = [UIColor.clear.cgColor, UIColor.black.cgColor]
            pulse.backgroundColors = self.colorsWithHalfOpacity(pulse.borderColors)
            pulse.path = UIBezierPath(ovalIn: self.activityIndicatorViewStrikes.bounds).cgPath
            pulse.transformBefore = CATransform3DMakeScale(0.65, 0.65, 0.0)
            pulse.duration = 2.0
            pulse.repeatDelay = 0.0
            pulse.repeatCount = Int.max
            pulse.lineWidth = 2.0
            pulse.backgroundColors = []
        }
    }
    
    func addRepeatingPulseToProgressIndicatorPoints() {
        let _ = self.activityIndicatorViewPoints.layer.addPulse { pulse in
            pulse.borderColors = [UIColor.clear.cgColor, UIColor.black.cgColor]
            pulse.backgroundColors = self.colorsWithHalfOpacity(pulse.borderColors)
            pulse.path = UIBezierPath(ovalIn: self.activityIndicatorViewPoints.bounds).cgPath
            pulse.transformBefore = CATransform3DMakeScale(0.65, 0.65, 0.0)
            pulse.duration = 2.0
            pulse.repeatDelay = 0.0
            pulse.repeatCount = Int.max
            pulse.lineWidth = 2.0
            pulse.backgroundColors = []
        }
    }
    
    func updateStrikeLabel() {
        
        if twl06Result.text == "No" {
            correctLbl.backgroundColor = .clear
            wrongLbl.backgroundColor = .white
            
            strikesLbl.transform = CGAffineTransform(scaleX: 0.3, y: 2)
            
            UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.3,  initialSpringVelocity: 0, options: .allowUserInteraction, animations: { self.strikesLbl.transform =  .identity
                self.strikesLbl.text = self.overallStrikes.description
            }) { (success) in
            }
            
        } else {
            strikesLbl.text = overallStrikes.description
        }
        if strikesLbl.text == "0" {
            gameTimer.invalidate()
            ending()
            
            if recordData == nil{
                let saveScore = scoreLbl.text
                let userDefaults = UserDefaults.standard
                userDefaults.set(saveScore, forKey: "Boggle")
                userDefaults.set(saveScore, forKey: "Scrabble")
                userDefaults.set(saveScore, forKey: "WordswithFriends")
            }
            else{
                self.scoreLbl.text = "0"
            }
            strikesLbl.text = overallStrikes.description
        }
        
        if bogglerecordData == nil{
            let saveScore = scoreLbl.text
            UserDefaults.standard.set(saveScore, forKey: "bogglerecord")
        } else{
            
            let score:Int? = Int(scoreLbl.text!)
            let record:Int?  = Int(bogglerecordData)
            
            if score! > record!{
                let saveScore = scoreLbl.text
                UserDefaults.standard.set(saveScore, forKey: "bogglerecord")
            }
            strikesLbl.text = overallStrikes.description
        }

            if scrabblerecordData == nil{
            let saveScore = scoreLbl.text
            UserDefaults.standard.set(saveScore, forKey: "scrabblerecord")
        } else{
            
            let score:Int? = Int(scoreLbl.text!)
            let record:Int?  = Int(scrabblerecordData)
            
            if score! > record!{
                let saveScore = scoreLbl.text
                UserDefaults.standard.set(saveScore, forKey: "scrabblerecord")
            }
            strikesLbl.text = overallStrikes.description
        }
        
        if wwfrecordData == nil{
            let saveScore = scoreLbl.text
            UserDefaults.standard.set(saveScore, forKey: "wwfrecord")
        } else{
            
            let score:Int? = Int(scoreLbl.text!)
            let record:Int?  = Int(wwfrecordData)
            
            if score! > record!{
                let saveScore = scoreLbl.text
                UserDefaults.standard.set(saveScore, forKey: "wwfrecord")
            }
            strikesLbl.text = overallStrikes.description
        }
        
        let _ = strikesLbl.layer.addPulse { pulse in
            pulse.borderColors = [
                UIColor(hue: CGFloat(arc4random()) / CGFloat(RAND_MAX), saturation: 1.0, brightness: 1.0, alpha: 1.0).cgColor
            ]
            pulse.backgroundColors = self.colorsWithHalfOpacity(pulse.borderColors)
        }
        strikesLbl.text = overallStrikes.description
    }
    
    func showPopup (_ sender: Any) {
        UIView.animate(withDuration: 0.2, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0, options: .curveEaseIn, animations: {
            self.startView.layoutIfNeeded()
        }, completion: nil)
        
        UIView.animate(withDuration: 0.2, animations: {
        })
        
        self.view.addSubview(startView)
        startView.center = self.view.center
        startView.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
        startView.alpha = 0
        
        UIView.animate(withDuration: 0.2) {
            self.startView.alpha = 1
            self.startView.transform = CGAffineTransform.identity
        }
    }
    
    func closePopup (_ sender: Any) {
        //        self.dismiss(animated: true, completion: nil)
        UIView.animate(withDuration: 0.1, animations: {
            self.startView.layoutIfNeeded()
        })
        
        UIView.animate(withDuration: 0.3, animations: {
            self.startView.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
            self.startView.alpha = 0
        }) { (success:Bool) in
            self.startView.removeFromSuperview()
        }
    }
    
    func counter() {
        seconds -= 3
        if (seconds == 0) {
            timer.invalidate()
        }
    }
    
    func startGameTimer(){
        startInt -= 1
        readyLbl.text = (String(startInt))
        
        // condition that checks and stops the number from going beyond 0
        if startInt == 0{
            startTimer.invalidate()
            
            timeLabel.text = "Go"
            closePopup(UIButton.self)
            updateProgress()
            wordTxt.delegate = self
            wordTxt.becomeFirstResponder()
            
            gameTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(GameViewController.game), userInfo: nil, repeats: true)
        }
    }
    
    func game(){
        gameInt -= 1
        timeLabel.text = String(gameInt)
        
        if gameInt == 0{
            gameTimer.invalidate()
            
            if bogglerecordData == nil{
                let saveScore = scoreLbl.text
                let userDefaults = UserDefaults.standard
                userDefaults.set(saveScore, forKey: "Boggle")
            } else {
                
                let score:Int? = Int(scoreLbl.text!)
                let record:Int?  = Int(bogglerecordData)
                
                if score! > record!{
                    let saveScore = scoreLbl.text
                    let userDefaults = UserDefaults.standard
                    userDefaults.set(saveScore, forKey: "Boggle")
                }
            }
            
            if scrabblerecordData == nil{
                let saveScore = scoreLbl.text
                let userDefaults =  UserDefaults.standard
                userDefaults.set(saveScore, forKey: "Scrabble")
            } else {
                
                let score:Int? = Int(scoreLbl.text!)
                let record:Int?  = Int(scrabblerecordData)
                
                if score! > record!{
                    let saveScore = scoreLbl.text
                    let userDefaults = UserDefaults.standard
                    userDefaults.set(saveScore, forKey: "Scrabble")
                }
            }
            
            if wwfrecordData == nil{
                let saveScore = scoreLbl.text
                let userDefaults = UserDefaults.standard
                userDefaults.set(saveScore, forKey: "WordswithFriends")
            } else {
                
                let score:Int? = Int(scoreLbl.text!)
                let record:Int?  = Int(wwfrecordData)
                
                if score! > record!{
                    let saveScore = scoreLbl.text
                    let userDefaults = UserDefaults.standard
                    userDefaults.set(saveScore, forKey: "WordswithFriends")
                }
            }
            Timer.scheduledTimer(timeInterval: 0, target: self, selector: #selector(GameViewController.ending), userInfo: nil, repeats: false)
        }
    }
    
    func saveEntry() {
        let objectToSave = WordItem()
        objectToSave.word = wordTxt.text!
        objectToSave.wordScore = wordScore
        objectToSave.count = objectToSave.incrementID()
        
        do {
            let realm = try Realm()
            try realm.write ({ () -> Void in
                realm.add(objectToSave)
                GameViewController.tableview?.reloadData()
                print("Word & Score Saved")
            })
        }
        catch
        {
        }
    }
    
    func isWordEntered(word: String) -> Bool {
        let realm = try! Realm()
        let predicate = NSPredicate(format: "word = %@", word)
        let result = realm.objects(WordItem.self).filter(predicate)
        return result.count > 0
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if (wordTxt.text?.isEmpty)! {
            wrongLbl.backgroundColor = .red
            correctLbl.backgroundColor = .clear
            self.wordScoreLbl.text = "0"
            wordTxt.shake()
            removeStrike()
            print("Strike Removed - No Word")
            updateStrikeLabel()
            print("Strike Updated - No Word")
            self.wordTitle.text = "BLANK"
            self.word = "BLANK"
            wordScore = 0
            self.wordScoreLbl.text = "\(wordScore)"
            saveEntry()
            print("\(word!) submitted")
            self.wordTxt.text = ""
            return true
        }
        
        if let word = wordTxt.text, !word.isEmpty {
            self.word = word
        }
        
        if !isWordEntered(word: wordTxt.text ?? "") {
            correctLbl.backgroundColor = .green
            wrongLbl.backgroundColor = .clear
            self.wordScoreLbl.text = "0"
            print("Entry Saved - New Word")
            updateScoreLabel()
            print("Score Updated - New Word")
            print("New Word submitted")
        } else {
            wrongLbl.backgroundColor = .red
            correctLbl.backgroundColor = .clear
            self.wordScoreLbl.text = "0"
            wordTxt.shake()
            removeStrike()
            print("Strike Removed - Repeated Word")
            updateStrikeLabel()
            print("Strike Updated - Repeated Word")
            self.wordTitle.text = "DUPLICATE"
            self.word = "DUPLICATE"
            print("\(word!) already submitted")
            self.wordTxt.text = ""
            return true
        }
        
        // Check the validity of the word for points add
        if twl06Result.text == "Yes" {
            correctLbl.backgroundColor = .green
            wrongLbl.backgroundColor = .clear
            self.wordScoreLbl.text = "0"
            saveEntry()
            print("Entry Saved - Correct Word")
            updateScoreLabel()
            print("Score Updated - Correct Word")
            print("New Word submitted")
        } else {
            wrongLbl.backgroundColor = .red
            correctLbl.backgroundColor = .clear
            self.wordScoreLbl.text = "0"
            wordTxt.shake()
            removeStrike()
            print("Strike Removed - Wrong/Misspelled Word")
            updateStrikeLabel()
            print("Strike Updated - Wrong/Misspelled Word")
            saveEntry()
            print("\(word!) doesn't exist")
            self.wordTxt.text = ""
            return true
        }
        self.wordTxt.text = ""
        return true
    }
    
    func toggleKeyboard() {
        if wordTxt.isFirstResponder {
            wordTxt.resignFirstResponder()
        } else {
            wordTxt.becomeFirstResponder()
        }
    }
    
    func removeStrike() {
        if twl06Result.text == "No" || (wordTxt.text?.isEmpty)! || isWordEntered(word: wordTxt.text ?? "") {
            overallStrikes -= 1
            strikesLbl.text = overallStrikes.description
        }
        
        if strikesLbl.text == "0" {
            gameTimer.invalidate()
            ending()
            return
        }
        print("STRIKES DEPLEATED")
    }
    
    func ending(){
        // this line takes the vc to the the specific 3rd viewController in the storyBoard
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "EndGameVC") as! EndGameViewController
        vc.scoreData = scoreLbl.text
        UserDefaults.standard.set(scoreLbl.text, forKey: GameViewController.scoringStyle ?? "123")
        self.present(vc, animated: true, completion: nil)
    }
}

