//
//  UIImage+Ext.swift
//  CitiFleet
//
//  Created by Nick Kibish on 3/16/16.
//  Copyright © 2016 Nick Kibish. All rights reserved.
//

import Foundation

extension UIImage {
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
}