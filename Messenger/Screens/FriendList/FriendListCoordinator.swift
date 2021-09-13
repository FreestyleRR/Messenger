//
//  FriendListCoordinator.swift
//  Messenger
//
//  Created by Паша Шарков on 09.08.2021.
//

import UIKit

protocol FriendListCoordinatorTransitions: class {
    func startCommunication()
}

protocol FriendListCoordinatorType {
    var transitions: FriendListCoordinatorTransitions? { get set }
    
    var friendUserModel: UserModel { get set }
    var currentUserModel: UserModel { get set }
    
    func startCommunication()
    func start()
}

class FriendListCoordinator: FriendListCoordinatorType {
    
    private weak var navigationController: UINavigationController?
    private weak var controller = Storyboard.main.controller(withClass: FriendListVC.self)
    weak var transitions: FriendListCoordinatorTransitions?
    
    var friendUserModel = UserModel()
    var currentUserModel = UserModel()
    
    init(navigationController: UINavigationController?, users: [[String: String]], currentUserModel: UserModel) {
        self.navigationController = navigationController
        controller?.viewModel = FriendListViewModel(self, users: users, currentUserModel: currentUserModel)
    }
    
    func start() {
        if let controller = controller {
            navigationController?.pushViewController(controller, animated: true)
        }
    }
    
    func startCommunication() {
        transitions?.startCommunication()
    }
    
    deinit {
        print("\(self) - \(#function)")
    }
}
