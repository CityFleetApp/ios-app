//
//  JobOfferVC.swift
//  CitiFleet
//
//  Created by Nick Kibish on 3/29/16.
//  Copyright © 2016 Nick Kibish. All rights reserved.
//

import UIKit
import KMPlaceholderTextView

class JobOfferVC: UITableViewController {
    let InstructionCellIndex = 9
    let StandordCellHeight: CGFloat = 78
    
    @IBOutlet var dateLbl: HighlitableLabel!
    @IBOutlet var timeLbl: HighlitableLabel!
    @IBOutlet var pickupAddress: UITextField!
    @IBOutlet var destinationTF: UITextField!
    @IBOutlet var fareTF: UITextField!
    @IBOutlet var gratuityTF: UITextField!
    @IBOutlet var vehicleTypeTF: HighlitableLabel!
    @IBOutlet var suiteLbl: HighlitableLabel!
    @IBOutlet var companyLbl: HighlitableLabel!
    @IBOutlet var jobTypeLbl: HighlitableLabel!
    @IBOutlet var instructionsTV: KMPlaceholderTextView!
    
    var uploader = JobOfferPost()
    var instructionsCellHeight: CGFloat = 78
    var jobOffer: JobOffer?
    
    private let CatTypes = [
        "Regular",
        "Black",
        "SUV",
        "SUV"
    ]
    
    private let JobTypes = [
        "Drop off",
        "Wait & Return",
        "Hourly"
    ]
    
    override func viewDidLoad() {
        pickupAddress.delegate = self
        pickupAddress.inputAccessoryView = nil
        destinationTF.delegate = self
        destinationTF.inputAccessoryView = nil
        
        let textFields = [
            pickupAddress,
            destinationTF,
            fareTF,
            gratuityTF
        ]
        
        for tf in textFields {
            tf.setStandardSignUpPlaceHolder(tf.placeholder!)
        }
        
        if let offer = jobOffer {
            setupJobOffer(offer)
        }
    }
    
    private func setupJobOffer(offer: JobOffer) {
        dateLbl.highlitedText = NSDateFormatter(dateFormat: "yyyy-MM-dd").stringFromDate(offer.pickupDatetime!)
        timeLbl.highlitedText = NSDateFormatter(dateFormat: "HH:mm").stringFromDate(offer.pickupDatetime!)
        pickupAddress.text = offer.pickupAddress
        destinationTF.text = offer.destination
        fareTF.text = offer.fare
        gratuityTF.text = offer.gratuity
        instructionsTV.text = offer.instructions
        vehicleTypeTF.highlitedText = jobOffer?.vehicleType
        jobTypeLbl.highlitedText = jobOffer?.jobType
        suiteLbl.highlitedText = jobOffer?.suite == true ? "Yes" : "No"
        
        uploader.jobType = JobTypes.indexOf((jobOffer?.jobType)!)! + 1
        uploader.vehicleType = CatTypes.indexOf((jobOffer?.vehicleType)!)! + 1
        uploader.suite = jobOffer?.suite
        uploader.id = jobOffer?.id
    }
    
    private func resignAllTextViewes() {
        pickupAddress.resignFirstResponder()
        destinationTF.resignFirstResponder()
        fareTF.resignFirstResponder()
        gratuityTF.resignFirstResponder()
        instructionsTV.resignFirstResponder()
    }
    
    private func checkPostAvailability() -> Bool {
        var isError = false
        let labels = [
            dateLbl,
            timeLbl,
            vehicleTypeTF,
            suiteLbl,
            jobTypeLbl
        ]
        
        for lbl in labels {
            if !checkLabel(lbl) {
                isError = true
            }
        }
        
        let textFields = [
            pickupAddress,
            destinationTF,
            fareTF,
            gratuityTF
        ]
        
        for tf in textFields {
            if !checkTextField(tf) {
                isError = true
            }
        }
        
        if instructionsTV.text == nil || instructionsTV.text.characters.count == 0 {
            showNoInstructionsAlert()
            isError = true
        }
        return isError
    }
    
    private func checkLabel(label: HighlitableLabel) -> Bool {
        if label.highlitedText == nil || label.highlitedText?.characters.count == 0 {
            label.textColor = UIColor(hex: 0xe71d36, alpha: 0.7)
            return false
        }
        return true
    }
    
    private func checkTextField(textField: UITextField) -> Bool {
        if textField.text == nil || textField.text?.characters.count == 0 {
            textField.setErrorPlaceholder(textField.placeholder!)
            return false
        }
        return true
    }
    
    private func showNoInstructionsAlert() {
        let alert = UIAlertController(title: Titles.MarketPlace.noInstructions, message: Titles.MarketPlace.noInstructionsMsg, preferredStyle: .Alert)
        let cancelAction = UIAlertAction(title: Titles.cancel, style: .Cancel, handler: nil)
        alert.addAction(cancelAction)
        presentViewController(alert, animated: true, completion: nil)
    }
}

//MARK: - Actions
extension JobOfferVC {
    @IBAction func post(sender: AnyObject) {
        if !checkPostAvailability() {
            uploader.dateTime = dateLbl.highlitedText! + " " + timeLbl.highlitedText!
            uploader.pickupAddress = pickupAddress.text
            uploader.destinationAddress = destinationTF.text
            uploader.fare = fareTF.text
            uploader.gratuity = gratuityTF.text
            uploader.instructions = instructionsTV.text
            
            if let _ = jobOffer {
                patchJob()
            } else {
                postJob()
            }
        }
    }
}

//MARK: - Private Methods 
extension JobOfferVC {
    private func postJob() {
        uploader.upload() { [unowned self] (error) in
            if error == nil {
                self.navigationController?.popViewControllerAnimated(true)
            }
        }
    }
    
    private func patchJob() {
        uploader.patch() { [unowned self] (error) in
            if error == nil {
                self.navigationController?.popViewControllerAnimated(true)
            }
        }
    }
}

//MARK: - TableView Delegate
extension JobOfferVC {
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return indexPath.row == InstructionCellIndex ? instructionsCellHeight : StandordCellHeight
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let index = indexPath.row
        switch index {
        case 0:
            dateCellSelected()
            break
        case 1:
            timeCellSelected()
            break
        case 2:
            pickupCellSelected()
            break
        case 3:
            destinationCellSelected()
            break
        case 4:
            fareCellSelected()
            break
        case 5:
            gratuityCellSelected()
            break
        case 6:
            vehicleTypeSelected()
            break
        case 7:
            suiteCellSelected()
            break
        case 8:
            jobTypeCellSelected()
            break
        case InstructionCellIndex:
            instructionsCellSelected()
            break
        default:
            break
        }
    }
    
    override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        tableView.setZeroSeparator(cell)
        if indexPath.row == InstructionCellIndex {
            if let cell = cell as? MyRentSaleDescriptionCell {
                cell.changedHeight = { [unowned self] (newHeight) in
                    self.instructionsCellHeight = newHeight
                    self.tableView.beginUpdates()
                    self.tableView.endUpdates()
                }
            }
        }
    }
}

extension JobOfferVC {
    func dateCellSelected() {
        let picker = DOCManagementDatePicker.viewFromNib()
        picker.completion = { [unowned self] (date, closed) in
            if let date = date as? NSDate {
                self.dateLbl.highlitedText = NSDateFormatter.standordFormater().stringFromDate(date)
            }
        }
        picker.show()
    }
    
    func timeCellSelected() {
        let picker = DOCManagementDatePicker.viewFromNib()
        picker.datePicker.datePickerMode = .Time
        picker.completion = { [unowned self] (date, closed) in
            if let date = date as? NSDate {
                self.timeLbl.highlitedText = NSDateFormatter.standordTimeFormater().stringFromDate(date)
            }
        }
        picker.show()
    }
    
    func pickupCellSelected() {
        pickupAddress.becomeFirstResponder()
    }
    
    func destinationCellSelected() {
        destinationTF.becomeFirstResponder()
    }
    
    func fareCellSelected() {
        fareTF.becomeFirstResponder()
    }
    
    func gratuityCellSelected() {
        gratuityTF.becomeFirstResponder()
    }
    
    func vehicleTypeSelected() {
        resignAllTextViewes()
        
        
        let dialog = PickerDialog.viewFromNib()
        dialog.components = CatTypes
        dialog.completion = { [weak self] (selectedItem, canceled) in
            if !canceled {
                let index = selectedItem as! Int
                self?.uploader.vehicleType = index + 1
                self?.vehicleTypeTF.highlitedText = self?.CatTypes[index]
            }
        }
        dialog.show()
    }
    
    func suiteCellSelected() {
        resignAllTextViewes()
        let components = [
            "Yes",
            "No"
        ]
        
        let dialog = PickerDialog.viewFromNib()
        dialog.components = components
        dialog.completion = { [unowned self] (selectedItem, canceled) in
            if !canceled {
                let index = selectedItem as! Int
                self.uploader.suite = !Bool(index)
                self.suiteLbl.highlitedText = components[index]
            }
        }
        dialog.show()
    }
    
    func jobTypeCellSelected() {
        resignAllTextViewes()
        
        let dialog = PickerDialog.viewFromNib()
        dialog.components = JobTypes
        dialog.completion = { [unowned self] (selectedItem, canceled) in
            if !canceled {
                let index = selectedItem as! Int
                self.uploader.jobType = index + 1
                self.jobTypeLbl.highlitedText = self.JobTypes[index]
            }
        }
        dialog.show()
    }
    
    func instructionsCellSelected() {
        instructionsTV.becomeFirstResponder()
    }
}

extension JobOfferVC: UITextFieldDelegate {
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}