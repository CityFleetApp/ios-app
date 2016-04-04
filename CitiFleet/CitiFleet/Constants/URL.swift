//
//  URL.swift
//  CitiFleet
//
//  Created by Nick Kibish on 2/24/16.
//  Copyright © 2016 Nick Kibish. All rights reserved.
//

import Foundation

struct MIME {
    struct Image {
        static let png = "image/png"
    }
}

struct URL {
    static let Sandbox = "http://citifleet.steelkiwi.com/api/"
    static let Production = ""
    static let BaseUrl = Sandbox
    struct User {
        struct APNS {
            static let Register = "users/devicesdevice/apns/"
        }
    }
    struct Login {
        static let Login = "users/login/"
        static let SignUp = "users/signup/"
        static let ResetPassword = "users/change-password/"
    }
    struct Social {
        static let Phones = "users/add-contacts-friends/"
        static let Twitter = "users/add-twitter-friends/"
        static let Facebook = "users/add-facebook-friends/"
        static let Instagram = "users/add-instagram-friends/"
    }
    struct LegalAid {
        static let DMVLawyer = "legalaid/dmv-lawyers/"
        static let TLCLawyer = "legalaid/tlc-lawyers/"
        static let Brockers = "legalaid/insurance/"
        static let Accountants = "legalaid/accouting/"
        static let Locations = "legalaid/locations/"
    }
    struct Profile {
        static let vehiclPhoto = "users/photos/"
        static let UploadAvatar = "users/upload-avatar/"
    }
    struct Notifications {
        static let notifications = "notifications/"
        static let markSeen = "/mark-seen/"
    }
    struct DOCManagement {
        static let Documents = "documents/"
    }
    struct MarketPlate {
        static let makes = "marketplace/cars/make/"
        static let models = "marketplace/cars/model/"
    }
    struct Marketplace {
        static let carsForRent = "marketplace/cars/sale/"
        static let carsForSale = "marketplace/cars/rent/"
        static let goodsForSale = "marketplace/goods/"
        
        static let fuel = "marketplace/fuel/"
        static let type = "marketplace/types/"
        static let color = "marketplace/colors/"
        static let seats = "marketplace/seats/"
        static let make = "marketplace/cars/make/"
        static let model = "marketplace/cars/model/"
        
        static let rent = "marketplace/cars/posting/rent/"
        static let sale = "marketplace/cars/posting/sale/"
        
        static let JOPost = "marketplace/offers/posting/"
        static let GeneralGoods = "marketplace/goods/posting/"
    }
    static let Reports = "reports/"
    static let BenefitsList = "benefits/"
}

struct Params {
    struct User {
        struct APNS {
            static let registrationId = "registration_id" // APNS Token
            static let deviceId = "device_id" // UDID / UIDevice.identifierForVendor()
            static let active = "active" // Inactive devices will not be sent notifications
        }
    }
    
    struct Response {
        static let serverError = "Server Error"
    }
    struct Header {
        static let contentType = "Content-Type"
        static let authentication = "Authorization"
        static let json = "application/json"
        static let token = "token "
    }
    struct Login {
        static let username = "username"
        static let password = "password"
        static let email = "email"
        static let phone = "phone"
        static let fullName = "full_name"
        static let hackLicense = "hack_license"
        static let passwordConfirm = "password_confirm"
        static let token = "token"
        static let avatarUrl = "avatar_url"
    }
    struct ResetPassword {
        static let currentPassword = "old_password"
        static let newPassword = "password"
        static let newConfirmPassword = "password_confirm"
    }
    struct Report {
        static let reportType = "report_type"
        static let latitude = "lat"
        static let longitude = "lng"
    }
    struct Social {
        static let phones = "contacts"
        static let token = "token"
        static let tokenSecret = "token_secret"
    }
    struct LegalAid {
        static let location = "location"
    }
    struct DOCManagement {
        static let id = "id"
        static let docType = "document_type"
        static let expiryDate = "expiry_date"
        static let plateNumber = "plate_number"
        static let photo = "file"
    }
    struct Posting {
        static let make = "make"
        static let model = "model"
        static let type = "type"
        static let color = "color"
        static let year = "year"
        static let fuel = "fuel"
        static let seats = "seats"
        static let price = "price"
        static let description = "description"
        static let photos = "photos"
        
        struct JOPosting {
            static let pickupDatetime = "pickup_datetime"
            static let pickupAddress = "pickup_address"
            static let destination = "destination"
            static let fare = "fare"
            static let gratuity = "gratuity"
            static let vehicleType = "vehicle_type"
            static let suite = "suite"
            static let jobType = "job_type"
            static let instructions = "instructions"
        }
        
        struct GeneralGoods {
            static let item = "item"
            static let price = "price"
            static let condition = "condition"
            static let description = "description"
            static let photos = "photos"
        }
    }
}

struct Response {
    struct UserInfo {
        static let Bio = "bio"
        static let Drives = "drives"
        static let Username = "username"
        static let Email = "email"
        static let Phone = "phone"
        static let FullName = "full_name"
        static let HackLicense = "hack_license"
        static let Token = "token"
        static let AvatarUrl = "avatar_url"
    }
    struct UploadAvatar {
        static let avatar = "avatar"
    }
    struct Benefits {
        static let ImageURL = "image_thumbnail"
        static let Barcode = "barcode"
        static let Title = "name"
    }
    struct LegalAid {
        static let id = "id"
        static let name = "name"
        struct Actor {
            static let name = "name"
            static let years = "years_of_experience"
            static let rating = "rating"
            static let phone = "phone"
            static let address = "address"
        }
    }
    struct VehiclPhoto {
        static let file = "file"
        static let id = "id"
        static let thumbnail  = "thumbnail"
    }
    struct Notifications {
        static let id = "id"
        static let title = "title"
        static let message = "message"
        static let date = "created"
        static let unseen = "unseen"
    }
    struct Marketplace {
        static let id = "id"
        static let itemName = "item"
        static let price = "price"
        static let condition = "condition"
        static let itemDescription = "description"
        static let photos = "photos"
        static let make = "make"
        static let model = "model"
        static let carType = "type"
        static let color = "color"
        static let year = "year"
        static let fuel = "fuel"
        static let seats = "seats"
        static let photoSize = "dimensions"
        struct JobOffers {
            static let id = "id"
            static let pickupDatetime = "pickup_datetime"
            static let pickupAddress = "pickup_address"
            static let destination = "destination"
            static let fare = "fare"
            static let gratuity = "gratuity"
            static let vehicle_type = "vehicle_type"
            static let suite = "suite"
            static let jobType = "job_type"
            static let instructions = "instructions"
            static let status = "status"
            static let created = "created"
        }
    }
}