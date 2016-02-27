//
//  URL.swift
//  CitiFleet
//
//  Created by Nick Kibish on 2/24/16.
//  Copyright © 2016 Nick Kibish. All rights reserved.
//

import Foundation

struct URL {
    static let Sandbox = "http://citifleet.steelkiwi.com/api/"
    static let Production = ""
    static let BaseUrl = Sandbox
    struct Login {
        static let Login = "userslogin/"
        static let SignUp = "userssignup/"
    }
}

struct Params {
    struct Response {
        static let serverError = "Server Error"
    }
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
        static let token = "token"
    }
}