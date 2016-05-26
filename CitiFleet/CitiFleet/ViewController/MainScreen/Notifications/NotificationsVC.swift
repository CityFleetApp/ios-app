//
//  NotificationsVC.swift
//  CitiFleet
//
//  Created by Nick Kibish on 3/17/16.
//  Copyright © 2016 Nick Kibish. All rights reserved.
//

import UIKit

class NotificationsVC: UIViewController {    
    @IBOutlet var notificationTable: UITableView!
    var notifications: [Notification]?
    
    override func viewDidLoad() {
        NotificationManager.sharedInstance.getList(updateNotifications)
    }
    
    override func viewWillAppear(animated: Bool) {
        navigationController?.navigationBar.hidden = false
    }
    
    private func updateNotifications(notifications: [Notification]?, ennor: NSError?) {
        self.notifications = notifications
        notificationTable.reloadData()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let viewController = segue.destinationViewController as! NotificationDetailVC
        let index = notificationTable.indexPathForSelectedRow?.row
        let notification = notifications![index!]
        NotificationManager.sharedInstance.markAsRead(notification)
        notification.unseen = false
        let cell = notificationTable.cellForRowAtIndexPath(NSIndexPath(forRow: index!, inSection: 0)) as! NotificationCell
        cell.notification = notification
        
        viewController.notification = notification
    }
    
    @IBAction func setFilter(sender: UIButton) {
        switch sender.tag {
        case 1:
            notifications = NotificationManager.sharedInstance.filter(.Unread)
            break
        case 2:
            notifications = NotificationManager.sharedInstance.filter(.All)
            break
        default:
            return
        }
        notificationTable.reloadData()
    }
}

extension NotificationsVC: UITableViewDelegate {
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 81
    }
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        tableView.setZeroSeparator(cell)
    }
}

extension NotificationsVC: UITableViewDataSource {
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notifications != nil ? notifications!.count : 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier(CellID.NotificationCell) as? NotificationCell
        if cell == nil {
            cell = NotificationCell(style: .Default, reuseIdentifier: CellID.NotificationCell)
        }
        let notification = notifications![indexPath.row]
        cell?.notification = notification
        return cell!
    }
}