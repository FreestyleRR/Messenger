//
//  FriendListViewModel.swift
//  Messenger
//
//  Created by Паша Шарков on 09.08.2021.
//

import UIKit

protocol FriendListViewModelType {
    
}

class FriendListViewModel: FriendListViewModelType {
    
    private let coordinator: FriendListCoordinatorType
    
    init(_ coordinator: FriendListCoordinatorType) {
        self.coordinator = coordinator
    }
    
    deinit {
        print("\(self) - \(#function)")
    }
}
