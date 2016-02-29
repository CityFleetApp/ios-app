//
//  LocationManager.swift
//  CitiFleet
//
//  Created by Nick Kibish on 2/29/16.
//  Copyright © 2016 Nick Kibish. All rights reserved.
//

import UIKit

class LocationManager: NSObject, CLLocationManagerDelegate {
    private static let shared = LocationManager()
    private let locationManager = CLLocationManager()
    var currentCoordinates: CLLocationCoordinate2D?
    
    override init() {
        super.init()
        locationManager.requestAlwaysAuthorization()
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let locValue = manager.location?.coordinate {
            currentCoordinates = locValue
        }
    }
}
