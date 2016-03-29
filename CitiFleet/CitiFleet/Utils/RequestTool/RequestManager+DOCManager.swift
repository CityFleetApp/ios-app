//
//  RequestManager+DOCManager.swift
//  CitiFleet
//
//  Created by Nick Kibish on 3/23/16.
//  Copyright © 2016 Nick Kibish. All rights reserved.
//

/*
* RequestManager + DOC Manager
*/

import Foundation

extension RequestManager {
    func getDocs(completion: (([AnyObject]?, NSError?) -> ())) {
        get(URL.DOCManagement.Documents, parameters: nil) { (json, error) -> () in
            if error != nil {
                completion(nil, error)
            }
            
            completion(json?.arrayObject, nil)
        }
    }
    
    func postDoc(HTTPMethod: String, fieldKey: String, fieldValue: String, docType: Int, photo: UIImage, completion: ((AnyObject?, NSError?) -> ())) {
        let data = UIImagePNGRepresentation(photo)
        let params = [
            fieldKey: fieldValue,
            Params.DOCManagement.docType: String(docType + 1)
        ]
        
        uploadPhoto(params, data: [data!], baseUrl: URL.DOCManagement.Documents, HTTPMethod: HTTPMethod, name: "file") { (response, error) -> () in
            if error != nil {
                completion(nil, error)
                return
            }
            completion(response, nil)
        }
    }
}
