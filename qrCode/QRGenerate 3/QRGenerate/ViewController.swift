//
//  ViewController.swift
//  QRGenerate
//
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var myTextField: UITextField!
    @IBOutlet weak var myImageView: UIImageView!
    
    @IBAction func button(_ sender: Any)
    {
        if let myString = myTextField.text
        {
            let data = myString.data(using: .ascii, allowLossyConversion: false)
            let filter = CIFilter(name: "CIQRCodeGenerator")
            filter?.setValue(data, forKey: "inputMessage")
            
            let img = UIImage(ciImage: (filter?.outputImage)!)
            
            myImageView.image = img
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

