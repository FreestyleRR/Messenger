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
    
    var users: [[String: String]] { get set }
    var currentUserModel: UserModel { get set }
    
    func start()
    func didSignUp()
}

class LoginCoordinator: LoginCoordinatorType {
    
    private weak var navigationController: UINavigationController?
    private weak var controller: LoginVC? = Storyboard.main.instantiateViewController()
    weak var transitions: LoginCoordinatorTransitions?
    private let rootNavigation = UINavigationController()
    
    var users: [[String : String]] = [[:]]
    var currentUserModel = UserModel()
    
    init(navigationController: UINavigationController?) {
        self.navigationController = navigationController
        controller?.viewModel = LoginViewModel(self)
    }
    
    func start() {
        if let controller = controller {
            navigationController?.pushViewController(controller, animated: false)
        }
    }
    
    func didSignUp() {
        transitions?.didSignUp()
    }
    
    deinit {
        print("\(self) - \(#function)")
    }
}
