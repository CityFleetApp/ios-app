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
    static let Socket = "ws://104.236.223.160/"
    static let Sandbox = "http://104.236.223.160/api/" //"http://citifleet.steelkiwi.com/api/"
    static let Production = ""
    static let BaseUrl = Sandbox
    struct User {
        static let Info = "users/info/"
        struct APNS {
            static let Register = "users/devicesdevice/apns/"
        }
        struct Profile {
            static let Profile = "users/profile/"
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
        static let types = "marketplace/types/"
        static let color = "marketplace/colors/"
        static let seats = "marketplace/seats/"
        static let make = "marketplace/cars/make/"
        static let model = "marketplace/cars/model/"
        
        static let rent = "marketplace/cars/posting/rent/"
        static let sale = "marketplace/cars/posting/sale/"
        
        static let JOPost = "marketplace/offers/posting/"
        static let GeneralGoods = "marketplace/goods/posting/"
        
        static let JobOffers = "marketplace/offers/"
        static let AcceptJob = "/accept_job/"
        static let RequestJob = "/request_job/"
        
        static let ManagePosts = "marketplace/manage-posts/"
        struct Photos {
            static let goodPhotos = "marketplace/goodsphotos/"
            static let carPhotos = "marketplace/carphotos/"
        }
    }
    struct Reports {
        static let Reports = "reports/"
        static let Nearby = "reports/nearby/"
        static let Map = "reports/map/"
        static let Confirm = "/confirm_report/"
        static let Deny = "/deny_report/"
        
        static let Friends = "reports/friends/"
    }
    static let BenefitsList = "benefits/"
    struct Chat {
        static let Friends = "chat/friends/"
        static let Rooms = "chat/rooms/"
        static let Messages = "/messages/"
    }
}

struct Params {
    static let id = "id"
    struct Chat {
        static let text = "text"
        static let room = "room"
        static let created = "created"
        static let author = "author_info"
        static let method = "method"
        static let name = "name"
        static let label = "label"
        static let members = "participants"
        static let participants = "participants_info"
        static let lastMessage = "last_message"
        static let lastMessageDate = "last_message_timestamp"
    }
    struct User {
        struct APNS {
            static let registrationId = "registration_id" // APNS Token
            static let deviceId = "device_id" // UDID / UIDevice.identifierForVendor()
            static let active = "active" // Inactive devices will not be sent notifications
        }
        struct Profile {
            static let carMake = "car_make"
            static let carModel = "car_model"
            static let bio = "bio"
            static let username = "username"
            static let carYear = "car_year"
            static let carType = "car_type"
            static let phone = "phone"
            static let carColor = "car_color"
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
    static let count = "count"
    static let next = "next"
    static let previous = "previous"
    static let results = "results"
    
    struct UserInfo {
        static let Latitude = "lat"
        static let Longitude = "lng"
        static let Bio = "bio"
        static let Drives = "drives"
        static let Username = "username"
        static let Email = "email"
        static let Phone = "phone"
        static let FullName = "full_name"
        static let HackLicense = "hack_license"
        static let Token = "token"
        static let AvatarUrl = "avatar_url"
        struct Info {
            static let jobsCompleted = "jobs_completed"
            static let rating = "rating"
            static let drives = "drives"
            static let bio = "bio"
            static let documentsUpToDate = "documents_up_to_date"
            static let avatarURL = "avatar_url"
        }
        struct Profile {
            static let carMake = "car_make"
            static let carModel = "car_model"
            static let bio = "bio"
            static let username = "username"
            static let carYear = "car_year"
            static let carType = "car_type"
            static let phone = "phone"
            static let carColor = "car_color"
            static let carMakeDisplay = "car_make_display"
            static let carModelDisplay = "car_model_display"
            static let carColorDisplay = "car_color_display"
            static let carTypeDisplay = "car_type_display"
        }
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
        static let created = "created"
        struct JobOffers {
            static let id = "id"
            static let pickupDatetime = "pickup_datetime"
            static let pickupAddress = "pickup_address"
            static let destination = "destination"
            static let fare = "fare"
            static let gratuity = "gratuity"
            static let vehicleType = "vehicle_type"
            static let suite = "suite"
            static let jobType = "job_type"
            static let instructions = "instructions"
            static let status = "status"
            static let created = "created"
        }
        struct ManagePost {
            static let postType = "posting_type"
        }
    }
    struct Chat {
        static let Name = "name"
        static let Label = "label"
        static let participantsInfo = "participants_info"
        static let participants = "participants"
        static let messageType = "type"
        static let text = "text"
        static let room = "room"
        static let roomID = "room_id"
        static let authorInfo = "author_info"
        static let _author = "author"
        static let unreadMessages = "unseen"
        static let created = "created"
        static let lastMessage = "last_message"
    }
}
