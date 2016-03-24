//
//  APNSManager.swift
//  CitiFleet
//
//  Created by Nick Kibish on 3/24/16.
//  Copyright © 2016 Nick Kibish. All rights reserved.
//

import Foundation

class APNSManager: NSObject {
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
        RequestManager.sharedInstance().makeSilentRequest(.POST, baseURL: URL.User.APNS.Register, parameters: params) { (json, error) -> () in
            
        }
    }
}
