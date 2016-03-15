//
//  LegalAidManager.swift
//  CitiFleet
//
//  Created by Nick Kibish on 3/14/16.
//  Copyright © 2016 Nick Kibish. All rights reserved.
//

import UIKit

class LegalAidManager: NSObject {
    var type: LegalAidType
    
    init(type: LegalAidType) {
        self.type = type
        super.init()
    }
    
    func getLocations(completion:( ([LegalAidLocation]?, NSError?) -> ())) {
        RequestManager.sharedInstance().getLegalAidLocations { (locations, error) -> () in
            if locations == nil || locations?.count == 0 {
                completion(nil, error)
            }
            var locationsArray: [LegalAidLocation] = []
            for loc in locations! {
                let locationID = loc[Response.LegalAid.id] as! Int
                let locationName = loc[Response.LegalAid.name] as! String
                locationsArray.append(LegalAidLocation(name: locationName, id: locationID))
            }
            completion(locationsArray, error)
        }
    }
    
    func getActors(location: LegalAidLocation, completion:( ([LegalAidActor]?, NSError?) -> ())) {
        /*
        RequestManager.sharedInstance().getActors(self.type, location: location) { (response, error) -> () in
            completion(nil, nil)
        }
        */
        RequestManager.sharedInstance().getLegalAidLocations { (actors, error) -> () in
            let contacts = [
                LegalAidActorContact(type: .Phone, title: "Phone", value: "+380975550099"),
                LegalAidActorContact(type: .Phone, title: "Phone", value: "+380975550099"),
                LegalAidActorContact(type: .Email, title: "Phone", value: "test@mail.com"),
                LegalAidActorContact(type: .Email, title: "Phone", value: "test2@mail.com"),
                LegalAidActorContact(type: .Email, title: "Phone", value: "test3@mail.com"),
                LegalAidActorContact(type: .Address, title: "Phone", value: "Соборная 25"),
                LegalAidActorContact(type: .Address, title: "Phone", value: "Келецкая 15")
            ]
            let testActors = [
                LegalAidActor(location: "Some where", name: "John Doe", rating: 4, yearsExp: 10, contacts: contacts),
                LegalAidActor(location: "Some where", name: "Jane Doe", rating: 4, yearsExp: 10, contacts: contacts),
                LegalAidActor(location: "Some where", name: "Darth Vader", rating: 4, yearsExp: 10, contacts: contacts),
                LegalAidActor(location: "Some where", name: "Luke Skywalker", rating: 4, yearsExp: 10, contacts: contacts),
                LegalAidActor(location: "Some where", name: "Kung Führer", rating: 4, yearsExp: 10, contacts: contacts),
                LegalAidActor(location: "Some where", name: "Rchie Blackmore", rating: 4, yearsExp: 10, contacts: contacts)
            ]
            completion(testActors, error)
            return
            
            if actors == nil || actors?.count == 0 {
                completion(nil, error)
                return
            }
            
            var actorsArray: [LegalAidActor] = []
            for actor in actors! {
                print("Actor: \(actor)")
            }
            completion(nil, nil)
        }
    }
}
