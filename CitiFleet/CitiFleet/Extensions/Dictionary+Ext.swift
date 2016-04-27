//
//  Dictionary+Ext.swift
//  CitiFleet
//
//  Created by Nick Kibish on 4/27/16.
//  Copyright © 2016 Nick Kibish. All rights reserved.
//

import Foundation

extension Dictionary {
    func mapPairs<OutKey: Hashable, OutValue>(@noescape transform: Element throws -> (OutKey, OutValue)) rethrows -> [OutKey: OutValue] {
        let tuples = try map(transform)
        var newDict: [OutKey: OutValue] = [:]
        for t in tuples {
            newDict[t.0] = t.1
        }
        return newDict
    }
    
    func filterPairs(@noescape includeElement: Element throws -> Bool) rethrows -> [Key: Value] {
        let tuples = try filter(includeElement)
        var newDict: [Key: Value] = [:]
        for t in tuples {
            newDict[t.0] = t.1
        }
        return newDict
    }
}