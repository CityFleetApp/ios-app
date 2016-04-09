//
//  MyRentSaeCell.swift
//  CitiFleet
//
//  Created by Nick Kibish on 3/19/16.
//  Copyright © 2016 Nick Kibish. All rights reserved.
//

import UIKit
import KMPlaceholderTextView

protocol CarBuilderCellText {
    var cellText: String? {get set}
}

class PostingCell: LegalAidCell, CarBuilderCellText {
    var didSelect: (() -> ())!
    
    var cellText: String? {
        get {
            return placeHolder?.highlitedText
        } set {
            placeHolder?.highlitedText = newValue
        }
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setEditable(true)
    }
    
    func createAccessoryView(textView: UIView) -> UIView {
        let toolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: 0, height: 44))
        let barButton = UIBarButtonItem(title: "Done", style: .Done, target: textView, action: "resignFirstResponder")
        toolBar.items = [barButton]
        barButton.tintColor = Color.Global.BlueTextColor
        return toolBar
    }
    
    func select() {
        didSelect()
    }
}

class MyRentSalePriceCell: PostingCell {
    static let CellID = "MyRentSalePriceCell"
    @IBOutlet var priceTF: UITextField!
    var changedText: ((String) -> ())?
    
    override var cellText: String? {
        get {
            return priceTF.text
        } set {
            priceTF.text = newValue
        }
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        priceTF.inputAccessoryView = createAccessoryView(priceTF)
        priceTF.setStandardSignUpPlaceHolder(priceTF.placeholder!)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    @IBAction func textChanged(sender: UITextField) {
        sender.setStandardSignUpPlaceHolder(sender.placeholder!)
        changedText?(sender.text!)
    }
}

extension MyRentSalePriceCell: UITextFieldDelegate {
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        if string.characters.count == 0 {
            return true
        }
        let pointString = "."
        if textField.text?.characters.count == 0 && string == pointString {
            return false
        } else if textField.text?.characters.count == 0 {
            return true
        }
        
        if textField.text?.characters.first == "0" {
            return false
        }
        
        if textField.text?.containsString(pointString) == true && string.containsString(pointString) {
            return false
        }
        
        if containLetters(string) {
            return false
        }
        
        if textField.text?.containsString(pointString) == false && string != pointString && textField.text?.characters.count >= 5 {
            return false
        }
        
        if textField.text?.containsString(pointString) == true {
            let strings = textField.text?.characters.split(pointString.characters.first!).map(String.init)
            let secondString = strings?.last
            if strings?.count > 1 && secondString!.characters.count >= 2 {
                return false
            }
        }
        
        return true
    }
    
    private func containLetters(string: String) -> Bool {
        for ch in string.characters {
            if ch < "1" && ch > "0" && ch != "." {
                return true
            }
        }
        return false
    }
}

class MyRentSaleDescriptionCell: PostingCell {
    static let CellID = "MyRentSaleDescriptionCell"
    @IBOutlet var descriptionTV: KMPlaceholderTextView!
    var changedHeight: ((CGFloat) -> ())!
    var changedText: ((String) -> ())!?
    var cellHeight: CGFloat?
    
    override var cellText: String? {
        get {
            return descriptionTV.text
        } set {
            descriptionTV.text = newValue
        }
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        descriptionTV.inputAccessoryView = createAccessoryView(descriptionTV)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}

extension MyRentSaleDescriptionCell: UITextViewDelegate {
    func textViewShouldEndEditing(textView: UITextView) -> Bool {
        textView.resignFirstResponder()
        return true
    }
    
    func textViewDidChange(textView: UITextView) {
        changedText?(textView.text)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 7
        let attributes = [
            NSFontAttributeName: UIFont(name: FontNames.Montserrat.Regular, size: 14.4)!,
            NSForegroundColorAttributeName: Color.Global.BlueTextColor,
            NSParagraphStyleAttributeName: paragraphStyle
        ]
        textView.attributedText = NSAttributedString(string: textView.text, attributes: attributes)
        
        let newHeight = calculateHeightForBio()
        if cellHeight != newHeight {
            cellHeight = newHeight
            changedHeight(newHeight)
//            descriptionTV.becomeFirstResponder()
        }
    }
    
    private func calculateHeightForBio() -> CGFloat {
        let topSize: CGFloat = 44 + 28
        let textViewWidth = CGRectGetWidth(UIScreen.mainScreen().bounds) - 28
        let height = descriptionTV.attributedText.heightWithConstrainedWidth(textViewWidth) + topSize
        return height
    }
}