//
//  ChatRoomsListDataSource.swift
//  CitiFleet
//
//  Created by Nick Kibish on 4/13/16.
//  Copyright © 2016 Nick Kibish. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire

class ChatRoomsListDataSource: NSObject {
    var rooms: [ChatRoom] = []
    var reloadData: (() -> ())!
    
    var nextPageUrl: String?
    var offset: Int = 0
    var searchText: String?
    var shouldLoadNext: Bool {
        return nextPageUrl != nil
    }
    
    func loadRooms() {
        nextPageUrl = nil
        self.rooms.removeAll()
        
        var url = URL.Chat.Rooms
        if let search = searchText {
            url = "\(URL.Chat.Rooms)?search=\(search)"
        }
        offset = 0
        RequestManager.sharedInstance().get(url, parameters: nil) { [weak self] (json, error) in
            if let roomResponse = json?.dictionaryObject {
                self?.nextPageUrl = roomResponse[Response.next] as? String
                
                if let rooms = roomResponse[Response.results] as? [AnyObject] {
                    for room in rooms {
                        let room = ChatRoom(json: room)
                        self?.rooms.append(room)
                        self?.offset += 1
                    }
                }
            }
            self?.reloadData()
        }
    }
    
    func loadNext(completion: (([ChatRoom]?, NSError?) -> ())) {
        if nextPageUrl == nil {
            return
        }
        
        nextPageUrl = nil
        
        var url = "\(URL.Chat.Rooms)?offset=\(offset)"
        if let search = searchText {
            url = "\(URL.Chat.Rooms)?search=\(search)&offset=\(offset)"
        }
        
        RequestManager.sharedInstance().makeRequest(.GET, baseURL: url, parameters: nil) { [weak self] (json, error) in
            if let error = error {
                completion(nil, error)
                return
            }
            if let roomResponse = json?.dictionaryObject {
                self?.nextPageUrl = roomResponse[Response.next] as? String
                
                if let rooms = roomResponse[Response.results] as? [AnyObject] {
                    var responseRooms: [ChatRoom] = []
                    for room in rooms {
                        let room = ChatRoom(json: room)
                        responseRooms.append(room)
                        self?.rooms.append(room)
                        self?.offset += 1
                    }
                    dispatch_async(dispatch_get_main_queue(), { 
                        completion(responseRooms, nil)
                    })
                    return
                }
                completion(nil, error)
            }
        }
    }
}
