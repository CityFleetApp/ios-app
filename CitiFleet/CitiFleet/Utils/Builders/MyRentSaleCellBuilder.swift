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
        dataManager.reloadData = { [weak self] in
            self?.tableView.reloadData()
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
    
    func resetModel() {
        if let make = postingCreater.make {
            dataManager.loadModels(make.0) { [weak self] in
                self?.tableView.reloadRowsAtIndexPaths([NSIndexPath(forRow: 1, inSection: 0)], withRowAnimation: .Automatic)
            }
        }
        postingCreater.model = nil
        let cell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: 1, inSection: 0)) as? PostingCell
        cell?.placeHolder?.highlitedText = nil
        cell?.placeHolder?.placeholderText = CellResources.RentSale.PlaceHolders[1]
        cell?.setEditable(true)
    }
}

extension MyRentSaleCellBuilder {
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
}

class UpdateRentSaleCellBuilder: MyRentSaleCellBuilder {
    var existingCar: CarForRentSale?
    
    override init(tableView: UITableView, marketPlaceManager: MarketPlaceManager) {
        super.init(tableView: tableView, marketPlaceManager: marketPlaceManager)
        dataManager.reloadData = { [weak self] in
            self?.tableView.reloadData()
            if let id = self?.dataManager.makeID((self?.existingCar?.make)!) {
                self?.dataManager.loadModels(id, completion: { 
                    self?.tableView.reloadRowsAtIndexPaths([NSIndexPath(forRow: 1, inSection: 0)], withRowAnimation: .Automatic)
                })
            }
        }
    }
    
    override func build(indexPath: NSIndexPath) -> UITableViewCell {
        let cellText = cellTextForIndexPath(indexPath)
        let cell = super.build(indexPath)
        if var cell = cell as? CarBuilderCellText {
            cell.cellText = cellText
        }
        return cell
    }
    
    override func resetModel() {
        existingCar?.model = nil
        super.resetModel()
    }
}

extension UpdateRentSaleCellBuilder {
    private func cellTextForIndexPath(indexPath: NSIndexPath) -> String? {
        switch indexPath.row {
        case 0: return postingCreater.make != nil ? postingCreater.make?.1 : existingCar?.make
        case 1: return postingCreater.model != nil ? postingCreater.model?.1 : existingCar?.model
        case 2: return postingCreater.type != nil ? postingCreater.type?.1 : existingCar?.type
        case 3: return postingCreater.color != nil ? postingCreater.color?.1 : existingCar?.color
        case 4: return postingCreater.year != nil ? postingCreater.year : existingCar?.year
        case 5: return postingCreater.fuel != nil ? postingCreater.fuel?.1 : existingCar?.fuel
        case 6: return postingCreater.seats != nil ? postingCreater.seats?.1 : existingCar?.seats != nil ? "\(existingCar!.seats!)" : nil
        case 7: return postingCreater.price != nil ? postingCreater.price : existingCar?.price
        case 8: return postingCreater.rentSaleDescription != nil ? postingCreater.rentSaleDescription : existingCar?.itemDescription
        default: return nil
        }
    }
}