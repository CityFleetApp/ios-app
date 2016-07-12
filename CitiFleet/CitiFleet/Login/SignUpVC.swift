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
    static let LinkTag = "LinkTag"
    
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
    @IBOutlet var agreeSwitcher: UISwitch!
    
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
        let baseAttributes = [
            NSFontAttributeName: UIFont(name: FontNames.Montserrat.Regular, size: 16)!,
            NSForegroundColorAttributeName: UIColor.lightGrayColor()
        ]
        let attributedText = NSMutableAttributedString(string: agreeLabel.text, attributes: baseAttributes)
        
        var linkAttribute = [
            NSForegroundColorAttributeName: UIColor(hex: 0x2EC4B6, alpha: 1),
            NSUnderlineStyleAttributeName: 1,
            SignUpVC.LinkTag: 1
        ]
        
        attributedText.addAttributes(linkAttribute, range: NSMakeRange(11, 14))
        
        linkAttribute[SignUpVC.LinkTag] = 2
        attributedText.addAttributes(linkAttribute, range: NSMakeRange(30, 20))
        
        agreeLabel.attributedText = attributedText
        
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(textTapped(_:)))
        agreeLabel.addGestureRecognizer(recognizer)
    }
    
    func textTapped(sender: UITapGestureRecognizer) {
        var location = sender.locationInView(agreeLabel)
        location.x -= agreeLabel.textContainerInset.left
        location.y -= agreeLabel.textContainerInset.top
        
        let characterIndex = agreeLabel.layoutManager.characterIndexForPoint(location, inTextContainer: agreeLabel.textContainer, fractionOfDistanceBetweenInsertionPoints: nil)
        if characterIndex < agreeLabel.textStorage.length {
            let rangePointer: NSRangePointer = nil
            let attributes = agreeLabel.textStorage.attributesAtIndex(characterIndex, effectiveRange: rangePointer)
            
            if attributes[SignUpVC.LinkTag] as? Int == 1 {
                let helpVC = HelpVC()
                helpVC.urlString = URL.Help.privacy
                helpVC.title = "Privacy Policy"
                navigationController?.pushViewController(helpVC, animated: true)
            } else if attributes[SignUpVC.LinkTag] as? Int == 2 {
                let helpVC = HelpVC()
                helpVC.urlString = URL.Help.terms
                helpVC.title = "Terms and Conditions"
                navigationController?.pushViewController(helpVC, animated: true)
            }
            
        }
        
        agreeLabel.textStorage
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
        
        addLinksToAttributeLabel()
    }
    
    override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        tableView.setZeroSeparator(cell)
    }
    
    @IBAction func signUp(sender: AnyObject) {
        if !agreeSwitcher.on {
            let alert = UIAlertController(title: "You should agree to Privacy Policy and Terms and Conditions", message: nil, preferredStyle: .Alert)
            let action = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
            alert.addAction(action)
            presentViewController(alert, animated: true, completion: nil)
            return 
        }
        
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