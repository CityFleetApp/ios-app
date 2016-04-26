//
//  Message.swift
//  CitiFleet
//
//  Created by Nick Kibish on 4/14/16.
//  Copyright © 2016 Nick Kibish. All rights reserved.
//

import UIKit

class Message: NSObject {
    var id: Int?
    var message: String?
    var roodHash: String?
    var roomId: Int?
    var date: NSDate?
    var author: User?
    var participants: [Friend] = []

    override init() {
        super.init()
    }
    
    init(json: AnyObject) {
        super.init()
        message = json[Response.Chat.text] as? String
        roomId = json[Response.Chat.room] as? Int
        if let dateStr = json[Response.Chat.created] as? String {
            date = NSDateFormatter.serverResponseFormat.dateFromString(dateStr)
        }
        if let participantsArray = json[Response.Chat.participants] as? [AnyObject] {
            parseParticipants(participantsArray)
            let authorID = json[Response.Chat._author] as? Int
            let authorArr = participants.filter({ return $0.id == authorID })
            author = authorArr.count > 0 ? authorArr[0] : nil 
        }
    }
}

//MARK: - Private Methods
extension Message {
    private func parseParticipants(usersArr: [AnyObject]) {
        for friendObj in usersArr {
            let friend = Friend(json: friendObj)
            participants.append(friend)
        }
    }
}