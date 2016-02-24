//
//  LoginVC.swift
//  CitiFleet
//
//  Created by Nick Kibish on 2/23/16.
//  Copyright © 2016 Nick Kibish. All rights reserved.
//

import UIKit
import SwiftValidator

class LoginVC: UIViewController {
    private var logo2MailStartHeight: CGFloat?
    private var button2BottomStartHeight: CGFloat?
    
    @IBOutlet var logo2TopTextFieldLayout: NSLayoutConstraint!
    @IBOutlet var button2BottomLayout: NSLayoutConstraint!
    
    @IBOutlet var mailTextField: LoginTextField!
    @IBOutlet var passwordTextField: LoginTextField!
    
    private let validator = Validator()
    private let placeholderText = [""]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerKeyboardEvents()
        validator.registerField(mailTextField, rules: [RequiredRule()])
        validator.registerField(passwordTextField, rules: [RequiredRule()])
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        logo2MailStartHeight = logo2TopTextFieldLayout.constant
        button2BottomStartHeight = button2BottomLayout.constant
    }
    
    func registerKeyboardEvents() {
        registerNotification("keyboardWillShow:", notification: UIKeyboardWillShowNotification)
        registerNotification("keyboardWillChangeFrame:", notification: UIKeyboardWillChangeFrameNotification)
        registerNotification("keyboardWillHide:", notification: UIKeyboardWillHideNotification)
    }
    
    func registerNotification(selectorName:String, notification:String) {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector(selectorName), name: notification, object: nil)
    }
    
    @IBAction func logIn(sender: AnyObject) {
        validator.validate { (errors) -> Void in
            for error in errors {
                error.0.text = ""
                error.0.setErrorPlaceholder(error.1.errorMessage)
            }
            
            if errors.count == 0 {
                
            }
        }
    }
    
    func loginRequest() {
        User.login(mailTextField.text!, password: passwordTextField.text!) { (user, error) -> () in
            
        }
    }
}

//MARK: - Keyboard events
extension LoginVC {
    func keyboardWillShow(userInfo:NSNotification?) {
        updateConstraints(userInfo)
    }
    
    func keyboardWillChangeFrame(userInfo:NSNotification?) {
        updateConstraints(userInfo)
    }
    
    func keyboardWillHide(userInfo:NSNotification?) {
        updateConstraints(userInfo)
    }
    
    func updateConstraints(userInfo:NSNotification?) {
        button2BottomLayout.constant = button2BottomStartHeight! + keyboardHeight(userInfo!)
        logo2TopTextFieldLayout.constant = logo2MailStartHeight! - keyboardHeight(userInfo!)
        UIView.animateWithDuration(0.5) {
            self.view.layoutSubviews()
        }
    }
    
    func keyboardHeight(notification: NSNotification) -> CGFloat {
        var info = notification.userInfo!
        let keyboardFrame: CGRect = (info[UIKeyboardFrameEndUserInfoKey] as! NSValue).CGRectValue()
        return keyboardFrame.size.height
    }
}