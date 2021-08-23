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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        print(viewModel)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    private func setupUI() {
        title = "Log in"
        view.backgroundColor = .white
        nameField.layer.cornerRadius = 12
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
    }
    
    @IBAction func btnSignInClicked(_ sender: UIButton) {
        validate()
    }
    
    @objc
    private func dismissKeyboard() {
        view.endEditing(true)
    }
    
    deinit {
        print("\(self) - \(#function)")
    }
}

// MARK: - UITextFieldDelegate

extension LoginVC: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

extension LoginVC {
    
    private func validate() {
        let username = nameField.text ?? ""
        print(viewModel)
        
        if viewModel.isValid(username: username) {
            signIn(username: username)
        }
    }
    
    private func signIn(username: String) {
        viewModel.signUp(username: username) { [weak self] in
            DispatchQueue.main.async {
                self?.viewModel.didSignUp()
            }
        }
    }
}
