//
//  AddFriendsCell.swift
//  CitiFleet
//
//  Created by Nick Kibish on 3/1/16.
//  Copyright © 2016 Nick Kibish. All rights reserved.
//

import UIKit

class AddFriendsCell: UITableViewCell {
    @IBOutlet var title: UILabel!
    @IBOutlet var icon: UIImageView!
    internal var selectedColor = Color.Dash.SelectedCell
    internal var titleColor = Color.Dash.SelectedCell
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
    }
    
    func setup() {
        icon.image = icon.image?.imageWithRenderingMode(.AlwaysTemplate)
        icon.tintColor = titleColor
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        super.touchesBegan(touches, withEvent: event)
        backgroundColor = selectedColor
        title.textColor = UIColor.whiteColor()
        icon.tintColor = UIColor.whiteColor()
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        super.touchesEnded(touches, withEvent: event)
        backgroundColor = UIColor.whiteColor()
        title.textColor = titleColor
        icon.tintColor = titleColor
    }
    
    override func touchesCancelled(touches: Set<UITouch>?, withEvent event: UIEvent?) {
        super.touchesCancelled(touches, withEvent: event)
        backgroundColor = UIColor.whiteColor()
        title.textColor = titleColor
        icon.tintColor = titleColor
    }

}
