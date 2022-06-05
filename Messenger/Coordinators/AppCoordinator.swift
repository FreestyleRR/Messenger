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
    
    private var loginCoordinator: LoginCoord?
    private var friendCoordinator: FriendListCoord?
    private var messageCoordinator: MessageListCoordinatorType?
    
    init(window: UIWindow) {
        self.window = window
        self.window.rootViewController = rootController
        self.window.makeKeyAndVisible()
    }
    
    func startLogin() {
        loginCoordinator = LoginCoord(navigationController: rootController)
        loginCoordinator?.transitions = self
        loginCoordinator?.start()
    }
    
    func startFriends() {
        guard let coordinator = loginCoordinator else { return }
        
        friendCoordinator = FriendListCoord(navigationController: rootController,
                                                  users: coordinator.users,
                                                  currentUserModel: coordinator.currentUserModel)
        friendCoordinator?.transitions = self
        friendCoordinator?.start()
    }
    
    func startMessages() {
        guard let coordinator = friendCoordinator else { return }
        
        messageCoordinator = MessageListCoordinator(navigationController: rootController,
                                                    friendModel: coordinator.friendUserModel,
                                                    currentModel: coordinator.currentUserModel)
        messageCoordinator?.start()
    }
}

// MARK: - LoginCoordinatorTransitions -

extension AppCoordinator: LoginCoordinatorTransitions, FriendListCoordinatorTransitions {
    func didSignUp() {
        startFriends()
    }
    
    func startCommunication() {
        startMessages()
    }
}
