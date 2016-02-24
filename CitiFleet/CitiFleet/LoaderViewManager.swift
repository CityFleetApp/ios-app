//
//  LoaderViewManager.swift
//  CitiFleet
//
//  Created by Nick Kibish on 2/24/16.
//  Copyright © 2016 Nick Kibish. All rights reserved.
//

import UIKit
import MBProgressHUD

class LoaderViewManager: NSObject {
    class func showLoader() {
        let view = AppDelegate.sharedDelegate().window?.rootViewController?.view
        dispatch_async(dispatch_get_main_queue()) { () -> Void in
            MBProgressHUD.showHUDAddedTo(view, animated: true)
        }
    }
    
    class func hideLoader() {
        let view = AppDelegate.sharedDelegate().window?.rootViewController?.view
        dispatch_async(dispatch_get_main_queue()) { () -> Void in
            MBProgressHUD.hideHUDForView(view, animated: true)
        }
    }
}
