//
//  LoginViewController.swift
//  Messenger
//
//  Created by Паша Шарков on 27.07.2021.
//

import UIKit
import Firebase
import FirebaseDatabase

class LoginViewController: UIViewController {
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "icon")
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.clipsToBounds = true
        return scrollView
    }()
    
    private let nameField: UITextField = {
        let field = UITextField()
        field.autocapitalizationType = .none
        field.autocorrectionType = .no
        field.returnKeyType = .continue
        field.layer.cornerRadius = 12
        field.layer.borderWidth = 1
        field.layer.borderColor = UIColor.lightGray.cgColor
        field.placeholder = "Name..."
        field.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: 0))
        field.leftViewMode = .always
        field.backgroundColor = .white
        return field
    }()
    
    private let startButton: UIButton = {
        let button = UIButton()
        button.setTitle("Start", for: .normal)
        button.backgroundColor = .link
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 12
        button.layer.masksToBounds = true
        button.titleLabel?.font = .systemFont(ofSize: 20, weight: .bold)
        return button
    }()
    
    private var users = [[String: String]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Log in"
        view.backgroundColor = .white
        
        startButton.addTarget(self,
                              action: #selector(startButtonTapped),
                              for: .touchUpInside)
        
        nameField.delegate = self
        
        let tapGR = UITapGestureRecognizer(target: self, action: #selector(hideKeyboardWhenTappedAround))
        view.addGestureRecognizer(tapGR)
        
        //MARK: - Add subviews
        view.addSubview(scrollView)
        scrollView.addSubview(imageView)
        scrollView.addSubview(nameField)
        scrollView.addSubview(startButton)
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        scrollView.frame = view.bounds
        
        let size = scrollView.width/3
        imageView.frame = CGRect(x: (scrollView.width-size)/2,
                                 y: 20,
                                 width: size,
                                 height: size)
        
        nameField.frame = CGRect(x: 30,
                                 y: imageView.bottom+10,
                                 width: scrollView.width-60,
                                 height: 52)
        
        startButton.frame = CGRect(x: 30,
                                   y: nameField.bottom+10,
                                   width: scrollView.width-60,
                                   height: 52)
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
    
    @objc private func startButtonTapped(){
        guard let name = nameField.text,
              !name.isEmpty,
              name.count >= 2
        else {
            alertUserStartError()
            return
        }
        
        
        var user = 0
        glob: if users.count > 0 {
            for i in users {
                if name == i["name"]! {
                    UserDefaults.standard.setValue(i["uid"], forKey: "uid")
                    UserDefaults.standard.setValue(name, forKey: "name")
                    users.remove(at: user)
                    break glob
                } else {
                    user += 1
                }
            }
            
            let uID = UUID().uuidString
            UserDefaults.standard.setValue(uID, forKey: "uid")
            UserDefaults.standard.setValue(name, forKey: "name")
            
            DatabaseManager.shared.insertUser(with: ChatUser(name: name, uid: uID), completion: { success in
                if success {
                    print("User creating")
                } else {
                    print("User not creating")
                }
            })
        } else {
            let uID = UUID().uuidString
            UserDefaults.standard.setValue(uID, forKey: "uid")
            UserDefaults.standard.setValue(name, forKey: "name")
            
            DatabaseManager.shared.insertUser(with: ChatUser(name: name, uid: uID), completion: { success in
                if success {
                    print("User creating")
                } else {
                    print("User not creating")
                }
            })
        }
        
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let vc = storyboard.instantiateViewController(identifier: "FriendsViewController") as! FriendsViewController
        vc.users = users
        navigationController?.pushViewController(vc, animated: true)
        nameField.text = ""
    }
    
    func alertUserStartError() {
        let alert = UIAlertController(title: "Error",
                                      message: "You name incorrected",
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel",
                                      style: .cancel,
                                      handler: nil))
        present(alert, animated: true)
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

extension LoginViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == nameField {
            startButtonTapped()
        }
        return true
    }
}
