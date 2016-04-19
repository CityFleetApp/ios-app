//
//  MarketplaceItem.swift
//  CitiFleet
//
//  Created by Nick Kibish on 3/31/16.
//  Copyright © 2016 Nick Kibish. All rights reserved.
//

import UIKit

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
            let item = CarForRentSale(json: obj)
            items.append(item)
        }
        self.items = items
    }
    
    private func parseGoodsForSale(respObject: RequestManager.ArrayResponse) {
        var items: [MarketplaceItem] = []
        for obj in respObject! {
            let item = GoodForSale(json: obj)
            items.append(item)
        }
        self.items = items
    }
}