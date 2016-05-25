//
//  NSDateFormater+Ext.swift
//  CitiFleet
//
//  Created by Nick Kibish on 3/23/16.
//  Copyright © 2016 Nick Kibish. All rights reserved.
//

import Foundation

extension NSDateFormatter {
    class func standordFormater() -> NSDateFormatter {
        let formater = NSDateFormatter()
        formater.dateFormat = "MM / dd / ayyyy"
        return formater
    }
    
    class func standordTimeFormater() -> NSDateFormatter {
        let formater = NSDateFormatter()
        formater.dateFormat = "HH:mm"
        return formater
    }
    
    class var serverResponseFormat: NSDateFormatter {
        get {let formater = NSDateFormatter()
            formater.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
            return formater
        }
    }
    
    convenience init(dateFormat: String) {
        self.init()
        self.dateFormat = dateFormat
    }
}