//
//  FriendListViewModel.swift
//  Messenger
//
//  Created by Паша Шарков on 09.08.2021.
//

import UIKit

protocol FriendListViewModelType {
    var users: [[String: String]] { get }
    var currentUserModel: UserModel { get }
    var reuseId: String { get }
    
    func getIndex(_ index: Int)
    func startCommunication()
}

class FriendListViewModel: FriendListViewModelType {
    
    private var coordinator: FriendListCoordinatorType
    
    var users: [[String : String]]
    var currentUserModel: UserModel
    
    init(_ coordinator: FriendListCoordinatorType, users: [[String: String]], currentUserModel: UserModel) {
        self.coordinator = coordinator
        self.users = users
        self.currentUserModel = currentUserModel
    }
    
    var reuseId: String {
        return "cell"
    }
    
    func getIndex(_ index: Int) {
        guard let uid = users[index]["uid"] else {
            return
        }
        guard let name = users[index]["name"] else {
            return
        }
        let model = UserModel(name: name, uid: uid)
        coordinator.friendUserModel = model
    }
    
    deinit {
        print("\(self) - \(#function)")
    }
    
    func startCommunication() {
        coordinator.currentUserModel = currentUserModel
        coordinator.startCommunication()
    }
    
}
