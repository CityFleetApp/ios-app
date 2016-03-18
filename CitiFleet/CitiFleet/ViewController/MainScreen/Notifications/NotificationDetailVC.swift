//
//  NotificationDetailVC.swift
//  CitiFleet
//
//  Created by Nick Kibish on 3/17/16.
//  Copyright © 2016 Nick Kibish. All rights reserved.
//

import UIKit

class NotificationDetailVC: UITableViewController {
    private let titleCellHeight: CGFloat = 83
    @IBOutlet var notificationMessageTF: UITextView!
    @IBOutlet var notificationTitleLbl: UILabel!
    var notification: Notification!
    
    override func viewWillAppear(animated: Bool) {
        setupNotification()
    }
    
    private func setupNotification() {
        title = notification.typeTitle
        notificationTitleLbl.text = notification.title
        notificationMessageTF.attributedText = NSAttributedString(string: notification.message!, attributes: notificationMessageTF.attributedText.attributesAtIndex(0, effectiveRange: NSRangePointer()))
        tableView.reloadData()
    }
    
    private func calculateHeightForBio() -> CGFloat {
        let topSize: CGFloat = 44 + 28
        let textViewWidth = CGRectGetWidth(UIScreen.mainScreen().bounds) - 28
        let height = notificationMessageTF.attributedText.heightWithConstrainedWidth(textViewWidth) + topSize
        return height
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return indexPath.row == 0 ? titleCellHeight : calculateHeightForBio()
    }
}
