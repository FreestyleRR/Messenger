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
