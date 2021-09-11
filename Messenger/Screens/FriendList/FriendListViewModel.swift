//
//  FriendListViewModel.swift
//  Messenger
//
//  Created by Паша Шарков on 09.08.2021.
//

import UIKit

protocol FriendListViewModelType {
    var users: [[String: String]] { get }
    
    func getIndex(_ index: Int)
    func startCommunication()
}

class FriendListViewModel: FriendListViewModelType {
    var users: [[String : String]]
    
    private var coordinator: FriendListCoordinatorType
    
    init(_ coordinator: FriendListCoordinatorType, users: [[String: String]]) {
        self.coordinator = coordinator
        self.users = users
    }
    
    func getIndex(_ index: Int) {
        guard let uid = users[index]["uid"] else {
            return
        }
        guard let name = users[index]["name"] else {
            return
        }
        let model = UserModel(name: name, uid: uid)
        coordinator.userModel = model
    }
    
    deinit {
        print("\(self) - \(#function)")
    }
    
    func startCommunication() {
        coordinator.startCommunication()
    }
    
}
