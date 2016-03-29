
//  RequestManager+Posting.swift
//  CitiFleet
//
//  Created by Nick Kibish on 3/29/16.
//  Copyright © 2016 Nick Kibish. All rights reserved.
//

import Foundation

extension RequestManager {
    func postRentSale(type: RentSaleCreator.PostType, make: Int, model: Int, carType: Int, color: Int, year: String, fuel: Int, seats: Int, price: String, description: String, photos: [UIImage], completion: ((NSError?) -> ())) {
        typealias Param = Params.Posting
        
        let params = [
            Param.make: String(make),
            Param.model: String(model),
            Param.type: String(carType),
            Param.color: String(color),
            Param.year: year,
            Param.fuel: String(fuel),
            Param.seats: String(seats),
            Param.price: price,
            Param.description: description
        ]
        
        var imageData: [NSData] = []
        for image in photos {
            imageData.append(UIImagePNGRepresentation(image)!)
        }
        
        var URLStr = ""
        switch type {
        case .Rent:
            URLStr = URL.Marketplace.rent
            break
        case .Sale:
            URLStr = URL.Marketplace.sale
            break
        }
        
        uploadPhoto(params, data: imageData, baseUrl: URLStr, HTTPMethod: "POST", name: "photos") { (responseObj, error) -> () in
            completion(error)
        }
    }
    
    func postJobOffer(dateTime: String, pickup: String, destination: String, fare: String, gratuity: String, vehicleType: Int, isSuite: Bool, jobType: Int, instructions: String, completion: ((NSError?) -> ())) {
        typealias Param = Params.Posting.JOPosting
        let params = [
            Param.pickupDatetime: dateTime,
            Param.pickupAddress: pickup,
            Param.destination: destination,
            Param.fare: fare,
            Param.gratuity: gratuity,
            Param.vehicleType: String(vehicleType),
            Param.suite: isSuite ? "true" : "false",
            Param.jobType: String(jobType),
            Param.instructions: instructions
        ]
        
        post(URL.Marketplace.JOPost, parameters: params) { (json, error) -> () in
            completion(error)
        }
    }
}