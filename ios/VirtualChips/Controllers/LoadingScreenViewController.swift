//
//  LoadingScreenViewController.swift
//  VirtualChips
//
//  Created by David Valdez on 11/14/17.
//  Copyright © 2017 company. All rights reserved.
//
///Stiven Deleur, Anubhav Garg, Valerie Gomez, David Valdez, Rohan Shastri
import UIKit
import Starscream
class LoadingScreenViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        ServerConnect.socket!.delegate = self
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension LoadingScreenViewController : WebSocketDelegate {
    func websocketDidConnect(socket: WebSocketClient) {
        
    }
    
    func websocketDidReceiveData(socket: WebSocketClient, data: Data) {
        
    }
    
    
    func websocketDidDisconnect(socket: WebSocketClient, error: Error?) {
        
    }
    
    func websocketDidReceiveMessage(socket: WebSocketClient, text: String) {
        print("LOADING below is the text from the server")
        print(text)
        
        let jsonData = text.data(using: .utf8)!
        print ("jsonData is listed below")
        print (jsonData)
        let decoder = JSONDecoder()
        let receivedMessage = try! decoder.decode(ReceivedMessage.self, from: jsonData)
        print ("This is the recieved message")
        print (receivedMessage)
        if receivedMessage.event == "beginGame" {
            let numPlayers = Int(receivedMessage.params["numPlayers"]!)
            var i = 1;
            while i <= numPlayers!{
                let currentPlayerID = Int(receivedMessage.params["userId\(i)"]!)
                let currentPlayerName = receivedMessage.params["username\(i)"]
                let addingplayer = Player(username: currentPlayerName!, currentGame: "test", currentBet: 0, userId: currentPlayerID!, currentBalance: Int(receivedMessage.params["buyIn"]!)!)
                Game.allPlayers[currentPlayerID!] = addingplayer
                if currentPlayerID == Game.currentPlayerId {
                    Game.currentPlayer = addingplayer
                }
                i = i + 1
            }
            performSegue(withIdentifier: "startGameSegue", sender: nil)
        }
        
    }
    
    
    
}
