//
//  URL.swift
//  CitiFleet
//
//  Created by Nick Kibish on 2/24/16.
//  Copyright © 2016 Nick Kibish. All rights reserved.
//

import Foundation

struct URL {
    static let Sandbox = "http://104.236.223.160/"
    static let Production = ""
    static let BaseUrl = Sandbox
    struct Login {
        static let Login = ""
        static let SignUp = "users/signup/"
    }
}

struct Params {
    struct Header {
        static let contentType = "Content-Type"
        static let authentication = "Authentication: Token"
        static let json = "application/json"
    }
    struct Login {
        static let username = "username"
        static let password = "password"
        static let email = "email"
        static let phone = "phone"
        static let fullName = "full_name"
        static let hackLicense = "hack_license"
        static let passwordConfirm = "password_confirm"
    }
}