//
//  MatchSetViewController.swift
//  Singular
//
//  Created by dlr4life on 8/1/17.
//  Copyright © 2017 DLR LLC. All rights reserved.
//

import UIKit
import Pastel
import GLInAppPurchase
import RealmSwift

class MatchSetViewController: UIViewController {
    
    // Variables
    var currentMode: String?
    var currentCount: String?
    var currentStyle: String?

    var selection: Int = 0

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        gameMode()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        let pastelView = PastelView(frame: view.bounds)
        
        // Custom Direction
        pastelView.startPastelPoint = .bottomLeft
        pastelView.endPastelPoint = .topRight
        
        // Custom Duration
        pastelView.animationDuration = 2.0
        
        // Custom Color
        pastelView.setColors([UIColor(red: 156/255, green: 39/255, blue: 176/255, alpha: 1.0),
                              UIColor(red:0.21, green:0.56, blue:0.73, alpha:1.0),
                              UIColor(red:0.97, green:0.97, blue:0.97, alpha:1.0),
                              UIColor(red:0.04, green:0.18, blue:0.25, alpha:1.0)])
        
        pastelView.startAnimation()
//        view.insertSubview(pastelView, at: 1)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        var _ = segue.destination as! ConfirmViewController
//        ConfirmViewController.currentMode = self.currentMode!
//        ConfirmViewController.currentCount = self.currentCount!
//        ConfirmViewController.currentStyle = self.currentStyle!
        
        if let mode = currentMode {
            ConfirmViewController.currentStyle = mode
        }
        
        if let count = currentCount {
            ConfirmViewController.currentStyle = count
        }
        
        if let style = currentStyle {
            ConfirmViewController.currentStyle = style
        }
    }
    
    let appBanner = GLInAppPurchaseUI(title: "Skip The Line", subTitle: "Be first in the queue", bannerBackGroundStyle: .transparentStyle)

    func actionGoToConfirmVC(sender: AnyObject) {
        self.performSegue(withIdentifier: "actionGoToConfirmVC", sender: UIButton())
    }
    
    func actionGoBackFromMatchSet(sender: AnyObject) {
        self.performSegue(withIdentifier: "actionGoBackFromMatchSet", sender: nil)
    }
    
    func showSimpleAlert(_ message:String) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: "Completion Handler", message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            self.navigationController?.present(alert, animated: true, completion: nil)
        }
    }
    
    func gameMode() {
        let appBanner = GLInAppPurchaseUI(title: "Tournament / Practice", subTitle: "Practice for the Tournament", bannerBackGroundStyle: .transparentStyle)

        appBanner.displayContent(imageSetWithDescription:
            [
                UIImage(named:"practiceIcon")!:"Practice Mode##High Scores saved",
                UIImage(named:"tournamentIcon")!:"Challenge other users!##Entered words saved",
                ])
        appBanner.addButtonWith("Next", cancelTitle: "") { (selectedTitle, isOptionSelected, selectedAction) in
            if isOptionSelected {  //Some Option have been selected
                self.appBanner.dismissBanner()
//                self.players()
                self.scoring()
            } else {
                let alert = UIAlertController(title: "Game Mode Selection", message: "Please select a Game Mode to proceed", preferredStyle:UIAlertControllerStyle.alert)
                
                // Create the "Ok" button
                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: { (action) in alert.dismiss(animated: true, completion: nil)
                }))
                self.present(alert, animated: true, completion: nil)

            }
//            if selectedTitle == "Exit" { //selectedButtonTitle
//            self.appBanner.dismissBanner()
//            self.performSegue(withIdentifier: "actionGoBackFromMatchSet", sender: nil)
//            }
        }

        appBanner.addAction(GLInAppAction(title: "1", subTitle: "Practice", price: "", handler: { (action) in
            self.currentMode = "\(action.actionSubTitle!)"
            ConfirmViewController.currentMode = "Practice"
            GameViewController.currentMode = "Practice"
            MPGameViewController.currentMode = "Practice"
            print("Practice Mode Selected!")
        }))

        appBanner.addAction(GLInAppAction(title: "2", subTitle: "Tournament", price: "", handler: { (action) in
            self.currentMode = "\(action.actionSubTitle!)"
            ConfirmViewController.currentMode = "Tournament"
            GameViewController.currentMode = "Tournament"
            MPGameViewController.currentMode = "Tournament"
            print("Tournament Mode Selected!")
        }))
        appBanner.presentBanner()
    }
    
//    func players() {
//        let appBanner = GLInAppPurchaseUI(title: "Single Player / Multiplayer", subTitle: "# of Players", bannerBackGroundStyle: .transparentStyle)
//        
//        appBanner.displayContent(imageSetWithDescription:
//            [
//                UIImage(named:"singlePlayerIcon")!:"Play against the Computer##Beat your best score",
//                UIImage(named:"multiPlayerIcon")!:"Challenge other global users##Flex your vocabulary!",
//                ])
//        appBanner.addButtonWith("Next", cancelTitle: "") { (selectedTitle, isOptionSelected, selectedAction) in
//            if isOptionSelected {  //Some Option have been selected
//                self.appBanner.dismissBanner()
//                self.scoring()
//            }
//            //            if selectedTitle == "Exit" { //selectedButtonTitle
//            //                self.appBanner.dismissBanner()
//            //                self.performSegue(withIdentifier: "actionGoBackFromMatchSet", sender: nil)
//            //            }
//        }
//        
//        appBanner.addAction(GLInAppAction(title: "1", subTitle: "Single Player", price: "", handler: { (action) in
//            self.currentCount = "\(action.actionSubTitle!)"
//            GameViewController.currentCount = "Single Player"
//            GameViewController.currentCount = "Single Player"
//            MPGameViewController.currentCount = "Single Player"
//            print("Single Player Selected!")
//        }))
//        
//        appBanner.addAction(GLInAppAction(title: "2", subTitle: "Multiplayer", price: "", handler: { (action) in
//            self.currentCount = "\(action.actionSubTitle!)"
//            GameViewController.currentCount = "Multiplayer"
//            GameViewController.currentCount = "Multiplayer"
//            MPGameViewController.currentCount = "Multiplayer"
//            print("Multiplayer Selected!")
//        }))
//        appBanner.presentBanner()
//    }
    
    func scoring() {
        let appBanner = GLInAppPurchaseUI(title: "Select Scoring Style", subTitle: "Score the most points/words", bannerBackGroundStyle: .transparentStyle)
        
        appBanner.displayContent(imageSetWithDescription:
            [
                UIImage(named:"scoreStyle_0")!:"Boggle Scoring##Number of letters = Points",
                UIImage(named:"scoreStyle_1")!:"Scrabble Scoring##Characters = points",
                UIImage(named:"scoreStyle_2")!:"Words w/ Friends Scoring##Characters = different points",
                ])
        appBanner.addButtonWith("Play!", cancelTitle: "") { (selectedTitle, isOptionSelected, selectedAction) in
            if isOptionSelected {   //Some Option have been selected
                self.appBanner.dismissBanner()
                self.performSegue(withIdentifier: "actionGoToConfirmVC", sender: UIButton())
            } else {
                let alert = UIAlertController(title: "Scoring Style Selection", message: "Please select a Scoring Style to proceed", preferredStyle:UIAlertControllerStyle.alert)
                
                // Create the "Ok" button
                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: { (action) in alert.dismiss(animated: true, completion: nil)
                }))
                self.present(alert, animated: true, completion: nil)
                
            }
            //            if selectedTitle == "Exit" { //selectedButtonTitle
            //                self.appBanner.dismissBanner()
            //                self.performSegue(withIdentifier: "actionGoBackFromMatchSet", sender: nil)
            //            }
        }
        
        appBanner.addAction(GLInAppAction(title: "1", subTitle: "Boggle", price: "", handler: { (action) in
            self.currentStyle = "\(action.actionSubTitle!)"
            ConfirmViewController.currentStyle = "Boggle"
            GameViewController.currentStyle = "Boggle"
            MPGameViewController.currentStyle = "Boggle"
            print("Boggle Scoring Style Selected!")
        }))
        
        appBanner.addAction(GLInAppAction(title: "2", subTitle: "Scrabble", price: "", handler: { (action) in
            self.currentStyle = "\(action.actionSubTitle!)"
            ConfirmViewController.currentStyle = "Scrabble"
            GameViewController.currentStyle = "Scrabble"
            MPGameViewController.currentStyle = "Scrabble"
            print("Scrabble Scoring Style Selected!")
        }))
        
        appBanner.addAction(GLInAppAction(title: "3", subTitle: "W.W.F.", price: "", handler: { (action) in
//            self.currentStyle = "\(action.actionSubTitle!)"
            self.currentStyle = "WordswithFriends"
            ConfirmViewController.currentStyle = "WordswithFriends"
            GameViewController.currentStyle = "WordswithFriends"
            MPGameViewController.currentStyle = "WordswithFriends"
            print("Words With Friends Scoring Style Selected!")
        }))
        appBanner.presentBanner()
    }
    
    //@IBAction func dismissToHomeVC(_ sender: AnyObject) {
    //    performSegue(withIdentifier: "actionGoBackFromMatchSet", sender: nil)
    //}
    
}

//@IBAction func dismissToHomeVC(_ sender: AnyObject) {
//    performSegue(withIdentifier: "actionGoBackFromMatchSet", sender: nil)
//}

extension UIColor {
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    
    convenience init(netHex:Int) {
        self.init(red:(netHex >> 16) & 0xff, green:(netHex >> 8) & 0xff, blue:netHex & 0xff)
    }
}
