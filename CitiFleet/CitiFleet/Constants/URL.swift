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
    struct Login {
        static let Login = "users/login/"
        static let SignUp = "users/signup/"
    }
    struct Social {
        static let Phones = "users/add-contacts-friends/"
        static let Twitter = "users/add-twitter-friends/"
        static let Facebook = "users/add-facebook-friends/"
        static let Instagram = "users/add-instagram-friends/"
    }
    static let Reports = "reports/"
    static let UploadAvatar = "users/upload-avatar/"
}

struct Params {
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
}

struct Response {
    struct UploadAvatar {
        static let avatar = "avatar"
    }
}