//
//  FriendsListDataSource.swift
//  CitiFleet
//
//  Created by Nick Kibish on 4/13/16.
//  Copyright © 2016 Nick Kibish. All rights reserved.
//

import UIKit

class FriendsListDataSource: NSObject {
    private var _friends: [Friend] = []
    private var filteredFriends: [Friend] = []
    private var searchText: String?
    
    var loadDataCompleted: (() -> ())!
    
    var friends: [Friend] {
        if searchText == nil || searchText == "" {
            return _friends
        } else {
            return filteredFriends
        }
    }
    
    func loadFriends() {
        _friends.removeAll()
        RequestManager.sharedInstance().get(URL.Chat.Friends, parameters: nil) { [weak self] (json, error) in
            if let friends = json?.arrayObject {
                for obj in friends {
                    let friend = Friend(json: obj)
                    self?._friends.append(friend)
                }
            }
            self?.loadDataCompleted()
        }
    }
    
    func searchFriends(searchText: String?) {
        self.searchText = searchText
        if let text = searchText {
            filteredFriends = _friends.filter({ return $0.fullName?.lowercaseString.rangeOfString(text.lowercaseString) != nil })
        }
        loadDataCompleted()
    }
}