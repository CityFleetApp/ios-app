//
//  ImageUploader.swift
//  CitiFleet
//
//  Created by Nick Kibish on 3/9/16.
//  Copyright © 2016 Nick Kibish. All rights reserved.
//

import UIKit

class ImageUploader: NSObject {
    /// Create request
    ///
    /// - parameter userid:   The userid to be passed to web service
    /// - parameter password: The password to be passed to web service
    /// - parameter email:    The email address to be passed to web service
    ///
    /// - returns:            The NSURLRequest that was created
    
    func createRequest (data: NSData, baseUrl: String, HTTPMethod: String, name: String, params: [String: AnyObject]?) -> NSURLRequest {
        let boundary = generateBoundaryString()
        
        let url = NSURL(string: RequestManager.sharedInstance().url(baseUrl))!
        let request = NSMutableURLRequest(URL: url)
        request.HTTPMethod = HTTPMethod
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        request.setValue(Params.Header.token + (User.currentUser()?.token)!, forHTTPHeaderField: Params.Header.authentication)
        
        request.HTTPBody = createBodyWithParameters(data, boundary: boundary, name: name, params: params)
        
        return request
    }
    
    /// Create body of the multipart/form-data request
    ///
    /// - parameter parameters:   The optional dictionary containing keys and values to be passed to web service
    /// - parameter filePathKey:  The optional field name to be used when uploading files. If you supply paths, you must supply filePathKey, too.
    /// - parameter paths:        The optional array of file paths of the files to be uploaded
    /// - parameter boundary:     The multipart/form-data boundary
    ///
    /// - returns:                The NSData of the body of the request
    
    func createBodyWithParameters(data: NSData, boundary: String, name: String, params: [String: AnyObject]?) -> NSData {
        let body = NSMutableData()
        
        if params != nil {
            for param in (params?.enumerate())! {
                body.appendData(String(format: "--%@\r\n", boundary).dataUsingEncoding(NSUTF8StringEncoding)!)
                body.appendData(String(format: "Content-Disposition: form-data; name=\"%@\"\r\n\r\n", param.element.0 ).dataUsingEncoding(NSUTF8StringEncoding)!)
                body.appendData(String(format: "%@\r\n", param.element.1 as! String).dataUsingEncoding(NSUTF8StringEncoding)!)
            }
        }
        
        body.appendData("--\(boundary)\r\n".dataUsingEncoding(NSUTF8StringEncoding)!)
        body.appendData("Content-Disposition: form-data; name=\"\(name)\"; filename=\"avatar.png\"\r\n".dataUsingEncoding(NSUTF8StringEncoding)!)
        body.appendData("Content-Type: \(MIME.Image.png)\r\n\r\n".dataUsingEncoding(NSUTF8StringEncoding)!)
        body.appendData(data)
        body.appendData("\r\n".dataUsingEncoding(NSUTF8StringEncoding)!)
        
        body.appendData("--\(boundary)--\r\n".dataUsingEncoding(NSUTF8StringEncoding)!)
        return body
    }
    
    func paramsFromDict(params: [String: AnyObject]?) -> NSData? {
        if params == nil {
            return nil
        }
        
        do {
            return try NSJSONSerialization.dataWithJSONObject(params!, options: [])
        } catch {
            return nil
        }
    }
    
    /// Create boundary string for multipart/form-data request
    ///
    /// - returns:            The boundary string that consists of "Boundary-" followed by a UUID string.
    
    func generateBoundaryString() -> String {
        return "Boundary-\(NSUUID().UUIDString)"
    }
}
