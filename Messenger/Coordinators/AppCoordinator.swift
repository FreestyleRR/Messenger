//
//  AppCoordinator.swift
//  Messenger
//
//  Created by Паша Шарков on 09.08.2021.
//

import Foundation


protocol Coordinator {
    var childCoordinators: [Coordinator] { get }
    func start()
}

final class AppCoordinator: Coordinator {
    
    
    private(set) var childCoordinators: [Coordinator] = []
    
    func start() {
        
    }
    
    
    
    
}
