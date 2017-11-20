//
//  WelcomeViewController.swift
//  VirtualChips
//
//  Created by David Valdez on 11/14/17.
//  Copyright © 2017 company. All rights reserved.
//
//Stiven Deleur, Anubhav Garg, Valerie Gomez, David Valdez, Rohan Shastri
import UIKit
import Starscream
class WelcomeViewController: UIViewController {
    
    //Declares Login Segue as Constant
    private let LOGIN_SEGUE = "loginSegue";
    
    //Declares Register Segue as Constant
    private let REGISTER_SEGUE = "registerSegue";
    
    private let GUEST_GAMEHUB_SEGUE = "guestGameHubSegue";

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        ServerConnect.sendServerConnection()
        
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
    @IBAction func loginWelcome(_ sender: Any) {
        performSegue(withIdentifier: LOGIN_SEGUE, sender: nil)
    }
    
    @IBAction func signUpWelcome(_ sender: Any) {
        performSegue(withIdentifier: REGISTER_SEGUE, sender: nil)
    }
    
    @IBAction func guestClicked(_ sender: Any) {
        performSegue(withIdentifier: GUEST_GAMEHUB_SEGUE, sender: nil)
    }
    

}
