//
//  NewGameCodeViewController.swift
//  VirtualChips
//
//  Created by David Valdez on 11/15/17.
//  Copyright © 2017 company. All rights reserved.
//
//Stiven Deleur, Anubhav Garg, Valerie Gomez, David Valdez, Rohan Shastri
import UIKit
import Starscream
class NewGameCodeViewController: UIViewController {

    let NEW_GAME_START_SEGUE = "hostStartGameSegue"

    var gameID : String?
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var testButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ServerConnect.socket!.delegate = self
        let data = (gameID ?? "").data(using: .ascii, allowLossyConversion: false)
        let filter = CIFilter(name: "CIQRCodeGenerator")
        filter?.setValue(data, forKey: "inputMessage")
        
        let img = UIImage(ciImage: (filter?.outputImage)!)
        
        imageView.image = img
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

extension NewGameCodeViewController : WebSocketDelegate {
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
        if receivedMessage.event == "startGame" {
            performSegue(withIdentifier: NEW_GAME_START_SEGUE, sender: nil)
        }else if receivedMessage.event == "userJoined"{
            print("User " + (receivedMessage.params["id"] ?? "N/A") + " joined")
        }
        
    }
    
    
    
}
