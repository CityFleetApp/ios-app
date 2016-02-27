//
//  File.swift
//  CitiFleet
//
//  Created by Nick Kibish on 2/22/16.
//  Copyright © 2016 Nick Kibish. All rights reserved.
//

import UIKit

extension UITextField {
    func setPlaceholder(font:UIFont, color:UIColor, text:String) {
        let attributes = [
            NSForegroundColorAttributeName: color,
            NSFontAttributeName : font
        ]
        self.attributedPlaceholder = NSAttributedString(string: text, attributes:attributes)
    }
}

extension UITextField {
    func setStandardplaceHolder(placeHolderText: String) {
        self.setPlaceholder(Fonts.Login.SignUpPlaceHolder, color: UIColor(hex: 0xa8a9a9, alpha: 1), text: placeHolderText)
    }
    
    func setErrorPlaceholder(placeHolderText: String) {
        self.setPlaceholder(Fonts.Login.SignUpPlaceHolder, color: UIColor(hex: 0xe71d36, alpha: 0.7), text: placeHolderText)
    }
}
