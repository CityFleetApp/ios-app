//
//  Titles.swift
//  CitiFleet
//
//  Created by Nick Kibish on 2/26/16.
//  Copyright © 2016 Nick Kibish. All rights reserved.
//

import Foundation

struct Titles {
    static let cancel = "Cancel"
    static let error = "Error"
    static let ConnectionFailed = "Unable to connect to the internet"
    static let Unknown = "Unknown"
    struct Dash {
        static let openCamera = "Take a photo"
        static let openLibrary = "Photo Library"
    }
    struct LegalAid {
        static let noLocationsTitle = "No Locations"
        static let noLocationsMsg = "There are no locations"
    }
    struct Profile {
        static let deletePhotoTitle = "Delete photo"
        static let deletePhotoMsg = "Are you sure you want to delete this photo?"
    }
    struct MainScreen {
        static let noMarkersTitle = "Find something"
        static let noMarkersMsg = "Use search to open direction"
    }
}