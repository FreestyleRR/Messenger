//
//  MessageListCoordinator.swift
//  Messenger
//
//  Created by Паша Шарков on 09.08.2021.
//

import UIKit

protocol MessageListCoordinatorTransitions: class {
    
}

protocol MessageListCoordinatorType {
    func start()
}

class MessageListCoordinator: MessageListCoordinatorType {
    private weak var navigationController: UINavigationController?
    weak var controller = Storyboard.main.controller(withClass: MessageListVC.self)
    weak var transitions: MessageListCoordinatorTransitions?
    
    init(navigationController: UINavigationController?, model: UserModel) {
        self.navigationController = navigationController
        controller?.viewModel = MessageListViewModel(self, model: model)
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
