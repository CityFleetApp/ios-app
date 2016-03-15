//
//  LegalAidActor.swift
//  CitiFleet
//
//  Created by Nick Kibish on 3/14/16.
//  Copyright © 2016 Nick Kibish. All rights reserved.
//

import UIKit

enum LegalAiContactType {
    case Phone
    case Email
    case Address
}

struct LegalAidLocation {
    var name: String!
    var id: Int!
}

struct LegalAidActorContact {
    var type: LegalAiContactType!
    var title: String!
    var value: String!
}

struct LegalAidActor {
    var location: LegalAidLocation!
    var name: String!
    var rating: Double!
    var yearsExp: Int!
    var contacts: [LegalAidActorContact]!
}