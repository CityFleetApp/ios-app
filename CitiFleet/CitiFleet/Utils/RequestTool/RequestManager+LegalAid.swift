//
//  RequestManager+LegalAid.swift
//  CitiFleet
//
//  Created by Nick Kibish on 3/14/16.
//  Copyright © 2016 Nick Kibish. All rights reserved.
//

import Foundation

extension RequestManager {
    func getLegalAidLocations(completion:((ArrayResponse, NSError?) -> ())) {
        get(URL.LegalAid.Locations, parameters: nil) { (json, error) -> () in
            completion(json?.arrayObject, error)
        }
    }
    
    func getActors(type: LegalAidType, location:LegalAidLocation, completion: (ArrayResponse, NSError?) -> () ) {
        let params = [
            Params.LegalAid.location: location.id
        ]
        
        get(urlFromType(type), parameters: params) { (json, error) -> () in
            completion(json?.arrayObject, error)
        }
    }
    
    private func urlFromType(type: LegalAidType) -> String {
        var urlString: String!
        switch type {
        case .Accountants:
            urlString = URL.LegalAid.Accountants
            break
        case .DMVLawyer:
            urlString = URL.LegalAid.DMVLawyer
            break
        case .TLCLawyer:
            urlString = URL.LegalAid.TLCLawyer
            break
        case .InsuranceBrokers:
            urlString = URL.LegalAid.Brockers
            break
        }
        return urlString
    }
}