//
//  Report.swift
//  CitiFleet
//
//  Created by Nick Kibish on 2/29/16.
//  Copyright © 2016 Nick Kibish. All rights reserved.
//

import UIKit
import GoogleMaps

class Report: NSObject {
    private let iconNames = [
        "police-ic",
        "tlc-ic",
        "accident-ic",
        "trafic---ic",
        "hazard-ic",
        "road-closure-ic"
    ]
    
    private let iconMapNames = [
        "Police",
        "TLC",
        "Accident",
        "Traffic",
        "Hazard",
        "Road-Closure"
    ]
    
    private var _marker: ReportMarker?
    private var mapIcon: UIImage? {
        let iconName = iconMapNames[type.rawValue - 1]
        return UIImage(named: iconName)
    }
    
    var latitude: CLLocationDegrees = 0.0
    var longitude: CLLocationDegrees = 0.0
    var type: ReportType = .Police
    var icon: UIImage? {
        let iconName = iconNames[type.rawValue - 1]
        return UIImage(named: iconName)
    }
    
    var marker: ReportMarker {
        if let marker = _marker {
            return marker
        }
        _marker = ReportMarker(position: CLLocationCoordinate2D(latitude: latitude, longitude: longitude))
        _marker?.icon = mapIcon
        _marker?.report = self 
        return _marker!
    }
    
    override var hashValue: Int {
        get {
            return "\(self.latitude) \(self.longitude) \(self.type.rawValue)".hashValue
        }
    }
    
    init(lat: CLLocationDegrees, lon: CLLocationDegrees, type: ReportType) {
        self.latitude = lat
        self.longitude = lon
        self.type = type
        super.init()
    }
    
    
    func post(complation: ((error: NSError?) -> ())) {
        RequestManager.sharedInstance().postReport(latitude, long: longitude, type: type) { (response, error) -> () in
            if let error = error {
                complation(error: error)
                return
            }
            complation(error: nil)
        }
    }
}

//MARK: Override Operatiors
func ==(left: Report, right: Report) -> Bool {
    return left.latitude == right.latitude && left.longitude == right.longitude && left.type == right.type
}

class ReportMarker: GMSMarker {
    weak var report: Report?
}