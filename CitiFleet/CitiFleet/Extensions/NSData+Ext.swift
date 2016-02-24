//
//  NSData+Ext.swift
//  CitiFleet
//
//  Created by Nick Kibish on 2/24/16.
//  Copyright © 2016 Nick Kibish. All rights reserved.
//

import Foundation

typealias JSONObject = Dictionary<String, AnyObject>

extension NSData {
    func json() -> JSONObject? {
        
        return nil
    }
}

extension NSError {
    func serverMessage() -> String? {
        return self.userInfo[Params.Response.serverError] as? String
    }
}