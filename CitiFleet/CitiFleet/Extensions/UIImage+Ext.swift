//
//  UIImage+Ext.swift
//  CitiFleet
//
//  Created by Nick Kibish on 3/16/16.
//  Copyright © 2016 Nick Kibish. All rights reserved.
//

import Foundation
import AVFoundation

extension UIImage {
    static func imageWithView(view: UIView) -> UIImage {
        UIGraphicsBeginImageContext(view.frame.size)
        view.drawViewHierarchyInRect(view.bounds, afterScreenUpdates: true)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
    
    func normalizedImage() -> UIImage {
        if (self.imageOrientation == UIImageOrientation.Up) {
            return self;
        }
        
        UIGraphicsBeginImageContextWithOptions(self.size, false, self.scale);
        let rect = CGRect(x: 0, y: 0, width: self.size.width, height: self.size.height)
        self.drawInRect(rect)
        
        let normalizedImage : UIImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext();
        return normalizedImage;
    }
    
    func scaleToMaxSide(side: CGFloat) -> UIImage {
        let cof = min(1, CGFloat(1024) / max(size.width, size.height))
        let boundingRect = CGSizeApplyAffineTransform(size, CGAffineTransformMakeScale(cof, cof))
        
        UIGraphicsBeginImageContextWithOptions(size, false, cof)
        drawInRect(CGRect(origin: CGPointZero, size: size))
        
        let scaledImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return scaledImage
    }
}