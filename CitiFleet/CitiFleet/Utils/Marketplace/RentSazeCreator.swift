//
//  RentSazeCreator.swift
//  CitiFleet
//
//  Created by Nick Kibish on 3/28/16.
//  Copyright © 2016 Nick Kibish. All rights reserved.
//

import Foundation

class RentSaleCreator: NSObject {
    static let NoPhotosErrorCode = 100
    static let NoPriceErrorCode = 101
    static let NoDescriptionErrorCode = 102
    enum PostType {
        case Rent, Sale
    }
    
    typealias MarketPlaceItem = MarketPlaceManager.MarketPlaceItem
    var make: MarketPlaceItem?
    var model: MarketPlaceItem?
    var type: MarketPlaceItem?
    var color: MarketPlaceItem?
    var year: String?
    var fuel: MarketPlaceItem?
    var seats: MarketPlaceItem?
    var price: String?
    var rentSaleDescription: String?
    var photos: [UIImage] = []
    var postingType: PostType!
    
    func postNewRentSale(completion: ((NSError?) -> ())) {
        RequestManager.sharedInstance().postRentSale(postingType, make: make!.0, model: model!.0, carType: type!.0, color: color!.0, year: year!, fuel: fuel!.0, seats: seats!.0, price: price!, description: rentSaleDescription!, photos: photos, completion: completion)
    }
    
    func checkCorrectParams() -> Int {
        if make == nil {
            return 0
        } else if model == nil {
            return 1
        } else if type == nil {
            return 2
        } else if color == nil {
            return 3
        } else if year == nil {
            return 4
        } else if fuel == nil {
            return 5
        } else if seats == nil {
            return 6
        } else if price == nil || price?.characters.count == 0 {
            return RentSaleCreator.NoPriceErrorCode
        } else if rentSaleDescription == nil || rentSaleDescription?.characters.count == 0 {
            return RentSaleCreator.NoDescriptionErrorCode
        } else if photos.count == 0 {
            return RentSaleCreator.NoPhotosErrorCode
        }
        return -1
    }
}
