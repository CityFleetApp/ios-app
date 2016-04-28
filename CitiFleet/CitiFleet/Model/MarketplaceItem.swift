//
//  MarketplaceItem.swift
//  CitiFleet
//
//  Created by Nick Kibish on 3/31/16.
//  Copyright © 2016 Nick Kibish. All rights reserved.
//

import UIKit

infix operator ^^ { associativity left precedence 120 }

func ^^<T : BooleanType, U : BooleanType>(lhs: T, rhs: U) -> Bool {
    return lhs.boolValue != rhs.boolValue
}

struct MarketplaceItemPhoto {
    var URL: NSURL
    var id: Int
}

class MarketplaceItem: NSObject {
    internal typealias Param = Response.Marketplace
    
    var itemDescription: String?
    var id: Int?
    var price: String?
    var photosURLs: [MarketplaceItemPhoto] = []
    var photoSize: CGSize!
    var isShownDetails = false
    var created: NSDate?
    
    var itemName: String? {
        return ""
    }
    
    override init() {
        
    }
    
    init(json: AnyObject) {
        super.init()
        id = json[Param.id] as? Int
        itemDescription = json[Param.itemDescription] as? String
        price = json[Param.price] as? String
        created = NSDateFormatter.serverResponseFormat.dateFromString(json[Param.created] as! String)
        if let urls = json[Param.photos] as? [AnyObject] {
            for photo in urls {
                let url = NSURL(string: photo["url"] as! String)!
                let photoID = photo["id"] as! Int
                photosURLs.append(MarketplaceItemPhoto(URL: url, id: photoID))
            }
        }
        
        if let photoSize = json[Param.photoSize] as? [CGFloat]? {
            let width = photoSize![0]
            let height = photoSize![1]
            self.photoSize = CGSize(width: width, height: height)
        } else {
            self.photoSize = CGSize(width: 100, height: 100)
        }
    }
}

class CarForRentSale: MarketplaceItem {
    var seats: Int?
    var color: String?
    var type: String?
    var make: String?
    var model: String?
    var fuel: String?
    var year: String?
    var isRent: Bool?
    
    override var itemName: String? {
        return "\(year ?? "") \(make ?? "") \(model ?? "")"
    }
    
    override init() {
        super.init()
    }
    
    override init(json: AnyObject) {
        super.init(json: json)
        seats = json[Param.seats] as? Int
        color = json[Param.color] as? String
        type = json[Param.carType] as? String
        make = json[Param.make] as? String
        model = json[Param.model] as? String
        fuel = json[Param.fuel] as? String
        year = String(json[Param.year] as! Int)
    }
}

class GoodForSale: MarketplaceItem {
    var condition: String?
    var goodName: String?
    
    override var itemName: String? {
        return goodName
    }
    
    override init() {
        super.init()
    }
    
    override init(json: AnyObject) {
        super.init(json: json)
        condition = json[Param.condition] as? String
        goodName = json[Param.itemName] as? String
    }
}

class MarketPlaceShopManager: NSObject {
    internal typealias Param = Response.Marketplace
    var items: [MarketplaceItem] = []
    var count: Int?
    var nextPage: String?
    var shouldLoad: Bool {
        return (count == nil) ^^ (nextPage != nil)
    }
    
    func reload(reloaded: (() -> ())?) {
        items.removeAll()
        nextPage = nil
        count = nil
        reloaded?()
    }
    
    func loadCarsForRent(completion: ((NSError?) -> ())) {
        loadItems(URL.Marketplace.carsForRent,
                  parseParams: { [weak self] (json) in
                    self?.parseCarsRespons(json)
            }, completion: completion)
    }
    
    func loadCarsForSale(completion: ((NSError?) -> ())) {
        loadItems(URL.Marketplace.carsForSale,
                  parseParams: { [weak self] (json) in
                    self?.parseCarsRespons(json)
            }, completion: completion)
    }
    
    func loadGoodsForSale(completion: ((NSError?) -> ())) {
        loadItems(URL.Marketplace.goodsForSale,
                  parseParams: { [weak self] (json) in
                    self?.parseGoodsForSale(json)
            }, completion: completion)
    }
    
    func loadItems(baseURL: String, parseParams: (([String : AnyObject]) -> ()), completion: ((NSError?) -> ())) {
        let requestManager = RequestManager.sharedInstance()
        if !requestManager.shouldStartRequest() {
            completion(NSError(domain: "", code: 0, userInfo: nil))
            return
        }
        let url = nextPage != nil ? nextPage : requestManager.url(baseURL)
        requestManager.makeRequestWithFullURL(.GET, baseURL: url!, parameters: nil) { (json, error) in
            if let resp = json?.dictionaryObject {
                parseParams(resp)
            }
            completion(error)
        }
    }
}

//MARK: - Private methods
extension MarketPlaceShopManager {
    private func parseCarsRespons(respObject: [String: AnyObject]) {
        count = respObject[Response.count] as? Int
        nextPage = respObject[Response.next] as? String
        
        if let result = respObject[Response.results] as? [AnyObject] {
            for item in result {
                let car = CarForRentSale(json: item)
                self.items.append(car)
            }
        }
    }
    
    private func parseGoodsForSale(respObject: [String: AnyObject]) {
        count = respObject[Response.count] as? Int
        nextPage = respObject[Response.next] as? String
        
        if let result = respObject[Response.results] as? [AnyObject] {
            for item in result {
                let good = GoodForSale(json: item)
                self.items.append(good)
            }
        }
    }
}