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
    
    
    @IBOutlet weak var nextToMoveLabel: UILabel!
    @IBOutlet weak var lastMoveLabel: UILabel!
    @IBOutlet weak var potSizeLabel: UILabel!
    
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
        usernameLabel.text = Game.currentPlayer!.username
        currentChipsLabel.text = String(Game.currentPlayer!.currentBalance)
        
        let toolbarDone = UIToolbar.init()
        toolbarDone.sizeToFit()
        let barBtnDone = UIBarButtonItem.init(barButtonSystemItem: UIBarButtonSystemItem.done,
                                              target: self, action: #selector(InGameViewController.doneButton_Clicked(_:)))
        
        toolbarDone.items = [barBtnDone] // You can even add cancel button too
        RaiseField.inputAccessoryView = toolbarDone
    }
    
    @objc func doneButton_Clicked( _ sender: Any?)
    {
        self.resignFirstResponder()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func clickCheck(_ sender: UIButton) {
        let messageContent = ["" : ""]
        let m1 = SendingMessage(command: "check", params: messageContent)
        let jsonEncoder = JSONEncoder()
        do {
            if let jsonData = try? jsonEncoder.encode(m1) {
                if let jsonString = String(data: jsonData, encoding: .utf8){
                    ServerConnect.socket?.write(string: jsonString)
                    print("below is the jsonString")
                    print(jsonString)
                }
                else{
                    print ("encoding failed")
                }
            }
            else {
                print ("encoding failed")
                return
            }
        }
    
    }
    @IBAction func clickFold(_ sender: UIButton) {
        let messageContent = ["" : ""]
        let m1 = SendingMessage(command: "fold", params: messageContent)
        let jsonEncoder = JSONEncoder()
        do {
            if let jsonData = try? jsonEncoder.encode(m1) {
                if let jsonString = String(data: jsonData, encoding: .utf8){
                    ServerConnect.socket?.write(string: jsonString)
                    print("below is the jsonString")
                    print(jsonString)
                }
                else{
                    print ("encoding failed")
                }
            }
            else {
                print ("encoding failed")
                return
            }
        }
    }
    @IBAction func clickCall(_ sender: UIButton) {
        let messageContent = ["amount" : String(currentCallAmount)]
        let m1 = SendingMessage(command: "bet", params: messageContent)
        let jsonEncoder = JSONEncoder()
        do {
            if let jsonData = try? jsonEncoder.encode(m1) {
                if let jsonString = String(data: jsonData, encoding: .utf8){
                    ServerConnect.socket?.write(string: jsonString)
                    print("below is the jsonString")
                    print(jsonString)
                }
                else{
                    print ("encoding failed")
                }
            }
            else {
                print ("encoding failed")
                return
            }
        }
    }
    @IBAction func clickRaise(_ sender: UIButton) {
        var raiseAmount = Int(RaiseField.text!);
        if (raiseAmount! > currentMaxBet){
            raiseAmount = currentMaxBet
        }
        if (raiseAmount! < currentMinBet){
            raiseAmount = currentMinBet
        }
        //when submit button is pressed
        let messageContent = ["amount" : String(raiseAmount! + currentCallAmount)]
        let m1 = SendingMessage(command: "bet", params: messageContent)
        let jsonEncoder = JSONEncoder()
        do {
            if let jsonData = try? jsonEncoder.encode(m1) {
                if let jsonString = String(data: jsonData, encoding: .utf8){
                    ServerConnect.socket?.write(string: jsonString)
                    print("below is the jsonString")
                    print(jsonString)
                }
                else{
                    print ("encoding failed")
                }
            }
            else {
                print ("encoding failed")
                return
            }
        }
    }
    
    
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
                RaiseField.isHidden = false
            }
            else{
                RaiseButton.isHidden = true;
                RaiseField.isHidden = true
            }
            if (receivedMessage.params["canCall"] == "true"){
                //display the option for raising to the user
                CallButton.isHidden = false;
                
                CallButton.setTitle("Call " + receivedMessage.params["callAmount"]!,  for: .normal)
            }
            else{
                CallButton.isHidden = true;
            }
            FoldButton.isHidden = true;
            currentCallAmount = Int (receivedMessage.params["callAmount"]!)!
            currentMaxBet = Int (receivedMessage.params["maxRaise"]!)!
            currentMinBet = Int (receivedMessage.params["minRaise"]!)!
            currentPotSize = Int (receivedMessage.params["potSize"]!)!
            potSizeLabel.text = "Chips in pot: " + String(currentPotSize)
            
        }else if (receivedMessage.event == "playerToMove"){
            //two text fields should be created for the purpose of displaying this.
            nextPlayer = Int(receivedMessage.params["id"]!)!
            nextPlayerChips = Int(receivedMessage.params["chips"]!)!
            Game.allPlayers[nextPlayer]?.currentBalance = nextPlayerChips
            nextToMoveLabel.text = "User " + (Game.allPlayers[Int(receivedMessage.params["id"]!)!]?.username)! + " is next to move. They have " + receivedMessage.params["chips"]! + " chips"
            if nextPlayer != Game.currentPlayerId {
                CheckButton.isHidden = true;
                RaiseButton.isHidden = true;
                CallButton.isHidden = true;
                FoldButton.isHidden = true;
                RaiseField.isHidden = true
            }
        }else if (receivedMessage.event == "bet"){
            Game.allPlayers[nextPlayer]?.currentBalance = (nextPlayerChips - Int(receivedMessage.params["amount"]!)!)
            lastMoveLabel.text = (Game.allPlayers[nextPlayer]?.username)! + " bet " + receivedMessage.params["amount"]!
            currentPotSize += Int(receivedMessage.params["amount"]!)!
            potSizeLabel.text = "Chips in pot: " + String(currentPotSize)
        }else if (receivedMessage.event == "check"){
            Game.allPlayers[nextPlayer]?.currentBalance = nextPlayerChips
            lastMoveLabel.text = (Game.allPlayers[nextPlayer]?.username)! + " checked "
        }else if (receivedMessage.event == "fold"){
            Game.allPlayers[nextPlayer]?.currentBalance = nextPlayerChips
            lastMoveLabel.text = (Game.allPlayers[nextPlayer]?.username)! + " folded"
        }
        currentChipsLabel.text = String(Game.currentPlayer!.currentBalance)
    }
    
    
    
}


