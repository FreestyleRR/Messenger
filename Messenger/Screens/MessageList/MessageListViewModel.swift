//
//  MessageListViewModel.swift
//  Messenger
//
//  Created by Паша Шарков on 09.08.2021.
//

import UIKit

protocol MessageListViewModelType {
    
    var userModel: UserModel { get set }
    var messages: [MessageModel] { get set }
    var friId: String { get }
    var currentId: String { get }
    var friendName: String { get }
    
    func sendMessage(_ text: String)
    func getAllMessages(completion: @escaping (() -> Void))
}

class MessageListViewModel: MessageListViewModelType {
    
    
    
    var currentId = UserDefaults.standard.value(forKey: "uid") as! String
    private let coordinator: MessageListCoordinatorType
    
    var userModel: UserModel
    var messages = [MessageModel]()
    var messageId: String?
    
    init(_ coordinator: MessageListCoordinatorType, model: UserModel) {
        self.coordinator = coordinator
        self.userModel = model
    }
    
    var friId: String {
        return userModel.uid
    }
    
    var friendName: String {
        return userModel.name
    }
    
    func sendMessage(_ text: String) {
        DatabaseManager.shared.sendMessage(from: currentId, to: friId, messageId: messageId!, message: text) { result in
            switch result {
            case .success(let messageCollection):
                self.messages = messageCollection
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
