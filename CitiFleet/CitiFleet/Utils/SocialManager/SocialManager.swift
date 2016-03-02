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
                self.makeTwitterRequest(session!.authToken, tokenSecret: session!.authTokenSecret)
            } else {
                print("error: \(error!.localizedDescription)");
            }
        }
    }
    
    private func makeTwitterRequest(token: String, tokenSecret: String) {
        RequestManager.sharedInstance().postTwitterToken(token, tokenSecret: tokenSecret) { (_, _) -> () in
            
        }
    }
}

//MARK: - FaceBook
extension SocialManager {
    func loginFacebook(fromViewController: UIViewController) {
        FBSDKLoginManager().logInWithPublishPermissions([], fromViewController: fromViewController) { (result, error) -> Void in
            print("FB token \(result.token.tokenString)")
            self.makeFBRequest(result.token.tokenString)
        }
    }
    
    private func makeFBRequest(token: String) {
        RequestManager.sharedInstance().postFacebookToken(token) { (_, _) -> () in
            
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
        makeInstagramRequest(authToken)
    }
    
    private func makeInstagramRequest(token: String) {
        RequestManager.sharedInstance().postInstagramToken(token) { (_, _) -> () in
            
        }
    }
}

extension SocialManager {
    func importContacts() {
        AddressBookManager().getAllPhones { (contacts, error) -> () in
            if let error = error {
                print(error)
            } else {
                self.makeContactsRequest(contacts!)
            }
        }
    }
    
    private func makeContactsRequest(contacts: [String]) {
        RequestManager.sharedInstance().postPhoneNumbers(contacts) { (_, _) -> () in
            
        }
    }
}