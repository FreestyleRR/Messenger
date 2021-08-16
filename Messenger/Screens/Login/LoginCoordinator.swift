//
//  LoginCoordinator.swift
//  Messenger
//
//  Created by Паша Шарков on 09.08.2021.
//

import Foundation
import UIKit

protocol LoginCoordinatorTransitions: class {
    
    func signUp()
}

protocol LoginCoordinatorType {
 
    func signUp()
}

class LoginCoordinator: LoginCoordinatorType {
    
    private weak var navigationController: UINavigationController?
    private weak var transitions: LoginCoordinatorTransitions?
    private weak var controller = Storyboard.login.controller(withClass: LoginVC.self)
    private var serviceHolder: ServiceHolder
    
    init(navigationController: UINavigationController?, transitions: LoginCoordinatorTransitions?, serviceHolder: ServiceHolder) {
        self.navigationController = navigationController
        self.transitions = transitions
        self.serviceHolder = serviceHolder
        
//        controller?.viewModel = LoginViewModel(self, serviceHolder: serviceHolder)
    }
    
    func start() {
        if let controller = controller {
            navigationController?.setViewControllers([controller], animated: false)
        }
    }
    
    
    func signUp() {
        
        transitions?.signUp()
    }
    
}
