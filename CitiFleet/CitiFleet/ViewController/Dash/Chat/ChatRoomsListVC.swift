//
//  ChatRoomsListVC.swift
//  CitiFleet
//
//  Created by Nick Kibish on 4/13/16.
//  Copyright © 2016 Nick Kibish. All rights reserved.
//

import UIKit

class ChatRoomsListVC: UITableViewController {
    private static let SingleCellAvatarSegueID = "SingleCellAvatarSegueID"
    private static let DoulbeCellAvatarSegueID = "DoulbeCellAvatarSegueID"
    var dataSource = ChatRoomsListDataSource()
    
    override func viewDidLoad() {
        dataSource.reloadData = { [weak self] in
            self?.tableView.reloadData()
        }
        dataSource.loadRooms()
    }
    
    override func viewWillAppear(animated: Bool) {
        SocketManager.sharedManager.open()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let vc = segue.destinationViewController as? ChatVC {
            let room = dataSource.rooms[(tableView.indexPathForSelectedRow?.row)!]
            vc.room = room
        }
    }
    
    deinit {
        SocketManager.sharedManager.close()
    }
}

//MARK: - Private Methods
extension ChatRoomsListVC {
    private func searchCell(tableView: UITableView, indexPath: NSIndexPath) -> UITableViewCell {
        let CellID = SearchCell.CellID
        var cell = tableView.dequeueReusableCellWithIdentifier(CellID) as? SearchCell
        if cell == nil {
            cell = SearchCell(style: .Default, reuseIdentifier: CellID)
        }
        return cell!
    }
    
    private func roomCell(tableView: UITableView, indexPath: NSIndexPath) -> UITableViewCell {
        let room = dataSource.rooms[indexPath.row]
        let CellID = room.participants.count > 1 ? ChatRoomCell.ChatRoomCellTwoPhotoID : ChatRoomCell.ChatRoomCellOnePhotoID
        var cell = tableView.dequeueReusableCellWithIdentifier(CellID) as? ChatRoomCell
        if cell == nil {
            cell = ChatRoomCell(style: .Default, reuseIdentifier: CellID)
        }
        
        cell?.roomNameLbl.text = room.participants.map({ $0.fullName! }).joinWithSeparator(", ")
        cell?.avatar.image = UIImage(named: Resources.NoAvatarIc)
        cell?.secondAvatar?.image = UIImage(named: Resources.NoAvatarIc)
        
        if room.participants.count == 0 {
            return cell!
        }
        
        if let url = room.participants[0].avatarURL {
            cell?.avatar.hnk_setImageFromURL(url)
        }
        
        if room.participants.count > 1 && room.participants[1].avatarURL != nil {
            cell?.secondAvatar?.hnk_setImageFromURL(room.participants[1].avatarURL!)
        }
        
        return cell!
    }
    
    
}

//MARK: - Table View Delegate
extension ChatRoomsListVC {
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        case 1:
            return dataSource.rooms.count
        default:
            return 0
        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            return searchCell(tableView, indexPath: indexPath)
        case 1:
            return roomCell(tableView, indexPath: indexPath)
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
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
}