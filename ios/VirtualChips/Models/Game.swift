//
//  Game.swift
//  VirtualChips
//
//  Created by David Valdez on 11/19/17.
//  Copyright © 2017 company. All rights reserved.
//
//Stiven Deleur, Anubhav Garg, Valerie Gomez, David Valdez, Rohan Shastri
import UIKit

class Game {
    
    static var name: String?
    static var numPlayers: Int?
    static var bigBlind: Int?
    static var smallBlind: Int?
    static var buyIn: Int?
    static var gameID: Int?
    static var allPlayers: [Player] = []
    static var currentPlayerId: Int?
    static var currentPlayer: Player?
    
}
