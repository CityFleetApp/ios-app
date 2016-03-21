//
//  PostingsRentSaleVC.swift
//  CitiFleet
//
//  Created by Nick Kibish on 3/20/16.
//  Copyright © 2016 Nick Kibish. All rights reserved.
//

import UIKit

class PostingsRentSaleVC: PostingsVC {
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let vc = OptionPostingBuild().createViewController(OptionPostingBuild.PostingType(rawValue: indexPath.row)!)
        navigationController?.pushViewController(vc, animated: true)
    }
}