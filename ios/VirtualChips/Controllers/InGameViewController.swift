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
class InGameViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return potentialWinners.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellPlayer", for: indexPath)
        let player = Game.allPlayers[potentialWinners[indexPath.row]]
        cell.textLabel?.text = player?.username
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let messageContent = ["userId" : String(potentialWinners[indexPath.row])]
        let m1 = SendingMessage(command: "chooseWinner", params: messageContent)
        let jsonEncoder = JSONEncoder()
        do {
            if let jsonData = try? jsonEncoder.encode(m1) {
                if let jsonString = String(data: jsonData, encoding: .utf8){
                    ServerConnect.socket?.write(string: jsonString)
                    winnerSelectView.isHidden = true
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
    
    
    
    @IBOutlet weak var FoldButton: UIButton!
    @IBOutlet weak var CallButton: UIButton!
    @IBOutlet weak var CheckButton: UIButton!
    @IBOutlet weak var RaiseButton: UIButton!
    @IBOutlet weak var raisePlusButton: UIButton!
    @IBOutlet weak var raiseMinusButton: UIButton!
    
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
    var raiseAmount = 0
    
    
    @IBOutlet weak var winnerSelectTableView: UITableView!
    @IBOutlet weak var winnerSelectText: UILabel!
    @IBOutlet weak var winnerSelectView: UIView!
    var potentialWinners: [Int] = []
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        winnerSelectView.isHidden = true
        ServerConnect.socket!.delegate = self
        // Do any additional setup after loading the view.
        usernameLabel.text = Game.currentPlayer!.username
        currentChipsLabel.text = String(Game.currentPlayer!.currentBalance)

    }
    
    @IBAction func increaseRaise(_ sender: Any) {
        raiseAmount += 5
        if (raiseAmount > currentMaxBet){
            raiseAmount = currentMaxBet
        }
        RaiseButton.setTitle("Raise " + String(raiseAmount), for: .normal)
    }
    @IBAction func decreaseBet(_ sender: UIButton) {
        raiseAmount -= 5
        if (raiseAmount < currentMinBet){
            raiseAmount = currentMinBet
        }
        RaiseButton.setTitle("Raise " + String(raiseAmount), for: .normal)
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
        if (raiseAmount > currentMaxBet){
            raiseAmount = currentMaxBet
        }
        if (raiseAmount < currentMinBet){
            raiseAmount = currentMinBet
        }
        //when submit button is pressed
        let messageContent = ["amount" : String(raiseAmount + currentCallAmount)]
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
                raisePlusButton.isHidden = false
                raiseMinusButton.isHidden = false
            }
            else{
                RaiseButton.isHidden = true
                raisePlusButton.isHidden = true
                raiseMinusButton.isHidden = true
            }
            if (receivedMessage.params["canCall"] == "true"){
                //display the option for raising to the user
                CallButton.isHidden = false;
                
                CallButton.setTitle("Call " + receivedMessage.params["callAmount"]!,  for: .normal)
            }
            else{
                CallButton.isHidden = true;
            }
            FoldButton.isHidden = false;
            currentCallAmount = Int (receivedMessage.params["callAmount"]!)!
            currentMaxBet = Int (receivedMessage.params["maxRaise"]!)!
            currentMinBet = Int (receivedMessage.params["minRaise"]!)!
            currentPotSize = Int (receivedMessage.params["potSize"]!)!
            potSizeLabel.text = "Chips in pot: " + String(currentPotSize)
            raiseAmount = currentMinBet
            RaiseButton.setTitle("Raise " + String(raiseAmount), for: .normal)
            
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
                raisePlusButton.isHidden = true
                raiseMinusButton.isHidden = true
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
        }else if (receivedMessage.event == "chooseWinner"){
            //Check if there is atleast 1 player
            if(Int(receivedMessage.params["numUsers"]!)! > 0){
                let numUsers = Int (receivedMessage.params["numUsers"]!)!
                
                var counter = 1
                potentialWinners = []
                while counter <= numUsers{
                    potentialWinners.append(Int (receivedMessage.params[String (counter)]!)!)
                    counter += 1
                }
                winnerSelectView.isHidden = false
                winnerSelectTableView.reloadData()
            }
        }else if (receivedMessage.event == "win"){
            let winner = Game.allPlayers[Int(receivedMessage.params["userId"]!)!]
            winner?.currentBalance += Int(receivedMessage.params["amount"]!)!
            lastMoveLabel.text = (winner?.username)! + " won " + receivedMessage.params["amount"]!
        }
        currentChipsLabel.text = String(Game.currentPlayer!.currentBalance)
    }
    
    
    
}


