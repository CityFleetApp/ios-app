//
//  AvatarHeaderView.swift
//  CitiFleet
//
//  Created by Nick Kibish on 3/13/16.
//  Copyright © 2016 Nick Kibish. All rights reserved.
//

import UIKit
import Haneke

protocol AvatarXIBName {
    func xibName() -> String
}

class AvatarHeaderView: UIView, AvatarXIBName {
    @IBOutlet var view: UIView!
    @IBOutlet var avatar: UIImageView!
    @IBOutlet var backgroundAvatar: UIImageView!
    @IBOutlet var nameLabel: UILabel!
    
    func xibName() -> String {
        return XIB.AvatarHeaderView.Avatar
    }
    
    init() {
        super.init(frame: CGRectZero)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        NSBundle.mainBundle().loadNibNamed(xibName(), owner: self, options: nil)[0] as! UIView
        var frame = bounds
        frame.size.width = CGRectGetWidth(UIScreen.mainScreen().bounds)
        view.frame = frame
        self.addSubview(view)
    }
    
    var avatarUrl: NSURL! {
        didSet {
            let cache = Shared.imageCache
            cache.fetch(URL: avatarUrl).onSuccess { [weak self] (image) in
                dispatch_async(dispatch_get_main_queue()) {
                    self?.avatarImage = image
                }
            }
        }
    }
    
    var avatarImage: UIImage? {
        get {
            return avatar.image
        }
        set {
            if let image = newValue {
                avatar.image = image
                backgroundAvatar.image = UIImageManager().applyClearBlur(image)
            }
        }
    }

    override func layoutSubviews() {
        view.frame = self.bounds
        view.layoutIfNeeded()
    }
}
