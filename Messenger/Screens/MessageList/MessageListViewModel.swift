//
//  MessageListViewModel.swift
//  Messenger
//
//  Created by Паша Шарков on 09.08.2021.
//

import UIKit

protocol MessageListViewModelType {
    
    var friendModel: UserModel { get }
    var messages: [MessageModel] { get }
    
    func sendMessage(_ text: String)
    func getAllMessages(completion: @escaping (() -> Void))
}

class MessageListViewModel: MessageListViewModelType {
    
    private let coordinator: MessageListCoordinatorType
    private var currentModel: UserModel
    private var messageId: String?
    
    var friendModel: UserModel
    var messages = [MessageModel]()
    
    init(_ coordinator: MessageListCoordinatorType, friendModel: UserModel, currentModel: UserModel) {
        self.coordinator = coordinator
        self.friendModel = friendModel
        self.currentModel = currentModel
    }
    
    func sendMessage(_ text: String) {
        let dateString = Data.dateFormatter.string(from: Date())
        let messageModel = MessageModel(fromId: currentModel.uid, toId: friendModel.uid, text: text, sentDate: dateString)
        guard let messId = messageId else { return }
        
        DatabaseManager.shared.sendMessage(message: messageModel, messageId: messId) { [weak self] result in
            switch result {
            case .success(let messageCollection):
                self?.messages = messageCollection
            case .failure(let error):
                print("failed to send message: \(error)")
            }
        }
    }
    
    private func getAllMessageFor(messageId: String, completion: @escaping (() -> Void)) {
        DatabaseManager.shared.getAllMessagesForConversation(messageID: messageId) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let messages):
                guard !messages.isEmpty else { return }
                self.messages = messages
                self.messageId = messageId
                completion()
            case .failure(let error):
                print("failed to get messages: \(error)")
            }
        }
    }
    
    func getAllMessages(completion: @escaping (() -> Void)) {
        let messageIdOne = "\(currentModel.uid)_\(friendModel.uid)"
        let messageIdTwo = "\(friendModel.uid)_\(currentModel.uid)"
        
        getAllMessageFor(messageId: messageIdOne) {
            completion()
        }
        
        getAllMessageFor(messageId: messageIdTwo) {
            completion()
        }
        
        if messageId == nil {
            messageId = messageIdOne
        }
    }
    
    deinit {
        print("\(self) - \(#function)")
    }
}
