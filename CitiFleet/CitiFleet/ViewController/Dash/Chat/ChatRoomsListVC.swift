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
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(newMessageReceived(_:)), name: SocketManager.NewMessage, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(joinedRoom(_:)), name: SocketManager.NewRoom, object: nil)
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
        cell?.searchTF.delegate = self
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
        cell?.contentView.backgroundColor = room.hasUnreadMesages ? UIColor(hex: Color.Chat.UnreadRoomBG, alpha: 0.3) : UIColor(hex: Color.Chat.CellBackeground, alpha: 0.8)
        
        cell?.lastMessageLbl.text = room.lastMessage
        
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
    
    private func moveRoomToTop(room: ChatRoom) {
        let index = dataSource.rooms.indexOf(room)
        dataSource.rooms.removeAtIndex(index!)
        dataSource.rooms.insert(room, atIndex: 0)
        
        tableView.moveRowAtIndexPath(NSIndexPath(forRow: index!, inSection: 1), toIndexPath: NSIndexPath(forRow: 0, inSection: 1))
        tableView.reloadRowsAtIndexPaths([NSIndexPath(forRow: 0, inSection: 1)], withRowAnimation: .None)
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
        if indexPath.section == 0 {
            return
        }
        let room = dataSource.rooms[indexPath.row]
        room.hasUnreadMesages = false
        tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
        SocketManager.sharedManager.markRoomAsRead(room)
    }
    
    override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.section == 0 {
            return
        }
        
        let room = dataSource.rooms[indexPath.row]
        cell.contentView.backgroundColor = room.hasUnreadMesages ? UIColor(hex: Color.Chat.UnreadRoomBG, alpha: 0.3) : UIColor(hex: Color.Chat.CellBackeground, alpha: 0.8)
        
        if indexPath.row == dataSource.rooms.count - 1 && dataSource.shouldLoadNext {
            dataSource.loadNext({ [weak self] (rooms, error) in
                if rooms == nil {
                    return
                }
                var indexPathes: [NSIndexPath] = []
                for index in (indexPath.row + 1)...(indexPath.row + rooms!.count) {
                    indexPathes.append(NSIndexPath(forRow: index, inSection: 1))
                }
                self?.tableView.insertRowsAtIndexPaths(indexPathes, withRowAnimation: .Automatic)
            })
        }
    }
}

//MARK: - Chat Notifications
extension ChatRoomsListVC {
    func newMessageReceived(notification: NSNotification) {
        if let message = notification.object as? Message {
            let rooms = dataSource.rooms.filter( {$0.id == message.roomId} )
            if rooms.count > 0 {
                let existingRoom = rooms[0]
                existingRoom.lastMessage = message.message
                existingRoom.hasUnreadMesages = true
                moveRoomToTop(existingRoom)
            }
        }
    }
    
    func joinedRoom(notification: NSNotification) {
        if let room = notification.object as? ChatRoom {
            let rooms = dataSource.rooms.filter( {$0.id == room.id} )
            if rooms.count > 0 {
                moveRoomToTop(room)
            } else {
                dataSource.rooms.insert(room, atIndex: 0)
                tableView.insertRowsAtIndexPaths([NSIndexPath(forRow: 0, inSection: 1)], withRowAnimation: .Automatic)
                dataSource.offset += 1
            }
        }
    }
}

//MARK: - Search Text Field
extension ChatRoomsListVC: UITextFieldDelegate {
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        dataSource.searchText = textField.text
        dataSource.loadRooms()
        return true
    }
}