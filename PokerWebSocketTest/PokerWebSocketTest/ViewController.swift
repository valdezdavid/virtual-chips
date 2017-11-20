//
//  ViewController.swift
//  PokerWebSocketTest
//
//  Created by Anubhav Garg on 11/13/17.
//  Copyright © 2017 Anubhav Garg. All rights reserved.
//

import UIKit
import Starscream

struct SendingMessage: Codable {
    var command: String
    var params: [String: String]
}

struct ReceivedMessage: Codable {
    var event: String
    var params: [String: String]
}

class ViewController: UIViewController {
    
    
    // MARK: - Properties
    var socket = WebSocket(url: URL(string: "ws://localhost:8080/CSCI-PokerChipServer/pokerchip")!, protocols: ["chat"])
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var ConnectServerButton: UIButton!
    
    @IBAction func sendServerConnection(_ sender: Any) {
        print("hello")
        socket.connect()
        
    }
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        print("just a check that view has loaded")
        socket.delegate = self
        navigationItem.hidesBackButton = true
    }
    deinit {
        socket.disconnect(forceTimeout: 0)
        socket.delegate = nil
    }
    
}

// MARK: - FilePrivate

extension ViewController : WebSocketDelegate {
    func websocketDidConnect(socket: WebSocketClient) {
        print("the socket has connected!!")
        let messageContent = ["username": "hello", "password": "hi"]
        let message1 = SendingMessage(command: "login", params: messageContent)
        let jsonEncoder = JSONEncoder()
        
        do {
            if let jsonData = try? jsonEncoder.encode(message1) {
                if let jsonString = String(data: jsonData, encoding: .utf8){
                    socket.write(string: jsonString)
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
        
    }
    
    func websocketDidReceiveData(socket: WebSocketClient, data: Data) {
        
    }
    

}




















