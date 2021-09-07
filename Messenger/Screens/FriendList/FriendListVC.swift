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
    
    var viewModemLogin: LoginViewModelType!
    var viewModel: FriendListViewModelType!
    
    @IBOutlet var tableView: UITableView!
    
    var users = [[String: String]]()
    private let name = UserDefaults.standard.value(forKey: "name") as! String
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    private func setupUI() {
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: reuseId)
        tableView.delegate = self
        tableView.dataSource = self
        title = name
    }
    
    deinit {
        print("\(self) - \(#function)")
    }
    
}

extension FriendListVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.users?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseId, for: indexPath)
        cell.textLabel?.text = viewModel.users?[indexPath.row]["name"]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) { tableView.deselectRow(at: indexPath, animated: true)
        tableView.deselectRow(at: indexPath, animated: true)
        
        let friendId = viewModel.users?[indexPath.row]["uid"]!
        let storyboard = Storyboard.main
        let vc = storyboard.instantiateViewController(identifier: "MessageListVC") as! MessageListVC
        vc.friId = friendId
        vc.navigationItem.largeTitleDisplayMode = .never
        vc.title = viewModel.users?[indexPath.row]["name"]
        navigationController?.pushViewController(vc, animated: true)
        
    }
}

