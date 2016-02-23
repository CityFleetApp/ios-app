//
//  MainLoginVC.swift
//  CitiFleet
//
//  Created by Nick Kibish on 2/22/16.
//  Copyright © 2016 Nick Kibish. All rights reserved.
//

import UIKit

class MainLoginVC: UIViewController {
    
    @IBOutlet var signUpBtn: UIButton!
    @IBOutlet var loginBtn: UIButton!
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.hidden = true
        signUpBtn.setShadow()
        loginBtn.setShadow()
        navigationController?.navigationBar.barStyle = .Black
    }
    
    @IBAction func createAccount(sender: AnyObject) {
        
    }
    
    @IBAction func logIn(sender: AnyObject) {
        
    }
}
