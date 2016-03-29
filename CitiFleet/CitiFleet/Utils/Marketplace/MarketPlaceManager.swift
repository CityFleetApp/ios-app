//
//  MarketPlaceManager.swift
//  CitiFleet
//
//  Created by Nick Kibish on 3/26/16.
//  Copyright © 2016 Nick Kibish. All rights reserved.
//

import UIKit

class MarketPlaceManager: NSObject {
    typealias MarketPlaceItem = (Int, String)
    
    let operationsKeyPath = "operations"
    var reloadData: (() -> ())?
    
    var make: [MarketPlaceItem] = []
    var colors: [MarketPlaceItem] = []
    var seats: [MarketPlaceItem] = []
    var fuel: [MarketPlaceItem] = []
    var type: [MarketPlaceItem] = []
    var model: [MarketPlaceItem] = []
    
    private class DataDownloader: NSOperation {
        enum State: String {
            case Ready, Executing, Finished
            
            private var keyPath: String {
                return "is" + rawValue
            }
        }
        
        private let Params = ("id", "name")
        var manager: MarketPlaceManager
        var URLstr: String
        var completed: (([MarketPlaceItem]) -> ())
        
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
        
        init(manager: MarketPlaceManager, URLstr: String, completion: (([MarketPlaceItem]) -> ())) {
            self.manager = manager
            self.URLstr = URLstr
            completed = completion
            super.init()
        }
        
        private override func start() {
            if cancelled {
                state = .Finished
                return
            }
            
            main()
            state = .Executing
        }
        
        private override func cancel() {
            state = .Finished
        }
        
        private override func main() {
            RequestManager.sharedInstance().makeSilentRequest(.GET, baseURL: URLstr, parameters: nil) { [unowned self] (json, error) -> () in
                if let results = json?.arrayObject {
                    self.fillArray(results)
                }
            }
        }
        
        private func fillArray(results: [AnyObject]) {
            var array: [MarketPlaceItem] = []
            for result in results {
                let id = result[Params.0] as! Int
                let name = result[Params.1] as! String
                array.append((id, name))
            }
            state = .Finished
            completed(array)
        }
    }
    
    func loadData() {
        LoaderViewManager.showLoader()
        
        typealias MPURL = URL.Marketplace
        let operationQueue = NSOperationQueue()
        operationQueue.maxConcurrentOperationCount = 1
        
        operationQueue.addOperation(DataDownloader(manager: self, URLstr: MPURL.make, completion: { [unowned self] (arr) in
            self.make = arr
            }))
        operationQueue.addOperation(DataDownloader(manager: self, URLstr: MPURL.color, completion: { [unowned self] (arr) in
            self.colors = arr
            }))
        operationQueue.addOperation(DataDownloader(manager: self, URLstr: MPURL.seats, completion: { [unowned self] (arr) in
            self.seats = arr
            }))
        operationQueue.addOperation(DataDownloader(manager: self, URLstr: MPURL.fuel, completion: { [unowned self] (arr) in
            self.fuel = arr
            }))
        operationQueue.addOperation(DataDownloader(manager: self, URLstr: MPURL.type, completion: { [unowned self] (arr) in
            self.type = arr
            }))
        
        operationQueue.addObserver(self, forKeyPath: operationsKeyPath, options: NSKeyValueObservingOptions(), context: UnsafeMutablePointer())
    }
    
    func loadModels(makeID: Int, completion: (() -> ())) {
        model.removeAll()
        let url = "\(URL.Marketplace.model)?make=\(makeID)"
        RequestManager.sharedInstance().get(url, parameters: nil) { [unowned self] (json, error) -> () in
            let Params = ("id", "name")
            if let results = json?.arrayObject {
                for modelsJSON in results {
                    let id = modelsJSON[Params.0] as! Int
                    let name = modelsJSON[Params.1] as! String
                    self.model.append((id, name))
                }
            }
            completion()
        }
    }
    
    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        if keyPath != operationsKeyPath {
            super.observeValueForKeyPath(keyPath, ofObject: object, change: change, context: context)
            return
        }
        if let oq = object as? NSOperationQueue {
            if oq.operations.count == 0 {
                LoaderViewManager.hideLoader()
                reloadData?()
            }
        }
    }
}