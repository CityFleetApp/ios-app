//
//  Message.swift
//  CitiFleet
//
//  Created by Nick Kibish on 4/14/16.
//  Copyright © 2016 Nick Kibish. All rights reserved.
//

import UIKit
import Haneke

class Message: NSObject {
    var id: Int?
    var message: String?
    var roodHash: String?
    var roomId: Int?
    var date: NSDate?
    var author: User?
    var participants: [Friend] = []
    var imageURL: NSURL?
    var image: UIImage?
    var imageSize: CGSize?
    
    override init() {
        super.init()
    }
    
    init(json: AnyObject) {
        super.init()
        message = json[Response.Chat.text] as? String
        roomId = json[Response.Chat.room] as? Int
        if let urlString = json[Response.Chat.image] as? String {
            imageURL = NSURL(string: urlString)
            let width = (json[Response.Chat.imageSize] as! [CGFloat])[0]
            let height = (json[Response.Chat.imageSize] as! [CGFloat])[1]
            imageSize = CGSize(width: width, height: height)
        }
        if let dateStr = json[Response.Chat.created] as? String {
            let dateFormatter = NSDateFormatter.serverResponseFormat
            dateFormatter.timeZone = NSTimeZone(name: "GMT")
            date = dateFormatter.dateFromString(dateStr)
        }
        if let participantsArray = json[Response.Chat.participants] as? [AnyObject] {
            parseParticipants(participantsArray)
            let authorID = json[Response.Chat._author] as? Int
            let authorArr = participants.filter({ return $0.id == authorID })
            author = authorArr.count > 0 ? authorArr[0] : nil 
        }
    }
    
    func getImage(completion: ((UIImage?) -> ())) {
        let cache = Shared.imageCache
        if let url = imageURL {
            cache.fetch(URL: url).onSuccess({ [weak self] (image) in
                self?.image = image
                dispatch_async(dispatch_get_main_queue(), { 
                    completion(image)
                })
            })
            .onFailure({ (error) in
                dispatch_async(dispatch_get_main_queue(), {
                    completion(nil)
                })
            })
        } else {
            dispatch_async(dispatch_get_main_queue(), {
                completion(nil)
            })
        }
    }
}

//MARK: - Private Methods
extension Message {
    private func parseParticipants(usersArr: [AnyObject]) {
        for friendObj in usersArr {
            let friend = Friend(json: friendObj)
            participants.append(friend)
        }
    }
}