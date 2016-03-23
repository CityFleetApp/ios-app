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
    func postDoc(fieldKey: String, fieldValue: String, docType: Int, photo: UIImage) {
        let data = UIImagePNGRepresentation(photo)
        let params = [
            fieldKey: fieldValue,
            Params.DOCManagement.docType: String(docType)
        ]
        uploadPhoto(params, data: data!, baseUrl: URL.DOCManagement.Documents, HTTPMethod: "POST", name: "file") { (response, error) -> () in
            
        }
    }
}