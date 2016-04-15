//
//  ChatDataSource.swift
//  CitiFleet
//
//  Created by Nick Kibish on 4/14/16.
//  Copyright © 2016 Nick Kibish. All rights reserved.
//

import UIKit

class ChatDataSource: NSObject {
    var messages: [Message] = []
    var reloadData: (() -> ())!
    
    func loadData() {
        let message = Message()
        message.date = NSDate()
        message.id = 0
        message.author = User.currentUser()
        message.message = "Loren Ipsum"
        
        let message2 = Message()
        message2.date = NSDate(timeIntervalSince1970: NSDate().timeIntervalSince1970 - 1000)
        message2.id = 1
        message2.message = "Sivert Høyem (born 22 January 1976) is a Norwegian singer, best known as the vocalist of the rock band Madrugada. After the band broke up following the death of Robert Burås in 2007, he has enjoyed success as a solo artist and is also a member of The Volunteers with whom he released the album Exiles in 2006."
        
        let user = User()
        user.avatarURL = NSURL(string: "https://upload.wikimedia.org/wikipedia/commons/a/ad/Nobel_Peace_Prize_Concert_2010_Sivert_Høyem_IMG_6247.jpg")
        user.fullName = "Sivert Høyem"
        user.userName = "Sivert Høyem"
        message2.author = user
        
        messages = [message, message2]
        reloadData()
    }
}
