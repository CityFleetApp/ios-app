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
    var marker: GMSMarker? {
        get {
            return _marker
        }
        set {
            if _marker == nil {
                _marker = newValue
                _marker?.map = mapView
                return
            }
            _marker?.position = (newValue?.position)!
            _marker?.title = newValue?.title
        }
    }
    
    private var shouldCenterCurrentLocation = true
    private var _marker: GMSMarker?
    
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
        if !shouldCenterCurrentLocation {
            return
        }
        centerMe(nil)
    }
    
    @IBAction func search(sender: AnyObject) {
        let autocompleteController = GMSAutocompleteViewController()
        
        let filter = GMSAutocompleteFilter()
        filter.country = "UA"
        
//        autocompleteController.autocompleteBounds = LocationManager.sharedInstance().rectForSearch
        autocompleteController.autocompleteFilter = filter
        autocompleteController.delegate = self
        self.presentViewController(autocompleteController, animated: true, completion: nil)
    }
    
    @IBAction func centerMe(sender: AnyObject?) {
        shouldCenterCurrentLocation = true
        let coordinate = LocationManager.sharedInstance().currentCoordinates
        let camera = GMSCameraPosition.cameraWithLatitude(coordinate.latitude, longitude: coordinate.longitude, zoom: 16)
        mapView.animateToCameraPosition(camera)
    }
}

extension MapVC: GMSAutocompleteViewControllerDelegate {
    
    // Handle the user's selection.
    func viewController(viewController: GMSAutocompleteViewController, didAutocompleteWithPlace place: GMSPlace) {
        self.dismissViewControllerAnimated(true) {
            self.shouldCenterCurrentLocation = false
            let position = place.coordinate
            let marker = GMSMarker(position: position)
            marker.title = place.name
            self.marker = marker
            
            self.mapView.animateToLocation(position)
        }
    }
    
    func viewController(viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: NSError) {
        // TODO: handle the error.
        print("Error: ", error.description)
    }
    
    // User canceled the operation.
    func wasCancelled(viewController: GMSAutocompleteViewController) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    // Turn the network activity indicator on and off again.
    func didRequestAutocompletePredictions(viewController: GMSAutocompleteViewController) {
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
    }
    
    func didUpdateAutocompletePredictions(viewController: GMSAutocompleteViewController) {
        UIApplication.sharedApplication().networkActivityIndicatorVisible = false
    }
    
}