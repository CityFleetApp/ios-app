//
//  FriendsListVC.swift
//  CitiFleet
//
//  Created by Nick Kibish on 4/13/16.
//  Copyright © 2016 Nick Kibish. All rights reserved.
//

import UIKit
import Haneke

class FriendsListVC: UITableViewController {
    var datasource = FriendsListDataSource()
    
    override func viewDidLoad() {
        datasource.loadDataCompleted = { [weak self] in
            self?.tableView.reloadData()
        }
        datasource.loadFriends()
    }
}

//MARK: - Private Methods
extension FriendsListVC {
    private func searchCell(tableView: UITableView, indexPath: NSIndexPath) -> UITableViewCell {
        let CellID = SearchCell.CellID
        var cell = tableView.dequeueReusableCellWithIdentifier(CellID) as? SearchCell
        if cell == nil {
            cell = SearchCell(style: .Default, reuseIdentifier: CellID)
        }
        return cell!
    }
    
    private func friendCell(tableView: UITableView, indexPath: NSIndexPath) -> UITableViewCell {
        let CellID = FriendCell.CellID
        let friend = datasource.friends[indexPath.row]
        var cell = tableView.dequeueReusableCellWithIdentifier(CellID) as? FriendCell
        if cell == nil {
            cell = FriendCell(style: .Default, reuseIdentifier: CellID)
        }
        
        cell?.avatarImg.image = UIImage(named: Resources.NoAvatarIc)
        if let url = friend.avatarURL {
            cell?.avatarImg.hnk_setImageFromURL(url)
        }
        cell?.fullNameLbl.text = friend.fullName
        cell?.phoneLbl.text = friend.phone
        
        return cell!
    }
}

//MARK: - Table View Delegate
extension FriendsListVC {
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        case 1:
            return datasource.friends.count
        default:
            return 0
        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            return searchCell(tableView, indexPath: indexPath)
        case 1:
            return friendCell(tableView, indexPath: indexPath)
        default:
            return UITableViewCell()
        }
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        switch indexPath.section {
        case 0:
            return 37
        case 1:
            return 66
        default:
            return 0
        }
    }
}