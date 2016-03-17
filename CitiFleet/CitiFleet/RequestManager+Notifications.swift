//
//  RequestManager+Notifications.swift
//  CitiFleet
//
//  Created by Nick Kibish on 3/17/16.
//  Copyright © 2016 Nick Kibish. All rights reserved.
//

import Foundation

extension RequestManager {
    func getNotificationList(completion: ((ArrayResponse, NSError?) -> ())) {
        get(URL.Notifications.notifications, parameters: nil, completion: { (json, error) in
            completion(json?.arrayObject, error)
        })
    }
    
    func getNotifcation(id: Int) {
        
    }
}