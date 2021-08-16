//
//  ProfileViewController.swift
//  Messenger
//
//  Created by Паша Шарков on 27.07.2021.
//

import UIKit
import Firebase

class FriendListVC: UIViewController {
    
    var reuseId = "cell"
    
    var viewModel: FriendListViewModelType!
    
    @IBOutlet var tableView: UITableView!
    
    var users = [[String: String]]()
    private let name = UserDefaults.standard.value(forKey: "name") as! String
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        
    }
    
    private func setupUI() {
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: reuseId)
        tableView.delegate = self
        tableView.dataSource = self
        title = name
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

extension FriendListVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
            let cell = tableView.dequeueReusableCell(withIdentifier: reuseId, for: indexPath)
            cell.textLabel?.text = users[indexPath.row]["name"]
            return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) { tableView.deselectRow(at: indexPath, animated: true)
        tableView.deselectRow(at: indexPath, animated: true)
        
        let friendId = users[indexPath.row]["uid"]!
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let vc = storyboard.instantiateViewController(identifier: "MessageListVC") as! MessageListVC
        vc.friId = friendId
        vc.navigationItem.largeTitleDisplayMode = .never
        vc.title = users[indexPath.row]["name"]
        navigationController?.pushViewController(vc, animated: true)
        
    }
}

