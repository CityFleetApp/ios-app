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
        var actorPlaceholder: String
        var actorInfoTitle: String
        var actorNamePlacehelder: String
    }
    
    private struct LegalAidTitles {
        static let DMVLawyer = ActorInfo(title: "DMV Lawyers",
            actorTitle: "Lawyer",
            actorImage: "la-lawyer",
            actorPlaceholder: "Select Lawyer",
            actorInfoTitle: "LAWYER'S INFO",
            actorNamePlacehelder: "Lawyer's Name"
        )
        static let TLCLawyer = ActorInfo(title: "TLC Lawyers",
            actorTitle: "Lawyer",
            actorImage: "la-lawyer",
            actorPlaceholder: "Select Lawyer",
            actorInfoTitle: "LAWYER'S INFO",
            actorNamePlacehelder: "Lawyer's Name"
        )
        static let Accountants = ActorInfo(title: "Accountants",
            actorTitle: "Accountant",
            actorImage: "la-accountants",
            actorPlaceholder: "Select Accountant",
            actorInfoTitle: "ACCOUNTANT'S INFO",
            actorNamePlacehelder: "Accountant's Name"
        )
        static let InsuranceBrokers = ActorInfo(title: "Insurance Brokers",
            actorTitle: "Broker",
            actorImage: "la-insurance-frokers",
            actorPlaceholder: "Select Broker",
            actorInfoTitle: "BROKER'S INFO",
            actorNamePlacehelder: "Broker's Name"
        )
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
        legalAidVC.headerTitle = actorInfo.actorInfoTitle
        legalAidVC.actorLabel.placeholderText = actorInfo.actorPlaceholder
        legalAidVC.nameLabel.placeholderText = actorInfo.actorNamePlacehelder
    }
}
