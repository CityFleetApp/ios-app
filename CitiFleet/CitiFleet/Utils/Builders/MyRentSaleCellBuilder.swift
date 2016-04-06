//
//  MyRentSaleCellBuilder.swift
//  CitiFleet
//
//  Created by Nick Kibish on 3/19/16.
//  Copyright © 2016 Nick Kibish. All rights reserved.
//

import UIKit

class PostingCellBuilder: NSObject {
    var tableView: UITableView
    var dataManager: MarketPlaceManager
    var postingCreater: RentSaleCreator!
    
    var reloadData: (() -> ())!
    var reloadCell: (( CGFloat ) -> ())!
    
    private var CellID = "Cell"
    init(tableView: UITableView, marketPlaceManager: MarketPlaceManager) {
        dataManager = marketPlaceManager
        self.tableView = tableView
        super.init()
        dataManager.reloadData = { [unowned self] in
            self.tableView.reloadData()
        }
    }
    
    func build(indexPath: NSIndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
}

class MyRentSaleCellBuilder: PostingCellBuilder {
    private let PostingCellID = "PostingCell"
    
    override func build(indexPath: NSIndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 7:
            return createTextFieldCell()
        case 8:
            return createDescriptionCell()
        default:
            var cell = tableView.dequeueReusableCellWithIdentifier(PostingCellID) as? PostingCell
            if cell == nil {
                cell = PostingCell(style: .Default, reuseIdentifier: PostingCellID)
            }
            let index = indexPath.row
            cell?.title.text = CellResources.RentSale.Titles[index]
            cell?.placeHolder?.placeholderText = CellResources.RentSale.PlaceHolders[index]
            cell?.icon.image = UIImage(named: CellResources.RentSale.iconNames[index])?.imageWithRenderingMode(.AlwaysTemplate)
            if indexPath.row == 1 {
                cell?.setEditable(postingCreater.model != nil)
            }
            cell?.setEditable(true)
            
            setupCellAction(cell!, indexPath: indexPath)
            return cell!
        }
    }
    
    func createTextFieldCell() -> UITableViewCell {
        let cellID = MyRentSalePriceCell.CellID
        var cell = tableView.dequeueReusableCellWithIdentifier(cellID) as? MyRentSalePriceCell
        if cell == nil {
            cell = MyRentSalePriceCell(style: .Default, reuseIdentifier: cellID)
        }
        cell?.didSelect = {
            cell?.priceTF.becomeFirstResponder()
        }
        
        cell?.changedText = { [unowned self] (text) in
            self.postingCreater.price = text
        }
        
        cell?.setEditable(true)
        return cell!
    }
    
    func createDescriptionCell() -> UITableViewCell {
        let cellID = MyRentSaleDescriptionCell.CellID
        var cell = tableView.dequeueReusableCellWithIdentifier(cellID) as? MyRentSaleDescriptionCell
        if cell == nil {
            cell = MyRentSaleDescriptionCell(style: .Default, reuseIdentifier: cellID)
        }
        cell?.didSelect = {
            cell?.descriptionTV.becomeFirstResponder()
        }
        cell?.changedHeight = { [unowned self] (newHeight) in
            self.reloadCell(newHeight)
        }
        cell?.changedText = { [unowned self] (text) in
            self.postingCreater.rentSaleDescription = text
        }
        
        cell?.setEditable(true)
        return cell!
    }
    
    private func setupCellAction(cell: PostingCell, indexPath: NSIndexPath) {
        let arrays = [
            dataManager.make,
            dataManager.model,
            dataManager.type,
            dataManager.colors,
            createYearArr(),
            dataManager.fuel,
            dataManager.seats
        ]
        cell.didSelect = { [weak self] in
            let dialog = PickerDialog.viewFromNib()
            dialog.components = arrays[indexPath.row].map({ return $0.1 })
            dialog.completion = { (selectedItem, canceled) in
                if !canceled {
                    self?.selectedItem(selectedItem!, indexPath: indexPath)
                }
            }
            dialog.show()
        }
    }
    
    private func createYearArr() -> [MarketPlaceManager.MarketPlaceItem] {
        var yearsArr: [MarketPlaceManager.MarketPlaceItem] = []
        let df = NSDateFormatter()
        df.dateFormat = "yyyy"
        let year = Int(df.stringFromDate(NSDate()))
        for i in 2009...year! {
            yearsArr.append((i - 2009, String(i)))
        }
        return yearsArr
    }
    
    private func selectedItem(item: AnyObject, indexPath: NSIndexPath) {
        let index = item as! Int
        var cellText = ""
        switch indexPath.row {
        case 0:
            let make = dataManager.make[index]
            postingCreater.make = make
            resetModel()
            cellText = make.1
            break
        case 1:
            let model = dataManager.model[index]
            postingCreater.model = model
            cellText = model.1
            break
        case 2:
            let type = dataManager.type[index]
            postingCreater.type = type
            cellText = type.1
            break
        case 3:
            let color = dataManager.colors[index]
            postingCreater.color = color
            cellText = color.1
            break
        case 4:
            let year = String(2009 + index)
            postingCreater.year = year
            cellText = year
            break
        case 5:
            let fuel = dataManager.fuel[index]
            postingCreater.fuel = fuel
            cellText = fuel.1
            break
        case 6:
            let seats = dataManager.seats[index]
            postingCreater.seats = seats
            cellText = seats.1
            break
        default:
            break
        }
        
        let cell = tableView.cellForRowAtIndexPath(indexPath) as? PostingCell
        cell?.placeHolder?.highlitedText = cellText
    }
    
    private func resetModel() {
        if let make = postingCreater.make {
            dataManager.loadModels(make.0) { [unowned self] in
                self.tableView.reloadRowsAtIndexPaths([NSIndexPath(forRow: 1, inSection: 0)], withRowAnimation: .Automatic)
            }
        }
        postingCreater.model = nil
        let cell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: 1, inSection: 0)) as? PostingCell
        cell?.placeHolder?.highlitedText = nil
        cell?.placeHolder?.placeholderText = CellResources.RentSale.PlaceHolders[1]
        cell?.setEditable(true)
    }
}
