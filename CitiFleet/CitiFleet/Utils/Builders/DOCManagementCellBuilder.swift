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
    let TemplateImage = UIImage(named: "Doc-management-template")
    var tableView: UITableView
    var indexPath: NSIndexPath
    var docManager: DOCManager
    
    init(tableView: UITableView, indexPath: NSIndexPath, docManager: DOCManager) {
        self.tableView = tableView
        self.indexPath = indexPath
        self.docManager = docManager
        super.init()
    }
    
    deinit {
        print("Destroyed builder")
    }
    
    func build() -> DOCManagementCell {
        var cell = tableView.dequeueReusableCellWithIdentifier(DOCManagementCellID) as? DOCManagementCell
        if cell == nil {
            cell = DOCManagementCell(style: .Default, reuseIdentifier: DOCManagementCellID)
        }
        
        if let doc = docManager.documents[Document.CellType(rawValue: indexPath.row)!] {
            setupCellWithExistingDoc(cell!, doc: doc)
        } else {
            setupNewCell(cell!)
        }
        
        let type = Document.CellType(rawValue: indexPath.row)
        cell?.title.text = DOCManagementCellBuilder.titles[indexPath.row]
        cell?.docType = type
        setActionsForCell(cell, type: type)
        
        return cell!
    }
    
    private func setActionsForCell(cell: DOCManagementCell?, type: Document.CellType?) {
        let weakRef = self
        cell?.saveDocument = { (document) in
            weakRef.docManager.addDocument(document, completion: { () -> () in
                
            })
        }
        
        cell?.selectedPhoto = { (image) in
            var doc = weakRef.documentWithType(type!)
            doc.photo = image
        }
        
        cell?.selectedDate = { (date) in
            var doc = weakRef.documentWithType(type!)
            doc.expiryDate = date
        }
    }
    
    private func documentWithType(documentType: Document.CellType) -> Document {
        if let doc = docManager.documents[documentType] {
            return doc
        }
        let doc = Document(type: documentType, uploaded: false, expiryDate: nil, plateNumber: nil, photo: nil, photoURL: nil)
        docManager.documents[documentType] = doc
        return doc
    }
    
    private func setupCellWithExistingDoc(cell: DOCManagementCell, doc: Document) {
        cell.newDoc = true
        if let url = doc.photoURL {
            cell.docPhoto.hnk_setImageFromURL(url)
        } else if let image = doc.photo {
            cell.docPhoto.image = image
        } else {
            cell.docPhoto.image = TemplateImage
        }
        
        if let date = doc.expiryDate {
            cell.dateLabel?.highlitedText = NSDateFormatter.standordFormater().stringFromDate(date)
        } else {
            cell.dateLabel?.highlitedText = nil
        }
    }
    
    private func setupNewCell(cell: DOCManagementCell) {
        cell.newDoc = false
        cell.docPhoto.image = TemplateImage
        cell.dateLabel?.highlitedText = nil
    }
}