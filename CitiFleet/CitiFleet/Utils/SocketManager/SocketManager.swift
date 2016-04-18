//
//  SocketManager.swift
//  CitiFleet
//
//  Created by Nick Kibish on 4/16/16.
//  Copyright © 2016 Nick Kibish. All rights reserved.
//

import UIKit
import SocketRocket
import SwiftyJSON

class SocketManager: NSObject {
    enum State {
        case Opened
        case Opening
        case Closed
        case Closing
    }
    enum Method: String {
        case PostMessage = "post_message"
        case ReceiveMessage  = "receive_message"
        case RoomInvitation = "room_invitation"
    }
    static let sharedManager = SocketManager()
    lazy var socket: SRWebSocket = {
        let url = "\(URL.Socket)?token=\((User.currentUser()?.token)!)"
        return SRWebSocket(URL: NSURL(string: url)!)
    }()
    
    var state: SocketManager.State = .Closed
    
    override init() {
        super.init()
        socket.delegate = self
    }
    
    func open() {
        if state == .Closed {
            state = .Opening
            socket.open()
        }
    }
    
    func close() {
        if state == .Opened {
            state = .Closing
            socket.close()
        }
    }
    
    func sendMessage(message: Message) {
        let params = [
            Params.Chat.method: Method.PostMessage.rawValue,
            Params.Chat.text: message.message!,
            Params.Chat.room: message.roodHash!
        ]
        let data = NSKeyedArchiver.archivedDataWithRootObject(params)
        let str = "{\"method\" : \"post_message\", \"text\" : \"the only thing \", \"room\" :  \"vxzrocCFriHYZLoOFLrW7xnsLPH7NUXC\"}"
        socket.send(data)
        
    }
}

extension SocketManager: SRWebSocketDelegate {
    func webSocketDidOpen(webSocket: SRWebSocket!) {
        state = .Opened
    }
    
    func webSocket(webSocket: SRWebSocket!, didCloseWithCode code: Int, reason: String!, wasClean: Bool) {
        state = .Closed
    }
    
    func webSocket(webSocket: SRWebSocket!, didFailWithError error: NSError!) {
        
    }
    
    func webSocket(webSocket: SRWebSocket!, didReceiveMessage message: AnyObject!) {
        
    }
    
    func webSocket(webSocket: SRWebSocket!, didReceivePong pongPayload: NSData!) {
        
    }
}