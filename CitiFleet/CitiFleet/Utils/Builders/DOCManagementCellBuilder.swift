//
//  DOCManagementCellBuilder.swift
//  CitiFleet
//
//  Created by Nick Kibish on 3/22/16.
//  Copyright © 2016 Nick Kibish. All rights reserved.
//

import UIKit

class DOCManagementCellBuilder: NSObject {
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
    var tableView: UITableView
    var indexPath: NSIndexPath
    
    init(tableView: UITableView, indexPath: NSIndexPath) {
        self.tableView = tableView
        self.indexPath = indexPath
        super.init()
    }
    
    func build() -> DOCManagementCell {
        var cell = tableView.dequeueReusableCellWithIdentifier(DOCManagementCellID) as? DOCManagementCell
        if cell == nil {
            cell = DOCManagementCell(style: .Default, reuseIdentifier: DOCManagementCellID)
        }
        cell?.title.text = DOCManagementCellBuilder.titles[indexPath.row]
        return cell!
    }
    
    
}
