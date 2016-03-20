//
//  DialogView.swift
//  CitiFleet
//
//  Created by Nick Kibish on 3/19/16.
//  Copyright © 2016 Nick Kibish. All rights reserved.
//

import UIKit

class DialogView: UIView {
    static let XIBName = "DialogView"
    
    @IBOutlet var containerHeightConstraint: NSLayoutConstraint!
    @IBOutlet var bgImageView: UIImageView!
    @IBOutlet var containerBgImageView: UIImageView!
    @IBOutlet var containerView: UIView!
    @IBOutlet var containerViewBottomSpace: NSLayoutConstraint!
    
    var containerViewHeight: CGFloat!
    var completion: ((AnyObject?, Bool) -> ())!
    
    private var superView: UIView!
    
    class func viewFromNib() -> DialogView {
        let view = NSBundle.mainBundle().loadNibNamed(DialogView.XIBName, owner: self, options: nil).first as! DialogView
        return view
    }
    
    @IBAction func tapView(sender: UITapGestureRecognizer) {
        if !CGRectContainsPoint(containerView.frame, sender.locationInView(self)) {
            hide(nil, closed: true)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        containerViewHeight = containerHeightConstraint.constant
        containerViewBottomSpace.constant = -containerViewHeight
        layoutSubviews()
    }
    
    func show() {
        superView = AppDelegate.sharedDelegate().rootViewController().view
        frame = superView.bounds
        superView.addSubview(self)
        
        bgImageView.image = UIImage.imageWithView(superView).applyDarkEffect()
        setupBluredBackground()
        animateAppearing()
    }
    
    func hide(obj: AnyObject?, closed: Bool) {
        animateDisappearing()
        completion(obj, closed)
    }
    
    internal func animateDisappearing() {
        self.changeContainerPosition(-containerViewHeight) {
            UIView.animateWithDuration(0.25,
                animations: {
                    self.alpha = 0
                }, completion: { (_) in
                    self.removeFromSuperview()
            })
        }
    }
    
    internal func animateAppearing() {
        alpha = 0
        UIView.animateWithDuration(0.25,
            animations: {
                self.alpha = 1
            }, completion: { (completed) in
                self.changeContainerPosition(0, completion: nil)
        })
    }
    
    internal func changeContainerPosition(newPosition: CGFloat, completion: (() -> ())?) {
        self.containerViewBottomSpace.constant = newPosition
        UIView.animateWithDuration(0.25,
            animations: {
                self.layoutIfNeeded()
            }, completion: { (_) in
                completion?()
        })
    }
    
    private func setupBluredBackground() {
        let visualEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .ExtraLight)) as UIVisualEffectView
        visualEffectView.frame = containerBgImageView.bounds
        containerBgImageView.addSubview(visualEffectView)
    }
}
