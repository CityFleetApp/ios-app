//
//  MyRentSaeCell.swift
//  CitiFleet
//
//  Created by Nick Kibish on 3/19/16.
//  Copyright © 2016 Nick Kibish. All rights reserved.
//

import UIKit
import KMPlaceholderTextView

class PostingCell: LegalAidCell {
    var didSelect: (() -> ())!
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func select() {
        didSelect()
    }
}

class MyRentSalePriceCell: PostingCell {
    static let CellID = "MyRentSalePriceCell"
    @IBOutlet var priceTF: UITextField!
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}

extension MyRentSalePriceCell: UITextFieldDelegate {
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        if textField.text?.containsString(".") == true && string.containsString(".") {
            return false
        }
        return !containLetters(string)
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
    var cellHeight: CGFloat?
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
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
            descriptionTV.becomeFirstResponder()
        }
    }
    
    private func calculateHeightForBio() -> CGFloat {
        let topSize: CGFloat = 44 + 28
        let textViewWidth = CGRectGetWidth(UIScreen.mainScreen().bounds) - 28
        let height = descriptionTV.attributedText.heightWithConstrainedWidth(textViewWidth) + topSize
        return height
    }
}