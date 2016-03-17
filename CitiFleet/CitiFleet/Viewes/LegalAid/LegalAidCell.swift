//
//  LegalAidCell.swift
//  CitiFleet
//
//  Created by Nick Kibish on 3/14/16.
//  Copyright © 2016 Nick Kibish. All rights reserved.
//

import UIKit

class LegalAidCell: DashMenuCell {
    @IBOutlet var icon: UIImageView!
    @IBOutlet var placeHolder: HighlitableLabel?
    
    var inactiveColor = UIColor.lightGrayColor()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        icon.image = icon.image?.imageWithRenderingMode(.AlwaysTemplate)
        icon.tintColor = selectedColor
        
        selectedColor = Color.Global.LightGreen
        titleColor = selectedColor
        setEditable(false)
    }
    
    func setEditable(editable: Bool) {
        userInteractionEnabled = editable
        icon.tintColor = editable ? selectedColor : inactiveColor
        title.textColor = editable ? selectedColor : inactiveColor
        if editable {
            placeHolder?.updateText()
        } else {
            placeHolder?.text = nil
            placeHolder?.textColor = inactiveColor
        }
    }

    override func selectCell() {
        super.selectCell()
        placeHolder?.textColor = UIColor.whiteColor()
        icon.tintColor = UIColor.whiteColor()
    }
    
    override func deselectCell() {
        super.deselectCell()
        placeHolder?.updateText()
        icon.tintColor = selectedColor
    }
}
