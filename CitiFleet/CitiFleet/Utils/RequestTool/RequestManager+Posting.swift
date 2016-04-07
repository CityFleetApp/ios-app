
//  RequestManager+Posting.swift
//  CitiFleet
//
//  Created by Nick Kibish on 3/29/16.
//  Copyright © 2016 Nick Kibish. All rights reserved.
//

import Foundation

//MARK: - MarketPlace
extension RequestManager {
    func getCarsForRent(completion: ((ArrayResponse, NSError?) -> ())) {
        get(URL.Marketplace.carsForRent, parameters: nil) { (json, error) -> () in
            completion(json?.arrayObject, error)
        }
    }
    
    func getCarsForSale(completion: ((ArrayResponse, NSError?) -> ())) {
        get(URL.Marketplace.carsForSale, parameters: nil) { (json, error) -> () in
            completion(json?.arrayObject, error)
        }
    }
    
    func getGoodsForSale(completion: ((ArrayResponse, NSError?) -> ())) {
        get(URL.Marketplace.goodsForSale, parameters: nil) { (json, error) -> () in
            completion(json?.arrayObject, error)
        }
    }
    
    func getJobOffers(completion: ((ArrayResponse, NSError?) -> ())) {
        get(URL.Marketplace.JobOffers, parameters: nil) { (json, error) in
            completion(json?.arrayObject, error)
        }
    }
}

//MARK: - Posting
extension RequestManager {
    func postGeneralGood(item: String, price: String, condition: Int, goodDescription: String, images: [UIImage], completion: ((NSError?) -> ())) {
        typealias Param = Params.Posting.GeneralGoods
        let params = [
            Param.item: item,
            Param.price: price,
            Param.condition: String(condition),
            Param.description: goodDescription
        ]
        
        var imageData: [NSData] = []
        for image in images {
            imageData.append(UIImagePNGRepresentation(image)!)
        }
        
        uploadPhoto(params, data: imageData, baseUrl: URL.Marketplace.GeneralGoods, HTTPMethod: "POST", name: Param.photos) { (response, error) -> () in
            completion(error)
        }
        
    }
    
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
        let params = createParams(dateTime, pickup: pickup, destination: destination, fare: fare, gratuity: gratuity, vehicleType: vehicleType, isSuite: isSuite, jobType: jobType, instructions: instructions)
        
        post(URL.Marketplace.JOPost, parameters: params) { (json, error) -> () in
            completion(error)
        }
    }
    
    func patchJobOffer(id: Int, dateTime: String, pickup: String, destination: String, fare: String, gratuity: String, vehicleType: Int, isSuite: Bool, jobType: Int, instructions: String, completion: ((NSError?) -> ())) {
        let params = createParams(dateTime, pickup: pickup, destination: destination, fare: fare, gratuity: gratuity, vehicleType: vehicleType, isSuite: isSuite, jobType: jobType, instructions: instructions)
        
        let urlString = URL.Marketplace.JOPost + "\(id)/"
        
        patch(urlString, parameters: params) { (json, error) -> () in
            completion(error)
        }
    }
    
    private func createParams(dateTime: String, pickup: String, destination: String, fare: String, gratuity: String, vehicleType: Int, isSuite: Bool, jobType: Int, instructions: String) -> [String: String] {
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
        return params
    }
}