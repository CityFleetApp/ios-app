//
//  LoginTextField.swift
//  CitiFleet
//
//  Created by Nick Kibish on 2/23/16.
//  Copyright © 2016 Nick Kibish. All rights reserved.
//

import UIKit

@IBDesignable class LoginTextField: UITextField {
    private let leftViewFrame = CGRect(x: 0, y: 0, width: 60, height: 0)
    private let attributes = [NSFontAttributeName: Fonts.Login.LoginPlaceholder, NSForegroundColorAttributeName: Color.Login.PlaceHolderForeground]
    private let errorAttributes = [NSFontAttributeName: Fonts.Login.LoginPlaceholder, NSForegroundColorAttributeName: Color.Login.ErrorPlaceholderForeground]
    
    @IBInspectable var image: UIImage? {
        get {
            if let leftImageView = leftView as? UIImageView {
                return leftImageView.image
            }
            return nil
        }
        set {
            let imageView = UIImageView(image: newValue)
            var imageFrame = leftViewFrame
            imageFrame.size.height = bounds.height
            imageView.frame = imageFrame
            imageView.contentMode = .Center
            leftView = imageView
        }
    }
    
    @IBInspectable var attributedPlaceholderText: String! {
        get {
            if let attrPlaceholderText = attributedPlaceholder {
                return String(attrPlaceholderText)
            }
            return ""
        }
        set {
            attributedPlaceholder = NSAttributedString(string: newValue, attributes: attributes)
        }
    }
    
    override func setErrorPlaceholder(placeHolderText: String) {
        attributedPlaceholder = NSAttributedString(string: placeHolderText, attributes: errorAttributes)
    }
    
    override func drawRect(rect: CGRect) {
        super.drawRect(rect)
        leftViewMode = .Always
    }
}
