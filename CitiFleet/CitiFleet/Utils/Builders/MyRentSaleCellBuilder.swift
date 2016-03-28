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
    var postingCreater: RentSazeCreator!
    
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
        var cell = tableView.dequeueReusableCellWithIdentifier(PostingCellID) as? PostingCell
        if cell == nil {
            cell = PostingCell(style: .Default, reuseIdentifier: PostingCellID)
        }
        let index = indexPath.row
        cell?.title.text = CellResources.RentSale.Titles[index]
        cell?.placeHolder?.placeholderText = CellResources.RentSale.PlaceHolders[index]
        cell?.icon.image = UIImage(named: CellResources.RentSale.iconNames[index])?.imageWithRenderingMode(.AlwaysTemplate)
        cell?.setEditable(indexPath.row != 1)
        setupCellAction(cell!, indexPath: indexPath)
        return cell!
    }
    
    private func setupCellAction(cell: PostingCell, indexPath: NSIndexPath) {
        let arrays = [dataManager.make, dataManager.make, dataManager.type, dataManager.colors, createYearArr(), dataManager.seats]
        cell.didSelect = {
            let dialog = PickerDialog.viewFromNib()
            dialog.components = arrays[indexPath.row].map({ return $0.1 })
            dialog.completion = { [unowned self] (selectedItem, canceled) in
                if !canceled {
                    self.selectedItem(selectedItem!, indexPath: indexPath)
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
            let model = dataManager.model![index]
            postingCreater.model = model
            cellText = model.1
            break
        case 2:
            let type = dataManager.type[index]
            postingCreater.model = type
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
        postingCreater.model = nil
        let cell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: 1, inSection: 0)) as? PostingCell
        cell?.placeHolder?.placeholderText = CellResources.RentSale.PlaceHolders[1]
        cell?.setEditable(true)
    }
}
