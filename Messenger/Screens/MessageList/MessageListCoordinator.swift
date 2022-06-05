//
//  MessageListCoordinator.swift
//  Messenger
//
//  Created by Паша Шарков on 09.08.2021.
//

import UIKit

protocol MessageListCoordinatorType {
    func start()
}

class MessageListCoordinator: MessageListCoordinatorType {
    
    private weak var navigationController: UINavigationController?
    weak var controller = Storyboard.main.controller(withClass: MessageListVC.self)
    
    init(navigationController: UINavigationController?, friendModel: UserModel, currentModel: UserModel) {
        self.navigationController = navigationController
        controller?.viewModel = MessageListViewModel(self, friendModel: friendModel, currentModel: currentModel)
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
