//
//  Notification.swift
//  CitiFleet
//
//  Created by Nick Kibish on 3/17/16.
//  Copyright © 2016 Nick Kibish. All rights reserved.
//

import Foundation

enum NotificationType: String {
    case JobOffer = "offer_created"
    case Other = "other"
}

class Notification: NSObject {
    var id: Int?
    var title: String?
    var message: String?
    var date: NSDate?
    var unseen: Bool?
    var notificationType: NotificationType?
    var refID: Int?
    
    var dateString: String {
        get {
            return NSDateFormatter.standordFormater().stringFromDate(date!)
        }
    }
    
    var typeTitle: String {
        get {
            switch notificationType! {
            case .JobOffer:
                return "TLC Alert"
            default:
                return "TLC Alert"
            }
        }
    }
    
    init(json: AnyObject) {
        super.init()
        id = json[Response.Notifications.id] as? Int
        title = json[Response.Notifications.title] as? String
        message = json[Response.Notifications.message] as? String
        date = NSDateFormatter(dateFormat: DateFormat.Notification.dateFormat).dateFromString(json[Response.Notifications.date] as!  String)
        unseen = json[Response.Notifications.unseen] as? Bool
        notificationType = NotificationType(rawValue: json[Response.Notifications.refType] as! String)
        refID = json[Response.Notifications.refID] as? Int
    }
}