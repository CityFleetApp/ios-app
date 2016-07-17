//
//  NotificationDetailVC.swift
//  CitiFleet
//
//  Created by Nick Kibish on 3/17/16.
//  Copyright © 2016 Nick Kibish. All rights reserved.
//

import UIKit
import AVKit

class NotificationDetailVC: UITableViewController {
    private let titleCellHeight: CGFloat = 83
    private let buttonHeight: CGFloat = 40

    @IBOutlet var notificationMessageTF: UITextView!
    @IBOutlet var notificationTitleLbl: UILabel!
    var notification: Notification!
    
    override func viewWillAppear(animated: Bool) {
        setupNotification()
    }
    
    @IBAction func openJobOffer() {
        let urlStr = "\(URL.Marketplace.JobOffers)\(notification.refID!)/"
        RequestManager.sharedInstance().get(urlStr, parameters: nil) { [weak self] (json, error) in
            if let jobDict = json?.dictionaryObject {
                let jobOffer = JobOffer(json: jobDict)
                let storyboard = UIStoryboard(name: Storyboard.MarketPlace, bundle: nil)
                let vc: JobOfferInfoVC? = storyboard.instantiateViewControllerWithIdentifier(jobOffer.status == .Available ? JobOfferInfoVC.StoryboardID : JobOfferAwardedVC.StoryboardID) as? JobOfferInfoVC
                
                if let viewController = vc {
                    viewController.job = jobOffer
                    self?.navigationController?.pushViewController(viewController, animated: true)
                }
            }
        }
    }
    
    private func setupNotification() {
        title = notification.typeTitle
        notificationTitleLbl.text = notification.title
        let rangePointer: NSRangePointer = nil
        notificationMessageTF.attributedText = NSAttributedString(string: notification.message!, attributes: notificationMessageTF.attributedText.attributesAtIndex(0, effectiveRange: rangePointer))
        tableView.reloadData()
    }
    
    private func calculateHeightForBio() -> CGFloat {
        let topSize: CGFloat = 44 + 28
        let textViewWidth = CGRectGetWidth(UIScreen.mainScreen().bounds) - 28
        let height = notificationMessageTF.attributedText.heightWithConstrainedWidth(textViewWidth) + topSize
        return height
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        switch indexPath.row {
        case 0:
            return titleCellHeight
        case 1:
            return calculateHeightForBio()
        case 2:
            return notification.notificationType == .JobOffer ? buttonHeight : 0
        default:
            return 0
        }
    }
}
