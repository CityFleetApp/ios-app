//
//  PhoneTextField.swift
//  CitiFleet
//
//  Created by Nick Kibish on 2/28/16.
//  Copyright © 2016 Nick Kibish. All rights reserved.
//

import UIKit

class PhoneTextField: UITextField {
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        var frame = bounds
        frame.size.width = 20
        let leftView = UILabel(frame: frame)
        leftView.font = Fonts.Login.SignUpTextField
        leftView.text = "+1"
        leftView.textAlignment = .Center
        leftViewMode = .Never
        self.leftView = leftView
    }
}
