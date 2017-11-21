//
//  GameHubViewController.swift
//  VirtualChips
//
//  Created by David Valdez on 11/14/17.
//  Copyright © 2017 company. All rights reserved.
//
///Stiven Deleur, Anubhav Garg, Valerie Gomez, David Valdez, Rohan Shastri
import UIKit
import Starscream
class GameHubViewController: UIViewController {

    //DECLARE New Game Segue as CONST
    private let NEW_GAME_SEGUE = "newGameSegue"
    //DECLARE Join Game Segue as CONST
    private let JOIN_GAME_SEGUE = "joinGameSegue"
    override func viewDidLoad() {
        super.viewDidLoad()

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
    @IBAction func startNewGameClicked(_ sender: Any) {
        performSegue(withIdentifier: NEW_GAME_SEGUE, sender: nil)
    }
    @IBAction func joinGameClicked(_ sender: Any) {
        performSegue(withIdentifier: JOIN_GAME_SEGUE, sender: nil)
    }
    
    @IBAction func unwindToGamehub(unwindSegue: UIStoryboardSegue) {
        
    }
    
    
} // CLASS







