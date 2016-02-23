//
//  UITableView+Ext.swift
//  CitiFleet
//
//  Created by Nick Kibish on 2/23/16.
//  Copyright © 2016 Nick Kibish. All rights reserved.
//

import UIKit

extension UITableView {
    func setZeroSeparator(cell: UITableViewCell) {
        if(self.respondsToSelector(Selector("setSeparatorInset:"))){
            self.separatorInset = UIEdgeInsetsZero
        }
        
        if(self.respondsToSelector(Selector("setLayoutMargins:"))){
            self.layoutMargins = UIEdgeInsetsZero
        }
        
        if(cell.respondsToSelector(Selector("setLayoutMargins:"))){
            cell.layoutMargins = UIEdgeInsetsZero
        }
    }
}
