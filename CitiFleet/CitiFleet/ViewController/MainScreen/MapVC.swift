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
        mapView.delegate = self
        
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
        filter.country = "US"
        
        autocompleteController.autocompleteBounds = LocationManager.sharedInstance().rectForSearch
        autocompleteController.autocompleteFilter = filter
        autocompleteController.delegate = self
        
        self.presentViewController(autocompleteController, animated: true) {
            let suearhBar = self.findSearchBar(autocompleteController.view)
            suearhBar?.setTextColor(UIColor.whiteColor())
        }
    }
    
    func findSearchBar(view: UIView) -> UISearchBar? {
        for subview in view.subviews {
            if subview.isKindOfClass(UISearchBar) {
                return subview as? UISearchBar
            } else {
                if let searchFromSubView = findSearchBar(subview) {
                    return searchFromSubView
                }
            }
        }
        return nil
    }
    
    @IBAction func centerMe(sender: AnyObject?) {
        shouldCenterCurrentLocation = true
        let coordinate = LocationManager.sharedInstance().currentCoordinates
        let camera = GMSCameraPosition.cameraWithLatitude(coordinate.latitude, longitude: coordinate.longitude, zoom: 16)
        mapView.animateToCameraPosition(camera)
    }
    
    @IBAction func direction(sender: AnyObject) {
        if marker == nil {
            let alert = UIAlertController(title: Titles.MainScreen.noMarkersTitle, message: Titles.MainScreen.noMarkersMsg, preferredStyle: .Alert)
            let cancelAction = UIAlertAction(title: Titles.cancel, style: .Cancel, handler: nil)
            alert.addAction(cancelAction)
            presentViewController(alert, animated: true, completion: nil)
            return
        }
        if (UIApplication.sharedApplication().canOpenURL(NSURL(string:"comgooglemaps://")!)) {
            let currentLocation = LocationManager.sharedInstance().currentCoordinates
            let url = "comgooglemaps://?saddr=\(currentLocation.latitude),\(currentLocation.longitude)&daddr=\(marker!.position.latitude),\(marker!.position.longitude)"
            
            UIApplication.sharedApplication().openURL(NSURL(string:
                url)!)
        } else {
            print("Can't use comgooglemaps://");
        }
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

extension MapVC: GMSMapViewDelegate {
    func mapView(mapView: GMSMapView, willMove gesture: Bool) {
        shouldCenterCurrentLocation = false
    }
}