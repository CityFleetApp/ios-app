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
    static let done = "Done"
    static let error = "Error"
    static let Done = "Done"
    static let ConnectionFailed = "Unable to connect to the internet"
    static let Unknown = "Unknown"
    struct Chat {
        static let TextViewPlaceHolder = "Enter your message.."
    }
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
        static let documentsIsUpToDate = "All up to date"
        static let documentsIsNotUpToDate = "Check your dacuments"
    }
    struct MainScreen {
        static let noMarkersTitle = "Find something"
        static let noMarkersMsg = "Use search to open direction"
    }
    struct MarketPlace {
        static let noPhotos = "Select Photo"
        static let noPhotosMsg = "Select at least one photo"
        
        static let noPrice = "Set the price"
        static let noPriceMsg = "Please, set the prise of the vehicle"
        
        static let noDescription = "Provide the description"
        static let noDescriptionMsg = "Please, provide description of your vehicle"
        
        static let noInstructions = "Provide the instructions"
        static let noInstructionsMsg = "Please, provide the instructions of job"
        
        static let noGoodDescriptionMsg = "Please, provide description of the good"
        
        static let topLabelTitle = "General Goods"
    }
}