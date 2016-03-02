//
//  SocialManager.swift
//  CitiFleet
//
//  Created by Nick Kibish on 3/1/16.
//  Copyright © 2016 Nick Kibish. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit
import TwitterKit

class SocialManager: NSObject {
    static let sharedInstance = SocialManager()
}

extension SocialManager {
    func loginTwitter() {
        Twitter.sharedInstance().logInWithCompletion { session, error in
            if (session != nil) {
                print("signed in as \(session!.authToken)");
            } else {
                print("error: \(error!.localizedDescription)");
            }
        }
    }
}

extension SocialManager {
    func loginFacebook(fromViewController: UIViewController) {
        FBSDKLoginManager().logInWithPublishPermissions([], fromViewController: fromViewController) { (result, error) -> Void in
            print(result.token.tokenString)
        }
    }
}

extension SocialManager {
    func loginInstagram() {
        
    }
}
