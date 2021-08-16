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
    
    private var users = [[LoginViewModel]]()
    
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
        let userName = nameField.text ?? ""
        
        if let errorStr = viewModel.validate(name: userName) {
            AlertHelper.showAlert(errorStr)
            return
        }
        
        view.endEditing(true)
        signIn(name: userName)
    }
    
    private func signIn(name: String) {
        
    }
    
}
