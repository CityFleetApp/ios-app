//
//  Fonts.swift
//  CitiFleet
//
//  Created by Nick Kibish on 2/22/16.
//  Copyright © 2016 Nick Kibish. All rights reserved.
//

import UIKit

struct FontNames {
    struct Montserrat {
        static let SemiBold = "Montserrat-SemiBold"
        static let Bold = "Montserrat-Bold"
        static let Black = "Montserrat-Black"
        static let Regular = "Montserrat-Regular"
        static let UltraLight = "Montserrat-UltraLight"
        static let Light = "Montserrat-Light"
        static let ExtraBold = "Montserrat-ExtraBold"
    }
}

struct Fonts {
    struct Login {
        static let NavigationTitle = UIFont(name: FontNames.Montserrat.Regular, size: 19)!
        static let SignUpPlaceHolder = UIFont(name: FontNames.Montserrat.Light, size: 14)!
        static let LoginPlaceholder = UIFont(name: FontNames.Montserrat.Light, size: 16.7)!
        static let SignUpTextField = UIFont(name: FontNames.Montserrat.Regular, size: 16.56)!
    }
    struct PickerDialog {
        static let PicerRowFort = UIFont(name: FontNames.Montserrat.Regular, size: 19)!
    }
}