//
//  OwnSocket.swift
//  CitiFleet
//
//  Created by Nick Kibish on 4/18/16.
//  Copyright © 2016 Nick Kibish. All rights reserved.
//

import UIKit
import SocketRocket

class OwnSocket: SRWebSocket {
    deinit {
        print("Destroyed ")
    }
}
