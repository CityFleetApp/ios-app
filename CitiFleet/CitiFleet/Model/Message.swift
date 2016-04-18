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

    override init() {
        super.init()
    }
    
    init(json: AnyObject) {
        super.init()
        message = json[Response.Chat.text] as? String
        roomId = json[Response.Chat.room] as? Int
        date = NSDateFormatter.serverResponseFormat.dateFromString(json[Response.Chat.created] as! String)
        author = Friend(json: (json[Response.Chat.author])!!)
    }
}
