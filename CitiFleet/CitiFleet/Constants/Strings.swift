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
    struct ChangePassword {
        struct Placeholder {
            static let oldPass = "Enter your current password"
            static let newPass = "Enter your new password"
            static let newConfirmPass = "Enter your confirm password"
        }
    }
}

struct ErrorString {
    static let DefaultMessage = "Something went wrong"
    static let ConnectionFailed = "Please, check your internet settings"
    struct SignUp {
        static let NotValidPhone = "Enter a valid 10 digit phone number"
        static let IncorrectPassword = "Must be 8 characters with 1 number"
    }
    struct Social {
        static let localContactsAccessDenied = "Unable to get contacts. Please open system settings and give access to contfacs for CitiFleet"
    }
}