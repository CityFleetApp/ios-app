//
//  NotificationManager.swift
//  CitiFleet
//
//  Created by Nick Kibish on 3/17/16.
//  Copyright © 2016 Nick Kibish. All rights reserved.
//

import Foundation

class NotificationManager: NSObject {
    private static let _sharedInstance = NotificationManager()
    static var sharedInstance: NotificationManager {
        return _sharedInstance
    }
    
    func getList(completion: (([Notification]?, NSError?) -> ())) {
        RequestManager.sharedInstance().getNotificationList { (notifications, error) -> () in
            if error != nil {
                completion(nil, error)
                return
            }
            
            if let notificotinList = notifications {
                self.handleNotificationResponse(notificotinList, error: error, completion: completion)
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
            let id = notification[Response.Notifications.id] as! Int
            let title = notification[Response.Notifications.title] as! String
            let message = notification[Response.Notifications.message] as! String
            let unseen = notification[Response.Notifications.unseen] as! Bool
            let dateStr = notification[Response.Notifications.date] as!  String
            let date = dateFormater.dateFromString(dateStr)
            
            notifications.append(Notification(id: id, title: title, message: message, date: date!, unseen: unseen))
        }
        
        completion(notifications, error)
    }
}
