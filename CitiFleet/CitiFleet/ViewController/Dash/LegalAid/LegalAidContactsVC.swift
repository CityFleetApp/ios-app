//
//  LegalAidContactsVC.swift
//  CitiFleet
//
//  Created by Nick Kibish on 3/15/16.
//  Copyright © 2016 Nick Kibish. All rights reserved.
//

import UIKit

class LegalAidContactsVC: UITableViewController {
    var actor: LegalAidActor?
    var sections: [[LegalAidActorContact]]?
    private var activeType: LegalAiContactType?
    private var cellHeight: CGFloat = 78
    
    override func viewDidLoad() {
        title = actor?.name
        createSections()
        tableView.reloadData()
    }
    
    private func createSections() {
        sections = []
        addContactsToCell(.Phone)
        addContactsToCell(.Email)
        addContactsToCell(.Address)
    }
    
    private func addContactsToCell(type: LegalAiContactType) {
        if let contacts = sectionWithType(type) {
            sections?.append(contacts)
        }
    }
    
    private func sectionWithType(type: LegalAiContactType) -> [LegalAidActorContact]? {
        var contacts: [LegalAidActorContact] = []
        activeType = type
        if let allContacts = actor?.contacts {
            for contact in allContacts {
                if contact.type == type {
                    contacts.append(contact)
                }
            }
        }
        if contacts.count == 0 {
            return nil
        }
        return contacts
    }
}

extension LegalAidContactsVC {
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return cellHeight
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let contact = sections![section][0]
        return titleWithType(contact.type)
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        if let sections = sections {
            return sections.count
        }
        return 0
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections![section].count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let contact = sections![indexPath.section][indexPath.row]
        let cell = tableView.dequeueReusableCellWithIdentifier(CellID.LegalAidCells.ContactCell) as! LegalAidCell
        cell.icon.image = imageWithType(contact.type)
        cell.title.text = contact.title
        cell.placeHolder?.highlitedText = contact.value
        cell.setEditable(true)
        return cell
    }
    
    override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        tableView.setZeroSeparator(cell)
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        switch indexPath.section {
        case 0:
            call(indexPath.row)
            break
        case 1:
            openGoogleMaps(indexPath.row)
            break
        case 2:
            openGoogleMaps(indexPath.row)
            break
        default:
            break
        }
    }
    
    private func imageWithType(type: LegalAiContactType) -> UIImage {
        let imageName: String?
        switch type {
        case .Phone:
            imageName = Resources.LegalAid.PhoneIcon
            break
        case .Email:
            imageName = Resources.LegalAid.MailIcon
            break
        case .Address:
            imageName = Resources.LegalAid.AddressIcon
            break
        }
        let image = UIImage(named: imageName!)
        return image!.imageWithRenderingMode(.AlwaysTemplate)
    }
    
    private func titleWithType(type: LegalAiContactType) -> String {
        switch type {
        case .Phone: return "      Phone"
        case .Email: return "      Email"
        case .Address: return "      Address"
        }
    }
}

extension LegalAidContactsVC {
    func call(phoneIndex: Int) {
        let contact = sections![0][phoneIndex]
        UIApplication.sharedApplication().openURL(NSURL(string: "tel://" + contact.value)!)
    }
    
    func sendMail(mailIndex: Int) {
        
    }
    
    func openGoogleMaps(addressIndex: Int) {
        let contact = sections![1][addressIndex]
        if (UIApplication.sharedApplication().canOpenURL(NSURL(string:"comgooglemaps://")!)) {
            guard let urlString = ("comgooglemaps://?q="+contact.value).stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet()) else { return }
            guard let url = NSURL(string: urlString) else { return }
            
            UIApplication.sharedApplication().openURL(url)
        } else {
            guard let urlString = ("https://www.google.com/maps/?q="+contact.value).stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet()) else { return }
            guard let url = NSURL(string: urlString) else { return }
            
            UIApplication.sharedApplication().openURL(url)
        }
        
    }
    
}
