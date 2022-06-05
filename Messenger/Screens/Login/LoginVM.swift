//
//  LoginViewModel.swift
//  Messenger
//
//  Created by Паша Шарков on 09.08.2021.
//

import Foundation

class LoginVM {
    private(set) var coordinator: LoginCoord
    private(set) var users: [[String: String]] = [[:]]
    private(set) var currentUserModel = UserModel()
    
    init(_ coordinator: LoginCoord) {
        self.coordinator = coordinator
    }
    
    func getUsers() {
        DatabaseManager.shared.getAllUsers { [weak self] result in
            switch result {
            case .success(let usersCollection):
                self?.users = usersCollection
            case .failure(let error):
                print("Failed to get usres: \(error)")
            }
        }
    }
    
    func isValid(username: String) -> Bool {
        return username.count > 1 && username.count < 15
    }
    
    func signUp(username: String, completion: @escaping (() -> Void)) {
        let existUser = !users.filter { $0["user_name"] == username }.isEmpty
        
        if existUser {
            guard let user = users.first (where: { $0["user_name"] == username }) else { return }
            guard let uid = user["user_id"], let name = user["user_name"] else { return }
            
            currentUserModel = UserModel(name: name, uid: uid)
            users = users.filter { $0["user_name"] != username }
            completion()
        } else {
            let uID = UUID().uuidString
            currentUserModel = UserModel(name: username, uid: uID)
            
            DatabaseManager.shared.insertUser(user: currentUserModel) { success in
                if success {
                    print("User creating")
                    completion()
                } else {
                    print("Error: User is not creating")
                }
            }
        }
    }
    
    deinit {
        print("\(self) - \(#function)")
    }
    
    func didSignUp() {
        coordinator.users = users
        coordinator.currentUserModel = currentUserModel
        coordinator.didSignUp()
    }
}
