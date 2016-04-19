//
//  APNSManager.swift
//  CitiFleet
//
//  Created by Nick Kibish on 3/24/16.
//  Copyright © 2016 Nick Kibish. All rights reserved.
//

import Foundation

class APNSManager: NSObject {
    let AlreadyRegisteredKey = "AlreadyRegisteredKey"
    var deviceToken: String?
    private static let _sharedManager = APNSManager()
    static var sharedManager: APNSManager {
        get {
            return _sharedManager
        }
    }
    
    func registerForRemoteNotifications() {
        let application = UIApplication.sharedApplication()
        let notificationSettings = UIUserNotificationSettings(forTypes: [.Alert, .Sound], categories: nil)
        application.registerUserNotificationSettings(notificationSettings)
        application.registerForRemoteNotifications()
    }
    
    func registerAPNSToken(deviceToken: NSData?) {
        if (NSUserDefaults.standardUserDefaults().valueForKey(AlreadyRegisteredKey) as? Bool) == true {
            return
        }
        typealias APNSParams = Params.User.APNS
        
        let characterSet: NSCharacterSet = NSCharacterSet( charactersInString: "<>" )
        let deviceTokenString: String = deviceToken!.description
            .stringByTrimmingCharactersInSet( characterSet )
            .stringByReplacingOccurrencesOfString( " ", withString: "" ) as String
        self.deviceToken = deviceTokenString
        
        let params = [
            APNSParams.deviceId: (UIDevice.currentDevice().identifierForVendor?.UUIDString)!,
            APNSParams.registrationId: deviceTokenString
        ]
        RequestManager.sharedInstance().makeSilentRequest(.POST, baseURL: URL.User.APNS.Register, parameters: params) { [weak self] (json, error) -> () in
            if error == nil {
                if let key = self?.AlreadyRegisteredKey {
                    NSUserDefaults.standardUserDefaults().setValue(true, forKey: key)
                }
            }
        }
    }
}
