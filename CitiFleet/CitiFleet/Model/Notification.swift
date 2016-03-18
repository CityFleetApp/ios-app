//
//  Notification.swift
//  CitiFleet
//
//  Created by Nick Kibish on 3/17/16.
//  Copyright © 2016 Nick Kibish. All rights reserved.
//

import Foundation

struct Notification {
    var id: Int
    var title: String
    var message: String?
    var date: NSDate
    var unseen: Bool
    
    var dateString: String {
        get {
            let dateformatter = NSDateFormatter()
            dateformatter.dateFormat = DateFormat.Notification.dateFormat
            return dateformatter.stringFromDate(date)
        }
    }
    
    var typeTitle: String {
        get {
            return "TLC Alert"
        }
    }
}