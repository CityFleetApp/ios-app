//
//  RequestManager+Chat.swift
//  CitiFleet
//
//  Created by Nick Kibish on 4/19/16.
//  Copyright © 2016 Nick Kibish. All rights reserved.
//

import Foundation

extension RequestManager {
    func postRoom(participants:[User], completion: ((ChatRoom?, NSError?) -> ())) {
        let ids = participants.map({ return $0.id! })
        let params = [
            Params.Chat.members: ids,
            Params.Chat.name: participants.map({ $0.fullName! }).joinWithSeparator(", ")
        ]
        
        post(URL.Chat.Rooms, parameters: params as? [String : AnyObject]) { (json, error) in
            if let roomObj = json?.dictionaryObject {
                let room = ChatRoom(json: roomObj)
                completion(room, nil)
                return
            }
            completion(nil, error)
        }
    }
}