//
//  ManagePostsListDataSource.swift
//  CitiFleet
//
//  Created by Nick Kibish on 4/6/16.
//  Copyright © 2016 Nick Kibish. All rights reserved.
//

import Foundation

protocol PreviousPost {
    var postType: ManagePostsListDataSource.PostType? { get }
    var postID: Int? { get }
    var title: String? { get }
    var postDescription: String? { get }
    var dateString: String? { get }
    var imageName: String? { get }
}

class ManagedJob: JobOffer, PreviousPost {
    var postType: ManagePostsListDataSource.PostType? {
        return ManagePostsListDataSource.PostType.JobOffer
    }
    var postID: Int? {
        return id
    }
    var title: String? {
        return instructions
    }
    var postDescription: String? {
        return "Job Offer"
    }
    var dateString: String? {
        return NSDateFormatter(dateFormat: "dd/MM/yy").stringFromDate(created!)
    }
    var imageName: String? {
        return "manage_job"
    }
}

class ManagedCar: CarForRentSale, PreviousPost {
    var postType: ManagePostsListDataSource.PostType? {
        return ManagePostsListDataSource.PostType.Car
    }
    var postID: Int? {
        return id
    }
    var title: String? {
        return "\(year!) \(make!) \(model!)"
    }
    var postDescription: String? {
        return "Vehicles for Rent/Sale"
    }
    var dateString: String? {
        return NSDateFormatter(dateFormat: "dd/MM/yy").stringFromDate(created!)
    }
    var imageName: String? {
        return "manage_car"
    }
}

class ManagedGood: GoodForSale, PreviousPost {
    var postType: ManagePostsListDataSource.PostType? {
        return ManagePostsListDataSource.PostType.Good
    }
    var postID: Int? {
        return id
    }
    var title: String? {
        return goodName
    }
    var postDescription: String? {
        return "General Goods for Sale"
    }
    var dateString: String? {
        return NSDateFormatter(dateFormat: "dd/MM/yy").stringFromDate(created!)
    }
    var imageName: String? {
        return "manage-good"
    }
}

class ManagePostsListDataSource: NSObject {
    enum PostType: String {
        case Car = "car"
        case Good = "goods"
        case JobOffer = "offer"
    }
    
    var previousPosts: [PreviousPost] = []
    
    func loadData (completion: ((NSError?) -> ())) {
        RequestManager.sharedInstance().get(URL.Marketplace.ManagePosts, parameters: nil) { [weak self ] (json, error) in
            if let items = json?.arrayObject {
                self?.parseObjects(items)
                completion(error)
            }
        }
    }
}

extension ManagePostsListDataSource {
    private func parseObjects(items:[AnyObject]) {
        previousPosts.removeAll()
        for post in items {
            let type = PostType(rawValue: post[Response.Marketplace.ManagePost.postType] as! String)
            switch type! {
            case PostType.Car:
                previousPosts.append(ManagedCar(json: post))
                break
            case PostType.Good:
                previousPosts.append(ManagedGood(json: post))
                break
            case PostType.JobOffer:
                previousPosts.append(ManagedJob(json: post))
                break
            }
        }
    }
    
    private func parseCar(item: AnyObject) -> ManagedCar {
        let car = ManagedCar(json: item)
        return car
    }
}