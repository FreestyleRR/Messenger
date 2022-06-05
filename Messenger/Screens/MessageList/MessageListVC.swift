//
//  MessageListVC.swift
//  Messenger
//
//  Created by Паша Шарков on 28.07.2021.
//

import UIKit
import IQKeyboardManagerSwift

class MessageListVC: UIViewController {
    var viewModel: MessageListViewModelType!
    private var heightConstraint: NSLayoutConstraint?
    private let inputLinesScrollThreshold = 6
    
    @IBOutlet var textView: UITextView!
    @IBOutlet var container: UIView!
    @IBOutlet var tableView: UITableView!
    @IBOutlet var placeholderLabel: UILabel!
    @IBOutlet var enterMessageButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        getMessages()
    }
    
    private func setup() {
        title = viewModel.friendModel.name
        setupTableView()
        setupTextField()
        setupDismissKeyboardGesture()
        setupKeyboardHiding()
    }
    
    private func setupTextField() {
        textView.layer.masksToBounds = true
        textView.layer.cornerRadius = 20
        textView.delegate = self
        textView.textContainerInset = UIEdgeInsets(top: 10, left: 13, bottom: 10, right: 5)
    }
    
    private func setupTableView() {
        tableView.dataSource = self
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = UITableView.automaticDimension
        tableView.alwaysBounceVertical = true
        tableView.keyboardDismissMode = .onDrag
        tableView.register(UINib(nibName: OutcomeCell.reuseId, bundle: nil), forCellReuseIdentifier: OutcomeCell.reuseId)
        tableView.register(UINib(nibName: IncomeCell.reuseId, bundle: nil), forCellReuseIdentifier: IncomeCell.reuseId)
    }
    
    private func scrollToLastRow() {
        let indexPath = IndexPath(row: viewModel.messages.count - 1, section: 0)
        self.tableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
    }
    
    private func setupKeyboardHiding() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
            NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    private func getMessages() {
        viewModel.getAllMessages { [weak self] in
            DispatchQueue.main.async {
                self?.tableView.reloadData()
                self?.scrollToLastRow()
            }
        }
    }
    
    private func sendMessage() {
        guard let text = textView.text,
              !text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else { return }
        
        viewModel.sendMessage(text)
        textView.text = ""
        checkLines()
    }
    
    private func checkLines() {
        placeholderLabel.isHidden = !textView.text.isEmpty
        let isConstraintActive = heightConstraint.flatMap { $0.isActive } ?? false
        
        let lineHeight = textView.font?.lineHeight ?? 1
        
        if isConstraintActive == false {
            heightConstraint = textView.heightAnchor.constraint(equalToConstant: textView.frame.height)
            heightConstraint?.isActive = true
            textView.isScrollEnabled = true
        } else {
            heightConstraint?.constant = textView.numberOfLine() > inputLinesScrollThreshold ?
            lineHeight * CGFloat(inputLinesScrollThreshold) : textView.contentSize.height
        }
        textView.layoutIfNeeded()
    }
    
    private func setupDismissKeyboardGesture() {
        let dismissKeyboardTap = UITapGestureRecognizer(target: self, action: #selector(viewTapped(_:)))
        view.addGestureRecognizer(dismissKeyboardTap)
    }
    
    @objc func viewTapped(_ recognizer: UITapGestureRecognizer) {
        if recognizer.state == UIGestureRecognizer.State.ended {
            view.endEditing(true)
        }
    }
    
    @IBAction func sendButton(_ sender: UIButton) {
        sendMessage()
    }
    
    deinit {
        print("\(self) - \(#function)")
    }
}

//MARK: - UITextViewDelegate -

extension MessageListVC: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        checkLines()
    }
}
    
extension MessageListVC {
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            if view.frame.origin.y == 0 {
                view.frame.origin.y -= keyboardSize.height
            }
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        if view.frame.origin.y != 0 {
            view.frame.origin.y = 0
        }
    }
}

// MARK: - UITableViewDataSource -

extension MessageListVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let index = viewModel.messages[indexPath.row].fromId
        
        if index != viewModel.friendModel.uid {
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
