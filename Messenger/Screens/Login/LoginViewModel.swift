//
//  LoginViewModel.swift
//  Messenger
//
//  Created by Паша Шарков on 09.08.2021.
//

import Foundation

protocol LoginViewModelType {
    
    var users: [[String: String]] { get }
    
    //actions
    func login(name: String, completion: @escaping SimpleClosure<String?>)
    func getUsers(completion: @escaping SimpleClosure<[[String: String]]>)
    func validate(name: String) -> String?
    func signUp()
}

class LoginViewModel: LoginViewModelType {
    
    
    func login(name: String, completion: @escaping SimpleClosure<String?>) {
        
        let existUser = !users.filter { $0["name"] == name }.isEmpty
        
        if existUser {
            if let user = users.first(where: { $0["name"] == name }) {
                users = users.filter { $0["name"] != name }
                UserDefaults.standard.setValue(user["uid"], forKey: "uid")
                UserDefaults.standard.setValue(user["name"], forKey: "name")
            }
        } else {
            let uID = UUID().uuidString
            UserDefaults.standard.setValue(uID, forKey: "uid")
            UserDefaults.standard.setValue(name, forKey: "name")
            
            DatabaseManager.shared.insertUser(with: UserModel(name: name, uid: uID), completion: { success in
                if success {
                    print("User creating")
                } else {
                    print("User not creating")
                }
            })
        }
    }
    
    
    var users: [[String: String]]
    
    
    func getUsers(completion: @escaping SimpleClosure<[[String: String]]>) {
        DatabaseManager.shared.getAllUsers(completion: { [weak self] result in
            switch result {
            case .success(let usersCollection):
                self?.users = usersCollection
            case .failure(let error):
                print("Failed to get usres: \(error)")
            }
        })
    }
    
//    fileprivate let coordinator: LoginCoordinatorType
//    private var serviceHolder: ServiceHolder
    
    init(user: [[String: String]]) {
        self.users = user
    }
    
    deinit {
        print("SignInViewModel - deinit")
    }
    
    func validate(name: String) -> String? {
        if name.count < 2 {
            return nil
        }
        return nil
    }
    
    func signUp() {
        
       
    }
}
