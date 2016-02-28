//
//  Strings.swift
//  CitiFleet
//
//  Created by Nick Kibish on 2/26/16.
//  Copyright © 2016 Nick Kibish. All rights reserved.
//

import Foundation

struct StringConstants {
    struct SignUp {
        struct Placeholder {
            static let FullName = "Enter your full name"
            static let Username = "Enter your username"
            static let Phone = "Enter your phone"
            static let HackLicense = "Enter your hack license"
            static let Email = "Enter your email"
            static let Password = "Enter your password"
            static let ConfirmPassword = "Enter your confirm password"
        }
    }
    struct Login {
        struct Placeholder {
            static let Email = "Enter Email"
            static let Password = "Enter Password"
        }
    }
}

struct ErrorString {
    static let DefaultMessage = "Something went wrong"
    struct SignUp {
        static let NotValidPhone = "Enter a valid 11 digit phone number"
        
    }
}