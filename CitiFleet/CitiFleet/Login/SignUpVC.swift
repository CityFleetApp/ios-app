//
//  SignUpVC.swift
//  CitiFleet
//
//  Created by Nick Kibish on 2/22/16.
//  Copyright © 2016 Nick Kibish. All rights reserved.
//

import UIKit
import SwiftValidator

class SignUpVC: UITableViewController {
    private typealias Placeholder = StringConstants.SignUp.Placeholder
    private typealias ErrorMessage = ErrorString.SignUp
    private typealias RequestParams = Params.Login
    
    @IBOutlet var fullName: UITextField!
    @IBOutlet var userName: UITextField!
    @IBOutlet var phone: UITextField!
    @IBOutlet var hackLicense: UITextField!
    @IBOutlet var email: UITextField!
    @IBOutlet var password: UITextField!
    @IBOutlet var confirmPassword: UITextField!
    @IBOutlet var agreeLabel: UITextView!
    
    @IBOutlet var signUpBtn: UIButton!
    
    let validator = Validator()
    private let placeholderText = [
        Placeholder.FullName,
        Placeholder.Username,
        Placeholder.Phone,
        Placeholder.HackLicense,
        Placeholder.Email,
        Placeholder.Password,
        Placeholder.ConfirmPassword
    ]
    
    private var textFields: [UITextField]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setValidations()
        textFields = [fullName, userName, phone, hackLicense, email, password, confirmPassword]
        setDefaultPlaceholders()
        
        navigationController?.navigationBar.titleTextAttributes = [ NSFontAttributeName: Fonts.Login.NavigationTitle,  NSForegroundColorAttributeName: UIColor.whiteColor()]
    }
    
    func addLinksToAttributeLabel() {
        
    }
    
    func setDefaultPlaceholders() {
        for i in 0..<textFields!.count {
            textFields![i].setStandardSignUpPlaceHolder(placeholderText[i])
        }
    }
    
    func setValidations() {
        validator.registerField(fullName, rules: [RequiredRule(), FullNameRule()])
        validator.registerField(userName, rules: [RequiredRule()])
        validator.registerField(phone, rules: [RequiredRule(), PhoneNumberRule(regex: "^\\d{10}$", message: ErrorMessage.NotValidPhone)])
        validator.registerField(hackLicense, rules: [RequiredRule()])
        validator.registerField(email, rules: [RequiredRule(), EmailRule()])
        validator.registerField(password, rules: [RequiredRule(), PasswordRule(regex: ConfirmPasswordRule.regex, message: ErrorMessage.IncorrectPassword)])
        validator.registerField(confirmPassword, rules: [RequiredRule(), ConfirmPasswordRule(textField: password)])
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.hidden = false
        signUpBtn.setDefaultShadow()
    }
    
    override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        tableView.setZeroSeparator(cell)
    }
    
    @IBAction func signUp(sender: AnyObject) {
        validator.validate { (errors) -> Void in
            for error in errors {
                error.0.text = ""
                error.0.setErrorPlaceholder(error.1.errorMessage)
            }
            
            if errors.count == 0 {
                self.signUpRequest()
            }
        }
    }
    
    func signUpRequest() {
        let tmpUser = User()
        tmpUser.email = email.text
        tmpUser.profile.username = userName.text
        tmpUser.fullName = fullName.text
        tmpUser.hackLicense = hackLicense.text
        tmpUser.profile.phone = phone.text!
        
        User.signUp(tmpUser, password: password.text!, confirmPassword: confirmPassword.text!) { (user, error) -> () in
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                if let _ = user {
                    self.dismissViewControllerAnimated(true, completion: nil)
                }
            })
        }
    }
}

extension SignUpVC: UITextFieldDelegate {
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if let index = textFields?.indexOf(textField) {
            selectNextField(index)
        }
        return true
    }
    
    func selectNextField(index:Int) {
        let nextIndex = index + 1
        if nextIndex >= textFields?.count {
            textFields![index].resignFirstResponder()
        } else {
            textFields![nextIndex].becomeFirstResponder()
        }
    }
}