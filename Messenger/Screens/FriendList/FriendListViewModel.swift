//
//  FriendListViewModel.swift
//  Messenger
//
//  Created by Паша Шарков on 09.08.2021.
//

import UIKit

protocol FriendListViewModelType {
    
    var users: [[String: String]]? { get }
    
}

class FriendListViewModel: FriendListViewModelType {
    var users: [[String : String]]?
    
    
    private let coordinator: FriendListCoordinatorType
    
    init(_ coordinator: FriendListCoordinatorType, users: [[String: String]]) {
        self.coordinator = coordinator
        self.users = users
    }
    
    deinit {
        print("\(self) - \(#function)")
    }
    
}
