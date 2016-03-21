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
            
            GMSPlacesClient.sharedClient().autocompleteQuery("mcdonalds", bounds: LocationManager.sharedInstance().rectForSearch, filter: nil, callback: { (results, error) in
                print("Search result: \(results)")
            })
        }
    }
    
    @IBAction func search(sender: AnyObject) {
        let autocompleteController = GMSAutocompleteViewController()
        
        let filter = GMSAutocompleteFilter()
        filter.country = "UA"
        
        autocompleteController.autocompleteBounds = LocationManager.sharedInstance().rectForSearch
        autocompleteController.autocompleteFilter = filter
        autocompleteController.delegate = self
        self.presentViewController(autocompleteController, animated: true, completion: nil)
    }
    
    @IBAction func centerMe(sender: AnyObject) {
        
    }
}

extension MapVC: GMSAutocompleteViewControllerDelegate {
    
    // Handle the user's selection.
    func viewController(viewController: GMSAutocompleteViewController, didAutocompleteWithPlace place: GMSPlace) {
        print("Place name: ", place.name)
        print("Place address: ", place.formattedAddress)
        print("Place attributions: ", place.attributions)
        self.dismissViewControllerAnimated(true, completion: nil)
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