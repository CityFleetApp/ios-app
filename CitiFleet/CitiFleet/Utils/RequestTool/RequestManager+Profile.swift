//
//  RequestManager+Profile.swift
//  CitiFleet
//
//  Created by Nick Kibish on 3/16/16.
//  Copyright © 2016 Nick Kibish. All rights reserved.
//

import Foundation

extension RequestManager {
    func uploadAvatar(data: NSData, completion: ((NSURL?, NSError?) -> ())) {
        uploadPhoto(data, baseUrl: URL.Profile.UploadAvatar, HTTPMethod: "PUT", name: "avatar", completion: { (data, error) in
            if let avatarURL = data?.valueForKey(Response.UploadAvatar.avatar) as? String {
                self.saveAvatar(avatarURL)
                completion(NSURL(string: avatarURL), nil)
            }
            completion(nil, error)
        })
    }
    
    func uploadVehicle(data: NSData, completion: ((AnyObject?, NSError?) -> ())) {
        uploadPhoto(data, baseUrl: URL.Profile.vehiclPhoto, HTTPMethod: "POST", name: "file", completion: completion)
    }
    
    func downloadVehicleImages(completion:(([AnyObject]?, NSError?) -> ())) {
        get(URL.Profile.vehiclPhoto, parameters: nil) { (json, error) -> () in
            if let json = json {
                completion(json.arrayObject, error)
            } else {
                completion(nil, error)
            }
        }
    }
    
    func deletePhoto(id: Int, completion:((Bool, NSError?) -> ())) {
        let deleteUrl = URL.Profile.vehiclPhoto + "\(id)/"
        delete(deleteUrl, parameters: nil) { (json, error) -> () in
            print("Delete respoonse: \(json)")
            print("Image Index \(id)")
            completion(true, error)
        }
    }
}