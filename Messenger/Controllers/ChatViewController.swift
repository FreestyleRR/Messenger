//
//  ChatViewController.swift
//  Messenger
//
//  Created by Паша Шарков on 28.07.2021.
//

import UIKit
import Firebase
import IQKeyboardManagerSwift

class ChatViewController: UIViewController {
    
    public static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .long
        formatter.locale = .current
        return formatter
    }()
    
    public var messages = [Message]()
    
    private let currentId = UserDefaults.standard.value(forKey: "uid") as! String
    var friId: String!
    var messageId: String!
    
    @IBOutlet var container: UIView!
    @IBOutlet var tableView: UITableView!
    @IBOutlet var inputTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        
    }
    
    private func setupUI() {
        let tapGR = UITapGestureRecognizer(target: self, action: #selector(hideKeyboardWhenTappedAround))
        self.view.addGestureRecognizer(tapGR)
        
        tableView.register(UINib(nibName: OutcomeCell.reuseId, bundle: nil), forCellReuseIdentifier: OutcomeCell.reuseId)
        tableView.register(UINib(nibName: IncomeCell.reuseId, bundle: nil), forCellReuseIdentifier: IncomeCell.reuseId)
        
        tableView.dataSource = self
        
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = UITableView.automaticDimension
        
        tableView.alwaysBounceVertical = true
        tableView.backgroundColor = UIColor.white
        tableView.keyboardDismissMode = .interactive
        
        inputTextField.delegate = self
    }
    
    @IBAction func sendButton(_ sender: UIButton) {
        sendMessage()
        
        inputTextField.text = ""
        tableView.reloadData()
    }
    
    func scrollToLastRow() {
            let indexPath = IndexPath(row: self.messages.count - 1, section: 0)
            self.tableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let messageIdOne = "\(currentId)_\(friId!)"
        let messageIdTwo = "\(friId!)_\(currentId)"
 
    //MARK: - Chek messages for currentId_friId
        DatabaseManager.shared.getAllMessagesForConversation(with: currentId, messageID: messageIdOne, completion: { result in
            switch result {
            case .success(let messages):
                guard !messages.isEmpty else {
                    return
                }
                self.messages = messages
                self.messageId = messageIdOne
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                    self.scrollToLastRow()
                }
            case .failure(let error):
                print("failed to get messages: \(error)")
            }
        })
        
    //MARK: - Chek messages for friId_currentId
        DatabaseManager.shared.getAllMessagesForConversation(with: currentId,
                                                             messageID: messageIdTwo, completion: { result in
            switch result {
            case .success(let messages):
                guard !messages.isEmpty else {
                    return
                }
                self.messages = messages
                self.messageId = messageIdTwo
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                    self.scrollToLastRow()
                }
            case .failure(let error):
                print("failed to get messages: \(error)")
            }
        })
    }
    
    @objc func sendMessage() {
        guard let text = inputTextField.text,
              !text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
                    return
                }
        
        let ref = Database.database().reference()
        let mmessage = Message(fromId: currentId,
                               toId: friId,
                               text: text,
                               sentDate: Date())
        
        let messageDate = mmessage.sentDate
        let dateString = ChatViewController.dateFormatter.string(from: messageDate)
        
        let conversationData: [String: Any] = [
            "fromId": currentId,
            "toId": friId!,
            "date": dateString,
            "message": text
        ]
        //MARK: - Send and check messages
        if messageId == ("\(currentId)_\(friId!)") {
        ref.child("conversation_\(self.currentId)_\(self.friId!)/messages").observeSingleEvent(of: .value, with: { snapshot in
            if var conversation = snapshot.value as? [[String: Any]] {
                conversation.append(conversationData)
                ref.child("conversation_\(self.messageId!)/messages").setValue(conversation) { error, _ in
                    guard error == nil else {
                        return
                    }
                }
            } else {
                ref.child("conversation_\(self.currentId)_\(self.friId!)/messages").setValue([conversationData]) { error, _ in
                    guard error == nil else {
                        return
                    }
                }
            }
        })
        } else {
            ref.child("conversation_\(self.friId!)_\(self.currentId)/messages").observeSingleEvent(of: .value, with: { snapshot in
                if var conversation = snapshot.value as? [[String: Any]] {
                    conversation.append(conversationData)
                    ref.child("conversation_\(self.messageId!)/messages").setValue(conversation) { error, _ in
                        guard error == nil else {
                            return
                        }
                    }
                } else {
                    ref.child("conversation_\(self.friId!)_\(self.currentId)/messages").setValue([conversationData]) { error, _ in
                        guard error == nil else {
                            return
                        }
                    }
                }
            })
        }
        
        dismissKeyboard()
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

// MARK: - UITextFieldDelegate

extension ChatViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return true
    }
}

// MARK: - UITableViewDataSource

extension ChatViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let index = messages[indexPath.row].fromId
        if index == currentId {
            let cell = tableView.dequeueReusableCell(withIdentifier: IncomeCell.reuseId, for: indexPath) as! IncomeCell
            cell.configure(with: messages[indexPath.row])
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: OutcomeCell.reuseId, for: indexPath) as! OutcomeCell
            cell.configure(with: messages[indexPath.row])
            return cell
        }
    }
}



