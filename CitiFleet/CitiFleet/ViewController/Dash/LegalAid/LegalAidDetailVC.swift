//
//  LegalAidDetailVC.swift
//  CitiFleet
//
//  Created by Nick Kibish on 3/12/16.
//  Copyright © 2016 Nick Kibish. All rights reserved.
//

import UIKit
import Cosmos

class LegalAidDetailVC: UITableViewController {
    private var cellHeight: CGFloat = 78
    private var buttonCellHeight: CGFloat = 91
    
    @IBOutlet var actorTitle: UILabel!
    @IBOutlet var actorImage: UIImageView!
    
    @IBOutlet var locationLabel: HighlitableLabel!
    @IBOutlet var actorLabel: HighlitableLabel!
    @IBOutlet var yearsLabel: HighlitableLabel!
    @IBOutlet var nameLabel: HighlitableLabel!
    @IBOutlet var raitingView: CosmosView!
    
    var setuper: LegalAidSetuper?
    var headerTitle: String!
    var legalAidManager: LegalAidManager?
    
    var selectedLocation: LegalAidLocation? {
        didSet {
            if let location = selectedLocation {
                locationLabel.highlitedText = location.name
                selectedActor = nil
            }
        }
    }
    
    var selectedActor: LegalAidActor? {
        didSet {
            actorLabel.highlitedText = selectedActor?.name
            nameLabel.highlitedText = selectedActor?.name
            if let years = selectedActor?.yearsExp {
                yearsLabel.highlitedText = String(years)
            }
            if let rating = selectedActor?.rating {
                raitingView.rating = rating
            }
            
            tableView.reloadData()
        }
    }
    
    var locationsList: [LegalAidLocation]? {
        didSet {
            if locationsList == nil {
                let alert = UIAlertController(title: Titles.LegalAid.noLocationsTitle, message: Titles.LegalAid.noLocationsMsg, preferredStyle: .Alert)
                let cancelAction = UIAlertAction(title: Titles.cancel, style: .Cancel, handler: nil)
                alert.addAction(cancelAction)
                self.presentViewController(alert, animated: true, completion: nil)
            }
            setEditableLocationCell(locationsList != nil)
            selectedActor = nil
        }
    }
    
    var actorList: [LegalAidActor]? {
        didSet {
            setEditableActorCell(actorList != nil)
        }
    }
    
    override func viewDidLoad() {
        if let setuper =  setuper {
            setuper.setupViewController()
        }
        loadLocations()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let contactViewController = segue.destinationViewController as? LegalAidContactsVC {
            contactViewController.actor = selectedActor
        }
    }
    
    private func loadLocations() {
        legalAidManager?.getLocations({ (locations, error) -> () in
            if locations != nil && (locations?.count)! > 0 {
                self.locationsList = locations
            }
        })
    }
    
    private func setEditableActorCell(editable: Bool) {
        let cell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: 1, inSection: 0)) as! LegalAidCell
        cell.setEditable(editable)
    }
    
    private func setEditableLocationCell(editable: Bool) {
        let cell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: 0, inSection: 0)) as! LegalAidCell
        cell.setEditable(editable)
    }
}

//MARK: - Table View Delegate
extension LegalAidDetailVC {
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 1: return selectedActor == nil ? nil : headerTitle
        default: return nil
        }
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.section == 1 && selectedActor == nil {
            return 0
        } else if indexPath.section == 1 && indexPath.row == 3 {
            return buttonCellHeight
        }
        
        return cellHeight
    }
}

extension LegalAidDetailVC {
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.section != 0 {
            return
        }
        
        switch indexPath.row {
        case 0:
            selectedLocationCell()
            break
        case 1:
            selectActorCell()
            break
        default:
            break
        }
    }
    
    //MARK: Selecte Location
    private func selectedLocationCell() {
        let pickerView = PickerDialog.viewFromNib()
        pickerView.components = self.locationsList!.map({ (location) -> String in
            return location.name
        })
        pickerView.showOnView((self.navigationController?.view)!)
        pickerView.complation = setSelectedLocation
    }
    
    private func setSelectedLocation(index: Int?, title: String?, closed: Bool) {
        if closed {
            return
        }
        if let index = index {
            locationLabel.highlitedText = title
            selectedLocation = locationsList![index]
            legalAidManager?.getActors(selectedLocation!, completion: handleLoadActorsResponse)
        }
    }
    
    private func handleLoadActorsResponse(actors: [LegalAidActor]?, error: NSError?) {
        actorList = actors
    }
    
    //MARK: Select Actor
    private func selectActorCell() {
        let pickerView = PickerDialog.viewFromNib()
        pickerView.components = self.actorList!.map({ (actor) -> String in
            return actor.name
        })
        pickerView.showOnView((self.navigationController?.view)!)
        pickerView.complation = setSelectedActor
    }
    
    private func setSelectedActor(index: Int?, title: String?, closed: Bool) {
        if closed {
            return
        }
        if let index = index {
            actorLabel.highlitedText = title
            selectedActor = actorList![index]
        }
    }
}