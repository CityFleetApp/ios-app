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
    @IBOutlet var fullName: UITextField!
    @IBOutlet var userName: UITextField!
    @IBOutlet var phone: UITextField!
    @IBOutlet var hackLicense: UITextField!
    @IBOutlet var email: UITextField!
    @IBOutlet var password: UITextField!
    @IBOutlet var confirmPassword: UITextField!
    
    @IBOutlet var signUpBtn: UIButton!
    
    let validator = Validator()
    private let placeholderText = ["Enter your full name",
        "Enter your username",
        "Enter your phone",
        "Enter your hack license",
        "Enter your email",
        "Enter your password",
        "Enter your confirm password"]
    
    private var textFields: [UITextField]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setValidations()
        textFields = [fullName, userName, phone, hackLicense, email, password, confirmPassword]
        
        navigationController?.navigationBar.titleTextAttributes = [ NSFontAttributeName: Fonts.Login.NavigationTitle,  NSForegroundColorAttributeName: UIColor.whiteColor()]
    }
    
    func setValidations() {
        validator.registerField(fullName, rules: [RequiredRule(), FullNameRule()])
        validator.registerField(userName, rules: [RequiredRule()])
        validator.registerField(phone, rules: [RequiredRule(), PhoneNumberRule(regex: "^\\d{11}$", message: "Enter a valid 11 digit phone number")])
        validator.registerField(hackLicense, rules: [RequiredRule()])
        validator.registerField(email, rules: [RequiredRule(), EmailRule()])
        validator.registerField(password, rules: [RequiredRule(), PasswordRule()])
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
        
    }
    
    @IBAction func back(sender: AnyObject) {
        self.navigationController?.popViewControllerAnimated(true)
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