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
    func signUp()
}

class LoginViewModel: LoginViewModelType {
    var signUpTitle: NSAttributedString
    
    fileprivate let coordinator: LoginCoordinatorType
    private var serviceHolder: ServiceHolder
    
    init(_ coordinator: LoginCoordinatorType, serviceHolder: ServiceHolder) {
        self.coordinator = coordinator
        self.serviceHolder = serviceHolder
    }
    
    deinit {
        print("SignInViewModel - deinit")
    }
    
    func validate(name: String) -> String? {
        if name.count == 0 {
            return nil
        }
        
        if name.count < 2 {
            return nil
        }
        return nil
    }
    
    func login(name: String, completion: @escaping SimpleClosure<String?>) {
        
        userService.login(email: email, password: password) { [weak self] errorStr in
            if let error = errorStr {
                completion(error)
                return
            }
        }
    }
    
    func signUp() {
        coordinator.signUp()
    }
}
