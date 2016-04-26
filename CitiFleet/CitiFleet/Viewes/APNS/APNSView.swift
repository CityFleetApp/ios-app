//
//  APNSView.swift
//  CitiFleet
//
//  Created by Nick Kibish on 4/26/16.
//  Copyright © 2016 Nick Kibish. All rights reserved.
//

import UIKit

class APNSView: UIView {
    @IBOutlet var pushIcon: UIImageView!
    @IBOutlet var pushText: UILabel!
    private var tapGesture: UITapGestureRecognizer!
    var natificationTapped: (() -> ())?
    
    class func viewFromNib() -> APNSView {
        let apnsView = NSBundle.mainBundle().loadNibNamed(XIB.APNSView, owner: self, options: nil).first as! APNSView
        apnsView.tapGesture = UITapGestureRecognizer(target: apnsView, action: #selector(tapped(_:)))
        
        apnsView.frame = CGRect(x: 0, y: -Sizes.Viewes.APNSHeight , width: UIScreen.mainScreen().bounds.width, height: Sizes.Viewes.APNSHeight)
        return apnsView
    }
    
    func show() {
        UIView.animateWithDuration(0.5) { [weak self] in
            if var frame = self?.frame {
                frame.origin.y = 0
                self?.frame = frame
            }
        }
        
        let delayTime = dispatch_time(DISPATCH_TIME_NOW, Int64(3 * Double(NSEC_PER_SEC)))
        dispatch_after(delayTime, dispatch_get_main_queue()) { [weak self] in
            self?.hide()
        }
    }
    
    func hide() {
        UIView.animateWithDuration(0.5, animations: { [weak self] in
            if var frame = self?.frame {
                frame.origin.y = -Sizes.Viewes.APNSHeight
                self?.frame = frame
            }
            }, completion: { [weak self]  (completed) in
                self?.removeFromSuperview()
        })
    }
}

//MARK: Private Methods
extension APNSView {
    func tapped(sender: UITapGestureRecognizer) {
        natificationTapped?()
        hide()
    }
}