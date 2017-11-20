//
//  InGameViewController.swift
//  VirtualChips
//
//  Created by David Valdez on 11/16/17.
//  Copyright © 2017 company. All rights reserved.
//
//Stiven Deleur, Anubhav Garg, Valerie Gomez, David Valdez, Rohan Shastri
import UIKit
import Starscream
class InGameViewController: UIViewController {
    
    
    @IBOutlet weak var FoldButton: UIButton!
    @IBOutlet weak var RaiseField: UITextField!
    @IBOutlet weak var CallButton: UIButton!
    @IBOutlet weak var CheckButton: UIButton!
    @IBOutlet weak var RaiseButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        RaiseField.isHidden = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func raiseClicked(_ sender: Any) {
        RaiseField.isHidden = false
    }
    

}
