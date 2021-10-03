//
//  DatabaseManager.swift
//  Messenger
//
//  Created by Паша Шарков on 28.07.2021.
//

import FirebaseDatabase
import SwiftUI

class DatabaseManager {
    
    static let shared = DatabaseManager()
    
    private let database = Database.database().reference()
    
    public func insertUser(user: UserModel, completion: @escaping (Bool) -> Void) {
        let userModel = [
            "user_name": user.name,
            "user_id": user.uid
        ]
        
        self.database.child(user.uid).setValue(userModel) { error, _ in
            self.database.child("users").observeSingleEvent(of: .value) { snapshot in
                if var userCollection = snapshot.value as? [[String: String]] {
                    userCollection.append(userModel)
                    self.database.child("users").setValue(userCollection) { error, _ in
                        guard error == nil else { completion(false); return }
                        completion(true)
                    }
                    return
                }
                
                let newCollection = [userModel]
                self.database.child("users").setValue(newCollection) { error, _ in
                    guard error == nil else { completion(false); return }
                    completion(true)
                }
            }
        }
    }

    public func getAllUsers(completion: @escaping (Result<[[String: String]], Error>) -> Void) {
        database.child("users").getData { error, snapshot in
            guard let value = snapshot.value as? [[String: String]] else {
                completion(.failure(DatabaseError.fatalError))
                return
            }
            completion(.success(value))
        }
    }
    
    public func getAllMessagesForConversation(messageID: String, completion: @escaping (Result<[MessageModel], Error>) -> Void) {
        database.child("conversation_\(messageID)/messages").observe(.value) { snapshot in
            guard let value = snapshot.value as? [[String: String]] else {
                completion(.failure(DatabaseError.fatalError))
                return
            }
            let messages: [MessageModel] = value.compactMap { dictionary in
                guard let fromId = dictionary["fromId"],
                      let content = dictionary["message"],
                      let toId = dictionary["toId"],
                      let dateString = dictionary["date"] else {
                    return nil
                }
                return MessageModel(fromId: fromId,
                                    toId: toId,
                                    text: content,
                                    sentDate: dateString)
            }
            completion(.success(messages))
        }
    }
    
    public func sendMessage(message: MessageModel, messageId: String, completion: @escaping (Result<[MessageModel], Error>) -> Void ) {
        
        let sendMessage: [String: String] = [
            "fromId": message.fromId,
            "toId": message.toId,
            "date": message.sentDate,
            "message": message.text
        ]
        
        database.child("conversation_\(messageId)/messages").observeSingleEvent(of: .value) { [weak self] snapshot in
            guard let self = self else { return }
            
            if var conversation = snapshot.value as? [[String: String]] {
                conversation.append(sendMessage)
                self.database.child("conversation_\(messageId)/messages").setValue(conversation)
            } else {
                self.database.child("conversation_\(messageId)/messages").setValue([sendMessage])
            }
        }
    }
}

enum DatabaseError: Error {
    case fatalError
}

