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
        RequestManager.sharedInstance().getActors(self.type, location: location) { (response, error) -> () in
            typealias Actor = Response.LegalAid.Actor
            if response == nil || response?.count == 0 {
                completion(nil, error)
                return
            }
            var actorList: [LegalAidActor] = []
            for contact in response! {
                let name = contact[Actor.name] as! String
                let years = contact[Actor.years] as! Int
                let phone = contact[Actor.phone] as! String
                let rating = contact[Actor.rating] as! Double
                let address = contact[Actor.address] as! String
                let contacts = [
                    LegalAidActorContact(type: .Phone, title: "Phone", value: phone),
                    LegalAidActorContact(type: .Address, title: "Address", value: address)
                ]
                
                let actor = LegalAidActor(location: location, name: name, rating: rating, yearsExp: years, contacts: contacts)
                actorList.append(actor)
            }
            completion(actorList, error)
        }
    }
}
