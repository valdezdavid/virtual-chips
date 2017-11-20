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
    var password: String
    var currentGame: String
    var currentBet: Int
    var userId: Int
    var distanceFromDealer: Int
    
    init?(username: String, password: String, currentGame: String, currentBet: Int, userId: Int, distanceFromDealer: Int) {
        // The name must not be empty
        guard !username.isEmpty else {
            return nil
        }
        guard !password.isEmpty else {
            return nil
        }
        // The rating must be between 0 and 5 inclusively
        guard (currentBet >= 0) else {
            return nil
        }
        self.username = username
        self.password = password
        self.currentGame = currentGame
        self.currentBet = currentBet
        self.userId = userId
        self.distanceFromDealer = distanceFromDealer
    
    }
    
    
}
