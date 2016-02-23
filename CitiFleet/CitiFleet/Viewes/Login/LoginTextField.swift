//
//  LoginTextField.swift
//  CitiFleet
//
//  Created by Nick Kibish on 2/23/16.
//  Copyright © 2016 Nick Kibish. All rights reserved.
//

import UIKit

class LoginTextField: UITextField {
    override func awakeFromNib() {
        super.awakeFromNib()
        cornerRadius = 5
        self.backgroundColor = UIColor(white: 1, alpha: 0.7)
        
    }
}
