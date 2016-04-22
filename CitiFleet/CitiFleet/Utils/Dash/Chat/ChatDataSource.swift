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
    
    var nextPageUrl: String?
    var offset: Int = 0
    var shouldLoadNext: Bool {
        return nextPageUrl != nil
    }
    
    init(room: ChatRoom) {
        self.room = room
        super.init()
    }
    
    func loadData() {
        let url = "\(URL.Chat.Rooms)\(room.id!)\(URL.Chat.Messages)"
        nextPageUrl = nil
        RequestManager.sharedInstance().get(url, parameters: nil) { [weak self] (json, error) in
            if error != nil {
                return
            }
            print("\(json?.dictionaryObject![Response.count] as? Int)")
            
            self?.nextPageUrl = json?.dictionaryObject![Response.next] as? String
            
            if let responseArray = json?.dictionaryObject![Response.results] as? [AnyObject] {
                for obj in responseArray {
                    let message = Message(json: obj)
                    self?.messages.append(message)
                    self?.offset += 1
                }
//                if let elements = self?.messages {
//                    self?.messages = elements.reverse()
//                }
            }
            self?.reloadData()
        }
    }
    
    func loadNew(completion:(([Message]?) -> ())) {
        if nextPageUrl == nil {
            return
        }
        let url = "\(URL.Chat.Rooms)\(room.id!)\(URL.Chat.Messages)?offset=\(offset)"
        nextPageUrl = nil
        RequestManager.sharedInstance().get(url, parameters: nil) { [weak self] (json, error) in
            if error != nil {
                completion(nil)
                return
            }
            self?.nextPageUrl = json?.dictionaryObject![Response.next] as? String
            if let responseArray = json?.dictionaryObject![Response.results] as? [AnyObject] {
                var messagesArray: [Message] = []
                for obj in responseArray {
                    let message = Message(json: obj)
                    self?.messages.append(message)
                    messagesArray.append(message)
                    self?.offset += 1
                }
                completion(messagesArray)
            }
            completion(nil)
        }
    }
}
