//
//  User.swift
//  Messenger
//
//  Created by Паша Шарков on 02.08.2021.
//

import Foundation

struct UserModel {
    var name: String
    var uid: String
    
    init() {
        name = "empty"
        uid = "empty"
    }
    
    init(name: String, uid: String) {
        self.name = name
        self.uid = uid
    }
}
