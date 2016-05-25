//
//  JobOfferPreloader.swift
//  CitiFleet
//
//  Created by Nick Kibish on 5/25/16.
//  Copyright © 2016 Nick Kibish. All rights reserved.
//

import UIKit

class JobOfferPreloader: NSObject {
    var jobTypes: [String]?
    var vehicleTypes: [String]?
    var completion: (() -> ())
    
    private let operationsKeyPath = "operations"
    
    init(completion: (() -> ())) {
        self.completion = completion
        super.init()
    }
    
    func downloadData() {
        LoaderViewManager.showLoader()
        
        let operationQueue = NSOperationQueue()
        operationQueue.maxConcurrentOperationCount = 1
        
        operationQueue.addOperation(JobOfferPreloadOperation(url: URL.Marketplace.jobTypes, completion: { [weak self] (arr) in
            self?.jobTypes = arr
        }))
        
        operationQueue.addOperation(JobOfferPreloadOperation(url: URL.Marketplace.vehicleTypes, completion: { [weak self] (arr) in
            self?.vehicleTypes = arr
        }))
        
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
                completion()
            }
        }
    }
}

class JobOfferPreloadOperation: AbstractOperation {
    var completion: (([String]?) -> ())
    var url: String
    
    private let param = "name"
    
    init(url: String, completion: (([String]?) -> ())) {
        self.url = url
        self.completion = completion
        super.init()
    }
    
    override func main() {
        RequestManager.sharedInstance().get(url, parameters: nil) { [unowned self] (json, error) in
            if let items = json?.arrayObject {
                var itemNames: [String] = []
                for item in items {
                    if let itemName = item[self.param] as? String {
                        itemNames.append(itemName)
                    }
                }
                self.completion(itemNames)
            } else {
                self.completion(nil)
            }
            self.state = .Finished
        }
    }
}