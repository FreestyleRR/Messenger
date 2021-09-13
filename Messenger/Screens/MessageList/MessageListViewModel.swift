//
//  MessageListViewModel.swift
//  Messenger
//
//  Created by Паша Шарков on 09.08.2021.
//

import UIKit

protocol MessageListViewModelType {
    
    var friendModel: UserModel { get }
    var currentModel: UserModel { get }
    var messages: [MessageModel] { get }
    
    func sendMessage(_ text: String)
    func getAllMessages(completion: @escaping (() -> Void))
}

class MessageListViewModel: MessageListViewModelType {
    private let coordinator: MessageListCoordinatorType
    
    var friendModel: UserModel
    var currentModel: UserModel
    var messages = [MessageModel]()
    var messageId: String?
    
    init(_ coordinator: MessageListCoordinatorType, friendModel: UserModel, currentModel: UserModel) {
        self.coordinator = coordinator
        self.friendModel = friendModel
        self.currentModel = currentModel
    }
    
    var currentId: String {
        return currentModel.uid
    }
    
    var friId: String {
        return friendModel.uid
    }
    
    func sendMessage(_ text: String) {
        DatabaseManager.shared.sendMessage(from: currentId, to: friId, messageId: messageId!, message: text) { [weak self] result in
            switch result {
            case .success(let messageCollection):
                self?.messages = messageCollection
            case .failure(let error):
                print("failed to send message: \(error)")
            }
        }
    }
    
    func getAllMessages(completion: @escaping (() -> Void)) {
        let messageIdOne = "\(currentId)_\(friId)"
        let messageIdTwo = "\(friId)_\(currentId)"
        
        DatabaseManager.shared.getAllMessagesForConversation(messageID: messageIdOne, completion: { [weak self] result in
            switch result {
            case .success(let messages):
                guard !messages.isEmpty else {
                    return
                }
                self?.messages = messages
                self?.messageId = messageIdOne
                completion()
            case .failure(let error):
                print("failed to get messages: \(error)")
            }
        })
        
        DatabaseManager.shared.getAllMessagesForConversation(messageID: messageIdTwo, completion: { [weak self] result in
            switch result {
            case .success(let messages):
                guard !messages.isEmpty else {
                    return
                }
                self?.messages = messages
                self?.messageId = messageIdTwo
                completion()
            case .failure(let error):
                print("failed to get messages: \(error)")
            }
        })
        
        if messageId == nil {
            messageId = "\(currentId)_\(friId)"
        }
    }
    
    deinit {
        print("\(self) - \(#function)")
    }
    
}
