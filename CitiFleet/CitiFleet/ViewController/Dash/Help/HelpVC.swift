//
//  HelpVC.swift
//  CitiFleet
//
//  Created by Nick Kibish on 3/21/16.
//  Copyright © 2016 Nick Kibish. All rights reserved.
//

import UIKit

class HelpVC: UIViewController {
    var URL = NSURL(string: "http://citifleet.steelkiwi.com/api/help/")!
    override func viewWillAppear(animated: Bool) {
        title = "Help"
        navigationController?.navigationBar.hidden = false
        let webView = UIWebView(frame: view.bounds)
        view.addSubview(webView)
        
        let request = NSURLRequest(URL: URL)
        webView.loadRequest(request)
        
        let barButton = UIBarButtonItem(image: UIImage(named: Resources.BackIc), style: .Plain, target: self, action: "back:")
        self.navigationItem.leftBarButtonItem = barButton
    }
}
