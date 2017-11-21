//
//  NewGameViewController.swift
//  VirtualChips
//
//  Created by David Valdez on 11/14/17.
//  Copyright © 2017 company. All rights reserved.
//
//Stiven Deleur, Anubhav Garg, Valerie Gomez, David Valdez, Rohan Shastri
import UIKit
import Starscream
class NewGameViewController: UIViewController {

    let GAME_CODE_SEGUE = "newCodeSegue"
    
    
    @IBOutlet weak var buyInSlider: UISlider!
    @IBOutlet weak var buyInLabel: UILabel!
    
    @IBOutlet weak var numPlayersSlider: UISlider!
    @IBOutlet weak var numPlayersLabel: UILabel!
    
    @IBOutlet weak var smallBlindSlider: UISlider!
    @IBOutlet weak var smallBlindLabel: UILabel!
    
    @IBOutlet weak var bigBlindSlider: UISlider!
    @IBOutlet weak var bigBlindLabel: UILabel!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ServerConnect.socket?.delegate = self
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func valueChanged(_ sender: UISlider) {
        sender.setValue(Float(Int(sender.value)), animated: false)
        if sender == buyInSlider {
            buyInLabel.text = String(Int(sender.value))
        }else if sender == numPlayersSlider {
            numPlayersLabel.text = String(Int(sender.value))
        }else if sender == smallBlindSlider {
            smallBlindLabel.text = String(Int(sender.value))
        }else if sender == bigBlindSlider {
            bigBlindLabel.text = String(Int(sender.value))
        }
    }
    
    
    @IBAction func buttonClicked(_ sender: UIButton) {
        print("TESTING CLICK")
        let numPlayers = numPlayersLabel.text ?? "5"
        let buyIn = buyInLabel.text ?? "100"
        let smallBlind = smallBlindLabel.text ?? "5"
        let bigBlind = bigBlindLabel.text ?? "10"

        let messageContent = ["numPlayers" : numPlayers, "buyIn": buyIn
                              , "smallBlind": smallBlind, "bigBlind": bigBlind]
        let m1 = SendingMessage(command: "startGame", params: messageContent)
        print("TESTING CLICK HMMM")
        let jsonEncoder = JSONEncoder()
        do {
            if let jsonData = try? jsonEncoder.encode(m1) {
                if let jsonString = String(data: jsonData, encoding: .utf8){
                    ServerConnect.socket?.write(string: jsonString)
                    print("below is the jsonString")
                    print(jsonString)
                    print("has tried to write the data")
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
    

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == GAME_CODE_SEGUE){
            let secondViewController = segue.destination as! NewGameCodeViewController
            secondViewController.gameID = sender as! String?
            
        }
    }
    
} //CLASS
extension NewGameViewController : WebSocketDelegate {
    func websocketDidConnect(socket: WebSocketClient) {
    
    }
    
    func websocketDidReceiveData(socket: WebSocketClient, data: Data) {
    
    }
    

    func websocketDidDisconnect(socket: WebSocketClient, error: Error?) {
        
    }
    
    func websocketDidReceiveMessage(socket: WebSocketClient, text: String) {
        print("below is the text from the server")
        print(text)
        
        let jsonData = text.data(using: .utf8)!
        print ("jsonData is listed below")
        print (jsonData)
        let decoder = JSONDecoder()
        let receivedMessage = try! decoder.decode(ReceivedMessage.self, from: jsonData)
        print ("This is the recieved message")
        print (receivedMessage)
        if (receivedMessage.event == "startGame"){
            if (receivedMessage.params["success"] == "true"){
                let newGameID = receivedMessage.params["id"]
                let numPlayers = numPlayersLabel.text ?? "5"
                let buyIn = buyInLabel.text ?? "100"
                let smallBlind = smallBlindLabel.text ?? "5"
                let bigBlind = bigBlindLabel.text ?? "10"
                
                Game.name = "currentTest"
                Game.numPlayers = Int(numPlayers)
                Game.bigBlind = Int(bigBlind)
                Game.smallBlind = Int(smallBlind)
                Game.buyIn = Int(buyIn)
                Game.gameID = Int(newGameID!)
                
                Game.currentPlayerId = Int(receivedMessage.params["userId"]!)
                
                print("below is the printing out of the game")
                print(Game.name ?? "")
                performSegue(withIdentifier: GAME_CODE_SEGUE, sender: newGameID)
            }
            else {
                
            }
        }
    }

    
}

