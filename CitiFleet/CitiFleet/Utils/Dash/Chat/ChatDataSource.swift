//
//  ChatDataSource.swift
//  CitiFleet
//
//  Created by Nick Kibish on 4/14/16.
//  Copyright © 2016 Nick Kibish. All rights reserved.
//

import UIKit

class ChatDataSource: NSObject {
    var room: ChatRoom!
    var messages: [Message] = []
    var reloadData: (() -> ())!
    
    init(room: ChatRoom) {
        self.room = room
        super.init()
    }
    
    func loadData() {
        let url = "\(URL.Chat.Rooms)\(room.id!)\(URL.Chat.Messages)"
        RequestManager.sharedInstance().get(url, parameters: nil) { [weak self] (json, error) in
            let messageObjects = json?.arrayObject
            for obj in messageObjects! {
                let message = Message(json: obj)
                self?.messages.append(message)
            }
            if let elements = self?.messages {
                self?.messages = elements.reverse()
            }
            self?.reloadData()
        }
    }
}
