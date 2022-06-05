//
//  FriendListVM.swift
//  Messenger
//
//  Created by Паша Шарков on 09.08.2021.
//

import UIKit

class FriendListVM {
    private var coordinator: FriendListCoord
    
    var users: [[String : String]]
    var currentUserModel: UserModel
    
    init(_ coordinator: FriendListCoord, users: [[String: String]], currentUserModel: UserModel) {
        self.coordinator = coordinator
        self.users = users
        self.currentUserModel = currentUserModel
    }
    
    func getIndex(_ index: Int) {
        guard let uid = users[index]["user_id"], let name = users[index]["user_name"] else {
            return
        }
        coordinator.friendUserModel = UserModel(name: name, uid: uid)
    }
    
    deinit {
        print("\(self) - \(#function)")
    }
    
    func startCommunication() {
        coordinator.currentUserModel = currentUserModel
        coordinator.startCommunication()
    }
}

extension FriendListVM {
    var title: String {
        "Friends"
    }
}
