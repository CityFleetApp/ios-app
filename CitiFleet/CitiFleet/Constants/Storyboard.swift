//
//  Storyboard.swift
//  CitiFleet
//
//  Created by Nick Kibish on 2/26/16.
//  Copyright © 2016 Nick Kibish. All rights reserved.
//

import Foundation

struct Storyboard {
    static let LoginStoryboard = "Login"
    static let DashStoryboard = "Dash"
}

struct XIB {
    static let ReportXIB = "ReportsView"
    static let BarcodeXIB = "BarcodeView"
    static let LegalAidXIB = "LegalAid"
    static let PickerDialog = "PickerDialog"
    static let DOCManagementDatePicekr = "DOCManagementDatePicker"
    struct AvatarHeaderView {
        static let Avatar = "AvatarHeaderView"
        static let Camera = "AvatarCameraView"
        static let Rating = "AvatarRatingView"
    }
}

struct ViewControllerID {
    static let Login = "LoginNC"
    static let Dash = "DashContainerVC"
}

struct CellID {
    static let BenefitCellID = "BenefitsCollectionViewCell"
    static let NotificationCell = "NotificationCell"
    struct LegalAidCells {
        static let ContactCell = "LegalAidContactCell"
    }
    struct Profile {
        static let VehiclePhotoCell = "VehiclePhotoCell"
    }
    
}

struct SegueID {
    static let Dash2Profile = "Dash2Profile"
    struct LegalAid2Details {
        static let DMWLawyers = "DMWLawyers"
        static let TLCLawyers = "TLCLawyers"
        static let Accountants = "Accountants"
        static let Brokers = "Brokers"
    }
}