//
//  MarketplaceItem.swift
//  CitiFleet
//
//  Created by Nick Kibish on 3/31/16.
//  Copyright © 2016 Nick Kibish. All rights reserved.
//

import UIKit

class MarketplaceItem: NSObject {
    var itemName: String?
    var itemDescription: String?
    var id: Int?
    var price: String?
    var photosURLs: [NSURL] = []
    var photoSize: [CGSize] = []
    var isShownDetails = false
}

class CarForRentSale: MarketplaceItem {
    var seats: Int?
    var color: String?
    var type: String?
    var make: String?
    var model: String?
    var fuel: String?
    var year: String?
}

class GoodForSale: MarketplaceItem {
    var condition: String?
    var goodName: String?
}

class MarketPlaceShopManager: NSObject {
    internal typealias Param = Response.Marketplace
    var items: [MarketplaceItem] = []
    
    func loadCarsForRent(completion: ((NSError?) -> ())) {
        RequestManager.sharedInstance().getCarsForRent { [unowned self] (response, error) -> () in
            if let resp = response {
                self.parseCarsRespons(resp)
            }
            completion(error)
        }
    }
    
    func loadCarsForSale(completion: ((NSError?) -> ())) {
        RequestManager.sharedInstance().getCarsForSale { [unowned self] (response, error) -> () in
            if let resp = response {
                self.parseCarsRespons(resp)
            }
            completion(error)
        }
    }
    
    func loadGoodsForSale(completion: ((NSError?) -> ())) {
        RequestManager.sharedInstance().getGoodsForSale { [unowned self] (response, error) -> () in
            if let resp = response {
                self.parseGoodsForSale(resp)
            }
            completion(error)
        }
    }
    
    private func parseCarsRespons(respObject: RequestManager.ArrayResponse) {
        var items: [MarketplaceItem] = []
        for obj in respObject! {
            let item = CarForRentSale()
            parseItemResponse(item, obj: obj)
            item.seats = obj[Param.seats] as? Int
            item.color = obj[Param.color] as? String
            item.type = obj[Param.carType] as? String
            item.make = obj[Param.make] as? String
            item.model = obj[Param.model] as? String
            item.fuel = obj[Param.fuel] as? String
            item.year = String(obj[Param.year] as! Int)
            items.append(item)
        }
        self.items = items
    }
    
    private func parseGoodsForSale(respObject: RequestManager.ArrayResponse) {
        var items: [MarketplaceItem] = []
        for obj in respObject! {
            let item = GoodForSale()
            parseItemResponse(item, obj: obj)
            item.condition = obj[Param.condition] as? String
            item.goodName = obj[Param.itemName] as? String
            items.append(item)
        }
        self.items = items
    }
    
    private func parseItemResponse(item: MarketplaceItem, obj: AnyObject) {
        item.id = obj[Param.id] as? Int
        item.itemDescription = obj[Param.itemDescription] as? String
        item.price = obj[Param.price] as? String
        let urls = obj[Param.photos] as? [String]
        for url in urls! {
            item.photosURLs.append(NSURL(string: url)!)
        }
        
        let photoSize = obj[Param.photoSize] as! [CGFloat]?
        let width = photoSize![0]
        let height = photoSize![1]
        
        item.photoSize.append(CGSize(width: width, height: height))
    }
}