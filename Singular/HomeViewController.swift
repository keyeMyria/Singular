//
//  HomeViewController.swift
//  Singular
//
//  Created by dlr4life on 5/12/17.
//  Copyright © 2017 DLR LLC. All rights reserved.
//

import UIKit
import Splitflap
import Pastel
import GameKit
import RealmSwift
import BetterSegmentedControl

class HomeViewController: UIViewController, SplitflapDataSource, SplitflapDelegate, GKGameCenterControllerDelegate {

    static var currentStyle: String?
    static var scoreLbl: UILabel!

    @IBOutlet weak var welcomeLabel: UILabel!
    
    @IBOutlet weak var languageImage: UIImageView!
    @IBOutlet weak var languageLbl: UILabel!
    @IBOutlet var languageBtn: UIButton!

    @IBOutlet weak var scoringControl: BetterSegmentedControl!
    @IBOutlet weak var splitflap: Splitflap!
    @IBOutlet weak var highscoreLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var versionLabel: UILabel!
    
    @IBOutlet var enterBtn: UIButton!
    @IBOutlet var resetBtn: UIButton!
    @IBOutlet var audioBtn: UIButton!
    @IBOutlet var checkGCLeaderboard: UIButton!
    @IBOutlet var tutorialBtn: UIButton!

    let highscoreItem = ["Boggle", "Scrabble", "Words with Friends"]
    let scoreItem = "0"
    var currentTitle:String?
//    var bogglevalue = "0"
//    var scrabblevalue = "0"
//    var wwfvalue = "0"
    var rotationAngle: CGFloat!
    
    var datasource: Results<WordItem>!
    var realm : Realm!
    
    var gcEnabled = Bool() // Check if the user has Game Center enabled
    var gcDefaultLeaderBoard = String() // Check the default leaderboardID
    
    // IMPORTANT: replace the red string below with your own Leaderboard ID (the one you've set in iTunes Connect)
    let LEADERBOARD_ID = "com.score.username"
    
    override func viewDidAppear(_ animated: Bool) {
        checkGCLeaderboard.alpha = 0
        tutorialBtn.alpha = 0
        audioBtn.alpha = 0
        
        splitflap.reload()
//        snowBalls()
//        snowchats()
//        snowLeaders()
        
        // Set the text to display by animating the flaps
        splitflap.setText("Singular", animated: true, completionBlock: {
            print("Display finished!")
        })
        
        checkGCLeaderboard.transform = CGAffineTransform(scaleX: 0.3, y: 2)
        tutorialBtn.transform = CGAffineTransform(scaleX: 0.3, y: 2)
        audioBtn.transform = CGAffineTransform(scaleX: 0.3, y: 2)

        UIView.animate(withDuration: 1, delay: 0.2, usingSpringWithDamping: 0.3,  initialSpringVelocity: 0, options: .allowUserInteraction, animations: { self.checkGCLeaderboard.transform =  .identity
            self.tutorialBtn.transform =  .identity
            self.audioBtn.transform =  .identity
        }) { (success) in
        }
        self.checkGCLeaderboard.alpha = 1
        self.tutorialBtn.alpha = 1
        self.audioBtn.alpha = 1
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = .white
        
        splitflap.datasource = self
        splitflap.delegate = self
//        splitflap.reload()
        
        versionLabel.layer.cornerRadius = 8
        
        languageBtn.layer.cornerRadius = 8
        languageBtn.layer.borderWidth = 1
        
        let language = NSLocale.preferredLanguages[0]
        let languageDic = NSLocale.components(fromLocaleIdentifier: language) as NSDictionary
        //let countryCode = languageDic.objectForKey("kCFLocaleCountryCodeKey")
        let languageCode = languageDic.object(forKey: "kCFLocaleLanguageCodeKey") as! String
        languageLbl.text = String(languageCode)
        
        enterBtn.layer.cornerRadius = 8
        resetBtn.layer.cornerRadius = 8

        let textVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
        versionLabel.text = ("Build Version: " + textVersion!)

        let pastelView = PastelView(frame: view.bounds)
        
        // Custom Direction
        pastelView.startPastelPoint = .bottomLeft
        pastelView.endPastelPoint = .topRight
        
        // Custom Duration
        pastelView.animationDuration = 2.0
        
        // Custom Color
        pastelView.setColors([UIColor(red: 156/255, green: 39/255, blue: 176/255, alpha: 1.0),
                              UIColor(red:0.21, green:0.56, blue:0.73, alpha:1.0),
                              UIColor(red:0.97, green:0.97, blue:0.97, alpha:1.0)])
        
        pastelView.startAnimation()
        view.insertSubview(pastelView, at: 1)
        
        if let name = UserDefaults.standard.value(forKey: "name") {
            welcomeLabel.text = "Welcome \(name)!"
        }
        
        scoringControl.titles = ["Boggle", "Scrabble", "WWF"]
//        scoringControl.titles = ["#imageLiteral(resourceName: "scoreStyle_0")", "#imageLiteral(resourceName: "scoreStyle_1")", "#imageLiteral(resourceName: "scoreStyle_2")"]
//        scoringControl.titles = String([UIImage(named: #imageLiteral(resourceName: "scoreStyle_0")), UIImage(named: #imageLiteral(resourceName: "scoreStyle_1")), UIImage(named: #imageLiteral(resourceName: "scoreStyle_2"))])
        scoringControl.titleFont = UIFont(name: "HelveticaNeue-Light", size: 13.0)!
        scoringControl.selectedTitleFont = UIFont(name: "HelveticaNeue-Medium", size: 13.0)!
        scoringControl.indicatorViewBackgroundColor = UIColor(red:0.62, green:0.60, blue:0.60, alpha:1.0)
        scoringControl.selectedTitleColor = UIColor(red:1.00, green:1.00, blue:1.00, alpha:1.0)
        scoringControl.bouncesOnChange = false
        scoringControl.addTarget(self, action: #selector(ScoringViewController.scoringControlValueChanged(_:)), for: .valueChanged)
        scoringControl.alwaysAnnouncesValue = true
        scoringControl.announcesValueImmediately = false
        
        do {
            try scoringControl.setIndex(0, animated: false)
        }
        catch BetterSegmentedControl.IndexError.indexBeyondBounds(let invalidIndex) {
            print("Tried setting invalid index \(invalidIndex) to demonstrate error handling.")
        }
        catch {
            print("An error occured")
        }
        try! scoringControl.setIndex(0, animated: false)

        // Call the GC authentication controller
//        authenticateLocalPlayer()
    }
    
    // MARK: - Splitflap DataSource Methods
    
    // Defines the number of flaps that will be used to display the text
    func numberOfFlapsInSplitflap(_ splitflap: Splitflap) -> Int {
        return 8
    }
    
    func tokensInSplitflap(_ splitflap: Splitflap) -> [String] {
        return SplitflapTokens.AlphanumericAndSpace
    }
    
    // MARK: - Splitflap Delegate Methods
    
    func splitflap(_ splitflap: Splitflap, rotationDurationForFlapAtIndex index: Int) -> Double {
        return 0.09
    }
    
    func splitflap(_ splitflap: Splitflap, builderForFlapAtIndex index: Int) -> FlapViewBuilder {
        return FlapViewBuilder { builder in
            builder.backgroundColor = .black
            builder.cornerRadius    = 5
            builder.font            = UIFont(name: "Courier", size: 30)
            builder.textAlignment   = .center
            builder.textColor       = .white
            builder.lineColor       = .darkGray
        }
        
        //        return FlapViewBuilder { builder in
        //            builder.backgroundColor = UIColor(red: 251/255, green: 249/255, blue: 243/255, alpha: 1)
        //            builder.cornerRadius    = 5
        //            builder.font            = UIFont(name: "Avenir-Black", size:45)
        //            builder.textAlignment   = .center
        //            builder.textColor       = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
        //            builder.lineColor       = UIColor(red: 0, green: 0, blue: 0, alpha: 0.3)
        //        }
        
    }

    // MARK: Emitter Functions

    func snowBalls() {
        let emitter = Emitter.get(with: #imageLiteral(resourceName: "swearImage2"))
        emitter.emitterPosition = CGPoint(x: view.frame.width / 2, y: 50)
        emitter.emitterSize = CGSize(width: view.frame.width, height: 2)
        view.layer.addSublayer(emitter)
    }

    func snowchats() {
        let emitter = Emitter.get(with: #imageLiteral(resourceName: "chatImage"))
        emitter.emitterPosition = CGPoint(x: view.frame.width / 2, y: 50)
        emitter.emitterSize = CGSize(width: view.frame.width, height: 2)
        view.layer.addSublayer(emitter)
    }
    
    func snowLeaders() {
        let emitter = Emitter.get(with: #imageLiteral(resourceName: "leaderboardImage"))
        emitter.emitterPosition = CGPoint(x: view.frame.width / 2, y: 50)
        emitter.emitterSize = CGSize(width: view.frame.width, height: 2)
        view.layer.addSublayer(emitter)
    }
    
    func scoringControlValueChanged(_ sender: BetterSegmentedControl) {
        
        switch sender.index {
        case 0:
            
            if let topScore = UserDefaults.standard.value(forKey: "b" ) as? String {
                 self.scoreLabel.text = topScore
            } else {
                self.scoreLabel.text = "0"
            }
        case 1:
            if let topScore = UserDefaults.standard.value(forKey: "s" ) as? String {
                self.scoreLabel.text = topScore
            } else {
                self.scoreLabel.text = "0"
            }
        case 2:
            if let topScore = UserDefaults.standard.value(forKey: "w" ) as? String {
                self.scoreLabel.text = topScore
            } else {
                self.scoreLabel.text = "0"
            }
        default:
            return
        }
    }
    
    // MARK: - AUTHENTICATE LOCAL PLAYER
    func authenticateLocalPlayer() {
        let localPlayer: GKLocalPlayer = GKLocalPlayer.localPlayer()
        
        localPlayer.authenticateHandler = {(ViewController, error) -> Void in
            if((ViewController) != nil) {
                // 1 Show login if player is not logged in
                self.present(ViewController!, animated: true, completion: nil)
            } else if (localPlayer.isAuthenticated) {
                // 2 Player is already euthenticated & logged in, load game center
                self.gcEnabled = true
                
                // Get the default leaderboard ID
                localPlayer.loadDefaultLeaderboardIdentifier(completionHandler: { (leaderboardIdentifer, error) in
                    if error != nil { print(error!)
                    } else { self.gcDefaultLeaderBoard = leaderboardIdentifer! }
                })
                
            } else {
                // 3 Game center is not enabled on the users device
                self.gcEnabled = false
                print("Local player could not be authenticated!")
                print(error!)
            }
        }
    }
    
    @available(iOS 6.0, *)
    func gameCenterViewControllerDidFinish(_ gameCenterViewController: GKGameCenterViewController) {
        gameCenterViewController.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func resetBtnPressed(_ sender: UIButton) {
        self.scoreLabel.text = "0"
        
        if highscoreLabel != nil {
            let alert = UIAlertController(title: "Reset High Score", message: "Your High Score has been reset!", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        do {
            let realm = try Realm()
            try realm.write ({ () -> Void in
                realm.deleteAll()
                print("All Words Deleted")
            })
        }
        catch
        {
        }

        let prefs = UserDefaults.standard
        prefs.set(false, forKey: "name")
        prefs.set(false, forKey: "bogglerecord")
        prefs.set(false, forKey: "scrabblerecord")
        prefs.set(false, forKey: "wwfrecord")
        prefs.set(false, forKey: "Boggle")
        prefs.set(false, forKey: "Scrabble")
        prefs.set(false, forKey: "WordswithFriends")
        prefs.set(false, forKey: "b")
        prefs.set(false, forKey: "s")
        prefs.set(false, forKey: "w")
    }
    
    // MARK: - OPEN GAME CENTER LEADERBOARD
    @IBAction func checkGCLeaderboardPressed(_ sender: AnyObject) {
        let gcVC = GKGameCenterViewController()
        gcVC.gameCenterDelegate = self
        gcVC.viewState = .leaderboards
        gcVC.leaderboardIdentifier = LEADERBOARD_ID
        present(gcVC, animated: true, completion: nil)
    }
}
