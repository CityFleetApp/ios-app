//
//  EditVehicleVC.swift
//  CitiFleet
//
//  Created by Nick Kibish on 4/5/16.
//  Copyright © 2016 Nick Kibish. All rights reserved.
//

import UIKit

class LoadDataOperation: NSOperation {
    typealias MarketPlaceItem = (Int, String)
    enum State: String {
        case Ready, Executing, Finished
        
        private var keyPath: String {
            return "is" + rawValue
        }
    }
    
    var URLstr: String
    var completed: (([MarketPlaceItem]) -> ())
    var state = State.Ready {
        willSet {
            willChangeValueForKey(newValue.keyPath)
            willChangeValueForKey(state.keyPath)
        }
        didSet {
            didChangeValueForKey(oldValue.keyPath)
            didChangeValueForKey(state.keyPath)
        }
    }
    
    private let Params = ("id", "name")
    
    override var ready: Bool {
        return super.ready && state == .Ready
    }
    
    override var executing: Bool {
        return state == .Executing
    }
    
    override var finished: Bool {
        return state == .Finished
    }
    
    override var asynchronous: Bool {
        return true
    }
    
    init(URLstr: String, completion: (([MarketPlaceItem]) -> ())) {
        self.URLstr = URLstr
        completed = completion
        super.init()
    }
    
    internal override func start() {
        if cancelled {
            state = .Finished
            return
        }
        
        main()
        state = .Executing
    }
    
    internal override func cancel() {
        state = .Finished
    }
    
    internal override func main() {
        RequestManager.sharedInstance().makeSilentRequest(.GET, baseURL: URLstr, parameters: nil) { [weak self] (json, error) -> () in
            if let results = json?.arrayObject {
                self?.fillArray(results)
            }
        }
    }
    
    private func fillArray(results: [AnyObject]) {
        var array: [MarketPlaceItem] = []
        for result in results {
            let id = result[Params.0] as! Int
            let name = result[Params.1] as! String
            array.append((id, name))
        }
        state = .Finished
        completed(array)
    }
}

class VehicleDataLoader: NSObject {
    typealias MarketPlaceItem = LoadDataOperation.MarketPlaceItem
    static let OperationsKeyPath = "operations"
    
    var make: [MarketPlaceItem] = []
    var colors: [MarketPlaceItem] = []
    var type: [MarketPlaceItem] = []
    var model: [MarketPlaceItem] = []
    
    private var loadCompletion: (() -> ())?
    
    func preloadData(completion: (() -> ())?) {
        loadCompletion = completion
        LoaderViewManager.showLoader()
        
        typealias MPURL = URL.Marketplace
        let operationQueue = NSOperationQueue()
        operationQueue.maxConcurrentOperationCount = 1
        
        operationQueue.addOperation(LoadDataOperation(URLstr: MPURL.make, completion: { [weak self] (arr) in
            self?.make = arr
            }))
        operationQueue.addOperation(LoadDataOperation(URLstr: MPURL.types, completion: { [weak self] (arr) in
            self?.type = arr
            }))
        operationQueue.addOperation(LoadDataOperation(URLstr: MPURL.color, completion: { [weak self] (arr) in
            self?.colors = arr
            }))
        
        operationQueue.addObserver(self, forKeyPath: VehicleDataLoader.OperationsKeyPath, options: NSKeyValueObservingOptions(), context: nil)
    }
    
    func loadModels(makeID: Int, completion: (() -> ())) {
        model.removeAll()
        let url = "\(URL.Marketplace.model)?make=\(makeID)"
        RequestManager.sharedInstance().get(url, parameters: nil) { [unowned self] (json, error) -> () in
            let Params = ("id", "name")
            if let results = json?.arrayObject {
                for modelsJSON in results {
                    let id = modelsJSON[Params.0] as! Int
                    let name = modelsJSON[Params.1] as! String
                    self.model.append((id, name))
                }
            }
            completion()
        }
    }
    
    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        if keyPath != VehicleDataLoader.OperationsKeyPath {
            super.observeValueForKeyPath(keyPath, ofObject: object, change: change, context: context)
            return
        }
        if let oq = object as? NSOperationQueue {
            if oq.operations.count == 0 {
                LoaderViewManager.hideLoader()
                loadCompletion?()
            }
        }
    }
}

struct MyVehicle {
    var make: LoadDataOperation.MarketPlaceItem?
    var model: LoadDataOperation.MarketPlaceItem?
    var type: LoadDataOperation.MarketPlaceItem?
    var color: LoadDataOperation.MarketPlaceItem?
    var year: LoadDataOperation.MarketPlaceItem?
}

class EditVehicleVC: UITableViewController {
    typealias MarketPlaceItem = LoadDataOperation.MarketPlaceItem
    static let OperationsKeyPath = "operations"
    let dataLoader = VehicleDataLoader()
    var myVehicle = MyVehicle()
    
    override func viewDidLoad() {
        dataLoader.preloadData { [weak self] in
            self?.setupData()
        }
    }
}

//MARK: - Actions -
extension EditVehicleVC {
    @IBAction func saveVehicle() {
        let user = User.currentUser()
        user?.profile.carColor = myVehicle.color?.0
        user?.profile.carColorDisplay = myVehicle.color?.1
        user?.profile.carModel = myVehicle.model?.0
        user?.profile.carModelDisplay = myVehicle.model?.1
        user?.profile.carMake = myVehicle.make?.0
        user?.profile.carMakeDisplay = myVehicle.make?.1
        user?.profile.carType = myVehicle.type?.0
        user?.profile.carTypeDisplay = myVehicle.type?.1
        user?.profile.carYear = myVehicle.year?.0
        navigationController?.popViewControllerAnimated(true)
    }
}

//MARK: - Private Methods -
extension EditVehicleVC {
    private func setupData() {
        let profile = User.currentUser()?.profile
        if let make = profile?.carMake {
            setCellText(NSIndexPath(forRow: 0, inSection: 0), cellText: dataLoader.make[make - 1].1)
            dataLoader.loadModels(make) { }
            myVehicle.make = (make, (profile?.carMakeDisplay)!)
        }
        
        if let model = profile?.carModelDisplay {
            setCellText(NSIndexPath(forRow: 1, inSection: 0), cellText: model)
            myVehicle.model = ((profile?.carModel)!, model)
        }
        
        if let type = profile?.carTypeDisplay {
            setCellText(NSIndexPath(forRow: 2, inSection: 0), cellText: type)
            myVehicle.type = ((profile?.carType)!, type)
        }
        
        if let color = profile?.carColorDisplay {
            setCellText(NSIndexPath(forRow: 3, inSection: 0), cellText: color)
            myVehicle.color = ((profile?.carColor)!, color)
        }
        
        if let year = profile?.carYear {
            setCellText(NSIndexPath(forRow: 4, inSection: 0), cellText: "\(year + 2009)")
            myVehicle.year = ((profile?.carYear)!, "\((profile?.carYear)! + 2009)")
        }
    }
    
    private func setCellText(indexPath: NSIndexPath, cellText: String) {
        let cell = tableView.cellForRowAtIndexPath(indexPath) as? PostingCell
        cell?.placeHolder?.highlitedText = cellText
        cell?.setEditable(true)
    }
    
    private func createYearArr() -> [MarketPlaceManager.MarketPlaceItem] {
        var yearsArr: [MarketPlaceManager.MarketPlaceItem] = []
        let df = NSDateFormatter()
        df.dateFormat = "yyyy"
        let year = Int(df.stringFromDate(NSDate()))!
        for i in 2009...year {
            yearsArr.append((i - 2009, String(i)))
        }
        return yearsArr
    }
    
    private func selectedItem(item: AnyObject, indexPath: NSIndexPath) {
        let index = item as! Int
        var cellText = ""
        switch indexPath.row {
        case 0:
            let make = dataLoader.make[index]
            myVehicle.make = make
            cellText = make.1
            resetModel()
            break
        case 1:
            let model = dataLoader.model[index]
            myVehicle.model = model
            cellText = model.1
            break
        case 2:
            let type = dataLoader.type[index]
            myVehicle.type = type
            cellText = type.1
            break
        case 3:
            let color = dataLoader.colors[index]
            myVehicle.color = color
            cellText = color.1
            break
        case 4:
            let year = createYearArr()[index]
            myVehicle.year = year
            cellText = year.1
            break
        default:
            break
        }
        
        let cell = tableView.cellForRowAtIndexPath(indexPath) as? PostingCell
        cell?.placeHolder?.highlitedText = cellText
    }
    
    private func resetModel() {
        if let make = myVehicle.make {
            dataLoader.loadModels(make.0) {
//                self.tableView.reloadRowsAtIndexPaths([NSIndexPath(forRow: 1, inSection: 0)], withRowAnimation: .Automatic)
            }
        }
        myVehicle.model = nil
        let cell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: 1, inSection: 0)) as? PostingCell
        cell?.placeHolder?.highlitedText = nil
//        cell?.placeHolder?.placeholderText = CellResources.RentSale.PlaceHolders[1]
        cell?.setEditable(true)
    }
}

//MARK: - TableView Delegate -
extension EditVehicleVC {
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let arrays = [
            dataLoader.make,
            dataLoader.model,
            dataLoader.type,
            dataLoader.colors,
            createYearArr()
        ]
        
        let dialog = PickerDialog.viewFromNib()
        dialog.components = arrays[indexPath.row].map({ return $0.1 })
        dialog.completion = { [weak self] (selectedItem, canceled) in
            if !canceled {
                self?.selectedItem(selectedItem!, indexPath: indexPath)
            }
        }
        dialog.show()
    }
    
    override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.row == 1 {
            let cell = cell as! PostingCell
            cell.setEditable(!(myVehicle.make == nil && myVehicle.model == nil))
        }
    }
}