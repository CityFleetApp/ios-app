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
    private static var hud: MBProgressHUD?
    class func showLoader() {
        let view = AppDelegate.sharedDelegate().rootViewController().view
        dispatch_async(dispatch_get_main_queue()) { () -> Void in
            if let existingHud = hud {
                existingHud.hide(false)
            }
            hud = MBProgressHUD.showHUDAddedTo(view, animated: true)
        }
    }
    
    class func hideLoader() {
        dispatch_async(dispatch_get_main_queue()) { () -> Void in
            hud?.hide(true)
        }
    }
    
    class func showDoneLoader(seconds: Int, completion:(()->())?) {
        let view = AppDelegate.sharedDelegate().rootViewController().view
        let hud = MBProgressHUD.showHUDAddedTo(view, animated: true)
        hud.customView = UIImageView(image: UIImage(named: Resources.Checkmark))
        hud.mode = .CustomView
        hud.labelText = "Done"
        
        dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0)) {
            dispatch_async(dispatch_get_main_queue()) { () -> Void in
            }
            sleep(UInt32(seconds))
            dispatch_async(dispatch_get_main_queue()) {
                hud.hide(true)
                if let complation = completion {
                    complation()
                }
            }
        }
    }
    
    class func showDoneLoader(text: String, seconds: Int, completion:(()->())?) {
        let view = AppDelegate.sharedDelegate().rootViewController().view
        let hud = MBProgressHUD.showHUDAddedTo(view, animated: true)
        hud.mode = .Text
        hud.labelText = text
        
        dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0)) {
            dispatch_async(dispatch_get_main_queue()) { () -> Void in
            }
            sleep(UInt32(seconds))
            dispatch_async(dispatch_get_main_queue()) {
                hud.hide(true)
                if let complation = completion {
                    complation()
                }
            }
        }
    }
}
