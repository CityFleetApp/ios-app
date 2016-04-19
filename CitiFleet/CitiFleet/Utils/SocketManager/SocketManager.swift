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

class SocketWrapper: NSObject {
    var socket: OwnSocket
    weak var delegate: SRWebSocketDelegate? {
        didSet {
            socket.delegate = delegate
        }
    }
    
    init(URL: NSURL) {
        socket = OwnSocket(URL: URL)
        super.init()
    }
    
    var readyState: SRReadyState {
        return socket.readyState
    }
    
    func open() {
        socket.open()
    }
    
    func close() {
        socket.close()
    }
    
    func send(message:AnyObject?) {
        socket.send(message)
    }
}

class SocketManager: NSObject {
    // MARK: Notifications
    static let NewMessage = "ReceivedNewMessage"
    static let NewRoom = "JoinedNewRoom"
    
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
    var socket: SocketWrapper?
    
    var state: SocketManager.State = .Closed
    
    func reloadSocket() {
//        socket = nil
        let url = "\(URL.Socket)?token=\((User.currentUser()?.token)!)"
        socket = SocketWrapper(URL: NSURL(string: url)!)
        socket?.delegate = self
//        state == .Closed
    }
    
    override init() {
        super.init()
    }
    
    func open() {
        if socket == nil {
            let url = "\(URL.Socket)?token=\((User.currentUser()?.token)!)"
            socket = SocketWrapper(URL: NSURL(string: url)!)
            socket?.delegate = self
            socket?.open()
        }
//        reloadSocket()
//        if socket?.readyState != .OPEN {
//        if state == .Closed {
//            state = .Opening
//            socket?.delegate = self
//            socket?.open()
//        }
    }
    
    func close() {
//        if state == .Opened {
//            state = .Closing
            socket?.close()
        socket = nil 
//        }
    }
    
    func sendMessage(message: Message) {
        let params = [
            Params.Chat.method: Method.PostMessage.rawValue,
            Params.Chat.text: message.message!,
            Params.Chat.room: message.roomId!
        ]
        do {
            let jsonData = try NSJSONSerialization.dataWithJSONObject(params, options: NSJSONWritingOptions.PrettyPrinted)
            let str = String(data: jsonData, encoding: NSUTF8StringEncoding)
            socket?.send(str)
        } catch let error as NSError {
            print(error)
        }
    }
}

//MARK: - Private Method
extension SocketManager {
    private func sendNewMessage(messageDict: [String: AnyObject]) {
        let message = Message(json: messageDict)
        let notification = NSNotification(name: SocketManager.NewMessage, object: message)
        NSNotificationCenter.defaultCenter().postNotification(notification)
    }
    
    private func sendNewInvitation(roomDict: [String: AnyObject]) {
        
    }
}

//MARK: - Socket Delegate
extension SocketManager: SRWebSocketDelegate {
    func webSocketDidOpen(webSocket: SRWebSocket!) {
        state = .Opened
    }
    
    func webSocket(webSocket: SRWebSocket!, didCloseWithCode code: Int, reason: String!, wasClean: Bool) {
        webSocket.delegate = nil
        socket = nil
    }
    
    func webSocket(webSocket: SRWebSocket!, didFailWithError error: NSError!) {
        
    }
    
    func webSocket(webSocket: SRWebSocket!, didReceiveMessage message: AnyObject!) {
        print("\nMessage: \(message)\nClass:\(message.classForCoder)")
        if let data = (message as! String).dataUsingEncoding(NSUTF8StringEncoding) {
            do {
                let messageDict: [String: AnyObject] = try NSJSONSerialization.JSONObjectWithData(data, options: []) as! [String:AnyObject]
                if messageDict[Response.Chat.messageType] as! String == SocketManager.Method.ReceiveMessage.rawValue {
                    sendNewMessage(messageDict)
                } else if messageDict[Response.Chat.messageType] as! String == SocketManager.Method.RoomInvitation.rawValue {
                    sendNewInvitation(messageDict)
                }
            } catch let error as NSError {4
                print(error)
            }
        }
    }
    
    func webSocket(webSocket: SRWebSocket!, didReceivePong pongPayload: NSData!) {
        
    }
}