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
    var deletedPhotos: [Int] = []
    var id: Int?
    
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
        }
        return -1
    }
}

class RentSaleUpdater: RentSaleCreator {
    var completion: ((NSError?) -> ())?
    private let operationsKeyPath = "operations"
    private var requestQueue = NSOperationQueue()
    
    override func checkCorrectParams() -> Int {
        if make != nil && model == nil {
            return 1
        }
        return -1
    }
    
    override func postNewRentSale(completion: ((NSError?) -> ())) {
        self.completion = completion
        
        let operationQueue = NSOperationQueue()
        operationQueue.maxConcurrentOperationCount = 1
        
        if let operation = createPatchOperation() {
            operationQueue.addOperation(operation)
        }
        
        for deletedID in deletedPhotos {
            operationQueue.addOperation(DeleteCarPhotoOperation(id: deletedID))
        }
        for image in photos {
            operationQueue.addOperation(AddCarPhotoOperation(photo: image, id: id!))
        }
        
        operationQueue.addObserver(self, forKeyPath: operationsKeyPath, options: NSKeyValueObservingOptions(), context: nil)
    }
    
    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        if keyPath != operationsKeyPath {
            super.observeValueForKeyPath(keyPath, ofObject: object, change: change, context: context)
            return
        }
        if let oq = object as? NSOperationQueue {
            if oq.operations.count == 0 {
                LoaderViewManager.hideLoader()
                completion?(nil)
            }
        }
    }
}

//MARK: - Private Methods
extension RentSaleUpdater {
    private func createPatchOperation() -> NSOperation? {
        typealias Param = Params.Posting
        let params: [String: AnyObject?] = [
            Param.make: make?.0,
            Param.model: model?.0,
            Param.type: type?.0,
            Param.color: color?.0,
            Param.year: year,
            Param.fuel: fuel?.0,
            Param.seats: seats?.0,
            Param.price: price,
            Param.description: rentSaleDescription
        ]
        
        let p = params
            .filterPairs( {return $0.1 != nil} )
            .mapPairs( {return ($0.0, String($0.1!) )} )
        
        if p.count > 0 {
            return PatchCarOperation(params: p, id: id!, isRent: postingType == .Rent ? true : false)
        }
        return nil
    }
}

class PatchCarOperation: AbstractOperation {
    let params: [String: String]
    let id: Int
    let isRent: Bool
    init(params: [String: String], id: Int, isRent: Bool) {
        self.params = params
        self.id = id
        self.isRent = isRent
        super.init()
    }
    
    override func main() {
        let urlString = isRent ? URL.Marketplace.rent : URL.Marketplace.sale + "\(id)/"
        RequestManager.sharedInstance().patch(urlString, parameters: params) { [weak self] (json, error) in
            self?.state = .Finished
        }
    }
}

class DeleteCarPhotoOperation: AbstractOperation {
    let id: Int
    init(id: Int) {
        self.id = id
        super.init()
    }
    
    override func main() {
        let urlString = URL.Marketplace.Photos.carPhotos + "\(id)/"
        RequestManager.sharedInstance().delete(urlString, parameters: nil) { [weak self] (json, error) in
            self?.state = .Finished
        }
    }
}

class AddCarPhotoOperation: AbstractOperation {
    let photo: UIImage
    let carID: Int
    let param = "car"
    
    init(photo: UIImage, id: Int) {
        self.photo = photo
        self.carID = id
        super.init()
    }
    
    override func main() {
        let urlString = URL.Marketplace.Photos.carPhotos
        let data = UIImagePNGRepresentation(photo)
        dispatch_async(dispatch_get_main_queue()) { [weak self] in
            if self == nil {
                return
            }
            RequestManager.sharedInstance().uploadPhoto([self!.param:"\(self!.carID)"], data: [data!], baseUrl: urlString, HTTPMethod: "POST", name: "file") { (_, _) in
                if self != nil {
                    self!.state = .Finished
                }
            }
        }
    }
}