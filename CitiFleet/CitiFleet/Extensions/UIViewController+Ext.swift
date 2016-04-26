//
//  Montserrat-ExtraBold.swift
//  CitiFleet
//
//  Created by Nick Kibish on 3/11/16.
//  Copyright © 2016 Nick Kibish. All rights reserved.
//

import UIKit

extension UIViewController {
    @IBAction func back(sender: AnyObject) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    func subscribeNotifications() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(openMessage(_:)), name: APNSManager.Notification.NewMessage.rawValue, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(openJobOffer(_:)), name: APNSManager.Notification.NewJobOffer.rawValue, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(openNotification(_:)), name: APNSManager.Notification.NewNotification.rawValue, object: nil)
    }
    
    func openMessage(notification: NSNotification) {
        
    }
    
    func openNotification(notification: NSNotification) {
        
    }
    
    func openJobOffer(notification: NSNotification) {
        
    }
}