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
    
    override func viewWillAppear(animated: Bool) {
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
        cell?.icon.image = UIImage(named: item.imageName!)?.imageWithRenderingMode(.AlwaysTemplate)
        return cell!
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let item = dataSource.previousPosts[indexPath.row]
        switch item.postType! {
        case ManagePostsListDataSource.PostType.Car:
            let carVC = UpdateCarVCBuilder().createViewController(item as! CarForRentSale)
            navigationController?.pushViewController(carVC, animated: true)
            break
        case ManagePostsListDataSource.PostType.Good:
            if let goodsVC = storyboard?.instantiateViewControllerWithIdentifier(ViewControllerID.Posting.GoodForSale) as? GeneralGoodsVC {
                goodsVC.generalGood = item as! GoodForSale
                navigationController?.pushViewController(goodsVC, animated: true)
            }
            break
        case ManagePostsListDataSource.PostType.JobOffer:
            if let jobofferVC = storyboard?.instantiateViewControllerWithIdentifier(ViewControllerID.Posting.JobOffer) as? JobOfferVC {
                jobofferVC.jobOffer = item as! JobOffer
                navigationController?.pushViewController(jobofferVC, animated: true)
            }
            break
        }
    }
}