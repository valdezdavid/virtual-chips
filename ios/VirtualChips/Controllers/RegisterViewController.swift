//
//  RegisterViewController.swift
//  VirtualChips
//
//  Created by David Valdez on 11/14/17.
//  Copyright © 2017 company. All rights reserved.
//
///Stiven Deleur, Anubhav Garg, Valerie Gomez, David Valdez, Rohan Shastri
import UIKit
import Starscream
class RegisterViewController: UIViewController {

    //Declares Register Segue as Constant (Register -> GameHub)
    private let REGISTER_GAMEHUB_SEGUE = "registerGameHubSegue";
    
    
    @IBOutlet weak var usernameField: UITextField!
    
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var repeatPasswordField: UITextField!
    @IBOutlet weak var errorLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
ServerConnect.socket?.delegate = self
        errorLabel.isHidden = true
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func registerButton(_ sender: Any) {
        
        if (passwordField.text != repeatPasswordField.text) {
            errorLabel.text = "Passwords do not match!"
            errorLabel.isHidden = false
            return
        }
        let messageContent = ["username" : usernameField.text, "password": passwordField.text]
        let m1 = SendingMessage(command: "register", params: messageContent as! [String : String])
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
} //CLASS

extension RegisterViewController : WebSocketDelegate {
    
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
        if receivedMessage.params["success"] == "true" {
            performSegue(withIdentifier: REGISTER_GAMEHUB_SEGUE, sender: nil)
        }else{
            errorLabel.text = "Username already exists!"
            errorLabel.isHidden = false
        }
        
    }

    
    
}










