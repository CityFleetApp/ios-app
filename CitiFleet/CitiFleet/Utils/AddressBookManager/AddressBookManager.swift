//
//  AddressBookManager.swift
//  CitiFleet
//
//  Created by Nick Kibish on 3/2/16.
//  Copyright © 2016 Nick Kibish. All rights reserved.
//

import UIKit
import SwiftAddressBook

class AddressBookManager: NSObject {
    func tryToGetContacts(completion:(([String]?, NSError?)->())) {
        let status = SwiftAddressBook.authorizationStatus()
        if status == .Authorized {
            getPhoneNumbers(completion)
        } else {
            completion(nil, nil)
        }
    }
    
    func getAllPhones(completion:(([String]?, NSError?)->())) {
        SwiftAddressBook.requestAccessWithCompletion({ [weak self] (success, error) in
            if success {
                self?.getPhoneNumbers(completion)
            } else {
                completion(nil, (error as NSError?))
            }
        })
    }
    
    private func getPhoneNumbers(completion: (([String]?, NSError?) -> ())) {
        var phoneNumbers: [String] = []
        if let people = swiftAddressBook?.allPeople {
            for person in people {
                if let numbers = mapPhones(person.phoneNumbers) {
                    phoneNumbers += numbers
                }
            }
        }
        completion(phoneNumbers, nil)
    }
    
    private func mapPhones(phones: Array<MultivalueEntry<String>>?) -> [String]? {
        return phones?.map({ (phone) -> String in
            let stringArray = phone.value.componentsSeparatedByCharactersInSet(
                NSCharacterSet.decimalDigitCharacterSet().invertedSet)
            return stringArray.joinWithSeparator("")
        }).filter({ $0 != nil && $0.characters.count > 0 })
    }
}
