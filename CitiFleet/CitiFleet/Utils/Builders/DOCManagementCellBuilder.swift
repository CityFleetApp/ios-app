//
//  DOCManagementCellBuilder.swift
//  CitiFleet
//
//  Created by Nick Kibish on 3/22/16.
//  Copyright © 2016 Nick Kibish. All rights reserved.
//

import UIKit
import Haneke

class DOCManagementCellBuilder: NSObject {
    static let titles = [
        "DMV License",
        "Hack License",
        "Insurance",
        "Diamond Card",
        "Insurance Certificate",
        "Certificate Of Liability",
        "Tic Plate Number",
        "Drug Test"
    ]
    
    let DOCManagementCellID: String = "DOCManagementCellID"
    let DOCManagementCellWithTFID: String = "DOCManagementCellWithTF"
    let TemplateImage = UIImage(named: "Doc-management-template")
    var tableView: UITableView
    weak var docManager: DOCManager?
    
    init(tableView: UITableView, docManager: DOCManager) {
        self.tableView = tableView
        self.docManager = docManager
        super.init()
    }
    
    deinit {
        print("Destroyed builder")
    }
    
    func build(indexPath: NSIndexPath) -> DOCManagementCell {
        let cellID = indexPath.row == 6 ? DOCManagementCellWithTFID : DOCManagementCellID
        
        var cell = tableView.dequeueReusableCellWithIdentifier(cellID) as? DOCManagementCell
        if cell == nil {
            cell = DOCManagementCell(style: .Default, reuseIdentifier: cellID)
        }
        
        if let doc = docManager!.documents[Document.CellType(rawValue: indexPath.row)!] {
            setupCellWithExistingDoc(cell!, doc: doc)
        } else {
            setupNewCell(cell!)
        }
        
        return cell!
    }
    
    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        let cancelAction = UIAlertAction(title: Titles.cancel, style: .Cancel, handler: nil)
        alert.addAction(cancelAction)
        AppDelegate.sharedDelegate().rootViewController().presentViewController(alert, animated: true, completion: nil)
    }
    
    func setActionsForCell(cell: DOCManagementCell?, type: Document.CellType?) {
        cell?.saveDocument = { [weak self] in
            if cell?.photo == nil {
                self?.showAlert("Provide photo", message: "Please, take a phofo of the document")
                return
            }
            
            if cell?.expDate == nil && cell?.dateLabel != nil {
                self?.showAlert("Select date", message: "Please, select expiration date of the document")
                return
            }
            
            if cell?.licenseNumber == nil && cell?.licenseNumberTF != nil {
                self?.showAlert("Enter Tic Plate Number", message: "Please, enter Tic Plate Number of the document")
                return
            }
            
            var document = Document(id: nil, type: (cell?.docType)!, uploaded: false, expiryDate: cell?.expDate, plateNumber: cell?.licenseNumber, photo: cell?.photo, photoURL: nil)
            if let doc = self?.docManager!.documents[(cell?.docType)!] {
                document.id = doc.id
                document.photoURL = doc.photoURL
                document.uploaded = true
            }
            self?.docManager!.addDocument(document, completion: { () -> () in
                
            })
        }
        
        cell?.selectedPhoto = { [weak self] (image) in
            var doc = self?.documentWithType(type!)
            doc?.photo = image
        }
        
        cell?.selectedDate = { [weak self] (date) in
            var doc = self?.documentWithType(type!)
            doc?.expiryDate = date
        }
    }
    
    func documentWithType(documentType: Document.CellType) -> Document {
        if let doc = docManager!.documents[documentType] {
            return doc
        }
        let doc = Document(id: nil, type: documentType, uploaded: false, expiryDate: nil, plateNumber: nil, photo: nil, photoURL: nil)
        docManager!.documents[documentType] = doc
        return doc
    }
    
    private func setupCellWithExistingDoc(cell: DOCManagementCell, doc: Document) {
        cell.newDoc = true
        if let url = doc.photoURL {
            Shared.imageCache.fetch(URL: url).onSuccess({ (image) -> () in
                cell.photo = image
            })
            cell.docPhoto.hnk_setImageFromURL(url)
        } else if let image = doc.photo {
            cell.photo = image
            cell.docPhoto.image = image
        } else {
            cell.photo = nil
            cell.docPhoto.image = TemplateImage
        }
        
        if let date = doc.expiryDate {
            cell.expDate = date
            cell.dateLabel?.highlitedText = NSDateFormatter.standordFormater().stringFromDate(date)
        } else {
            cell.expDate = nil
            cell.dateLabel?.highlitedText = nil
        }
        
        if let licenseNumber = doc.plateNumber {
            cell.licenseNumberTF?.text = licenseNumber
            cell.licenseNumber = licenseNumber
        } else {
            cell.licenseNumber = nil
            cell.licenseNumberTF?.text = ""
        }
    }
    
    private func setupNewCell(cell: DOCManagementCell) {
        cell.newDoc = false
        cell.docPhoto.image = TemplateImage
        cell.dateLabel?.highlitedText = nil
        cell.licenseNumberTF?.text = nil
    }
}
