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

    private let NEW_GAME_LOADING_SEGUE = "newGameLoadingSegue"
    
    private let TEST_SEGUE = "testSegue"
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
    
    @IBAction func testClicked(_ sender: Any) {
        performSegue(withIdentifier: TEST_SEGUE, sender: nil)
    }
    @IBAction func buttonClicked(_ sender: Any) {
    performSegue(withIdentifier: NEW_GAME_LOADING_SEGUE, sender: nil)
    }
}
