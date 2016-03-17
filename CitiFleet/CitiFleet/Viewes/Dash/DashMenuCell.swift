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
    @IBOutlet var nextScreenArrow: UIImageView?
    internal var selectedColor = Color.Dash.SelectedCell
    internal var titleColor = UIColor(hex: Color.Dash.CellTitleText, alpha: 1)
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        nextScreenArrow?.image = nextScreenArrow?.image?.imageWithRenderingMode(.AlwaysTemplate)
        nextScreenArrow?.tintColor = selectedColor
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        super.touchesBegan(touches, withEvent: event)
        selectCell()
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        super.touchesEnded(touches, withEvent: event)
        deselectCell()
    }
    
    override func touchesCancelled(touches: Set<UITouch>?, withEvent event: UIEvent?) {
        super.touchesCancelled(touches, withEvent: event)
        deselectCell()
    }
    
    func selectCell() {
        backgroundColor = selectedColor
        title.textColor = UIColor.whiteColor()
        nextScreenArrow?.tintColor = UIColor.whiteColor()
    }
    
    func deselectCell() {
        backgroundColor = UIColor.whiteColor()
        title.textColor = titleColor
        nextScreenArrow?.tintColor = selectedColor
    }
}

class DashLogOutCell: DashMenuCell {
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        selectedColor = UIColor.redColor()
        titleColor = UIColor.redColor()
    }
}
