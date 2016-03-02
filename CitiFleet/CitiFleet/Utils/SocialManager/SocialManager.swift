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

//MARK: - Twitter
extension SocialManager {
    func loginTwitter() {
        Twitter.sharedInstance().logInWithCompletion { session, error in
            if (session != nil) {
                print("Sectet: \(session!.authTokenSecret) token: \(session!.authToken)");
            } else {
                print("error: \(error!.localizedDescription)");
            }
        }
    }
}

//MARK: - FaceBook
extension SocialManager {
    func loginFacebook(fromViewController: UIViewController) {
        FBSDKLoginManager().logInWithPublishPermissions([], fromViewController: fromViewController) { (result, error) -> Void in
            print("FB token \(result.token.tokenString)")
        }
    }
}

//MARK: - Instagram
extension SocialManager {
    private typealias InstagramKeys = Keys.Instagram
    func loginInstagram() {
        let url = "https://api.instagram.com/oauth/authorize/?client_id=" + InstagramKeys.ClientID + "&redirect_uri=" + InstagramKeys.RedirectURI + "&response_type=token"
        
        UIApplication.sharedApplication().openURL(NSURL(string: url)!)
    }
    
    func loginRequest(srcUrl: NSURL) {
        let query = String(srcUrl)
        let parts = query.componentsSeparatedByString("=")
        let authToken = parts[1]
        print("Token: \(authToken)")
    }
}
