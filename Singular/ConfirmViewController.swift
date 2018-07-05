//
//  ConfirmViewController.swift
//  Singular
//
//  Created by dlr4life on 8/9/17.
//  Copyright © 2017 dlr4life. All rights reserved.
//

import UIKit
import Pastel

class ConfirmViewController: UIViewController {
    
    static var currentMode: String?
//    static var currentCount: String?
    static var currentStyle: String?
    
    @IBOutlet weak var gameModeLbl: UILabel!
    @IBOutlet weak var gameModeTxt: UILabel!
//    @IBOutlet weak var playerCountLbl: UILabel!
//    @IBOutlet weak var playerCountTxt: UILabel!
    @IBOutlet weak var scoringStyleLbl: UILabel!
    @IBOutlet weak var scoringStyleTxt: UILabel!
    
    var gameMode = String()
//    var playerCount = String()
    var scoringStyle = String()
    
    @IBOutlet var startBtn: UIButton!
    @IBOutlet var mPstartBtn: UIButton!
    @IBOutlet var exitBtn: UIButton!
    
    override func viewDidAppear(_ animated: Bool) {
        UIView.animate(withDuration: 0.5, animations: {
            self.gameModeLbl.alpha = 1
            self.gameModeTxt.alpha = 1
        }) { (true) in
//            self.showPlayerCount()
            self.showScoringStyle()
        }
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
        view.insertSubview(pastelView, at: 0)
        
        gameModeLbl.alpha = 0
        gameModeTxt.alpha = 0
//        playerCountLbl.alpha = 0
//        playerCountTxt.alpha = 0
        scoringStyleLbl.alpha = 0
        scoringStyleTxt.alpha = 0
        startBtn.alpha = 0
        mPstartBtn.alpha = 0
        exitBtn.alpha = 0
        
        gameModeTxt.text = ConfirmViewController.currentMode
//        playerCountTxt.text = ConfirmViewController.currentCount
        scoringStyleTxt.text = ConfirmViewController.currentStyle
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
//    func showPlayerCount () {
//        UIView.animate(withDuration: 0.5, animations: {
//            self.playerCountLbl.alpha = 1
//            self.playerCountTxt.alpha = 1
//        }, completion: { (true) in
//            self.showScoringStyle()
//        })
//    }
    
    func showScoringStyle () {
        UIView.animate(withDuration: 0.5, animations: {
            self.scoringStyleLbl.alpha = 1
            self.scoringStyleTxt.alpha = 1
        }, completion: { (true) in
            self.showPlayerButton()
//            self.startBtn.isHidden = false
//            self.startBtn.isEnabled = true
//            self.startBtn.alpha = 1
//            self.exitBtn.alpha = 1

        })
    }
    
    func showPlayerButton () {
        UIView.animate(withDuration: 0.5, animations: {
//            if self.playerCountTxt.text == "Multiplayer" {
            if self.gameModeTxt.text == "Tournament" {
            self.startBtn.isHidden = true
                self.startBtn.isEnabled = false
            self.mPstartBtn.isHidden = false
                self.mPstartBtn.isEnabled = true
                self.mPstartBtn.alpha = 1
            } else {
//            startBtn.isHidden = false
                self.startBtn.isEnabled = true
//            mPstartBtn.isHidden = true
                self.mPstartBtn.isEnabled = false
                self.startBtn.alpha = 1
            }
        }, completion: { (true) in
            self.exitBtn.alpha = 1
        })
    }
}
