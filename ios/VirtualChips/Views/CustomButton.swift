//
//  CustomButton.swift
//  VirtualChips
//
//  Created by David Valdez on 11/20/17.
//  Copyright © 2017 company. All rights reserved.
//

import Foundation
import UIKit


class CustomButton : UIButton {
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.layer.cornerRadius = 5.0
        self.layer.borderColor = UIColor.white.cgColor
        self.layer.borderWidth = 1.5
        self.backgroundColor = UIColor.darkGray
        self.tintColor = UIColor.white
    }
    
    
}
