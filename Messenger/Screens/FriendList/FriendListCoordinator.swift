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
    
}

class FriendListCoordinator: FriendListCoordinatorType {
    
    
    private weak var navigationController: UINavigationController?
    private weak var transitions: FriendListCoordinatorTransitions?
    private weak var controller = Storyboard.friendList.controller(withClass: FriendListVC.self)
    private var serviceHolder: ServiceHolder
    
    init(navigationController: UINavigationController?, transitions: FriendListCoordinatorTransitions?, serviceHolder: ServiceHolder) {
        self.navigationController = navigationController
        self.transitions = transitions
        self.serviceHolder = serviceHolder
        
        controller?.viewModel = FriendListViewModel(self, serviceHolder: serviceHolder)
    }
    
    func start() {
        if let controller = controller {
            navigationController?.setViewControllers([controller], animated: true)
        }
    }
    
    deinit {
        print("ReadingListCoordinator - deinit")
    }
}
