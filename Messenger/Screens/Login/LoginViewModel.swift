//
//  LoginViewModel.swift
//  Messenger
//
//  Created by Паша Шарков on 09.08.2021.
//

import Foundation

protocol LoginViewModelType {
    func getUsers()
    func isValid(username: String) -> Bool
    func signUp(username: String, completion: @escaping (() -> Void))
    
    func didSignUp()
}

class LoginViewModel: LoginViewModelType {
    
    var users: [[String: String]]?
    
    private var coordinator: LoginCoordinatorType
    
    init(_ coordinator: LoginCoordinatorType) {
        self.coordinator = coordinator
    }
    
    func getUsers() {
        DatabaseManager.shared.getAllUsers(completion: { [weak self] result in
            switch result {
            case .success(let usersCollection):
                self?.users = usersCollection
            case .failure(let error):
                print("Failed to get usres: \(error)")
            }
        })
    }
    
    func isValid(username: String) -> Bool {
        return username.count > 1 && username.count < 15
    }
    
    func signUp(username: String, completion: @escaping (() -> Void)) {
        
        let existUser = !users!.filter { $0["name"] == username }.isEmpty
        
        if existUser {
            let user = users!.first { $0["name"] == username }
            users = users!.filter { $0["name"] != username }
            UserDefaults.standard.setValue(user!["uid"], forKey: "uid")
            UserDefaults.standard.setValue(user!["name"], forKey: "name")
            completion()
        } else {
            let uID = UUID().uuidString
            UserDefaults.standard.setValue(uID, forKey: "uid")
            UserDefaults.standard.setValue(username, forKey: "name")
            
            DatabaseManager.shared.insertUser(with: UserModel(name: username, uid: uID), completion: { success in
                if success {
                    print("User creating")
                    completion()
                } else {
                    print("User not creating")
                }
            })
        }
    }
    
    func didSignUp() {
        coordinator.didSignUp()
    }
    
    deinit {
        print("\(self) - \(#function)")
    }
}
