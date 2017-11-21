//
//  InGameViewController.swift
//  VirtualChips
//
//  Created by David Valdez on 11/16/17.
//  Copyright © 2017 company. All rights reserved.
//
//Stiven Deleur, Anubhav Garg, Valerie Gomez, David Valdez, Rohan Shastri
import UIKit
import Starscream
class InGameViewController: UIViewController {
    
    
    @IBOutlet weak var FoldButton: UIButton!
    @IBOutlet weak var RaiseField: UITextField!
    @IBOutlet weak var CallButton: UIButton!
    @IBOutlet weak var CheckButton: UIButton!
    @IBOutlet weak var RaiseButton: UIButton!
    
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var currentChipsLabel: UILabel!
    
    var currentCallAmount = 0
    var currentMaxBet = 0
    var currentMinBet = 0
    var currentPotSize = 0
    var nextPlayer = -1
    var nextPlayerChips = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        ServerConnect.socket!.delegate = self
        // Do any additional setup after loading the view.
        RaiseField.isHidden = true
        usernameLabel.text = Game.currentPlayer!.username
        currentChipsLabel.text = String(Game.currentPlayer!.currentBalance)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBOutlet weak var clickCheck: UIButton!
    @IBOutlet weak var clickFold: UIButton!
    @IBOutlet weak var clickCall: UIButton!
    @IBOutlet weak var clickRaise: UIButton!
    

}

extension InGameViewController : WebSocketDelegate {
    func websocketDidConnect(socket: WebSocketClient) {
        
    }
    
    func websocketDidReceiveData(socket: WebSocketClient, data: Data) {
        
    }
    
    
    func websocketDidDisconnect(socket: WebSocketClient, error: Error?) {
        
    }
    
    func websocketDidReceiveMessage(socket: WebSocketClient, text: String) {
        print("IN GAME VIEW CONTROLLER below is the text from the server")
        print(text)
        
        let jsonData = text.data(using: .utf8)!
        print ("jsonData is listed below")
        print (jsonData)
        let decoder = JSONDecoder()
        let receivedMessage = try! decoder.decode(ReceivedMessage.self, from: jsonData)
        print ("This is the recieved message")
        print (receivedMessage)
        
        if (receivedMessage.event == "moveOptions"){
            if (receivedMessage.params["canCheck"] == "true"){
                //display the check option for the user
                CheckButton.isHidden = false;
            }
            else{
                CheckButton.isHidden = true;
            }
            if (receivedMessage.params["canRaise"] == "true"){
                //display the option for raising to the user
                RaiseButton.isHidden = false;
            }
            else{
                RaiseButton.isHidden = true;
            }
            if (receivedMessage.params["canCall"] == "true"){
                //display the option for raising to the user
                CallButton.isHidden = false;
            }
            else{
                CallButton.isHidden = true;
            }
            FoldButton.isHidden = true;
            currentCallAmount = Int (receivedMessage.params["callAmount"]!)!
            currentMaxBet = Int (receivedMessage.params["maxRaise"]!)!
            currentMinBet = Int (receivedMessage.params["minRaise"]!)!
            currentPotSize = Int (receivedMessage.params["potSize"]!)!
        }else if (receivedMessage.event == "playerToMove"){
            //two text fields should be created for the purpose of displaying this.
            nextPlayer = Int(receivedMessage.params["id"]!)!
            nextPlayerChips = Int(receivedMessage.params["chips"]!)!
            
            if nextPlayer != Game.currentPlayerId {
                CheckButton.isHidden = true;
                RaiseButton.isHidden = true;
                CallButton.isHidden = true;
                FoldButton.isHidden = true;
            }
        }else if (receivedMessage.event == "bet"){
            Game.allPlayers[nextPlayer]?.currentBalance = (nextPlayerChips - Int(receivedMessage.params["amount"]!)!)
            print((Game.allPlayers[nextPlayer]?.username)! + " bet " + receivedMessage.params["amount"]!)
        }else if (receivedMessage.event == "check"){
            Game.allPlayers[nextPlayer]?.currentBalance = nextPlayerChips
            print((Game.allPlayers[nextPlayer]?.username)! + " checked ")
        }else if (receivedMessage.event == "fold"){
            Game.allPlayers[nextPlayer]?.currentBalance = nextPlayerChips
            print((Game.allPlayers[nextPlayer]?.username)! + " folded")
        }
    }
    
    
    
}


