//
//  Colors.swift
//  CitiFleet
//
//  Created by Nick Kibish on 2/22/16.
//  Copyright © 2016 Nick Kibish. All rights reserved.
//

import UIKit

struct Color {
    struct NavigationBar {
        static let tintColor = 0xffffff
        static let barTint = 0x192c3b
    }
    struct Global {
        static let LightGreen = UIColor(hex: 0x2ec4b6, alpha: 1)
        static let BlueTextColor = UIColor(hex: 0x4c5a76, alpha: 1)
    }
    struct Dash {
        static let SelectedCell = Global.LightGreen
        static let CellTitleText = 0x4c5a76
    }
    struct Login {
        static let PlaceHolderForeground = UIColor(hex: 0x011627, alpha: 0.8)
        static let ErrorPlaceholderForeground = UIColor(red: 1, green: 0, blue: 0, alpha: 0.8)
    }
    struct PickerDialog {
        static let RowTextColor = UIColor(hex: 0x4c5a76, alpha: 1)
    }
    struct Notifcations {
        static let LabelGrayColor = 0x747474
    }
    struct Chat {
        static let CellBackeground = 0xF2F4F8
    }
}