//
//  JobOfferPost.swift
//  CitiFleet
//
//  Created by Nick Kibish on 3/30/16.
//  Copyright © 2016 Nick Kibish. All rights reserved.
//

import Foundation

class JobOfferPost: NSObject {
    var dateTime: String?
    var pickupAddress: String?
    var destinationAddress: String?
    var fare: String?
    var gratuity: String?
    var vehicleType: Int?
    var suite: Bool?
    var jobType: Int?
    var instructions: String?
    
    func upload(completion: ((NSError?) -> ()) ) {
        RequestManager.sharedInstance().postJobOffer(dateTime!, pickup: pickupAddress!, destination: destinationAddress!, fare: fare!, gratuity: gratuity!, vehicleType: vehicleType!, isSuite: suite!, jobType: jobType!, instructions: instructions!, completion: completion)
    }
    
}