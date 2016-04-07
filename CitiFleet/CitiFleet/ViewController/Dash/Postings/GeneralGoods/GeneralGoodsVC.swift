//
//  GeneralGoodsVC.swift
//  CitiFleet
//
//  Created by Nick Kibish on 3/30/16.
//  Copyright © 2016 Nick Kibish. All rights reserved.
//

import UIKit
import KMPlaceholderTextView

class GeneralGoodsVC: UITableViewController {
    let StandordCellHeight: CGFloat = 78
    let DescriptionCellIndex: Int = 3
    
    private let GoodConditions = [
        "Brand New (Never Used)",
        "New (Slightly Used)",
        "Used (Good Condition)",
        "Used"
    ]
    
    @IBOutlet var itemTF: UITextField!
    @IBOutlet var priceTF: UITextField!
    @IBOutlet var conditionsTF: HighlitableLabel!
    @IBOutlet var descriptionTF: KMPlaceholderTextView!
    @IBOutlet var goodsPhotoCV: UICollectionView!
    
    var photoDelegate: PostingPhotosCollectionDelegate!
    var instructionsCellHeight: CGFloat = 78
    var uploader = GeneralGoodsUploader()
    
    var generalGood: GoodForSale?
    
    override func viewDidLoad() {
        itemTF.delegate = self
        itemTF.inputAccessoryView = nil
        
        let menuItemDelete = UIMenuItem(title: "Delete", action: Selector("deletePhoto:"))
        //        let menuItemEdit = UIMenuItem(title: "Edit", action: Selector("editPhoto:"))
        UIMenuController.sharedMenuController().menuItems = [menuItemDelete]
        UIMenuController.sharedMenuController().menuVisible = true
        photoDelegate = PostingPhotosCollectionDelegate(reloadData: { [weak self] in
            self?.goodsPhotoCV.reloadData()
        })
        goodsPhotoCV.dataSource = photoDelegate
        goodsPhotoCV.delegate = photoDelegate
        
        if let _ = generalGood {
            setupGeneralGood()
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        let cell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: 3, inSection: 0)) as? MyRentSaleDescriptionCell
        cell?.textViewDidChange(descriptionTF)
    }
}

//MARK: - Private Methods 
extension GeneralGoodsVC {
    private func setupGeneralGood() {
        for photo in (generalGood?.photosURLs)! {
            photoDelegate.images.append(GalleryPhoto(image: nil, imageData: nil, attributedCaptionTitle: NSAttributedString(), largePhotoURL: photo.URL, thumbURL: photo.URL, id: photo.id))
        }
        goodsPhotoCV.reloadData()
        
        itemTF.text = generalGood?.goodName
        priceTF.text = generalGood?.price
        descriptionTF.text = generalGood?.itemDescription
        conditionsTF.highlitedText = generalGood?.condition
        uploader.condition = GoodConditions.indexOf((generalGood?.condition)!)! + 1
    }
    
    private func checkData() -> Bool {
        var isError = false
        
        if itemTF.text == nil || itemTF.text?.characters.count == 0 {
            itemTF.setErrorPlaceholder(itemTF.placeholder!)
            isError = true
        }
        
        if priceTF.text == nil || priceTF.text?.characters.count == 0 {
            priceTF.setErrorPlaceholder(priceTF.placeholder!)
            isError = true
        }
        
        if conditionsTF.highlitedText == nil || conditionsTF.highlitedText?.characters.count == 0 {
            conditionsTF.textColor = UIColor(hex: 0xe71d36, alpha: 0.7)
            isError = true
        }
        
        if descriptionTF.text == nil || descriptionTF.text.characters.count == 0 {
            showAlert(Titles.MarketPlace.noDescription, message: Titles.MarketPlace.noGoodDescriptionMsg)
        } else if photoDelegate.images.count == 0 {
            showAlert(Titles.MarketPlace.noPhotos, message: Titles.MarketPlace.noPhotosMsg)
        }
        
        return !isError
    }
    
    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        let cancelAction = UIAlertAction(title: Titles.cancel, style: .Cancel, handler: nil)
        alert.addAction(cancelAction)
        presentViewController(alert, animated: true, completion: nil)
    }
}

//MARK: - Actions 
extension GeneralGoodsVC {
    @IBAction func upload() {
        if checkData() {
            uploader.photos = photoDelegate.images.map({ (photo) -> UIImage in
                return photo.image!
            })
            uploader.itemName = itemTF.text
            uploader.ascingPrice = priceTF.text
            uploader.itemDescription = descriptionTF.text
            uploader.upload({ [unowned self] (error) in
                self.navigationController?.popViewControllerAnimated(true)
            })
        }
    }
}

//MARK: - TableView Delegate
extension GeneralGoodsVC {
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return indexPath.row == DescriptionCellIndex ? instructionsCellHeight : StandordCellHeight
    }
    
    override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        tableView.setZeroSeparator(cell)
        if indexPath.row == DescriptionCellIndex {
            if let cell = cell as? MyRentSaleDescriptionCell {
                cell.changedHeight = { [unowned self] (newHeight) in
                    self.instructionsCellHeight = newHeight
                    self.tableView.beginUpdates()
                    self.tableView.endUpdates()
                }
            }
        }
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        switch indexPath.row {
        case 0:
            selectedItem()
            break
        case 1:
            selectedPrice()
            break
        case 2:
            selectedConditions()
            break
        case 3:
            selectedDescription()
            break
        default:
            break
        }
    }
}

// MARK: - Selection Cell
extension GeneralGoodsVC {
    private func resignAllTextView() {
        itemTF.resignFirstResponder()
        priceTF.resignFirstResponder()
        descriptionTF.resignFirstResponder()
    }
    
    func selectedItem() {
        itemTF.becomeFirstResponder()
    }
    
    func selectedPrice() {
        priceTF.becomeFirstResponder()
    }
    
    func selectedConditions() {
        resignAllTextView()
        
        let dialog = PickerDialog.viewFromNib()
        dialog.components = GoodConditions
        dialog.completion = { [weak self] (selectedItem, canceled) in
            if !canceled {
                let index = selectedItem as! Int
                self?.conditionsTF.highlitedText = self?.GoodConditions[index]
                self?.uploader.condition = index + 1
            }
        }
        dialog.show()
        
    }
    
    func selectedDescription() {
        descriptionTF.becomeFirstResponder()
    }
    
}

//MARK: - UITextField Delegate
extension GeneralGoodsVC: UITextFieldDelegate {
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}