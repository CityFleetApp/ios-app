//
//  ManagePostsListDataSource.swift
//  CitiFleet
//
//  Created by Nick Kibish on 4/6/16.
//  Copyright © 2016 Nick Kibish. All rights reserved.
//

import Foundation

protocol PreviousPost {
    var postType: ManagePostsListDataSource.PostType? {get}
    var postID: Int? { get }
}

class ManagedJob: PreviousPost {
    var jobOffer: JobOffer?
    var postType: ManagePostsListDataSource.PostType? {
        return ManagePostsListDataSource.PostType.JobOffer
    }
    var postID: Int? {
        return jobOffer?.id
    }
}

class ManagedCar: CarForRentSale, PreviousPost {
    var postType: ManagePostsListDataSource.PostType? {
        return ManagePostsListDataSource.PostType.Car
    }
    var postID: Int? {
        return id
    }
}

class ManagedGood: GoodForSale, PreviousPost {
    var postType: ManagePostsListDataSource.PostType? {
        return ManagePostsListDataSource.PostType.Good
    }
    var postID: Int? {
        return id
    }
}

class ManagePostsListDataSource: NSObject {
    enum PostType: String {
        case Car = "car"
        case Good = "goods"
        case JobOffer = "offer"
    }
    
    func loadData () {
        RequestManager.sharedInstance().get(URL.Marketplace.ManagePosts, parameters: nil) { [weak self ] (json, error) in
            if let items = json?.arrayObject {
                self?.parseObjects(items)
            }
        }
    }
    
}

extension ManagePostsListDataSource {
    private func parseObjects(items:[AnyObject]) {
        var posts: [PreviousPost] = []
        for post in items {
            let type = PostType(rawValue: post[Response.Marketplace.ManagePost.postType] as! String)
            switch type! {
            case PostType.Car:
                break
            case PostType.Good:
                break
            case PostType.JobOffer:
                break
            default:
                break
            }
        }
    }
    
    private func parseCar(item: AnyObject) {
        
    }
}