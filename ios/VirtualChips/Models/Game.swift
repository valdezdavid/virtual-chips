//
//  Game.swift
//  VirtualChips
//
//  Created by David Valdez on 11/19/17.
//  Copyright © 2017 company. All rights reserved.
//

import UIKit

class Game {
    
    var name: String
    var numPlayers: Int
    var bigBlind: Int
    var smallBlind: Int
    var buyIn: Int
    
    init?(name: String, numPlayers: Int, bigBlind: Int, smallBlind: Int, buyIn: Int) {
        // The name must not be empty
        guard !name.isEmpty else {
            return nil
        }
        // The rating must be between 0 and 5 inclusively
        guard (bigBlind >= 0) else {
            return nil
        }
        guard (smallBlind >= 0) else {
            return nil
        }
        guard (buyIn >= 0) else {
            return nil
        }

        self.name = name
        self.numPlayers = numPlayers
        self.bigBlind = bigBlind
        self.smallBlind = smallBlind
        self.buyIn = buyIn
        
    }
    
}
