//
//  LoginViewController.swift
//  Messenger
//
//  Created by Паша Шарков on 27.07.2021.
//

import UIKit
import Firebase
import FirebaseDatabase

class LoginVC: UIViewController {
    
    var viewModel: LoginViewModelType!
    
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var conteiner: UIView!
    @IBOutlet weak var buttonStart: UIButton!
    
    private var users = [[String: String]]()
    
    deinit {
        print("SignInVC - deinit")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        
    }
    
    private func setupUI() {
        title = "Log in"
        view.backgroundColor = .white
        nameField.layer.cornerRadius = 12
        
        let tapGR = UITapGestureRecognizer(target: self, action: #selector(hideKeyboardWhenTappedAround))
        view.addGestureRecognizer(tapGR)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        getUsers()
    }
    
    func getUsers(){
        DatabaseManager.shared.getAllUsers(completion: { [weak self] result in
            switch result {
            case .success(let usersCollection):
                self?.users = usersCollection
            case .failure(let error):
                print("Failed to get usres: \(error)")
            }
        })
    }
    
    @objc func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}

extension LoginVC: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == nameField {
            nameField.resignFirstResponder()
            validate()
        }
        return true
    }
}

extension LoginVC {
    
    @IBAction func btnSignInClicked(_ sender: UIButton) {
        validate()
    }
    
    private func validate() {
        let name = nameField.text ?? ""
        
        if let errorStr = viewModel.validate(name: name) {
            AlertHelper.showAlert(errorStr)
            return
        }
        
        view.endEditing(true)
        signIn(name: name)
    }
    
    private func signIn(name: String) {
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
    
}
