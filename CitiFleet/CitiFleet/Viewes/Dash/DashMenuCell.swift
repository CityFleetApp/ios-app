//
//  DashMenuCell.swift
//  CitiFleet
//
//  Created by Nick Kibish on 2/26/16.
//  Copyright © 2016 Nick Kibish. All rights reserved.
//

import UIKit

class DashMenuCell: UITableViewCell {
    @IBOutlet var title: UILabel!
    internal var selectedColor = Color.Dash.SelectedCell
    internal var titleColor = UIColor(hex: Color.Dash.CellTitleText, alpha: 1)
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        super.touchesBegan(touches, withEvent: event)
        backgroundColor = selectedColor
        title.textColor = UIColor.whiteColor()
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        super.touchesEnded(touches, withEvent: event)
        backgroundColor = UIColor.whiteColor()
        title.textColor = titleColor
    }
    
    override func touchesCancelled(touches: Set<UITouch>?, withEvent event: UIEvent?) {
        super.touchesCancelled(touches, withEvent: event)
        backgroundColor = UIColor.whiteColor()
        title.textColor = titleColor
    }
    
}

class DashLogOutCell: DashMenuCell {
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        selectedColor = UIColor.redColor()
        titleColor = UIColor.redColor()
    }
}
