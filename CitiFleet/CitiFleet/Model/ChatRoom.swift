//
//  ChatRoom.swift
//  CitiFleet
//
//  Created by Nick Kibish on 4/13/16.
//  Copyright © 2016 Nick Kibish. All rights reserved.
//

import UIKit

class ChatRoom: NSObject {
    var name: String?
    var label: String?
    var participants: [Friend] = []
    
    init(json: AnyObject) {
        super.init()
        name = json[Response.Chat.Name] as? String
        label = json[Response.Chat.Label] as? String
        
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
