//
//  ConfirmPasswordRule.swift
//  CitiFleet
//
//  Created by Nick Kibish on 2/22/16.
//  Copyright © 2016 Nick Kibish. All rights reserved.
//

import SwiftValidator

class ConfirmPasswordRule: RegexRule {
    static let regex = "^(?=.*?[a-z])(?=.*?[0-9]).{8,}$"
    private var confirmTextField: UITextField?
    
    convenience init(textField: UITextField, message: String = "Invalid password confirmation") {
        self.init(regex: ConfirmPasswordRule.regex, message : message)
        confirmTextField = textField
    }
    
    override func validate(value: String) -> Bool {
        if value == confirmTextField?.text {
            return super.validate(value)
        }
        return false
    }
}
