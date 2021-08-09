//
//  LoginViewModel.swift
//  Messenger
//
//  Created by Паша Шарков on 09.08.2021.
//

import Foundation

protocol LoginViewModelType {
    
    
    var signUpTitle: NSAttributedString { get }
    
    //actions
    func validate(name: String) -> String?
    func login(name: String, completion: @escaping SimpleClosure<String?>)
    func login()
}

class LoginViewModel: LoginViewModelType {
    
    fileprivate let coordinator: LoginCoordinatorType
    private var serviceHolder: ServiceHolder
    
    init(_ coordinator: LoginCoordinatorType, serviceHolder: ServiceHolder) {
        self.coordinator = coordinator
        self.serviceHolder = serviceHolder
    }
    
    deinit {
        print("SignInViewModel - deinit")
    }
    
    func login() {
        coordinator.signUp()
    }
}
