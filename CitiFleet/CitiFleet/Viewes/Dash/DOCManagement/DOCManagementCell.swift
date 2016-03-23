//
//  DOCManagementCell.swift
//  CitiFleet
//
//  Created by Nick Kibish on 3/22/16.
//  Copyright © 2016 Nick Kibish. All rights reserved.
//

import UIKit

class DOCManagementCell: DashMenuCell {
    @IBOutlet var docPhoto: UIImageView!
    @IBOutlet var saveBtn: UIButton!
    @IBOutlet var dateLabel: HighlitableLabel?
    
    var saveDocument: ((Document) -> ())!
    var docType: Document.CellType!
    var photo: UIImage?
    var expDate: NSDate?
    
    private let expDateColor = UIColor(hex: 0x4C5A76, alpha: 1)
    private let placeHolderColor = UIColor.lightGrayColor()
    private let ExpDateTag = 100
    private let getereSelector = "photoClicked:"
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        titleColor = selectedColor
        saveBtn.setDefaultShadow()
        setupPhotoGesture()
    }
    
    deinit {
        print("Destroyed cell")
    }
    
    var availableForSave: Bool {
        get {
            return expDate != nil && photo != nil
        }
    }
    
    private func setupPhotoGesture() {
        let gesture = UITapGestureRecognizer(target: self, action: Selector(getereSelector))
        docPhoto.addGestureRecognizer(gesture)
    }
    
    func didSelect() {
        let picker = DOCManagementDatePicker.viewFromNib()
        picker.completion = completionDatePicking
        picker.show()
    }
    
    private func completionDatePicking(date: AnyObject?, closed: Bool) {
        if closed {
            return
        }
        if let date = date as? NSDate {
            expDate = date
            let dateFormater = NSDateFormatter()
            dateFormater.dateFormat = "yyyy-MM-dd"
            dateLabel?.highlitedText = dateFormater.stringFromDate(date)
        }
    }
    
    override func selectCell() {
        super.selectCell()
        dateLabel?.textColor = UIColor.whiteColor()
        (contentView.viewWithTag(ExpDateTag) as! UILabel).textColor = UIColor.whiteColor()
    }
    
    override func deselectCell() {
        super.deselectCell()
        dateLabel?.highlitedText = nil 
        (contentView.viewWithTag(ExpDateTag) as! UILabel).textColor = expDateColor
    }
}

extension DOCManagementCell {
    @IBAction func photoClicked(sender: UITapGestureRecognizer) {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .ActionSheet)
        let fabric = CameraFabric(imagePicerDelegate: self)
        alert.addAction(fabric.cameraAction())
        alert.addAction(fabric.libraryAction())
        alert.addAction(fabric.cancelAction())
        AppDelegate.sharedDelegate().rootViewController().presentViewController(alert, animated: true, completion: nil)
    }
    
    @IBAction func saveDocument(sender: UIButton) {
        let doc = Document(type: docType, expiryDate: expDate, plateNumber: nil, photo: photo!)
        saveDocument(doc)
    }
}

extension DOCManagementCell: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        let scaledImage = image.normalizedImage()
        picker.dismissViewControllerAnimated(true) {
            self.photo = scaledImage
            self.docPhoto.image = scaledImage
        }
    }
}