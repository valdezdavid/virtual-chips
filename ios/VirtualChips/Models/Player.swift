//
//  Player.swift
//  VirtualChips
//
//  Created by David Valdez on 11/19/17.
//  Copyright © 2017 company. All rights reserved.
//
//Stiven Deleur, Anubhav Garg, Valerie Gomez, David Valdez, Rohan Shastri
import UIKit

class Player {
    //MARK: Properties
    
    var username: String
    var currentGame: String
    var currentBet: Int
    var currentBalance: Int
    var userId: Int
    
    
    init?(username: String, currentGame: String, currentBet: Int, userId: Int, currentBalance: Int) {
        // The rating must be between 0 and 5 inclusively
        guard (currentBet >= 0) else {
            return nil
        }
        self.username = username
        self.currentGame = currentGame
        self.currentBet = currentBet
        self.userId = userId
        self.currentBalance = currentBalance
        
    }
    
    
}
