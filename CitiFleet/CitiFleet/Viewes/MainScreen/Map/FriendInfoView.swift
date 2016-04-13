//
//  FriendInfoView.swift
//  CitiFleet
//
//  Created by Nick Kibish on 4/12/16.
//  Copyright © 2016 Nick Kibish. All rights reserved.
//

import UIKit
import Haneke

class FriendInfoView: UIView {
    private static let NibName = "FriendInfoView"
    private let FriendInfoHeight: CGFloat = 150
    
    @IBOutlet var userAvatar: UIImageView!
    @IBOutlet var userNameLbl: UILabel!
    
    var friend: Friend! {
        didSet {
            userNameLbl.text = friend.fullName
            userAvatar.image = UIImage(named: Resources.NoAvatarIc)
            if let url = friend.avatarURL {
                userAvatar.hnk_setImageFromURL(url)
            }
        }
    }
    
    class func viewFromNib() -> FriendInfoView {
        let view = NSBundle.mainBundle().loadNibNamed(FriendInfoView.NibName, owner: self, options: nil).first as! FriendInfoView
        return view
    }
    
    func showView() {
        UIView.animateWithDuration(0.25) { [weak self] in
            if self == nil {
                return
            }
            self?.frame = CGRect(x: 0, y: 0, width: UIScreen.mainScreen().bounds.width, height: (self?.FriendInfoHeight)!)
        }
    }
    
    func hideView() {
        UIView.animateWithDuration(0.25) { [weak self] in
            if self == nil {
                return
            }
            self?.frame = CGRect(x: 0, y: -self!.FriendInfoHeight, width: UIScreen.mainScreen().bounds.width, height: (self?.FriendInfoHeight)!)
        }
    }
}

extension FriendInfoView {
    @IBAction func chatWithFriend(sender: AnyObject) {
        self.hideView()
    }
}