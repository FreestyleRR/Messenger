//
//  Conversation.swift
//  Messenger
//
//  Created by Паша Шарков on 03.08.2021.
//

import Foundation

struct Conversation {
    let id: String
    let name: String
    let otherUserId: String
    let latestMessage: LatestMessage
}

struct LatestMessage {
    let date: String
    let text: String
}
