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
import ReachabilitySwift
import AFNetworking
import MBProgressHUD
import Haneke

class RequestManager: NSObject {
    typealias ArrayResponse = [AnyObject]?
    typealias DictionaryResponse = [String: AnyObject]?
    
    private static var reachability: Reachability?
    private static var isReachable = true
    private static let shared = RequestManager()
    class func sharedInstance() -> RequestManager {
        return RequestManager.shared
    }
    
    override init() {
        super.init()
        createReachability()
    }
    
    func url(apiUrl:String) -> String {
        return URL.BaseUrl + apiUrl
    }
    
    func header() -> [String:String] {
        var header = [
            Params.Header.contentType: Params.Header.json
        ]
        
        if let token = User.currentUser()?.token {
            header[Params.Header.authentication] = Params.Header.token + token
        }
        
        return header
    }
    
    func shouldStartRequest() -> Bool {
        if RequestManager.isReachable != true {
            let alert = UIAlertController(title: Titles.ConnectionFailed, message: ErrorString.ConnectionFailed, preferredStyle: .Alert)
            let cancelAction = UIAlertAction(title: Titles.cancel, style: .Cancel, handler: nil)
            alert.addAction(cancelAction)
            AppDelegate.sharedDelegate().rootViewController().presentViewController(alert, animated: true, completion: nil)
            return false
        }
        
        LoaderViewManager.showLoader()
        return true
    }
    
    func endRequest(error: NSError?, responseData: NSData?) {
        LoaderViewManager.hideLoader()
        if error == nil {
            return
        }
    }

    func errorWithInfo(error: NSError, data: NSData?) -> NSError {
        if data == nil {
            return error
        }
        let json = JSON(data: data!)
        var errorText: String?
        if let errJson = json.dictionary?.first {
            errorText = errJson.1.array?.first?.string
        }
        var userInfo = error.userInfo
        userInfo[Params.Response.serverError] = errorText
        return NSError(domain: error.domain, code: error.code, userInfo: userInfo)
    }
}

//MARK: - Simple Request
extension RequestManager {
    func makeSilentRequest(method: Alamofire.Method, baseURL: String, parameters: [String:AnyObject]?, completion:((SwiftyJSON.JSON?, NSError?) -> ())) {
        Alamofire.request(method, url(baseURL), headers: header(), parameters: parameters, encoding: .JSON)
            .validate(statusCode: 200..<300)
            .responseData{ response in
                let dataString = String(data: response.data!, encoding: NSUTF8StringEncoding)
                print("Response data: \(dataString)")
                
                self.endRequest(nil, responseData: nil)
                switch response.result {
                case .Success(let data):
                    let json = JSON(data: data)
                    completion(json, nil)
                    break
                case .Failure(let error):
                    let handledError = self.errorWithInfo(error, data: response.data)
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        RequestErrorHandler(error: handledError, title: Titles.error).handle()
                    })
                    completion(nil, handledError)
                    break
                }
        }
    }
    
    func makeRequest(method: Alamofire.Method, baseURL: String, parameters: [String:AnyObject]?, completion:((SwiftyJSON.JSON?, NSError?) -> ())) {
        if !shouldStartRequest() {
            return
        }
        makeSilentRequest(method, baseURL: baseURL, parameters: parameters, completion: completion)
    }
    
    func post(baseURL: String, parameters: [String:AnyObject]?, completion:((SwiftyJSON.JSON?, NSError?) -> ())) {
        makeRequest(.POST, baseURL: baseURL, parameters: parameters, completion: completion)
    }
    
    func get(baseURL: String, parameters: [String:AnyObject]?, completion:((SwiftyJSON.JSON?, NSError?) -> ())) {
        makeRequest(.GET, baseURL: baseURL, parameters: parameters, completion: completion)
    }
    
    func delete(baseURL: String, parameters: [String:AnyObject]?, completion:((SwiftyJSON.JSON?, NSError?) -> ())) {
        makeRequest(.DELETE, baseURL: baseURL, parameters: parameters, completion: completion)
    }
}

//MARK: - Upload Photo
extension RequestManager {
    func uploadPhoto(params: [String: AnyObject]?, data: [NSData], baseUrl: String, HTTPMethod: String, name: String, completion: ((AnyObject?, NSError?) -> ())) {
        let view = AppDelegate.sharedDelegate().rootViewController().view
        let request = ImageUploader().createRequest(data, baseUrl: baseUrl, HTTPMethod: HTTPMethod, name: name, params: params)
        
        let hud = MBProgressHUD.showHUDAddedTo(view, animated: true)
        hud.mode = .AnnularDeterminate
        hud.labelText = "Uploading..."
        
        let manager = AFURLSessionManager(sessionConfiguration: NSURLSessionConfiguration.defaultSessionConfiguration())
        let uploadTask = manager.uploadTaskWithStreamedRequest(request,
            progress: { (progress) -> Void in
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    hud.progress = Float(progress.completedUnitCount) / Float(progress.totalUnitCount)
                })
            },
            completionHandler: { (response, responseObject, error) -> Void in
                if let error = error {
                    print("Response: \(responseObject)")
                    let handledError = self.errorWithInfo(error, data: responseObject as? NSData)
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        hud.hide(true)
                        RequestErrorHandler(error: handledError, title: Titles.error).handle()
                        completion(nil, error)
                    })
                    return
                }
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    hud.customView = UIImageView(image: UIImage(named: Resources.Checkmark))
                    hud.mode = .CustomView
                    hud.labelText = "Done"
                })
                sleep(1)
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    hud.hide(true)
                })
                completion(responseObject, error)
        })
        
        uploadTask.resume()
    }
    
    func saveAvatar(avatarUrlStr: String) {
        let URL = NSURL(string: avatarUrlStr)
        User.currentUser()?.avatarURL = URL
        User.currentUser()?.saveUser()
        
        let cache = Shared.imageCache
        if let URL = URL {
            cache.fetch(URL: URL)
        }
    }
}

//MARK: - Reachability
extension RequestManager {
    private func createReachability() {
        do {
            RequestManager.reachability = try Reachability.reachabilityForInternetConnection()
        } catch {
            return
        }
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "reachabilityChanged:", name: ReachabilityChangedNotification, object: RequestManager.reachability)
        do {
            try RequestManager.reachability?.startNotifier()
        } catch {
            return
        }
    }
    
    func reachabilityChanged(note: NSNotification) {
        let reachability = note.object as! Reachability
        
        if reachability.isReachable() {
            RequestManager.isReachable = true
        } else {
            RequestManager.isReachable = false
        }
    }
}