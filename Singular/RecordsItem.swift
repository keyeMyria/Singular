//
//  RecordsItem.swift
//  Singular
//
//  Created by dlr4life on 8/22/17.
//  Copyright © 2017 dlr4life. All rights reserved.
//

import UIKit
import RealmSwift

class ScoresItem: Object{
    dynamic var boggleHighScore = 0 // High Score for Boggle (before reset)
    dynamic var scrabbleHighScore = 0 // High Score for Scrsbble (before reset)
    dynamic var wwfHighScore = 0 // High Score for Words with Friends (before reset)
}

class TournamentsItem: Object{
    dynamic var numberHeld = 0 // Number of Tournaments started (before reset)
    dynamic var numberPlayed = 0 // Number of Tournaments completed
    dynamic var numberLost = 0 // Number of Tournaments Lost
    dynamic var numberWon = 0 // Number of Tournaments Won
    dynamic var numberTied = 0 // Number of Tournaments where Score was Tied
    dynamic var positionPlaced = 0 // 1st, 2nd, 3rd, or 4th in Multiplayer
}

class MatchesItem: Object{
    dynamic var numberHeld = 0 // Number of total matches started (before reset)
    dynamic var numberPlayed = 0 // Number of matches completed (does not reset)
    dynamic var wordsEntered = 0 // Number of words entered (beginning of time)
    dynamic var acceptedWords = 0 // Number of words accepted (beginning of time)
    dynamic var rejectedWords = 0 // Number of words rejected (beginning of time)
    dynamic var personalBestForDay = 0 // Best Score for the Calendar Day
    dynamic var personalBestForWeek = 0 // Best Score for the Calendar Week
    dynamic var personalBestForMonth = 0 // Best Score for the Calendar Month
    dynamic var personalBestForYear = 0 // Best Score for the Calendar Year
    dynamic var longestAcceptedStreak = Date().self // Date when streak was recorded
    dynamic var longestWord = "" // Word
    dynamic var mostPoints = "" // Word
}

class ProfileItem: Object{
    dynamic var playerId = ""
    dynamic var firstPlace = 0 // Number of times in 1st Place out of # of matches
    dynamic var secondPlace = 0 // Number of times in 2nd Place out of # of matches
    dynamic var thirdPlace = 0 // Number of times in 3rd Place out of # of matches
    dynamic var fourthPlace = 0 // Number of times in 4th Place out of # of matches
    dynamic var preferredScoringStyle = "" // Preferred Scoring Style
    dynamic var playerScore = "" // Player's Score at the end of the match
    dynamic var turnsLost = 0 // Number of turns lost during the match
    dynamic var wordsEntered = 0 // Number of words entered during the match
    dynamic var acceptedWords = 0 // Number of words accepted during the match
    dynamic var rejectedWords = 0 // Number of words rejected during the match
}

class LeaderboardItem: Object{
    dynamic var firstPlace: PlayerId? // Name of current user in firstPlace
    dynamic var secondPlace: PlayerId? // Name of current user insecondPlace
    dynamic var thirdPlace: PlayerId? // Name of current user in thirdPlace
    dynamic var fourthPlace: PlayerId? // Name of current user in fourthPlace
    dynamic var fifthPlace: PlayerId? // Name of current user in fifthPlace
    dynamic var sixthPlace: PlayerId? // Name of current user in sixthPlace
    dynamic var seventhPlace: PlayerId? // Name of current user in seventhPlace
    dynamic var eighthPlace: PlayerId? // Name of current user in eighthPlace
    dynamic var ninthPlace: PlayerId? // Name of current user in ninthPlace
    dynamic var tenthPlace: PlayerId? // Name of current user in tenthPlace
}

class PlayerId: Object {
    dynamic var name = "" // Players Name
    dynamic var playerId = "" // Player's Online Tag Number
    dynamic var guest = Bool() // Guest Tag Number
    dynamic var playerNumber = 0 // Player Incremented Tournament Number
    dynamic var gender = ""
    dynamic var birthdate = ""
}
