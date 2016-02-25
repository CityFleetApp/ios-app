//
//  UIButton+Ext.swift
//  CitiFleet
//
//  Created by Nick Kibish on 2/25/16.
//  Copyright © 2016 Nick Kibish. All rights reserved.
//

import UIKit

extension UIButton {
    func centerImageAndTitle(spacing: CGFloat) {
        let imageSize = imageView?.frame.size
        let titleSize = titleLabel?.frame.size
        let buttonHeight = CGRectGetHeight(bounds)
        
        if imageSize != nil && titleSize != nil {
            let totalHeight = (imageSize?.height)! + (titleSize?.height)! + spacing
            imageEdgeInsets = UIEdgeInsets(top: -(totalHeight - (imageSize?.height)!), left: 0, bottom: 0, right: -(titleSize?.width)!)
            titleEdgeInsets = UIEdgeInsets(top: 0, left: -(imageSize?.width)!, bottom: -(buttonHeight / 2) + spacing, right: 0)
        }
    }
    
    func centerImageAndTitle() {
        centerImageAndTitle(Sizes.Button.ImageTitleSpacing)
    }
}