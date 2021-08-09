//
//  Message.swift
//  Messenger
//
//  Created by Паша Шарков on 02.08.2021.
//

import Foundation

struct MessageModel {
    public var fromId: String
    public var toId: String
    public var text: String?
    public var sentDate: Date
}

struct Sender {
    public var senderId: String
}
