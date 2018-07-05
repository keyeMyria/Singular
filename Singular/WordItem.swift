//
//  WordItem.swift
//  Singular
//
//  Created by dlr4life on 7/29/17.
//  Copyright © 2017 DLR LLC. All rights reserved.
//

import UIKit
import RealmSwift
import Crashlytics

class WordItem: Object {
    dynamic var date: Date = Date()
    dynamic var count: Int = Int(0) // The incremented number of total words entered
    dynamic var word: String? // The word submitted by the player
    dynamic var wordScore = 0 // Number of points the submitted word was worth
    dynamic var lengthwordScore = 0 // Number of points the submitted word was worth
    dynamic var letterswordScore = 0 // Number of points the submitted word was worth
    
    func incrementID() -> Int {
        let realm = try! Realm()
        return (realm.objects(WordItem.self).max(ofProperty: "count") as Int? ?? 0) + 1
    }
    
}

let realm = try! Realm()
let allWords = realm.objects(WordItem.self)
let sortedWords = allWords.sorted(byKeyPath: "word.score.lengthwordScore.letterswordScore", ascending: true)

