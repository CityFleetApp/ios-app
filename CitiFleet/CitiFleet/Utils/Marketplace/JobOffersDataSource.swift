//
//  JobOffersDataSource.swift
//  CitiFleet
//
//  Created by Nick Kibish on 4/4/16.
//  Copyright © 2016 Nick Kibish. All rights reserved.
//

import Foundation

struct JobOffer {
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
    var status: String?
}

class JobOffersDataSource: NSObject {
    typealias Param = Response.Marketplace.JobOffers
    var items: [JobOffer] = []
    
    func loadData(completion: ((NSError?) -> ())) {
        RequestManager.sharedInstance().getJobOffers { [weak self] (response, error) in
            self?.items.removeAll()
            if error != nil || response == nil {
                completion(error)
                return
            }
            for obj in response! {
                let id = obj[Param.id] as? Int
                let pickupDatetime = NSDateFormatter.serverResponseFormat.dateFromString(obj[Param.pickupDatetime] as! String)
                let pickupAddress = obj[Param.pickupAddress] as? String
                let destination = obj[Param.destination] as? String
                let fare = obj[Param.fare] as? String
                let gratuity = obj[Param.gratuity] as? String
                let vehicleType = obj[Param.vehicleType] as? String
                let suite = obj[Param.suite] as? Bool
                let jobType = obj[Param.jobType] as? String
                let instructions = obj[Param.instructions] as? String
                let status = obj[Param.status] as? String
                
                let item = JobOffer(id: id, pickupDatetime: pickupDatetime, pickupAddress: pickupAddress, destination: destination, fare: fare, gratuity: gratuity, vehicleType: vehicleType, suite: suite, jobType: jobType, instructions: instructions, status: status)
                self?.items.append(item)
            }
            completion(nil)
        }
    }
}
