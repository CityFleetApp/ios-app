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
    let InstructionCellIndex = 12
    let StandordCellHeight: CGFloat = 78
    let RenewJobTitle = "RENEW JOB"
    
    @IBOutlet var jobTitTF: UITextField!
    @IBOutlet var dateLbl: HighlitableLabel!
    @IBOutlet var timeLbl: HighlitableLabel!
    @IBOutlet var pickupAddress: UITextField!
    @IBOutlet var destinationTF: UITextField!
    @IBOutlet var fareTF: UITextField!
    @IBOutlet var gratuityTF: UITextField!
    @IBOutlet var tollsTF: UITextField!
    @IBOutlet var vehicleTypeTF: HighlitableLabel!
    @IBOutlet var suiteLbl: HighlitableLabel!
    @IBOutlet var companyLbl: HighlitableLabel!
    @IBOutlet var jobTypeLbl: HighlitableLabel!
    @IBOutlet var instructionsTV: KMPlaceholderTextView!
    
    @IBOutlet var postBtn: UIButton!
    @IBOutlet var deleteBtn: UIButton!
    
    var uploader = JobOfferPost()
    var instructionsCellHeight: CGFloat = 78
    var jobOffer: JobOffer?
    
    private var dataPreloader: JobOfferPreloader!
    
    private var carTypes: [String] = []
    
    private var jobTypes: [String] = []
    
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
        
        postBtn.setDefaultShadow()
        deleteBtn.setDefaultShadow()
        
        dataPreloader = JobOfferPreloader(completion: { [weak self] in
            if let types = self?.dataPreloader.vehicleTypes {
                self?.carTypes = types
            }
            if let types = self?.dataPreloader.jobTypes {
                self?.jobTypes = types 
            }
        })
        dataPreloader.downloadData()
    }
    
    private func setupJobOffer(offer: JobOffer) {
        jobTitTF.text = offer.jobTitle
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
        tollsTF.text = jobOffer?.tolls
        companyLbl.highlitedText = jobOffer?.authorType?.rawValue
        
        uploader.isCompany = jobOffer?.isCompany
        uploader.jobTitle = offer.jobTitle
        uploader.jobType = jobTypes.indexOf((jobOffer?.jobType)!)! + 1
        uploader.vehicleType = carTypes.indexOf((jobOffer?.vehicleType)!)! + 1
        uploader.suite = jobOffer?.suite
        uploader.id = jobOffer?.id
        uploader.tolls = jobOffer?.tolls
        
        tableView.tableFooterView?.frame = CGRect(x: 0, y: 0, width: 0, height: 200)
        postBtn.setTitle(RenewJobTitle, forState: .Normal)
    }
    
    private func resignAllTextViewes() {
        pickupAddress.resignFirstResponder()
        destinationTF.resignFirstResponder()
        fareTF.resignFirstResponder()
        gratuityTF.resignFirstResponder()
        instructionsTV.resignFirstResponder()
        jobTitTF.resignFirstResponder()
        tollsTF.resignFirstResponder()
    }
    
    private func checkPostAvailability() -> Bool {
        var isError = false
        let labels = [
            dateLbl,
            timeLbl,
            vehicleTypeTF,
            suiteLbl,
            jobTypeLbl,
            companyLbl
        ]
        
        for lbl in labels {
            if !checkLabel(lbl) {
                isError = true
            }
        }
        
        let textFields = [
            jobTitTF,
            pickupAddress,
            destinationTF,
            fareTF,
            gratuityTF,
            tollsTF
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
            uploader.jobTitle = jobTitTF.text
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
    
    @IBAction func deleteJob(sender: AnyObject) {
        let urlStr = "marketplace/offers/\((jobOffer?.id)!)/"
        
        RequestManager.sharedInstance().delete(urlStr, parameters: nil) { [weak self] (json, error) in
            if error == nil {
                let alert = UIAlertController(title: "Job Offer Deletod", message: nil, preferredStyle: .Alert)
                let okAction = UIAlertAction(title: "OK", style: .Cancel, handler: { (action) in
                    self?.navigationController?.popViewControllerAnimated(true)
                })
                alert.addAction(okAction)
                self?.presentViewController(alert, animated: true, completion: nil)
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
            jobTitTF.becomeFirstResponder()
            break
        case 1:
            dateCellSelected()
            break
        case 2:
            timeCellSelected()
            break
        case 3:
            pickupCellSelected()
            break
        case 4:
            destinationCellSelected()
            break
        case 5:
            fareCellSelected()
            break
        case 6:
            gratuityCellSelected()
            break
        case 7:
            tollsTF.becomeFirstResponder()
            break
        case 8:
            vehicleTypeSelected()
            break
        case 9:
            suiteCellSelected()
            break
        case 10:
            corpanyCellSelected()
            break
        case 11:
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
                cell.changedHeight = { [weak self] (newHeight) in
                    self?.instructionsCellHeight = newHeight
                    self?.tableView.beginUpdates()
                    self?.tableView.endUpdates()
                }
            }
        }
    }
}

extension JobOfferVC {
    func dateCellSelected() {
        resignAllTextViewes()
        let picker = DOCManagementDatePicker.viewFromNib()
        picker.datePicker.minimumDate = NSDate()
        picker.completion = { [unowned self] (date, closed) in
            if let date = date as? NSDate {
                self.dateLbl.highlitedText = NSDateFormatter.standordFormater().stringFromDate(date)
            }
        }
        picker.show()
    }
    
    func timeCellSelected() {
        resignAllTextViewes()
        
        let picker = DOCManagementDatePicker.viewFromNib()
        if NSDateFormatter.standordFormater().stringFromDate(NSDate()) == self.dateLbl.highlitedText {
            picker.datePicker.minimumDate = NSDate()
        }
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
        dialog.components = carTypes
        dialog.completion = { [weak self] (selectedItem, canceled) in
            if !canceled {
                let index = selectedItem as! Int
                self?.uploader.vehicleType = index + 1
                self?.vehicleTypeTF.highlitedText = self?.carTypes[index]
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
    
    func corpanyCellSelected() {
        resignAllTextViewes()
        let components = [
            "Company",
            "Personal"
        ]
        
        let dialog = PickerDialog.viewFromNib()
        dialog.components = components
        dialog.completion = { [unowned self] (selectedItem, canceled) in
            if !canceled {
                let index = selectedItem as! Int
                self.uploader.isCompany = !Bool(index)
                self.companyLbl.highlitedText = components[index]
            }
        }
        dialog.show()
    }
    
    func jobTypeCellSelected() {
        resignAllTextViewes()
        
        let dialog = PickerDialog.viewFromNib()
        dialog.components = jobTypes
        dialog.completion = { [unowned self] (selectedItem, canceled) in
            if !canceled {
                let index = selectedItem as! Int
                self.uploader.jobType = index + 1
                self.jobTypeLbl.highlitedText = self.jobTypes[index]
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