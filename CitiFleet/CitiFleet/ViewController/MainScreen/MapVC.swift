//
//  MapVC.swift
//  CitiFleet
//
//  Created by Nick Kibish on 2/29/16.
//  Copyright © 2016 Nick Kibish. All rights reserved.
//

import UIKit
import GoogleMaps
import Darwin

protocol InfoViewDelegate {
    func showFrinedInfo(friend: Friend?)
    func showReportInfo(report: Report?)
    func hideViewes()
}

protocol MapViewDelegate {
    func showReport(coordinate: CLLocationCoordinate2D?)
}

class MapVC: UIViewController {
    private let RANDOM_RADIUS_FOR_MARKER = 10;
    private let METERS_IN_DEGREE: Double = 111000.0;
    
    private var shouldCenterCurrentLocation = true
    private var _marker: GMSMarker?
    private var reports: Set<Report> = []
    private var friends: Set<Friend> = []
    private var selectedFriend: Friend?
    
    let updatedLocationSel = "updatedLocation:"
    
    @IBOutlet var searchBtn: UIButton!
    @IBOutlet var centerMeBtn: UIButton!
    @IBOutlet var directionBtn: UIButton!
    @IBOutlet var mapView: GMSMapView!
    
    var infoDelegate: InfoViewDelegate?
    var shouldSendLocationRequest = false
    var delegate: MapViewDelegate?
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBtn.setDefaultShadow()
        centerMeBtn.setDefaultShadow()
        directionBtn.setDefaultShadow()
        mapView.delegate = self
        mapView.myLocationEnabled = true
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(self.updatedLocation(_:)), name: LocationManager.UpdateLocationNotification, object: nil)
    }
    
    override func viewWillAppear(animated: Bool) {
        shouldSendLocationRequest = true
        if let _ = User.currentUser() {
            LocationManager.sharedInstance().startUpdatingLocation()
        }
    }
    
    override func viewWillDisappear(animated: Bool) {
        shouldSendLocationRequest = false
    }
    
    override func subscribeNotifications() {
        
    }
    
    override func unsubscribe() {
        
    }
    
    func updatedLocation(locationNotif: NSNotification) {
        if User.currentUser()?.token == nil || shouldSendLocationRequest == false {
            return
        }
        loadReports()
        loadFriends()
        if !shouldCenterCurrentLocation {
            return
        }
        centerMe(nil)
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
}

//MARK: - Private Methods
extension MapVC {
    private func loadReports() {
        RequestManager.sharedInstance().getNearbyReports { [weak self] (response, error) in
            if let response = response {
                var newReports: Set<Report> = Set()
                for obj in response {
                    let lat = obj[Params.Report.latitude] as! CLLocationDegrees
                    let lon = obj[Params.Report.longitude] as! CLLocationDegrees
                    let id = obj[Params.id] as! Int

                    let type = ReportType(rawValue: obj[Params.Report.reportType] as! Int)
                    let report = Report(lat: lat, lon: lon, type: type!)
                    report.id = id
                    newReports.insert(report)
                }
                let shouldBeRemover = self?.reports.subtract(newReports)
                dispatch_async(dispatch_get_main_queue(), { 
                    self?.removeReports(shouldBeRemover)
                })
                
                self?.reports = newReports.union((self?.reports.intersect(newReports))!)
                dispatch_async(dispatch_get_main_queue(), { 
                    self?.updateReports()
                })
            }
        }
    }
    
    private func loadFriends() {
        RequestManager.sharedInstance().getNearbyFriends { [weak self] (response, error) in
            if let response = response {
                var newFriends: Set<Friend> = []
                for obj in response {
                    let user = Friend(json: obj)
                    newFriends.insert(user)
                }
                let shouldBeRemove = self?.friends.subtract(newFriends)
                dispatch_async(dispatch_get_main_queue(), { [weak self] in
                    self?.removeFriends(shouldBeRemove)
                })
//                newFriends!.union(self?.friends.intersect(newFriends))
                
                self?.friends = newFriends.union((self?.friends.intersect(newFriends))!)
                
                dispatch_async(dispatch_get_main_queue(), { [weak self] in
                    self?.updateFrinds()
                })
            }
        }
    }
    
    private func updateReports() {
        var count = 0
        for report in reports {
            if report.marker.map == nil {
                count += 1
                if containsSameCoordinate(report.marker.position) {
                    report.marker.position = getRandomCoordinate(report.marker.position)
                }
                report.marker.map = mapView
            }
        }
        print("Count: \(count)")
        
    }
    
    private func updateFrinds() {
        for friend in friends {
            if friend.marker.map == nil {
                if containsSameCoordinate(friend.marker.position) {
                    friend.marker.position = getRandomCoordinate(friend.marker.position)
                }
                friend.marker.map = mapView
                if friend == selectedFriend {
                    friend.updateMarker(true)
                } 
            }
        }
    }
    
    private func getRandomCoordinate(srcCoord: CLLocationCoordinate2D) -> CLLocationCoordinate2D {
        let radiusInDegrees = Double(RANDOM_RADIUS_FOR_MARKER) / METERS_IN_DEGREE
        let u = Double(arc4random()) / Double(uint.max)
        let v = Double(arc4random()) / Double(uint.max)
        let w = radiusInDegrees * sqrt(u)
        let t = 2 * M_PI * v
        let x = w * cos(t)
        let y = w * sin(t)
        
        let newX = x / cos(srcCoord.latitude)
        let foundLong = newX + srcCoord.longitude
        let foundLat = y + srcCoord.latitude
        
        return CLLocationCoordinate2D(latitude: foundLat, longitude: foundLong)
    }
    
    private func containsSameCoordinate(srcCoord: CLLocationCoordinate2D) -> Bool {
        let set: Set<CLLocationCoordinate2D> = Set(friends.map({ return $0.marker.position })).union(reports.map({ return $0.marker.position }))
        return set.contains(srcCoord)
    }
    
    private func removeReports(reportsToDelete: Set<Report>?) {
        if reportsToDelete == nil {
            return
        }
        for report in reportsToDelete! {
            report.marker.map = nil
        }
    }
    
    private func removeFriends(friendsToDelete: Set<Friend>?) {
        if friendsToDelete == nil {
            return
        }
        var count = 0
        for friend in friendsToDelete! {
            count += 1
            friend.marker.map = nil
        }
        print("count deleted: \(count)")
        
    }
}

//MARK: - Actions
extension MapVC {
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
            print("Can't use comgooglemaps://")
        }
    }
}

//MARK: - Map Autocompletion Delegate
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
    
    func mapView(mapView: GMSMapView, didTapAtCoordinate coordinate: CLLocationCoordinate2D) {
        infoDelegate?.hideViewes()
        selectedFriend?.updateMarker(false)
        selectedFriend = nil
    }
    
    func mapView(mapView: GMSMapView, didTapMarker marker: GMSMarker) -> Bool {
        if let marker = marker as? ReportMarker {
            infoDelegate?.showReportInfo(marker.report)
        } else if let marker = marker as? FriendMarker {
            if marker.friend == selectedFriend {
                return true
            }
            selectedFriend?.updateMarker(false)
            let friend = marker.friend
            friend?.updateMarker(true)
            selectedFriend = friend
            infoDelegate?.showFrinedInfo(marker.friend)
        }
        return true
    }
}

//MARK: - Map View Delegate
extension MapVC: GMSMapViewDelegate {
    func mapView(mapView: GMSMapView, willMove gesture: Bool) {
        shouldCenterCurrentLocation = false
    }
    
    func mapView(mapView: GMSMapView, didLongPressAtCoordinate coordinate: CLLocationCoordinate2D) {
        delegate?.showReport(coordinate)
    }
}

//MARK: - CLLocation Extension
extension CLLocationCoordinate2D: Hashable, Equatable {
    public var hashValue: Int {
        return "lat=\(latitude)long=\(longitude)".hash
    }
}

public func ==(left: CLLocationCoordinate2D, right: CLLocationCoordinate2D) -> Bool {
    return left.latitude == right.latitude && left.longitude == right.longitude
}