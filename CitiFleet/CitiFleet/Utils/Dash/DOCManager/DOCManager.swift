//
//  DOCManager.swift
//  CitiFleet
//
//  Created by Nick Kibish on 3/23/16.
//  Copyright © 2016 Nick Kibish. All rights reserved.
//

import UIKit

struct Document {
    enum CellType: Int {
        case DMVLicense = 0
        case HackLicense = 1
        case Insurance = 2
        case DiamondCard = 3
        case InsuranceCertificate = 4
        case CertificateOfLiability = 5
        case TicPlateNumber = 6
        case DrugTest = 7
    }
    
    var type: CellType
    var expiryDate: NSDate?
    var plateNumber: String?
    var photo: UIImage
}

class DOCManager: NSObject {
    var documents: [Document] = []
    
    func loadDocuments(completion:(([Document]?, NSError?) -> ())) {
        
    }
    
    func addDocument(document: Document, completion: (() -> ())) {
        var key, value: String
        if let expDate = document.expiryDate {
            key = Params.DOCManagement.expiryDate
            value = NSDateFormatter.standordFormater().stringFromDate(expDate)
        } else {
            key = Params.DOCManagement.plateNumber
            value = document.plateNumber!
        }
        
        RequestManager.sharedInstance().postDoc(key, fieldValue: value, docType: document.type.rawValue, photo: document.photo)
    }
}
