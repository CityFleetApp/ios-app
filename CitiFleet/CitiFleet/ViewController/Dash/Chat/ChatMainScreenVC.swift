//
//  ChatMainScreenVC.swift
//  CitiFleet
//
//  Created by Nick Kibish on 4/13/16.
//  Copyright © 2016 Nick Kibish. All rights reserved.
//

import UIKit

class ChatMainScreenVC: UIViewController {
    private enum SelectedScreen {
        case Contacts
        case Recent
    }
    private var selectedScreen = SelectedScreen.Contacts
    
    static let ChangeScreenNotification = "ChangeScreenNotification"
    
    @IBOutlet var underlineView: UIView!
    @IBOutlet var underlinePosition: NSLayoutConstraint!
    
    override func viewWillAppear(animated: Bool) {
        navigationController?.navigationBar.hidden = false
        setupUnderlinePosition(false)
    }
}

//MARK: - Private methods
extension ChatMainScreenVC {
    private func setupUnderlinePosition(animated: Bool = true) {
        let position = (underlineView.bounds.width / 2) * (selectedScreen == .Contacts ? -1 : 1)
        let duration = animated ? 0.25 : 0
        underlinePosition.constant = position
        UIView.animateWithDuration(duration) { [weak self] in
            self?.view.layoutIfNeeded()
        }
    }
    
    private func postNotification() {
        let obj = [DictionaryKeys.Chat.ScreenNumber: (selectedScreen == .Contacts ? 0 : 1)]
        let changeScreennotification =  NSNotification(name: ChatMainScreenVC.ChangeScreenNotification, object: nil, userInfo: obj)
        NSNotificationCenter.defaultCenter().postNotification(changeScreennotification)
    }
}

//MARK: - Actions
extension ChatMainScreenVC {
    @IBAction func addRoom(sender: AnyObject) {
        if let vc = storyboard?.instantiateViewControllerWithIdentifier(ContactListVC.StoryboardID) as? ContactListVC {
            let navigationController = UINavigationController()
            navigationController.viewControllers = [vc]
            presentViewController(navigationController, animated: true, completion: nil)
            vc.selectionCompleted = { [weak self] (users) in
                if let users = users {
                    RequestManager.sharedInstance().postRoom(Array(users), completion: { (room, error) in
                        if error == nil {
                            dispatch_async(dispatch_get_main_queue(), { [weak self] in
                                let vc = ChatVC.viewControllerFromStoryboard()
                                vc.room = room
                                self?.navigationController?.pushViewController(vc, animated: true)
                                })
                        }
                    })
                }
            }
        }
    }
    
    @IBAction func contactsClicked(sender: AnyObject) {
        selectedScreen = .Contacts
        setupUnderlinePosition()
        postNotification()
    }
    
    @IBAction func recentClicked(sender: AnyObject) {
        selectedScreen = .Recent
        setupUnderlinePosition()
        postNotification()
    }
}