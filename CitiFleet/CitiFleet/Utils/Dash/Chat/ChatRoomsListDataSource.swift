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
    var shouldLoadNext: Bool {
        return nextPageUrl != nil
    }
    
    func loadRooms() {
        self.rooms.removeAll()
        RequestManager.sharedInstance().get(URL.Chat.Rooms, parameters: nil) { [weak self] (json, error) in
            if let roomResponse = json?.dictionaryObject {
                self?.nextPageUrl = roomResponse[Response.next] as? String
                
                if let rooms = roomResponse[Response.results] as? [AnyObject] {
                    for room in rooms {
                        let room = ChatRoom(json: room)
                        self?.rooms.append(room)
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
        
        RequestManager.sharedInstance().makeRequestWithFullURL(.GET, baseURL: nextPageUrl!, parameters: nil) { [weak self] (json, error) in
            if let roomResponse = json?.dictionaryObject {
                if let error = error {
                    completion(nil, error)
                    return
                }
                self?.nextPageUrl = roomResponse[Response.next] as? String
                
                if let rooms = roomResponse[Response.results] as? [AnyObject] {
                    var responseRooms: [ChatRoom] = []
                    for room in rooms {
                        let room = ChatRoom(json: room)
                        responseRooms.append(room)
                        self?.rooms.append(room)
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
