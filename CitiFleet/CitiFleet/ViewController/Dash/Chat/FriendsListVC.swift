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
    internal class var StoryboardID: String {
        return "FriendsListVC"
    }
    
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
        let friend = datasource.friends[indexPath.row]
        RequestManager.sharedInstance().postRoom([friend], completion: { (room, error) in
            if error == nil {
                dispatch_async(dispatch_get_main_queue(), { [weak self] in
                    let vc = ChatVC.viewControllerFromStoryboard()
                    vc.room = room
                    self?.navigationController?.pushViewController(vc, animated: true)
                    })
            }
        })
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

//MARK: - Presented Friend List -
class ContactListVC: FriendsListVC {
    var selectedUsers = Set<Friend>()
    var selectionCompleted: ((Set<Friend>?) -> ())?
    
    override class var StoryboardID: String {
        return "ContactListVC"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
    }
    
    func setupNavigationBar() {
        let closeButton = UIBarButtonItem(title: Titles.cancel, style: .Plain, target: self, action: #selector(clone(_:)))
        navigationItem.leftBarButtonItem = closeButton
        
        let doneBtn = UIBarButtonItem(title: Titles.done, style: .Done, target: self, action: #selector(done(_:)))
        navigationItem.rightBarButtonItem = doneBtn
    }
    
    func clone(sender: AnyObject?) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func done(sender: AnyObject?) {
        dismissViewControllerAnimated(true, completion: { [weak self] in
            self?.selectionCompleted?(self?.selectedUsers)
        })
    }
}

//MARK: - UITableView Delegate 
extension ContactListVC {
    override func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.section == 0 {
            return
        }
        
        let cell = tableView.cellForRowAtIndexPath(indexPath) as! FriendCell
        
        let friend = datasource.friends[indexPath.row]
        let accessoryView = cell.accessoryView as? UIImageView
        
        accessoryView?.image = nil
        selectedUsers.remove(friend)
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.section == 0 {
            return
        }
        
        let cell = tableView.cellForRowAtIndexPath(indexPath) as! FriendCell
        
        let friend = datasource.friends[indexPath.row]
        let accessoryView = cell.accessoryView as? UIImageView
        
        accessoryView?.image = UIImage(named: Resources.Chat.AccessoryImage)
        selectedUsers.insert(friend)
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAtIndexPath: indexPath)
        if indexPath.section == 0 {
            return cell
        }
        
        let accesseryImage = UIImageView(frame: CGRect(x: 0, y: 0, width: 33, height: 33))
        accesseryImage.clipsToBounds = true
        accesseryImage.layer.cornerRadius = 16.5
        accesseryImage.contentMode = .Center
        accesseryImage.layer.borderColor = Color.Global.BlueTextColor.CGColor
        accesseryImage.layer.borderWidth = 1
        accesseryImage.backgroundColor = UIColor(hex: Color.Chat.CellBackeground, alpha: 0.8)
        
        cell.accessoryView = accesseryImage
        
        return cell
    }
    
    override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        if let accessoryImage = cell.accessoryView as? UIImageView {
            var checkMarkImage: UIImage?
            let friend = datasource.friends[indexPath.row]
            if selectedUsers.contains(friend) {
                checkMarkImage = UIImage(named: Resources.Chat.AccessoryImage)
            } else {
                checkMarkImage = nil
            }
            accessoryImage.image = checkMarkImage
        }
    }
}