//
//  ManagePostsListVC.swift
//  CitiFleet
//
//  Created by Nick Kibish on 4/6/16.
//  Copyright © 2016 Nick Kibish. All rights reserved.
//

import UIKit

class ManagePostsListVC: UITableViewController {
    let dataSource = ManagePostsListDataSource()
    let CellHeight: CGFloat = 81
    
    override func viewDidLoad() {
        dataSource.loadData { [weak self] (error) in
            if error == nil {
                self?.tableView.reloadData()
            }
        }
    }
}

extension ManagePostsListVC {
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.previousPosts.count
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return CellHeight
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let CellID = "PreviousPostCellID"
        let item = dataSource.previousPosts[indexPath.row]
        var cell = tableView.dequeueReusableCellWithIdentifier(CellID) as? NotificationCell
        if cell == nil {
            cell = UITableViewCell(style: .Default, reuseIdentifier: CellID) as? NotificationCell
        }
        cell?.title?.text = item.title
        cell?.notificationTitle?.text = item.postDescription
        cell?.dateLabel?.text = item.dateString
        cell?.icon.image = UIImage(named: item.imageName!)
        return cell!
    }
}