//
//  RequestManager+Reports.swift
//  CitiFleet
//
//  Created by Nick Kibish on 2/29/16.
//  Copyright © 2016 Nick Kibish. All rights reserved.
//

/*
Extension for Reports
*/

import Foundation
import Alamofire
import Swift
import SwiftyJSON
import ReachabilitySwift

enum ReportType: Int {
    case Police = 1
    case TLC = 2
    case Accident = 3
    case Trafic = 4
    case Hazard = 5
    case RoadClosure = 6
    
    func reportName() -> String {
        switch self {
        case .Police:
            return "Police"
        case .TLC:
            return "TLC"
        case .Accident:
            return "Accident"
        case .Trafic:
            return "Traffic Jam"
        case .Hazard:
            return "Hazard"
        case .RoadClosure:
            return "Road Closure"
        }
    }
}

extension RequestManager {
    func postReport(lat: CLLocationDegrees, long: CLLocationDegrees, type: ReportType, completion:(([String: AnyObject]?, NSError?) -> ())) {
        let params = [
            Params.Report.reportType: String(type.rawValue),
            Params.Report.latitude: String(lat),
            Params.Report.longitude: String(long)
        ]
        post(URL.Reports.Nearby, parameters: params) { (json, error) in
            completion(json?.dictionaryObject, error)
        }
    }
}
