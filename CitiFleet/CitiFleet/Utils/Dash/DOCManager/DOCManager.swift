//
//  DOCManager.swift
//  CitiFleet
//
//  Created by Nick Kibish on 3/23/16.
//  Copyright © 2016 Nick Kibish. All rights reserved.
//

import UIKit
import Haneke

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
    
    var id: Int?
    var type: CellType
    var uploaded: Bool
    var expiryDate: NSDate?
    var plateNumber: String?
    var photo: UIImage?
    var photoURL: NSURL? {
        didSet {
            
        }
    }
}

class DOCManager: NSObject {
    var documents: [Document.CellType: Document] = Dictionary ()
    
    deinit {
        print("Destroyed DOC Manager")
    }
    
    func loadDocuments(completion:(([Document.CellType: Document]?, NSError?) -> ())?) {
        RequestManager.sharedInstance().getDocs { [unowned self] (docs, error) -> () in
            if error != nil {
                completion!(nil, error)
                return
            }
            
            for doc in docs! {
                let id = doc[Params.DOCManagement.id] as! Int
                let typeIndex = doc[Params.DOCManagement.docType] as! Int
                let photoUrl = doc[Params.DOCManagement.photo] as? String
                let expDateString = doc[Params.DOCManagement.expiryDate] as? String
                let number = doc[Params.DOCManagement.plateNumber] as? String
                var expDate: NSDate?
                if let exp = expDateString {
                    expDate = NSDateFormatter.standordFormater().dateFromString(exp)
                }
                
                let doc = Document(id: id, type: Document.CellType(rawValue: typeIndex - 1)!, uploaded: true, expiryDate: expDate, plateNumber: number, photo: nil, photoURL: NSURL(string: photoUrl!))
                self.documents[doc.type] = doc
            }
            
            completion!(self.documents, nil)
        }
    }
    
    func addDocument(document: Document, completion: (() -> ())) {
        var key, value: String
        if let expDate = document.expiryDate {
            key = Params.DOCManagement.expiryDate
            value = NSDateFormatter(dateFormat: "yyyy-MM-dd").stringFromDate(expDate)
        } else {
            key = Params.DOCManagement.plateNumber
            value = document.plateNumber!
        }
        
        let HTTPMethod = document.id != nil ? "PATCH" : "POST"
        
        RequestManager.sharedInstance().postDoc(HTTPMethod, docID: document.id, fieldKey: key, fieldValue: value, docType: document.type.rawValue, photo: document.photo!.scaleToMaxSide(Sizes.Image.upladeSide), completion: { (response, error) in
            
        })
    }
}
