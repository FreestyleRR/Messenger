//
//  FriendListCoordinator.swift
//  Messenger
//
//  Created by Паша Шарков on 09.08.2021.
//

import UIKit

protocol FriendListCoordinatorTransitions: class {
    
}

protocol FriendListCoordinatorType {
    func start()
}

class FriendListCoordinator: FriendListCoordinatorType {
    private weak var navigationController: UINavigationController?
    private weak var controller = Storyboard.main.controller(withClass: FriendListVC.self)
    weak var transitions: FriendListCoordinatorTransitions?
    
    init(navigationController: UINavigationController?, users: [[String: String]]) {
        self.navigationController = navigationController
        controller?.viewModel = FriendListViewModel(self, users: users)
    }
    
    func start() {
        if let controller = controller {
            navigationController?.pushViewController(controller, animated: true)
        }
    }
    
    deinit {
        print("\(self) - \(#function)")
    }
}
