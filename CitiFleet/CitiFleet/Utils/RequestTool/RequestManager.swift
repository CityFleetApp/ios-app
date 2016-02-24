//
//  RequestManager.swift
//  CitiFleet
//
//  Created by Nick Kibish on 2/24/16.
//  Copyright © 2016 Nick Kibish. All rights reserved.
//

import Foundation
import Alamofire
import Swift
import SwiftyJSON

class RequestManager: NSObject {
    class func url(apiUrl:String) -> String {
        return URL.BaseUrl + apiUrl
    }
    
    class func header() -> [String:String] {
        return [Params.Header.contentType: Params.Header.json]
    }
    
    class func login(username: String, password: String, completion:(([String: AnyObject]?, NSError?) -> ())) {
        let params = [
            Params.Login.username: username,
            Params.Login.password: password
        ]
        
        Alamofire.request(.POST, url(URL.Login.Login), headers: header(), parameters: params, encoding: .JSON)
            .validate(statusCode: 200..<300)
            .responseJSON { response in
                if (response.result.error == nil) {
                    let json = JSON(data: response.data!)
                    let dict = json.dictionaryObject! as [String: AnyObject]
                    //                completion(dict, response.result.error)
                    debugPrint("HTTP Response Body: \(dict)")
                } else {
                    debugPrint("HTTP Request failed: \(response.result.error.debugDescription)")
                }
        }
    }
}
