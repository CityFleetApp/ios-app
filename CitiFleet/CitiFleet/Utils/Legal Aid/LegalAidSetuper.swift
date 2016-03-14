//
//  LegalAidSetuper.swift
//  CitiFleet
//
//  Created by Nick Kibish on 3/12/16.
//  Copyright © 2016 Nick Kibish. All rights reserved.
//

import UIKit

enum LegalAidType {
    case DMVLawyer
    case TLCLawyer
    case Accountants
    case InsuranceBrokers
}

class LegalAidSetuper: NSObject {
    private struct ActorInfo {
        var title: String
        var actorTitle: String
        var actorImage: String
    }
    private struct LegalAidTitles {
        static let DMVLawyer = ActorInfo(title: "DMV Lawyers", actorTitle: "Lawyer", actorImage: "la-lawyer")
        static let TLCLawyer = ActorInfo(title: "TLC Lawyers", actorTitle: "Lawyer", actorImage: "la-lawyer")
        static let Accountants = ActorInfo(title: "Accountants", actorTitle: "Accountant", actorImage: "la-lawyer")
        static let InsuranceBrokers = ActorInfo(title: "Insurance Brokers", actorTitle: "Broker", actorImage: "la-insurance-frokers")
    }
    
    var legalAidVC: LegalAidDetailVC
    var type: LegalAidType
    init(legalAidVC: LegalAidDetailVC, type: LegalAidType) {
        self.legalAidVC = legalAidVC
        self.type = type
        super.init()
    }
    
    func setupViewController() {
        switch type {
        case .DMVLawyer:
            setupInfo(LegalAidTitles.DMVLawyer)
            break
        case .TLCLawyer:
            setupInfo(LegalAidTitles.TLCLawyer)
            break
        case .Accountants:
            setupInfo(LegalAidTitles.Accountants)
            break
        case .InsuranceBrokers:
            setupInfo(LegalAidTitles.InsuranceBrokers)
            break
        }
    }
    
    private func setupInfo(actorInfo: ActorInfo) {
        legalAidVC.title = actorInfo.title
        let image = UIImage(named: actorInfo.actorImage)
        
        legalAidVC.actorImage.image = image
        legalAidVC.actorTitle.text = actorInfo.actorTitle
    }
}
