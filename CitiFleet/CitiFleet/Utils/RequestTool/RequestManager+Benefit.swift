//
//  Montserrat-Black.swift
//  CitiFleet
//
//  Created by Nick Kibish on 3/11/16.
//  Copyright © 2016 Nick Kibish. All rights reserved.
//

import Foundation

extension RequestManager {
    func getBenefits(completion:(([AnyObject]?, NSError?) -> ())) {
        get(URL.BenefitsList, parameters: nil) { (json, error) -> () in
            completion(json?.arrayObject, error)
        }
    }
}