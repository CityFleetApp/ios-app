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
    func getAllPhones(completion:(([String]?, NSError?)->())) {
        SwiftAddressBook.requestAccessWithCompletion({ (success, error) -> Void in
            
            if success {
                self.getPhoneNumbers(completion)
            } else {
                completion(nil, (error as NSError?))
            }
        })
    }
    
    private func getPhoneNumbers(completion: (([String]?, NSError?) -> ())) {
        var phoneNumbers: [String] = []
        if let people = swiftAddressBook?.allPeople {
            for person in people {
                if let numbers = self.mapPhones(person.phoneNumbers) {
                    phoneNumbers += numbers
                }
            }
        }
        completion(phoneNumbers, nil)
    }
    
    private func mapPhones(phones: Array<MultivalueEntry<String>>?) -> [String]? {
        return phones?.map({ (phone) -> String in
            return phone.value
        })
    }
}
