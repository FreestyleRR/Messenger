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
    
    private var coordinator: LoginCoordinatorType
    
    var users: [[String: String]] = [[:]]
    var currentUserModel = UserModel()
    
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
        
        let existUser = !users.filter { $0["name"] == username }.isEmpty
        
        if existUser {
            guard let user = users.first (where: { $0["name"] == username }) else {
                return
            }
            currentUserModel = UserModel(name: user["name"]!, uid: user["uid"]!)
            users = users.filter { $0["name"] != username }
            completion()
        } else {
            let uID = UUID().uuidString
            currentUserModel = UserModel(name: username, uid: uID)
            
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
        coordinator.users = users
        coordinator.currentUserModel = currentUserModel
        coordinator.didSignUp()
    }
    
    deinit {
        print("\(self) - \(#function)")
    }
}
