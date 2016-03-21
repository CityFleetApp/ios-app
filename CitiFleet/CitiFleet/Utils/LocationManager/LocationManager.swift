//
//  LocationManager.swift
//  CitiFleet
//
//  Created by Nick Kibish on 2/29/16.
//  Copyright © 2016 Nick Kibish. All rights reserved.
//

import UIKit
import CoreLocation
import GoogleMaps

class LocationManager: NSObject, CLLocationManagerDelegate {
    static let UpdateLocationNotification = "UpdateLocationNotification"
    var currentCoordinates: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 0.0, longitude: 0.0)
    
    private static let shared = LocationManager()
    private let locationManager = CLLocationManager()
    
    var rectForSearch: GMSCoordinateBounds {
        get {
            let northEast = CLLocationCoordinate2D(latitude: currentCoordinates.latitude + 1, longitude: currentCoordinates.longitude + 1)
            let southWest = CLLocationCoordinate2D(latitude: currentCoordinates.latitude - 1, longitude: currentCoordinates.longitude - 1)
            
            return GMSCoordinateBounds(coordinate: northEast, coordinate: southWest)
        }
    }
    
    class func sharedInstance() -> LocationManager {
        return LocationManager.shared
    }
    
    func startUpdatingLocation() {
        locationManager.startUpdatingLocation()
    }
    
    override init() {
        super.init()
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.requestWhenInUseAuthorization()
        }
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let locValue = manager.location?.coordinate {
            currentCoordinates = locValue
            let location = manager.location
            NSNotificationCenter.defaultCenter().postNotificationName(LocationManager.UpdateLocationNotification, object: nil, userInfo: ["location":location!]) //postNotificationName(LocationManager.UpdateLocationNotification, object: location)
        }
    }
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        print("Error: \(error)")
    }
}
