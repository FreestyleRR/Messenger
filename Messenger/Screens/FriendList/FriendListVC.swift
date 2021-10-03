//
//  ProfileViewController.swift
//  Messenger
//
//  Created by Паша Шарков on 27.07.2021.
//

import UIKit
import Firebase

class FriendListVC: UIViewController {
    
    var viewModel: FriendListViewModelType!
    
    @IBOutlet var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
    
    private func setupUI() {
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.delegate = self
        tableView.dataSource = self
        title = viewModel.currentUserModel.name
    }
    
    deinit {
        print("\(self) - \(#function)")
    }
}

extension FriendListVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = viewModel.users[indexPath.row]["user_name"]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) { tableView.deselectRow(at: indexPath, animated: true)
        tableView.deselectRow(at: indexPath, animated: true)
        viewModel.getIndex(indexPath.row)
        viewModel.startCommunication()
    }
}

