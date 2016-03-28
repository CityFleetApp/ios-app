//
//  OptionPostingBuild.swift
//  CitiFleet
//
//  Created by Nick Kibish on 3/20/16.
//  Copyright © 2016 Nick Kibish. All rights reserved.
//

import UIKit

class OptionPostingBuild: NSObject {
    enum PostingType: Int {
        case Rent = 0
        case Sale = 1
    }
    
    private let StoryboardName = "Postings"
    private let ViewControllerID = "OptionsPostingVC"
    
    func createViewController(type: PostingType) -> OptionsPostingVC {
        let storyboard = UIStoryboard(name: StoryboardName, bundle: NSBundle.mainBundle())
        let viewController = storyboard.instantiateViewControllerWithIdentifier(ViewControllerID) as! OptionsPostingVC
        let index = type.rawValue
        viewController.title = PostingTitles[index]
        viewController.cellHeight = CellHeights[index]
        viewController.numborOfRows = 5
        
        return viewController
    }
}
