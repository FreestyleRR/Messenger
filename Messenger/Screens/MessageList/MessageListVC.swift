//
//  ChatViewController.swift
//  Messenger
//
//  Created by Паша Шарков on 28.07.2021.
//

import UIKit
import Firebase
import IQKeyboardManagerSwift

class MessageListVC: UIViewController {
    
    var viewModel: MessageListViewModelType!
    
    @IBOutlet var container: UIView!
    @IBOutlet var tableView: UITableView!
    @IBOutlet var inputTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
    
    private func setupUI() {
        title = viewModel.friendModel.name
        tableView.dataSource = self
        inputTextField.delegate = self
        
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = UITableView.automaticDimension
        tableView.alwaysBounceVertical = true
        tableView.backgroundColor = UIColor.white
        tableView.keyboardDismissMode = .interactive
        
        tableView.register(UINib(nibName: OutcomeCell.reuseId, bundle: nil), forCellReuseIdentifier: OutcomeCell.reuseId)
        tableView.register(UINib(nibName: IncomeCell.reuseId, bundle: nil), forCellReuseIdentifier: IncomeCell.reuseId)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGesture.cancelsTouchesInView = false
        tableView.addGestureRecognizer(tapGesture)
    }
    
    @IBAction func sendButton(_ sender: UIButton) {
        sendMessage()
    }
    
    func scrollToLastRow() {
        let indexPath = IndexPath(row: viewModel.messages.count - 1, section: 0)
        self.tableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        viewModel.getAllMessages { [weak self] in
            DispatchQueue.main.async {
                self?.tableView.reloadData()
                self?.scrollToLastRow()
            }
        }
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    deinit {
        print("\(self) - \(#function)")
    }
}

// MARK: - Send message

extension MessageListVC {
    
    func sendMessage() {
        guard let text = inputTextField.text,
              !text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            return
        }
        viewModel.sendMessage(text)
        inputTextField.text = ""
    }
}

// MARK: - UITextFieldDelegate

extension MessageListVC: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
    }
}

// MARK: - UITableViewDataSource

extension MessageListVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let index = viewModel.messages[indexPath.row].fromId
        
        if index == viewModel.currentModel.uid {
            let cell = tableView.dequeueReusableCell(withIdentifier: IncomeCell.reuseId, for: indexPath) as! IncomeCell
            cell.configure(with: viewModel.messages[indexPath.row])
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: OutcomeCell.reuseId, for: indexPath) as! OutcomeCell
            cell.configure(with: viewModel.messages[indexPath.row])
            return cell
        }
    }
}



