//
//  LoginVC.swift
//  Messenger
//
//  Created by Паша Шарков on 27.07.2021.
//

import UIKit

class LoginVC: UIViewController {
    var viewModel: LoginVM!
    
    @IBOutlet weak var nameField: TextFieldView!
    @IBOutlet weak var conteiner: UIView!
    @IBOutlet weak var buttonStart: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        viewModel.getUsers()
    }
    
    private func setupUI() {
        title = "Log in"
        setupTextField()
        
        buttonStart.layer.masksToBounds = true
        buttonStart.layer.cornerRadius = 12
        nameField.layer.masksToBounds = true
        nameField.layer.cornerRadius = 12
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
    }
    
    private func setupTextField() {
        nameField.layer.borderWidth = 0.5
        nameField.layer.borderColor = UIColor.quaternarySystemFill.cgColor
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    deinit {
        print("\(self) - \(#function)")
    }
    
    @IBAction func btnSignInClicked(_ sender: UIButton) {
        validate()
    }
}

// MARK: - UITextFieldDelegate

extension LoginVC: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
    }
}

extension LoginVC {
    
    private func validate() {
        let username = nameField.text ?? ""
        
        if viewModel.isValid(username: username) {
            signIn(username: username)
            nameField.text = ""
        }
    }
    
    private func signIn(username: String) {
        viewModel.signUp(username: username) { [weak self] in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.viewModel.didSignUp()
            }
        }
    }
}
