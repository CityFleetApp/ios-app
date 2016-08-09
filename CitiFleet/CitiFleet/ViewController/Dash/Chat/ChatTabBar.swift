//
//  ChatTabBar.swift
//  CitiFleet
//
//  Created by Nick Kibish on 4/13/16.
//  Copyright © 2016 Nick Kibish. All rights reserved.
//

import UIKit

class ChatTabBar: UITabBarController {
    override func viewDidLoad() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(changeScreen(_:)), name: ChatMainScreenVC.ChangeScreenNotification, object: nil)
    }
    
    func changeScreen(notification: NSNotification) {
        guard let index = notification.userInfo![DictionaryKeys.Chat.ScreenNumber] as? Int else { return }
        selectedIndex = index
    }
}