//
//  RequestManager+SocialManager.swift
//  CitiFleet
//
//  Created by Nick Kibish on 3/2/16.
//  Copyright © 2016 Nick Kibish. All rights reserved.
//

import Foundation
import Alamofire
import Swift
import SwiftyJSON
import ReachabilitySwift

extension RequestManager {
    func postPhoneNumbers(phones:[String], completion:(([String: AnyObject]?, NSError?) -> ())) {
        let params = [
            Params.Social.phones: phones
        ]
        post(URL.Social.Phones, parameters: params) { (json, error) in
            completion(json?.dictionaryObject, error)
        }
    }
    
    func postFacebookToken(token: String, completion:(([String: AnyObject]?, NSError?) -> ())) {
        let params = [
            Params.Social.token: token
        ]
        post(URL.Social.Facebook, parameters: params) { (json, error) in
            completion(json?.dictionaryObject, error)
        }
    }
    
    func postInstagramToken(token: String, completion:(([String: AnyObject]?, NSError?) -> ())) {
        let params = [
            Params.Social.token: token
        ]
        post(URL.Social.Instagram, parameters: params) { (json, error) in
            completion(json?.dictionaryObject, error)
        }
    }
    
    func postTwitterToken(token: String, tokenSecret: String, completion:(([String: AnyObject]?, NSError?) -> ())) {
        let params = [
            Params.Social.token: token,
            Params.Social.tokenSecret: tokenSecret
        ]
        post(URL.Social.Twitter, parameters: params) { (json, error) in
            completion(json?.dictionaryObject, error)
        }
    }
}