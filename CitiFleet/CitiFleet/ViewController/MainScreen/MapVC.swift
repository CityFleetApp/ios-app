//
//  MapVC.swift
//  CitiFleet
//
//  Created by Nick Kibish on 2/29/16.
//  Copyright © 2016 Nick Kibish. All rights reserved.
//

import UIKit
import GoogleMaps

class MapVC: UIViewController {
    @IBOutlet var searchBtn: UIButton!
    @IBOutlet var centerMeBtn: UIButton!
    @IBOutlet var directionBtn: UIButton!
    @IBOutlet var mapView: GMSMapView!
    let updatedLocationSel = "updatedLocation:"
    
    private var shouldUpdateLocation = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBtn.setDefaultShadow()
        centerMeBtn.setDefaultShadow()
        directionBtn.setDefaultShadow()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector(updatedLocationSel), name: LocationManager.UpdateLocationNotification, object: nil)
    }
    
    override func viewWillAppear(animated: Bool) {
        if let _ = User.currentUser() {
            LocationManager.sharedInstance().startUpdatingLocation()
        }
    }
    
    func updatedLocation(locationNotif: NSNotification) {
        if let location = locationNotif.userInfo!["location"] as? CLLocation {
            let coordinate = location.coordinate
            let camera = GMSCameraPosition.cameraWithLatitude(coordinate.latitude, longitude: coordinate.longitude, zoom: 16)
            mapView.camera = camera
        }
    }
    
    @IBAction func centerMe(sender: AnyObject) {
        
    }
    
}
