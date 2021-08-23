//
//  LoginCoordinator.swift
//  Messenger
//
//  Created by Паша Шарков on 09.08.2021.
//

import Foundation
import UIKit

protocol LoginCoordinatorTransitions: class {
    func didSignUp()
}

protocol LoginCoordinatorType {
    var transitions: LoginCoordinatorTransitions? { get set }
    
    func start()
    func didSignUp()
}

class LoginCoordinator: LoginCoordinatorType {
    
    private weak var navigationController: UINavigationController?
    private weak var controller: LoginVC? = Storyboard.main.instantiateViewController()
    weak var transitions: LoginCoordinatorTransitions?
    
    private let rootNavigation = UINavigationController()
    
    init(navigationController: UINavigationController?) {
        self.navigationController = navigationController
        controller?.viewModel = LoginViewModel(self)
    }
    
    func start() {
        if let controller = controller {
            navigationController?.setViewControllers([controller], animated: false)
        }
    }
    
    func didSignUp() {
        transitions?.didSignUp()
    }
}
