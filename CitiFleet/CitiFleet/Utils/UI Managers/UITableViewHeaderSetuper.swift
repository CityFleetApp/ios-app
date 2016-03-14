//
//  UITableViewHeaderSetuper.swift
//  CitiFleet
//
//  Created by Nick Kibish on 3/14/16.
//  Copyright © 2016 Nick Kibish. All rights reserved.
//

import UIKit

class UITableViewHeaderSetuper: NSObject {
    var tableView: UITableView
    var headerView: UIView?
    var headerHeight: CGFloat
    
    init(tableView: UITableView, headerHeight: CGFloat) {
        self.tableView = tableView
        self.headerHeight = headerHeight
        super.init()
        
        setupTableView()
        updateHeaderView()
    }
    
    func setupTableView() {
        headerView = tableView.tableHeaderView as! AvatarCameraView
        tableView.tableHeaderView = nil
        tableView.addSubview(headerView!)
        
        tableView.contentInset = UIEdgeInsets(top: headerHeight, left: 0, bottom: 0, right: 0)
        tableView.contentOffset = CGPoint(x: 0, y: -headerHeight)
    }
    
    func updateHeaderView() {
        var headerRect = CGRect(x: 0, y: -headerHeight, width: tableView.bounds.width, height: headerHeight)
        if tableView.contentOffset.y < -headerHeight {
            headerRect.origin.y = tableView.contentOffset.y
            headerRect.size.height = -tableView.contentOffset.y
        }
        
        headerView!.frame = headerRect
    }
}
