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

public func url(apiUrl:String) -> String {
    return URL.BaseUrl + apiUrl
}

public func header() -> [String:String] {
    return [Params.Header.contentType: Params.Header.json]
}

public func login(username: String, password: String, confirmPassword: String, completion:([String: AnyObject]?, NSError?)) {
    let params = [
        Params.Login.email: username,
        Params.Login.password: password,
        Params.Login.passwordConfirm: confirmPassword
    ]
    
    Alamofire.request(.POST, url(URL.Login.SignUp), headers: header(), parameters: params, encoding: .JSON)
        .validate(statusCode: 200..<300)
        .responseJSON { response in
            if (response.result.error == nil) {
                let json = JSON(data: response.data!)
                let dict = json.dictionaryObject! as [String: AnyObject]
//                completion(dict, response.result.error)
                debugPrint("HTTP Response Body: \(dict)")
            }
            else {
                debugPrint("HTTP Request failed: \(response.result.error)")
            }
    }
}