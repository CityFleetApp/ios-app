//
//  Report.swift
//  CitiFleet
//
//  Created by Nick Kibish on 2/29/16.
//  Copyright © 2016 Nick Kibish. All rights reserved.
//

import UIKit
import GoogleMaps

class Report: Equatable, Hashable {
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
    
    var id: Int!
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
    
    init(lat: CLLocationDegrees, lon: CLLocationDegrees, type: ReportType) {
        self.latitude = lat
        self.longitude = lon
        self.type = type
//        super.init()
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

extension Report {
    var hashValue: Int {
        get {
            return (id.hashValue << 15).hashValue
        }
    }
}

//MARK: Override Operatiors
func ==(left: Report, right: Report) -> Bool {
    return left.id == right.id //left.latitude == right.latitude && left.longitude == right.longitude && left.type == right.type
}

class ReportMarker: GMSMarker {
    weak var report: Report?
}

class FriendMarker: GMSMarker {
    weak var friend: Friend?
}