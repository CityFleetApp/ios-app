 //

 //  AppDelegate.swift
//  CitiFleet
//
//  Created by Nick Kibish on 2/22/16.
//  Copyright © 2016 Nick Kibish. All rights reserved.
//

import UIKit
import Fabric
import Crashlytics
import FBSDKCoreKit
import FBSDKLoginKit
import TwitterKit
import Alamofire
import GoogleMaps

@UIApplicationMain

class AppDelegate: UIResponder, UIApplicationDelegate, UIScrollViewDelegate {
    var window: UIWindow?
    
    class func sharedDelegate() -> AppDelegate {
        return UIApplication.sharedApplication().delegate as! AppDelegate
    }
    
    func rootViewController() -> UIViewController {
        var rootViewController = topViewController((self.window?.rootViewController)!)
        if let navigationController = rootViewController.navigationController {
            rootViewController = navigationController.topViewController!
        }
        return rootViewController
    }
    
    func topViewController(viewController: UIViewController) -> UIViewController {
        if let presentedVC = viewController.presentedViewController {
            return topViewController(presentedVC)
        }
        return viewController
    }

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        application.statusBarStyle = .LightContent
        GMSServices.provideAPIKey(Keys.GoogleMaps)
        Fabric.with([Crashlytics.self, Twitter.self])
        FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
        
        test()
        
        return true
    }
    
    func test() {
        let r1 = Report(lat: 0, lon: 0, type: .Police)
        let r2 = Report(lat: 0, lon: 0, type: .Police)
        
        r1.id = 1
        r2.id = 2
        
        let r3 = Report(lat: 0, lon: 0, type: .Police)
        let r4 = Report(lat: 0, lon: 0, type: .Police)
        
        r3.id = 1
        r4.id = 2
        
        var set1: Set<Report> = Set()
        set1.insert(r1)
        set1.insert(r2)
//        set1.insert(r3)
//        set1.insert(r4)
        let set2: Set<Report> = Set([r3, r4])
        
        let set3 = set2.union(set2.intersect(set1)) //set1.intersect(set2).union(set2)
        
    }
    
    func application(application: UIApplication, openURL url: NSURL, sourceApplication: String?, annotation: AnyObject) -> Bool {
        if url.scheme.lowercaseString == Keys.Instagram.Scheme.lowercaseString {
            SocialManager.sharedInstance.loginRequest(url)
            return true
        }
        return FBSDKApplicationDelegate.sharedInstance().application(application, openURL: url, sourceApplication: sourceApplication, annotation: annotation)
    }

    func applicationDidBecomeActive(application: UIApplication) {
        showLoginViewController()
        Settings.sharedSettings.applySettings()
        LoaderViewManager.hideLoader()
        UINavigationBar.appearance().tintColor = UIColor(hex: Color.NavigationBar.tintColor, alpha: 1)
        UINavigationBar.appearance().barTintColor = UIColor(hex: Color.NavigationBar.barTint, alpha: 1)
        UINavigationBar.appearance().titleTextAttributes = [ NSFontAttributeName: Fonts.Login.NavigationTitle,  NSForegroundColorAttributeName: UIColor.whiteColor()]
        APNSManager.sharedManager.registerForRemoteNotifications()
    }
    
    func showLoginViewController() {
        if rootViewController().restorationIdentifier == ViewControllerID.Login {
            return
        }
        if User.currentUser() == nil {
            let storyboard = UIStoryboard(name: Storyboard.LoginStoryboard, bundle: NSBundle.mainBundle())
            let loginNavController = storyboard.instantiateViewControllerWithIdentifier(ViewControllerID.Login)
            dispatch_async(dispatch_get_main_queue(), { [weak self] () -> Void in
                self?.rootViewController().presentViewController(loginNavController, animated: true, completion: nil)
            })
        }
    }
    
    func application(application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: NSError) {
        
    }
    
    func application(application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData) {
        APNSManager.sharedManager.registerAPNSToken(deviceToken)
    }
    
    func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject]) {
        print("notification userInfo: \(userInfo)")
        APNSManager.sharedManager.didReceiveRemoteNotification(userInfo)
    }
}
