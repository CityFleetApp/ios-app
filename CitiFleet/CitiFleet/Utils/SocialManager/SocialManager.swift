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
        LoaderViewManager.showLoader()
        Twitter.sharedInstance().logInWithCompletion { session, error in
            if (session != nil) {
                print("Sectet: \(session!.authTokenSecret) token: \(session!.authToken)");
                self.makeTwitterRequest(session!.authToken, tokenSecret: session!.authTokenSecret)
            } else {
                LoaderViewManager.hideLoader()
                print("error: \(error!.localizedDescription)");
            }
        }
    }
    
    private func makeTwitterRequest(token: String, tokenSecret: String) {
        RequestManager.sharedInstance().postTwitterToken(token, tokenSecret: tokenSecret) { (_, _) -> () in
            LoaderViewManager.showDoneLoader(1, completion: nil)
        }
    }
}

//MARK: - FaceBook
extension SocialManager {
    func loginFacebook(fromViewController: UIViewController) {
        LoaderViewManager.showLoader()
        FBSDKLoginManager().logInWithPublishPermissions([], fromViewController: fromViewController) { (result, error) -> Void in
            if result.isCancelled {
                LoaderViewManager.hideLoader()
                return
            }
            self.makeFBRequest(result.token.tokenString)
        }
    }
    
    private func makeFBRequest(token: String) {
        RequestManager.sharedInstance().postFacebookToken(token) { (_, error) -> () in
            if error == nil {
                LoaderViewManager.showDoneLoader(1, completion: nil)
            }
        }
    }
}

//MARK: - Instagram
extension SocialManager {
    private typealias InstagramKeys = Keys.Instagram
    func loginInstagram() {
        LoaderViewManager.showLoader()
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
        RequestManager.sharedInstance().postInstagramToken(token) { (_, error) -> () in
            if error == nil {
                LoaderViewManager.showDoneLoader(1, completion: nil)
            }
        }
    }
}

extension SocialManager {
    func importContactsSilently() {
        if User.currentUser() == nil {
            return
        }
        AddressBookManager().tryToGetContacts { (phones, error) in
            if let phones = phones {
                
                let params = [
                    Params.Social.phones: phones
                ]
                RequestManager.sharedInstance().makeSilentRequest(.POST, baseURL: URL.Social.Phones, parameters: params, completion: { (json, error) in
                    
                })
            }
        }
    }
    
    func importContacts() {
        LoaderViewManager.showLoader()
        AddressBookManager().getAllPhones { (contacts, error) -> () in
            if error != nil || contacts == nil {
                LoaderViewManager.hideLoader()
                print(error)
            } else {
                self.makeContactsRequest(contacts!)
            }
        }
    }
    
    private func makeContactsRequest(contacts: [String]) {
        RequestManager.sharedInstance().postPhoneNumbers(contacts) { (_, error) -> () in
            if error == nil {
                LoaderViewManager.showDoneLoader(1, completion: nil)
            }
        }
    }
}