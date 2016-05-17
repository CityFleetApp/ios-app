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
    typealias Placeholder = StringConstants.Login.Placeholder
    typealias ErrorMessage = ErrorString.SignUp
    typealias LoginFont = Fonts.Login
    
    private var logo2MailStartHeight: CGFloat?
    private var button2BottomStartHeight: CGFloat?
    
    @IBOutlet var logo2TopTextFieldLayout: NSLayoutConstraint?
    @IBOutlet var button2BottomLayout: NSLayoutConstraint!
    
    @IBOutlet var mailTextField: LoginTextField!
    @IBOutlet var passwordTextField: LoginTextField?
    
    private let validator = Validator()
    private let placeholderText = [
        Placeholder.Email,
        Placeholder.Password
    ]
    
    class func viewControllerFromStoryboard() -> LoginVC {
        let storyboard = UIStoryboard(name: Storyboard.LoginStoryboard, bundle: NSBundle.mainBundle())
        return storyboard.instantiateViewControllerWithIdentifier(ViewControllerID.Login) as! LoginVC
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerKeyboardEvents()
        validator.registerField(mailTextField, rules: [RequiredRule()])
        if let tf = passwordTextField {
            validator.registerField(tf, rules: [RequiredRule()])
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        logo2MailStartHeight = logo2TopTextFieldLayout?.constant
        button2BottomStartHeight = button2BottomLayout.constant
        navigationController?.navigationBar.hidden = false
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
        mailTextField.resignFirstResponder()
        passwordTextField?.resignFirstResponder()
        
        validator.validate { [weak self] (errors) -> Void in
            for error in errors {
                error.0.text = ""
                error.0.setErrorPlaceholder(error.1.errorMessage)
            }
            
            if errors.count == 0 {
                self?.request()
            }
        }
    }
    
    func request() {
        let mail = mailTextField.text
        let password = passwordTextField!.text!
        
        User.login(mail!, password: password) { [weak self] (user, error) -> () in
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                if let _ = user {
                    self?.dismissViewControllerAnimated(true, completion: nil)
                } else {
//                    RequestErrorHandler(error: error!, title: Titles.error).handle()
                }
            })
        }
    }
}

//MARK: - Text Field Delegate
extension LoginVC: UITextFieldDelegate {
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if textField == mailTextField {
            passwordTextField?.becomeFirstResponder()
        } else {
            passwordTextField?.resignFirstResponder()
        }
        return true
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        textField.setPlaceholder(LoginFont.LoginPlaceholder, color: Color.Login.PlaceHolderForeground, text: placeholderText[textField.tag])
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
        button2BottomLayout.constant = button2BottomStartHeight!
        if let contant = logo2MailStartHeight {
            logo2TopTextFieldLayout?.constant = contant
        }
        UIView.animateWithDuration(0.5) { [weak self] in
            self?.view.layoutSubviews()
        }
    }
    
    func updateConstraints(userInfo:NSNotification?) {
        button2BottomLayout.constant = button2BottomStartHeight! + keyboardHeight(userInfo!)
        if let constant = logo2MailStartHeight {
            logo2TopTextFieldLayout?.constant = constant - keyboardHeight(userInfo!)
        }
        UIView.animateWithDuration(0.5) { [weak self] in
            self?.view.layoutSubviews()
        }
    }
    
    func keyboardHeight(notification: NSNotification) -> CGFloat {
        var info = notification.userInfo!
        let keyboardFrame: CGRect = (info[UIKeyboardFrameEndUserInfoKey] as! NSValue).CGRectValue()
        return keyboardFrame.size.height
    }
}

class ForgotPasswordVC: LoginVC {
    override func request() {
        if mailTextField.text == nil {
            return
        }
        RequestManager.sharedInstance().post(URL.User.ResetPassword, parameters: [Params.email: mailTextField.text!]) { [weak self] (json, error) in
            if error == nil {
                LoaderViewManager.showDoneLoader(1, completion: { 
                    self?.navigationController?.popViewControllerAnimated(true)
                })
            }
        }
    }
    
    override func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    override func back(sender: AnyObject) {
        mailTextField.resignFirstResponder()
        super.back(sender)
    }
}