//
//  ChatRoomsListDataSource.swift
//  CitiFleet
//
//  Created by Nick Kibish on 4/13/16.
//  Copyright © 2016 Nick Kibish. All rights reserved.
//

import UIKit
import SwiftyJSON

class ChatRoomsListDataSource: NSObject {
    var rooms: [ChatRoom] = []
    var reloadData: (() -> ())!
    
    func loadRooms() {
        self.rooms.removeAll()
        RequestManager.sharedInstance().get(URL.Chat.Rooms, parameters: nil) { [weak self] (json, error) in
            if let rooms = json?.arrayObject {
                for room in rooms {
                    let room = ChatRoom(json: room)
                    self?.rooms.append(room)
                }
            }
            self?.reloadData()
        }
    }
}
