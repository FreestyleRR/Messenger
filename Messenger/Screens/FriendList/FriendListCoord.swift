//
//  FriendListCoord.swift
//  Messenger
//
//  Created by Паша Шарков on 09.08.2021.
//

import UIKit

protocol FriendListCoordinatorTransitions: AnyObject {
    func startCommunication()
}

class FriendListCoord {
    private weak var navigationController: UINavigationController?
    private weak var controller = Storyboard.main.controller(withClass: FriendListVC.self)
    weak var transitions: FriendListCoordinatorTransitions?
    
    var friendUserModel = UserModel()
    var currentUserModel = UserModel()
    
    init(navigationController: UINavigationController?, users: [[String: String]], currentUserModel: UserModel) {
        self.navigationController = navigationController
        controller?.viewModel = FriendListVM(self, users: users, currentUserModel: currentUserModel)
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
