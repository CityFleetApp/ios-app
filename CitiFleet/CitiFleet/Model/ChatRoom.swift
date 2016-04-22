//
//  ChatRoom.swift
//  CitiFleet
//
//  Created by Nick Kibish on 4/13/16.
//  Copyright © 2016 Nick Kibish. All rights reserved.
//

import UIKit

class ChatRoom: NSObject {
    var lastMessage: String?
    var name: String?
    var id: Int?
    var participants: [Friend] = []
    var hasUnreadMesages = false
    
    override init() {
        super.init()
    }
    
    init(json: AnyObject) {
        super.init()
        name = json[Response.Chat.Name] as? String
        id = json[Params.id] as? Int
        lastMessage = json[Response.Chat.lastMessage] as? String
        hasUnreadMesages = json[Response.Chat.unreadMessages] as? Int > 0
        
        if let participants = json[Response.Chat.participantsInfo] as? [AnyObject] {
            for participant in participants {
                let friend = Friend(json: participant)
                if friend != User.currentUser() {
                    self.participants.append(friend)
                }
            }
        }
    }
}
