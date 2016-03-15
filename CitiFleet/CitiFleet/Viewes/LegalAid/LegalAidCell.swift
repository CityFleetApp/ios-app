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
    @IBOutlet var placeHolder: HighlitableLabel!
    var inactiveColor = UIColor.lightGrayColor()
    
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
            placeHolder.updateText()
        } else {
            placeHolder.text = nil
            placeHolder.textColor = inactiveColor
        }
    }
}

extension LegalAidCell {
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        super.touchesBegan(touches, withEvent: event)
        placeHolder.textColor = UIColor.whiteColor()
        icon.tintColor = UIColor.whiteColor()
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        super.touchesEnded(touches, withEvent: event)
        placeHolder.updateText()
        icon.tintColor = selectedColor
    }
    
    override func touchesCancelled(touches: Set<UITouch>?, withEvent event: UIEvent?) {
        super.touchesCancelled(touches, withEvent: event)
        placeHolder.updateText()
        icon.tintColor = selectedColor
    }
}
