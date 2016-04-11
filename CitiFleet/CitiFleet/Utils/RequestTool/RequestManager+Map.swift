//
//  RequestManager+Map.swift
//  CitiFleet
//
//  Created by Nick Kibish on 4/11/16.
//  Copyright © 2016 Nick Kibish. All rights reserved.
//

import Foundation

extension RequestManager {
    func getNearbyReports(completion:((ArrayResponse, NSError?) -> ())) {
        let latitude = LocationManager.sharedInstance().currentCoordinates.latitude
        let longitude = LocationManager.sharedInstance().currentCoordinates.longitude
        
        let urlString = URL.Reports.Nearby + "?\(Params.Report.latitude)=\(latitude)&\(Params.Report.longitude)=\(longitude)"
        
        makeSilentRequest(.GET, baseURL: urlString, parameters: nil) { (json, error) in
            completion(json?.arrayObject, error)
        }
    }
}