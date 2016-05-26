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
import AVKit
import AVFoundation

@UIApplicationMain

class AppDelegate: UIResponder, UIApplicationDelegate, UIScrollViewDelegate {
    var window: UIWindow?
    var playerController: AVPlayerViewController?
    var player: AVPlayer?
    
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
        
        return true
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
        SocialManager.sharedInstance.importContactsSilently()
        
        do {
            try playVideo()
        } catch AppError.InvalidResource(let name, let type) {
            debugPrint("Could not find resource \(name).\(type)")
        } catch {
            debugPrint("Generic error")
        }
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

 extension AppDelegate {
    private func playVideo() throws {
        guard let path = NSBundle.mainBundle().pathForResource(Resources.Splash, ofType:Resources.SplashType) else {
            throw AppError.InvalidResource(Resources.Splash, Resources.SplashType)
        }
        player = AVPlayer(URL: NSURL(fileURLWithPath: path))
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(playingStoped(_:)), name: AVPlayerItemDidPlayToEndTimeNotification, object: nil)
        playerController = AVPlayerViewController()
        playerController!.showsPlaybackControls = false
        playerController!
            .view.userInteractionEnabled = false
        playerController!.player = player
        rootViewController().presentViewController(playerController!, animated: false) { [weak self] in
            self?.player?.play()
        }
    }
    
    func playingStoped(notification: NSNotification) {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: AVPlayerItemDidPlayToEndTimeNotification, object: nil)
        playerController?.dismissViewControllerAnimated(false, completion: { [weak self] in
            self?.playerController = nil
            self?.player = nil
        })
    }
 }
 
 enum AppError : ErrorType {
    case InvalidResource(String, String)
 }