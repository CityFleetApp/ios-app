//
//  RequestManager+Map.swift
//  CitiFleet
//
//  Created by Nick Kibish on 4/11/16.
//  Copyright © 2016 Nick Kibish. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

extension RequestManager {
    func getNearbyReports(completion:((ArrayResponse, NSError?) -> ())) {
        let latitude = LocationManager.sharedInstance().currentCoordinates.latitude
        let longitude = LocationManager.sharedInstance().currentCoordinates.longitude
        
        let urlString = URL.Reports.Nearby + "?\(Params.Report.latitude)=\(latitude)&\(Params.Report.longitude)=\(longitude)"
        
        Alamofire.request(.GET, url(urlString), headers: header(), parameters: nil, encoding: .JSON)
            .validate(statusCode: 200..<300)
            .responseData{ response in
                let dataString = String(data: response.data!, encoding: NSUTF8StringEncoding)
                switch response.result {
                case .Success(let data):
                    let json = JSON(data: data)
                    completion(json.arrayObject, nil)
                    break
                case .Failure(let error):
                    let handledError = self.errorWithInfo(error, data: response.data)
                    completion(nil, handledError)
                    break
                }
        }
    }
    
    func getNearbyFriends(completion:((ArrayResponse, NSError?) -> ())) {
        let latitude = LocationManager.sharedInstance().currentCoordinates.latitude
        let longitude = LocationManager.sharedInstance().currentCoordinates.longitude
        
        let urlString = URL.Reports.Friends + "?\(Params.Report.latitude)=\(latitude)&\(Params.Report.longitude)=\(longitude)"
        
        Alamofire.request(.GET, url(urlString), headers: header(), parameters: nil, encoding: .JSON)
            .validate(statusCode: 200..<300)
            .responseData{ response in
                let dataString = String(data: response.data!, encoding: NSUTF8StringEncoding)
                switch response.result {
                case .Success(let data):
                    let json = JSON(data: data)
                    completion(json.arrayObject, nil)
                    break
                case .Failure(let error):
                    let handledError = self.errorWithInfo(error, data: response.data)
                    completion(nil, handledError)
                    break
                }
        }
    }
}