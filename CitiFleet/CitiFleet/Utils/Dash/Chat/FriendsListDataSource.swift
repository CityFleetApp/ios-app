//
//  FriendsListDataSource.swift
//  CitiFleet
//
//  Created by Nick Kibish on 4/13/16.
//  Copyright © 2016 Nick Kibish. All rights reserved.
//

import UIKit

class FriendsListDataSource: NSObject {
    var friends: [Friend] = []
    var loadDataCompleted: (() -> ())!
    
    func loadFriends() {
        friends.removeAll()
        RequestManager.sharedInstance().get(URL.Chat.Friends, parameters: nil) { [weak self] (json, error) in
            if let friends = json?.arrayObject {
                for obj in friends {
                    let friend = Friend(json: obj)
                    self?.friends.append(friend)
                }
            }
            self?.loadDataCompleted()
        }
    }
}