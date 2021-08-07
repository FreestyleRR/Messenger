//
//  ProfileViewController.swift
//  Messenger
//
//  Created by Паша Шарков on 27.07.2021.
//

import UIKit
import Firebase

class FriendsViewController: UIViewController {
    
    var reuseId = "cell"
    
    var newUser = true
    
    @IBOutlet var tableView: UITableView!
    
    var users = [[String: String]]()
    private let name = UserDefaults.standard.value(forKey: "name") as! String
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        creatingUser()
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: reuseId)
        tableView.delegate = self
        tableView.dataSource = self
        title = name
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }
    
    func creatingUser(){
        DatabaseManager.shared.getAllUsers(completion: { [weak self] result in
            switch result {
            case .success(let usersCollection):
                self?.users = usersCollection
                self?.tableView.reloadData()
            case .failure(let error):
                print("Failed to get usres: \(error)")
            }
        })
    }
    
}

extension FriendsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
//        if newUser {
//            return users.count - 1
//        }
        return users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let id = UserDefaults.standard.value(forKey: "uid") as! String
//        let currentId = users[indexPath.row]["uid"]
//        if id == currentId {
//
//        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: reuseId, for: indexPath)
            cell.textLabel?.text = users[indexPath.row]["name"]
            return cell
//        }
//        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) { tableView.deselectRow(at: indexPath, animated: true)
        tableView.deselectRow(at: indexPath, animated: true)
        
        let friendId = users[indexPath.row]["uid"]!
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let vc = storyboard.instantiateViewController(identifier: "ChatViewController") as! ChatViewController
        vc.friId = friendId
        vc.navigationItem.largeTitleDisplayMode = .never
        vc.title = users[indexPath.row]["name"]
        navigationController?.pushViewController(vc, animated: true)
        
    }
}

