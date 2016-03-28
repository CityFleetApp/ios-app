//
//  RentSazeCreator.swift
//  CitiFleet
//
//  Created by Nick Kibish on 3/28/16.
//  Copyright © 2016 Nick Kibish. All rights reserved.
//

import Foundation

class RentSazeCreator: NSObject {
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
    
}
