//
//  RoundedTextField.swift
//  Messenger
//
//  Created by Dillon Baker on 2/8/17.
//  Copyright © 2017 JDCollaboration. All rights reserved.
//

import UIKit

class RoundedTextField: UITextField {

    override func draw(_ rect: CGRect) {
        self.layer.cornerRadius = 15.0
        self.layer.borderWidth = 1.0
        self.layer.borderColor = UIColor(displayP3Red: 14.0/255.0, green: 122.0/255.0, blue: 254.0/255.0, alpha: 0.4).cgColor
    }

}
