//
//  UIColor+HEX.swift
//  CitiFleet
//
//  Created by Nick Kibish on 2/22/16.
//  Copyright © 2016 Nick Kibish. All rights reserved.
//

import UIKit

extension UIColor {
    convenience init(hex:Int, alpha:CGFloat) {
        let red = (hex / 256 / 256) % 256
        let green = (hex / 256) % 256
        let blue = hex % 256
        
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: alpha)
    }
}