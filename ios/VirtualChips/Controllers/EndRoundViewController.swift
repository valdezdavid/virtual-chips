////
////  EndRoundViewController.swift
////  VirtualChips
////
////  Created by David Valdez on 11/20/17.
////  Copyright © 2017 company. All rights reserved.
////
//
//import UIKit
//import Starscream
//class EndRoundViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
//
//
//    //Player set (using Player class in Models)
//    //var playersSet : [Player] = []
//    var playersArray: [Int]!
//
//    var numUsers = 0;
//    @IBOutlet weak var tableView: UITableView!
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        ServerConnect.socket!.delegate = self
//    }
//
//    override func didReceiveMemoryWarning() {
//        super.didReceiveMemoryWarning()
//        // Dispose of any resources that can be recreated.
//    }
//
//    //Table View
//    func numberOfSections(in tableView: UITableView) -> Int {
//        return 1
//    }
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        playersArray.count
//    }
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "cellPlayer", for: indexPath)
//        let player = playersArray[indexPath.row]
//        cell.textLabel?.text =
//    }
//
//}
//
//extension EndRoundViewController : WebSocketDelegate {
//    func websocketDidConnect(socket: WebSocketClient) {
//
//    }
//
//    func websocketDidReceiveData(socket: WebSocketClient, data: Data) {
//
//    }
//
//
//    func websocketDidDisconnect(socket: WebSocketClient, error: Error?) {
//
//    }
//
//    func websocketDidReceiveMessage(socket: WebSocketClient, text: String) {
//        print("below is the text from the server")
//        print(text)
//
//        let jsonData = text.data(using: .utf8)!
//        print ("jsonData is listed below")
//        print (jsonData)
//        let decoder = JSONDecoder()
//        let receivedMessage = try! decoder.decode(ReceivedMessage.self, from: jsonData)
//        print ("This is the recieved message")
//        print (receivedMessage)
//
//        if(receivedMessage.event == "chooseWinner"){
//            //Check if there is atleast 1 player
//            if(Int(receivedMessage.params["numUsers"]!)! > 0){
//                numUsers = Int (receivedMessage.params["numUsers"]!)!
//
//                var counter = 0
//                while counter <= numUsers{
//                    playersArray.append(Int (receivedMessage.params[String (counter + 1)]!)!)
//                    counter += 1
//                }
//
//            }
//        }
//
//
//    }
//}
//
