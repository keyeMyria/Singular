//
//  PlayerSelectViewController.swift
//  Singular
//
//  Created by dlr4life on 7/4/17.
//  Copyright © 2017 DLR LLC. All rights reserved.
//

import UIKit

class PlayerSelectViewController: UIViewController {
    
    var playerNumber:Int = 0
    var cellNames = [String]()

    @IBOutlet weak var decreasePlayerCount: UIButton!
    @IBOutlet weak var increasePlayerCount: UIButton!
    @IBOutlet weak var playerCount: UILabel!
    @IBOutlet weak var resetBtn: UIButton!
    @IBOutlet weak var scoringBtn: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()

    self.navigationItem.title = "Player Select"
        cellNames.append("0")

        let storage: UserDefaults = UserDefaults.standard
        let _:Int?=storage.object(forKey: "players") as? Int
        
        resetBtn.layer.borderWidth = 1
        resetBtn.layer.cornerRadius = 8
    
//        scoringBtn.isEnabled = false
        
//        if playerNumber == 0 {
//            scoringBtn.isEnabled = false
//            
//        } else if playerNumber >= 1 {
//            scoringBtn.isEnabled = true
//            return
//        }
//        else if playerNumber == 1 {
//            scoringBtn.isEnabled = true
//            return
//        }
        
        applychanges()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        super.viewDidLoad()
    }
    
    func applychanges(){
        playerCount.text=String(playerNumber)
    }

    @IBAction func decreasePlayerCountPress(_ sender: UIButton) {
        if playerNumber < 1 {
            return
        }
        scoringBtn.isEnabled = playerCount != nil
        playerNumber -= 1
        applychanges()
    }
    
    @IBAction func increasePlayerCountPress(_ sender: UIButton) {
        scoringBtn.isEnabled = playerCount != nil
        playerNumber += 1
        applychanges()
    }
    
    @IBAction func resetBtnPress(_ sender: UIButton) {
        scoringBtn.isEnabled = playerCount != nil
        playerNumber = 0
        applychanges()
    }
    
    @IBAction func scoringBtnPressed(_ sender: Any) {
        scoringBtn.setTitleColor(UIColor.green, for: UIControlState())
    }

}
