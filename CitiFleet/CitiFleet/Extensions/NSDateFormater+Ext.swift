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
        formater.dateFormat = "yyyy-MM-dd"
        return formater
    }
}