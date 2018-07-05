//
//  ThirdViewController.swift
//  Singular
//
//  Created by dlr4life on 8/9/17.
//  Copyright © 2017 dlr4life. All rights reserved.
//

import UIKit
import BetterSegmentedControl

class ThirdViewController: UIViewController {
    
    let alphabet: [String] = ["a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m", "n", "o", "p", "q", "r", "s", "t", "u", "v", "w", "x", "y", "z", "_"]
    var scrabbleScore: [Int] = [1, 3, 3, 2, 1, 4, 2, 4, 1, 8, 5, 1, 3, 1, 1, 3, 10, 1, 1, 1, 1, 4, 4, 8, 4, 10, 0]
    var wwfScore: [Int] = [1, 3, 4, 4, 2, 1, 4, 3, 1, 10, 5, 2, 4, 2, 1, 4, 10, 1, 1, 1, 2, 5, 4, 8, 3, 10, 0]
    
    @IBOutlet weak var scoringControl: BetterSegmentedControl!
    @IBOutlet weak var boggleView: UIView!
    @IBOutlet weak var scrabbleView: UIView!
    @IBOutlet weak var wordswithfriendsView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "Scoring Style"
        
        // Control 1: Created and designed in IB that announces its value on interaction (Many options & error handling)
        
        scoringControl.titles = ["Boggle", "Scrabble","WWF"]
        scoringControl.titleFont = UIFont(name: "HelveticaNeue-Light", size: 13.0)!
        scoringControl.selectedTitleFont = UIFont(name: "HelveticaNeue-Medium", size: 13.0)!
        scoringControl.indicatorViewBackgroundColor = UIColor(red:0.91, green:0.92, blue:0.95, alpha:1.0)
        scoringControl.selectedTitleColor = UIColor(red:0.00, green:0.16, blue:1.00, alpha:1.0)
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
        
//        print(scoringControl.titles)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        super.viewDidLoad()
    }
    
    func scoringControlValueChanged(_ sender: BetterSegmentedControl) {
        if sender.index == 0 {
            UIView.animate(withDuration: 0.1, animations: {
                self.boggleView.alpha = 1.0
                self.scrabbleView.alpha = 0.0
                self.wordswithfriendsView.alpha = 0.0
                print("Boggle")
            })
        } else if sender.index == 1 {
            UIView.animate(withDuration: 0.1, animations: {
                self.boggleView.alpha = 0.0
                self.scrabbleView.alpha = 1.0
                self.wordswithfriendsView.alpha = 0.0
                print("Scrabble")
            })
        } else if sender.index == 2 {
            UIView.animate(withDuration: 0.1, animations: {
                self.boggleView.alpha = 0.0
                self.scrabbleView.alpha = 0.0
                self.wordswithfriendsView.alpha = 1.0
                print("WWF")
            })
        }
    }

}
