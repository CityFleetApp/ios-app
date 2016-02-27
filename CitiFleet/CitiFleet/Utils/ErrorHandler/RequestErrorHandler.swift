//
//  RequestErrorHandler.swift
//  CitiFleet
//
//  Created by Nick Kibish on 2/26/16.
//  Copyright © 2016 Nick Kibish. All rights reserved.
//

import UIKit

class RequestErrorHandler: NSObject {
    private var error: NSError
    private var title: String?
    
    init(error: NSError, title: String?) {
        self.error = error
        self.title = title
        super.init()
    }
    
    func handle() {
        var message = ErrorString.DefaultMessage
        if let errorText = error.userInfo[Params.Response.serverError] as? String {
            message = errorText
        }
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        let cancelAction = UIAlertAction(title: Titles.cancel, style: .Cancel, handler: nil)
        alert.addAction(cancelAction)
        AppDelegate.sharedDelegate().rootViewController().presentViewController(alert, animated: true, completion: nil)
    }
}
