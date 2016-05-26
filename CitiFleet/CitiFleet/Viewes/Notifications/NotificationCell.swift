//
//  NotificationCell.swift
//  CitiFleet
//
//  Created by Nick Kibish on 3/17/16.
//  Copyright © 2016 Nick Kibish. All rights reserved.
//

import UIKit

class NotificationCell: LegalAidCell {
    @IBOutlet var notificationTypeLbl: UILabel?
    @IBOutlet var notificationTitle: UILabel?
    @IBOutlet var calendarIcon: UIImageView?
    @IBOutlet var dateLabel: UILabel?
    var grayColor = UIColor(hex: Color.Notifcations.LabelGrayColor, alpha: 1)
    var notification: Notification? {
        didSet {
            if let notif = notification {
                setNotification(notif)
            }
        }
    }
    
    private func setNotification(notification: Notification) {
        notificationTitle?.text = notification.title
        dateLabel?.text = notification.dateString
        if notification.unseen! {
            contentView.backgroundColor = UIColor(hex: 0xf0f0f0, alpha: 1)
        } else {
            contentView.backgroundColor = UIColor.whiteColor()
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
        calendarIcon?.image = calendarIcon?.image?.imageWithRenderingMode(.AlwaysTemplate)
        calendarIcon?.tintColor = grayColor
    }
    
    override func selectCell() {
        super.selectCell()
        calendarIcon?.tintColor = UIColor.whiteColor()
        dateLabel?.textColor = UIColor.whiteColor()
        notificationTitle?.textColor = UIColor.whiteColor()
    }
    
    override func deselectCell() {
        super.deselectCell()
        calendarIcon?.tintColor = grayColor
        dateLabel?.textColor = grayColor
        notificationTitle?.textColor = grayColor
    }
}
