//
//  GeneralGoodsUploader.swift
//  CitiFleet
//
//  Created by Nick Kibish on 3/30/16.
//  Copyright © 2016 Nick Kibish. All rights reserved.
//

import Foundation

class GeneralGoodsUploader: NSObject {
    var itemName: String?
    var ascingPrice: String?
    var condition: Int?
    var itemDescription: String?
    var photos: [UIImage] = []
    var id: Int?
    var deletedPhotos: [Int] = []
    
    func upload(completion: ((NSError?) -> ())) {
        RequestManager.sharedInstance().postGeneralGood(itemName!, price: ascingPrice!, condition: condition!, goodDescription: itemDescription!, images: photos, completion: completion)
    }
}

class GeneralGoodsPatcher: GeneralGoodsUploader {
    private let operationsKeyPath = "operations"
    private var requestQueue = NSOperationQueue()
    var completion: ((NSError?) -> ())!
    
    override func upload(completion: ((NSError?) -> ())) {
        self.completion = completion
        
        let operationQueue = NSOperationQueue()
        operationQueue.maxConcurrentOperationCount = 1
        operationQueue.addOperation(createPatchOperation())
        
        for deletedID in deletedPhotos {
            operationQueue.addOperation(DeleteGoodPhotoOperation(id: deletedID))
        }
        for image in photos {
            operationQueue.addOperation(AddPhotoOperation(photo: image, id: id!))
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
                completion(nil)
            }
        }
    }
    
    private func createPatchOperation() -> NSOperation {
        typealias Param = Params.Posting.GeneralGoods
        let params = [
            Param.item: itemName!,
            Param.price: ascingPrice!,
            Param.condition: String(condition),
            Param.description: itemDescription!
        ]
        
        return PatchGoodOperation(params: params, id: id!)
    }
}

class AbstractOperation: NSOperation {
    enum State: String {
        case Ready, Executing, Finished
        
        private var keyPath: String {
            return "is" + rawValue
        }
    }
    
    var state = State.Ready {
        willSet {
            willChangeValueForKey(newValue.keyPath)
            willChangeValueForKey(state.keyPath)
        }
        didSet {
            didChangeValueForKey(oldValue.keyPath)
            didChangeValueForKey(state.keyPath)
        }
    }
    
    override var ready: Bool {
        return super.ready && state == .Ready
    }
    
    override var executing: Bool {
        return state == .Executing
    }
    
    override var finished: Bool {
        return state == .Finished
    }
    
    override var asynchronous: Bool {
        return true
    }
    
    internal override func start() {
        if cancelled {
            state = .Finished
            return
        }
        
        main()
        state = .Executing
    }
    
    internal override func cancel() {
        state = .Finished
    }
}

class PatchGoodOperation: AbstractOperation {
    let params: [String: String]
    let id: Int
    init(params: [String: String], id: Int) {
        self.params = params
        self.id = id
        super.init()
    }
    
    override func main() {
        let urlString = URL.Marketplace.goodsForSale + "\(id)/"
        RequestManager.sharedInstance().patch(urlString, parameters: params) { [weak self] (json, error) in
            self?.state = .Finished
        }
    }
}

class DeleteGoodPhotoOperation: AbstractOperation {
    let id: Int
    init(id: Int) {
        self.id = id
        super.init()
    }
    
    override func main() {
        let urlString = URL.Marketplace.Photos.goodPhotos + "\(id)/"
        RequestManager.sharedInstance().delete(urlString, parameters: nil) { [weak self] (json, error) in
            self?.state = .Finished
        }
    }
}

class AddPhotoOperation: AbstractOperation {
    let photo: UIImage
    let goodID: Int
    let param = "goods"
    
    init(photo: UIImage, id: Int) {
        self.photo = photo
        self.goodID = id
        super.init()
    }
    
    override func main() {
        let urlString = URL.Marketplace.Photos.goodPhotos
        let data = UIImagePNGRepresentation(photo)
        dispatch_async(dispatch_get_main_queue()) { [unowned self] in
            RequestManager.sharedInstance().uploadPhoto([self.param:"\(self.goodID)"], data: [data!], baseUrl: urlString, HTTPMethod: "POST", name: "file") { [unowned self] (_, _) in
                self.state = .Finished
            }
        }
    }
}