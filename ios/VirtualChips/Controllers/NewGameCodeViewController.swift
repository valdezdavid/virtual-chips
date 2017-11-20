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
    
    
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var testButton: UIButton!
    
    private let TEST_SEGUE = "testSegue"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func buttonClicked(_ sender: Any) {
        if let myString = textField.text
        {
            let data = myString.data(using: .ascii, allowLossyConversion: false)
            let filter = CIFilter(name: "CIQRCodeGenerator")
            filter?.setValue(data, forKey: "inputMessage")
            
            let img = UIImage(ciImage: (filter?.outputImage)!)
            
            imageView.image = img
        }
        performSegue(withIdentifier: NEW_GAME_LOADING_SEGUE, sender: nil)
    }
}
