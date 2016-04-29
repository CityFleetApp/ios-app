//
//  Montserrat-ExtraBold.swift
//  CitiFleet
//
//  Created by Nick Kibish on 3/11/16.
//  Copyright © 2016 Nick Kibish. All rights reserved.
//

import UIKit
import Haneke


extension UIViewController {
    public override class func initialize() {
        struct Static {
            static var token: dispatch_once_t = 0
        }
        
        if self !== UIViewController.self {
            return
        }
        
        dispatch_once(&Static.token) {
            addMethod(#selector(viewWillAppear(_:)), swizzledSelector: #selector(ext_viewWillAppear(_:)))
            addMethod(#selector(viewDidDisappear(_:)), swizzledSelector: #selector(ext_viewDidDisappear(_:)))
        }
    }
    
    private class func addMethod(originalSelector: Selector, swizzledSelector: Selector) {
        let originalMethod = class_getInstanceMethod(self, originalSelector)
        let swizzledMethod = class_getInstanceMethod(self, swizzledSelector)
        
        let didAddMethod = class_addMethod(self, originalSelector, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod))
        
        if didAddMethod {
            class_replaceMethod(self, swizzledSelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod))
        } else {
            method_exchangeImplementations(originalMethod, swizzledMethod)
        }
    }
    
    func ext_viewWillAppear(animated: Bool) {
        self.ext_viewWillAppear(animated)
        subscribeNotifications()
    }
    
    func ext_viewDidDisappear(animated: Bool) {
        self.ext_viewDidDisappear(animated)
        unsubscribe()
    }
    
    @IBAction func back(sender: AnyObject) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    func subscribeNotifications() {
        if self.isKindOfClass(NSClassFromString("UIInputWindowController")!) {
            return
        }
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(openMessage(_:)), name: APNSManager.Notification.NewMessage.rawValue, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(openJobOffer(_:)), name: APNSManager.Notification.NewJobOffer.rawValue, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(openAwarderJobOffer(_:)), name: APNSManager.Notification.JobOfferAwarded.rawValue, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(openNotification(_:)), name: APNSManager.Notification.NewNotification.rawValue, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(openRateDriver(_:)), name: APNSManager.Notification.JobOfferCompleted.rawValue, object: nil)
    }
    
    func unsubscribe() {
        if self.isKindOfClass(NSClassFromString("UIInputWindowController")!) {
            return
        }
        NSNotificationCenter.defaultCenter().removeObserver(self, name: APNSManager.Notification.NewMessage.rawValue, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: APNSManager.Notification.NewJobOffer.rawValue, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: APNSManager.Notification.NewNotification.rawValue, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: APNSManager.Notification.JobOfferAwarded.rawValue, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: APNSManager.Notification.JobOfferCompleted.rawValue, object: nil)
    }
    
    func openMessage(notification: NSNotification) {
        let apnsView = APNSView.viewFromNib()
        apnsView.pushIcon.layer.cornerRadius = apnsView.pushIcon.frame.width / 2
        
        if let message = notification.object as? Message {
            getRootView().addSubview(apnsView)
            apnsView.pushText.text = message.message
            
            apnsView.natificationTapped = { [weak self] in
                let room = ChatRoom()
                room.id = message.roomId
                let chatVC = ChatVC.viewControllerFromStoryboard()
                chatVC.room = room
                
                self?.getNavigationController()?.pushViewController(chatVC, animated: true)
                apnsView.hide()
            }
            
            if let url = message.author?.avatarURL {
                apnsView.pushIcon.hnk_setImageFromURL(url)
                let cache = Shared.imageCache
                cache.fetch(URL: url).onSuccess { image in
                    dispatch_async(dispatch_get_main_queue()) {
                        apnsView.pushIcon.image = image
                        apnsView.show()
                    }
                }
            } else {
                apnsView.pushIcon.image = UIImage(named: Resources.NoAvatarIc)
                apnsView.show()
            }
        }
    }
    
    func openNotification(notification: NSNotification) {
        
    }
    
    func openJobOffer(notification: NSNotification) {
        if let job = notification.object as? JobOffer {
            openJob(false, job: job)
        }
    }
    
    func openAwarderJobOffer(notification: NSNotification) {
        if let job = notification.object as? JobOffer {
            openJob(true, job: job)
        }
    }
    
    func openRateDriver(notification: NSNotification) {
        if let job = notification.object as? JobOffer {
            let apnsView = APNSView.viewFromNib()
            getRootView().addSubview(apnsView)
            apnsView.pushText.text = job.jobTitle
            apnsView.pushIcon.image = UIImage(named: Resources.Notification.JobOffer)
            
            apnsView.natificationTapped = { [weak self] in
                let urlStr = "\(URL.Marketplace.JobOffers)\(job.id!)/"
                RequestManager.sharedInstance().get(urlStr, parameters: nil, completion: { (json, error) in
                    if let obj = json?.dictionaryObject {
                        let jobOffer = JobOffer(json: obj)
                        jobOffer.driverName = job.driverName
                        let vc = JobOfferCompletedByUserVC.viewControllerFromStoryboard()
                        vc.jobOffer = jobOffer
                        self?.getNavigationController()?.pushViewController(vc, animated: true)
                    }
                })
            }
            
            apnsView.show()
        }
    }
}

//MARK: - Private Methods
extension UIViewController {
    private func openJob(isAwarder: Bool, job: JobOffer) {
        let apnsView = APNSView.viewFromNib()
        getRootView().addSubview(apnsView)
        apnsView.pushText.text = job.jobTitle
        apnsView.pushIcon.image = UIImage(named: Resources.Notification.JobOffer)
        
        apnsView.natificationTapped = { [weak self] in
            let urlStr = "\(URL.Marketplace.JobOffers)\(job.id!)/"
            RequestManager.sharedInstance().get(urlStr, parameters: nil, completion: { (json, error) in
                if let obj = json?.dictionaryObject {
                    let job = JobOffer(json: obj)
                    let vc = isAwarder ? JobOfferAwardedVC.viewControllerFromStoryboard() : JobOfferInfoVC.viewControllerFromStoryboard()
                    vc.job = job
                    self?.getNavigationController()?.pushViewController(vc, animated: true)
                }
            })
        }
        
        apnsView.show()
    }
    
    private func getRootView() -> UIView {
        if let root = AppDelegate.sharedDelegate().rootViewController() as? RootVC {
            return root.view
        } else if let _ = AppDelegate.sharedDelegate().rootViewController().presentingViewController as? RootVC {
            return AppDelegate.sharedDelegate().rootViewController().view
        }
        return UIView()
    }
    
    private func getNavigationController() -> UINavigationController? {
        var navController: UINavigationController?
        for vc in AppDelegate.sharedDelegate().rootViewController().childViewControllers {
            if vc.isKindOfClass(UINavigationController) {
                navController = vc as? UINavigationController
            }
        }
        return navController
    }
}

extension UINavigationController {
    override func subscribeNotifications() {
        
    }
    
    override func unsubscribe() {
        
    }
}