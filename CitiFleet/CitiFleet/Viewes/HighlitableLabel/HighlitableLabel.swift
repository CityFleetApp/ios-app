//
//  HighlitableLabel.swift
//  CitiFleet
//
//  Created by Nick Kibish on 3/12/16.
//  Copyright © 2016 Nick Kibish. All rights reserved.
//

import UIKit

class HighlitableLabel: UILabel {
    @IBInspectable var placeholderFont: UIFont {
        return UIFont(name: FontNames.Montserrat.Light, size: 14.35)!
    }
    
    @IBInspectable var highlitedFont: UIFont {
        return UIFont(name: FontNames.Montserrat.Regular, size: 14.35)!
    }
    
    @IBInspectable var placeholderTextColor: UIColor {
        return UIColor(hex: 0xa8a9a9, alpha: 1)
    }
    
    @IBInspectable var highlitedTextColor: UIColor {
        return UIColor(hex: 0x4c5a76, alpha: 1) 
    }
    
    @IBInspectable var placeholderText: String? {
        didSet {
            updateText()
        }
    }
    
    @IBInspectable var highlitedText: String? {
        didSet {
            updateText()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        updateText()
    }
    
    func updateText() {
        if highlitedText == nil || highlitedText?.characters.count == 0 {
            setPlaceHolderText()
        } else {
            setHighlitedText()
        }
    }
    
    private func setPlaceHolderText() {
        text = placeholderText
        font = placeholderFont
        textColor = placeholderTextColor
    }
    
    private func setHighlitedText() {
        text = highlitedText
        font = highlitedFont
        textColor = highlitedTextColor
    }
}
