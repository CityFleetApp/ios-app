//
//  ResetPasswordVC.swift
//  CitiFleet
//
//  Created by Nick Kibish on 3/10/16.
//  Copyright © 2016 Nick Kibish. All rights reserved.
//

import UIKit
import SwiftValidator

class ResetPasswordVC: UITableViewController {
    private typealias Placeholder = StringConstants.ChangePassword.Placeholder
    
    @IBOutlet var currentPasswordTF: UITextField!
    @IBOutlet var newPasswordTF: UITextField!
    @IBOutlet var confirmNewPassTF: UITextField!
    
    private let validator = Validator()
    private var textFields: [UITextField]?
    private var placeholderText = [
        Placeholder.oldPass,
        Placeholder.newPass,
        Placeholder.newConfirmPass
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textFields = [
            currentPasswordTF,
            newPasswordTF,
            confirmNewPassTF
        ]
        addFieldsToValidate()
        setDefaultPlaceholders()
    }
    
    private func setDefaultPlaceholders() {
        for i in 0..<textFields!.count {
            textFields![i].setStandardSignUpPlaceHolder(placeholderText[i])
        }
    }
    
    private func addFieldsToValidate() {
        validator.registerField(currentPasswordTF, rules: [RequiredRule()])
        validator.registerField(newPasswordTF, rules: [RequiredRule(), PasswordRule(regex: ConfirmPasswordRule.regex, message: ErrorString.SignUp.IncorrectPassword)]);
        validator.registerField(confirmNewPassTF, rules: [RequiredRule(), ConfirmPasswordRule(textField: newPasswordTF)])
    }
}

extension ResetPasswordVC {
    @IBAction func changePassword(sender: AnyObject) {
        validator.validate { (errors) -> Void in
            if errors.count > 0 {
                self.handleValidationErrors(errors)
                return
            }
            self.sendRequest()
        }
    }
    
    func handleValidationErrors(errors: [UITextField : ValidationError]) {
        for error in errors {
            error.0.text = ""
            error.0.setErrorPlaceholder(error.1.errorMessage)
        }
    }
    
    func sendRequest() {
        let currPassword = currentPasswordTF.text
        let newPassword = newPasswordTF.text
        let newConfirmPassword = newPasswordTF.text
        
        RequestManager.sharedInstance().resetPassword(currPassword!, newPassword: newPassword!, newConfirmPassword: newConfirmPassword!) { (response, error) -> () in
            if error == nil {
                LoaderViewManager.showDoneLoader(1) {
                    self.navigationController?.popViewControllerAnimated(true)
                }
            }
        }
    }
}

extension ResetPasswordVC: UITextFieldDelegate {
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        let nextTag = textField.tag + 1
        if nextTag > (textFields?.count)! - 1 {
            textField.resignFirstResponder()
            changePassword(textField)
        } else {
            textFields![nextTag].becomeFirstResponder()
        }
        return true
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        textField.setStandardSignUpPlaceHolder(placeholderText[textField.tag])
    }
}