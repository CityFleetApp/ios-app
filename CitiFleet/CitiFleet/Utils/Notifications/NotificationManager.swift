//
//  NotificationManager.swift
//  CitiFleet
//
//  Created by Nick Kibish on 3/17/16.
//  Copyright © 2016 Nick Kibish. All rights reserved.
//

import Foundation

enum NotificationFilterType {
    case All
    case Unread
}

class NotificationManager: NSObject {
    private static let _sharedInstance = NotificationManager()
    static var sharedInstance: NotificationManager {
        return _sharedInstance
    }
    
    var notificationList: [Notification]?
    
    func filter(type: NotificationFilterType) -> [Notification] {
        switch type {
        case .All:
            return notificationList!
        case .Unread:
            return notificationList!.filter { $0.unseen! }
        }
    }
    
    func markAsRead(notification: Notification) {
        let notificationID = notification.id!
        RequestManager.sharedInstance().markNotificationRead(notificationID) { (_, _) in }
    }
    
    func getList(completion: (([Notification]?, NSError?) -> ())) {
        RequestManager.sharedInstance().getNotificationList { [weak self] (notifications, error) -> () in
            if error != nil {
                completion(nil, error)
                return
            }
            
            if let notificotinList = notifications {
                self?.handleNotificationResponse(notificotinList, error: error, completion: completion)
                return
            }
            completion(nil, error)
        }
    }
    
    private func handleNotificationResponse(notificationOjects: [AnyObject]!, error: NSError?, completion: (([Notification]?, NSError?) -> ())) {
        var notifications: [Notification] = []
        let dateFormater = NSDateFormatter()
        dateFormater.dateFormat = DateFormat.Notification.dateFormat
        for notification in notificationOjects {
            notifications.append(Notification(json: notification))
        }
        notificationList = notifications
        completion(notifications, error)
    }
}
