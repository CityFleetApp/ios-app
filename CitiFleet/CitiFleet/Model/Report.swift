//
//  Report.swift
//  CitiFleet
//
//  Created by Nick Kibish on 2/29/16.
//  Copyright © 2016 Nick Kibish. All rights reserved.
//

import UIKit

class Report: NSObject {
    var latitude: CGFloat = 0.0
    var longitude: CGFloat = 0.0
    var type: ReportType = .Police
    
    init(lat: CGFloat, lon: CGFloat, type: ReportType) {
        self.latitude = lat
        self.longitude = lon
        self.type = type
        super.init()
    }
    
    func post(complation: ((error: NSError) -> ())) {
        RequestManager.sharedInstance().postReport(latitude, long: longitude, type: type) { (response, error) -> () in
            if let error = error {
                complation(error: error)
                return
            }
            
        }
    }
}
