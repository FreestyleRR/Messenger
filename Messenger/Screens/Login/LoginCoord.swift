//
//  LoginCoord.swift
//  Messenger
//
//  Created by Паша Шарков on 09.08.2021.
//

import Foundation
import UIKit

protocol LoginCoordinatorTransitions: AnyObject {
    func didSignUp()
}

class LoginCoord {
    private weak var navigationController: UINavigationController?
    private weak var controller: LoginVC? = Storyboard.main.instantiateViewController()
    private let rootNavigation = UINavigationController()
    weak var transitions: LoginCoordinatorTransitions?
    
    var users: [[String : String]] = [[:]]
    var currentUserModel = UserModel()
    
    init(navigationController: UINavigationController?) {
        self.navigationController = navigationController
        controller?.viewModel = LoginVM(self)
    }
    
    func start() {
        if let controller = controller {
            navigationController?.navigationBar.installBlurEffect()
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
