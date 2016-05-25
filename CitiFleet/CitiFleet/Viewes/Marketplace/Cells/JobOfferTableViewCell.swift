//
//  JobOfferTableViewCell.swift
//  CitiFleet
//
//  Created by Nick Kibish on 4/4/16.
//  Copyright © 2016 Nick Kibish. All rights reserved.
//

import UIKit

class JobOfferTableViewCell: NotificationCell {
    @IBOutlet var jobStateLabel: UILabel!
    class var jobsReuseIdentifier: String {
        get {
            return "JobOfferTableViewCell"
        }
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        titleColor = UIColor(hex: Color.Dash.CellTitleText, alpha: 1)
        self.title.textColor = titleColor
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func deselectCell() {
        super.deselectCell()
        title.textColor = UIColor(hex: Color.Dash.CellTitleText, alpha: 1)
    }
}
