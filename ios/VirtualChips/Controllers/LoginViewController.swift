//
//  LoginViewController.swift
//  VirtualChips
//
//  Created by David Valdez on 11/13/17.
//  Copyright © 2017 company. All rights reserved.
//
/*
 /Stiven Deleur, Anubhav Garg, Valerie Gomez, David Valdez, Rohan Shastri
 
 */



import UIKit
import Starscream

class LoginViewController: UIViewController, UITextFieldDelegate {
    //Declares Login Segue as Constant
    let LOGIN_GAMEHUB_SEGUE = "loginGameHubSegue";
    
    @IBOutlet weak var usernameText: UITextField!
    
    @IBOutlet weak var passwordText: UITextField!
    @IBOutlet weak var errorLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        ServerConnect.socket?.delegate = self
        errorLabel.isHidden = true
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    @IBAction func cancelLogin(_ sender: Any) {
        //Go back to Register View Controller
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func loginButton(_ sender: Any) {
        
        let messageContent = ["username" : usernameText.text, "password": passwordText.text]
        let m1 = SendingMessage(command: "login", params: messageContent as! [String : String])
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
    
    
} //Class

extension LoginViewController : WebSocketDelegate {
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
        if receivedMessage.params["success"] == "true" {
            performSegue(withIdentifier: LOGIN_GAMEHUB_SEGUE, sender: nil)
        }else{
            errorLabel.isHidden = false
        }
        
    }
    
    
}









