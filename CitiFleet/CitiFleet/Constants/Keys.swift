//
//  Keys.swift
//  CitiFleet
//
//  Created by Nick Kibish on 2/29/16.
//  Copyright © 2016 Nick Kibish. All rights reserved.
//

import Foundation

struct DictionaryKeys {
    struct APNS {
        static let main = "aps"
        static let alert = "alert"
    }
    struct Chat {
        static let ScreenNumber = "ScreenNumber"
    }
}

struct Keys {
    static let GoogleMaps = "AIzaSyDz48RYxfjSqKwEUmjCiLDi2Bn7vU5pLvg"
    struct Instagram {
        struct test {
            static let clientID = "2abff7abc27b44e488695c9b4ea452a9"
            static let scheme = "ignickkibish"
            static let path = "://instalog"
        }
        
        struct skd {
            static let clientID = "dcbc5373293d4c8aa3465ad53ca946bc"
            static let scheme = "CitiFleet"
            static let path = "://"
        }
        
        typealias str = Instagram.skd

        static let Scheme = Instagram.str.scheme
        static let RedirectURI = Instagram.str.scheme + Instagram.str.path
        static let ClientID = Instagram.str.clientID
        static let ClientSecret = "JLZSfqPXiiNCMOmHzU3eK85DD0VqmoUkmVNNp92LSyx9GPyGRS"
    }
}