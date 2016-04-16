//
//  SocketManager.swift
//  CitiFleet
//
//  Created by Nick Kibish on 4/16/16.
//  Copyright © 2016 Nick Kibish. All rights reserved.
//

import UIKit
import SocketRocket

class SocketManager: NSObject {
    enum Method: String {
        case PostMessage = "post_message"
        case ReceiveMessage  = "receive_message"
        case RoomInvitation = "room_invitation"
    }
    static let sharedManager = SocketManager()
    lazy var socket: SRWebSocket = {
        let request = NSMutableURLRequest(URL: NSURL(string: URL.Socket)!)
        request.setValue("\(Params.Header.token) \(User.currentUser()?.token!)", forHTTPHeaderField: Params.Header.authentication)
        return SRWebSocket(URLRequest: request)
    }()
    
    override init() {
        super.init()
        socket.delegate = self
    }
    
    func open() {
        socket.open()
    }
    
    func close() {
        socket.close()
    }
    
    func sendMessage(message: Message) {
        let params = [
            Params.Chat.method: Method.PostMessage.rawValue,
            Params.Chat.text: message.message!,
            Params.Chat.room: message.roodHash!
        ]
        let data = NSKeyedArchiver.archivedDataWithRootObject(params)
        socket.send(data)
    }
}

extension SocketManager: SRWebSocketDelegate {
    func webSocketDidOpen(webSocket: SRWebSocket!) {
        
    }
    
    func webSocket(webSocket: SRWebSocket!, didReceiveMessage message: AnyObject!) {
        
    }
}