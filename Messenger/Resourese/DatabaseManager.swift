//
//  DatabaseManager.swift
//  Messenger
//
//  Created by Паша Шарков on 28.07.2021.
//

import Foundation
import FirebaseDatabase

final class DatabaseManager {
    
    static let shared = DatabaseManager()
    
    private let database = Database.database().reference()
    
    public func insertUser(with user: ChatUser) {
        database.child(user.userName)
    }
}

struct ChatUser {
    let userName: String
}
