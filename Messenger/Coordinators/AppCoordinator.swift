//
//  AppCoordinator.swift
//  Messenger
//
//  Created by Паша Шарков on 09.08.2021.
//

import UIKit

class AppCoordinator {
    var window: UIWindow
    
    private var rootController = UINavigationController()
    
    private var loginCoordinator: LoginCoordinatorType?
    private var friendCoordinator: FriendListCoordinatorType?
    
    init(window: UIWindow) {
        self.window = window
        
        self.window.rootViewController = rootController
        self.window.makeKeyAndVisible()
    }
    
    func startLogin() {
        loginCoordinator = LoginCoordinator(navigationController: rootController)
        loginCoordinator?.transitions = self
        loginCoordinator?.start()
    }
    
    func startFriends() {
        friendCoordinator = FriendListCoordinator(navigationController: rootController, users: loginCoordinator?.users ?? [["name": "No friends"]])
        friendCoordinator?.start()
    }
}

// MARK: - LoginCoordinatorTransitions

extension AppCoordinator: LoginCoordinatorTransitions {
    func didSignUp() {
        startFriends()
    }
}
