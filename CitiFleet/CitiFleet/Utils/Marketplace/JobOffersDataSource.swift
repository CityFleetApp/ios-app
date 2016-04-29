//
//  JobOffersDataSource.swift
//  CitiFleet
//
//  Created by Nick Kibish on 4/4/16.
//  Copyright © 2016 Nick Kibish. All rights reserved.
//

import Foundation

class JobOffer: NSObject {
    enum JobOfferStatus: String {
        case Available = "Available"
        case Covered = "Covered"
        case Completed = "Completed"
    }
    
    var id: Int?
    var pickupDatetime: NSDate?
    var pickupAddress: String?
    var destination: String?
    var fare: String?
    var gratuity: String?
    var vehicleType: String?
    var suite: Bool?
    var jobType: String?
    var instructions: String?
    var status: JobOfferStatus?
    var created: NSDate?
    var jobTitle: String?
    var awarded: Bool?
    var driverName: String?
    
    override init() {
        
    }
    
    init(json: AnyObject) {
        typealias Param = Response.Marketplace.JobOffers
        id = json[Param.id] as? Int
        pickupDatetime = NSDateFormatter.serverResponseFormat.dateFromString(json[Param.pickupDatetime] as! String)
        pickupAddress = json[Param.pickupAddress] as? String
        destination = json[Param.destination] as? String
        fare = json[Param.fare] as? String
        gratuity = json[Param.gratuity] as? String
        vehicleType = json[Param.vehicleType] as? String
        suite = json[Param.suite] as? Bool
        jobType = json[Param.jobType] as? String
        instructions = json[Param.instructions] as? String
        if let statusStr = json[Param.status] as? String {
            status = JobOfferStatus(rawValue: statusStr)
        }
        
        jobTitle = json[Param.title] as? String
        awarded = json[Param.awarded] as? Bool
        
        created = NSDateFormatter.serverResponseFormat.dateFromString(json[Param.created] as! String)
    }
}

class JobOffersDataSource: NSObject {
    typealias Param = Response.Marketplace.JobOffers
    var items: [JobOffer] = []
    
    var count: Int?
    var nextPage: String?
    var availableCount: Int?
    
    var shouldLoadNext: Bool {
        return nextPage != nil
    }
    
    func loadAll(completion: ((NSError?) -> ())) {
        let url = URL.Marketplace.JobOffers
        loadData(url, completion: completion)
    }
    
    func loadAvailable(completion: ((NSError?) -> ())) {
        let url = "\(URL.Marketplace.JobOffers)?status=1"
        loadData(url, completion: completion)
    }
    
    func loadData(url: String, completion: ((NSError?) -> ())) {
        RequestManager.sharedInstance().get(URL.Marketplace.JobOffers, parameters: nil) { [weak self] (json, error) in
            self?.items.removeAll()
            let response = json?.dictionaryObject
            self?.parseResponse(response, error: error, completion: completion)
        }
    }
    
    func loadNext(completion: ((NSError?) -> ())) {
        if let next = nextPage {
            RequestManager.sharedInstance().makeRequestWithFullURL(.GET, baseURL: next, parameters: nil, completion: { [weak self] (json, error) in
                let response = json?.dictionaryObject
                self?.parseResponse(response, error: error, completion: completion)
            })
        }
    }
}

//MARK: - Private Methods
extension JobOffersDataSource {
    func parseResponse(response: [String: AnyObject]?, error: NSError?, completion: ((NSError?) -> ())) {
        if error != nil || response == nil {
            completion(error)
            return
        }
        availableCount = response![Response.Marketplace.available] as? Int 
        nextPage = response![Response.next] as? String
        count = response![Response.count] as? Int
        let offers = response![Response.results] as! [AnyObject]
        for obj in offers {
            let item = JobOffer(json: obj)
            items.append(item)
        }
        completion(nil)
    }
}