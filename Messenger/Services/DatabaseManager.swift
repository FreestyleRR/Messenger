//
//  DatabaseManager.swift
//  Messenger
//
//  Created by Паша Шарков on 28.07.2021.
//

import Foundation
import FirebaseDatabase

final class DatabaseManager {
    
    static let shared = DatabaseManager()
    
    private let database = Database.database().reference()
    
    public func insertUser(with user: UserModel, completion: @escaping (Bool) -> Void) {
        self.database.child(user.uid).setValue([
            "user_name": user.name,
            "user_id": user.uid
        ], withCompletionBlock: { error, _ in
            guard error == nil else {
                print("fatal error")
                completion(false)
                return
            }
            self.database.child("users").observeSingleEvent(of: .value, with: { snapshot in
                if var userCollection = snapshot.value as? [[String: String?]] {
                    let newElement = [
                        "name": user.name,
                        "uid": user.uid
                    ]
                    userCollection.append(newElement)
                    self.database.child("users").setValue(userCollection, withCompletionBlock: { error, _ in
                        guard error == nil else {
                            completion(false)
                            return
                        }
                        completion(true)
                    })
                } else {
                    let newCollection: [[String: String?]] = [
                        [
                            "name": user.name,
                            "uid": user.uid
                        ]
                    ]
                    self.database.child("users").setValue(newCollection, withCompletionBlock: { error, _ in
                        guard error == nil else {
                            completion(false)
                            return
                        }
                        completion(true)
                    })
                }
            })
        })
    }
    
    public func getAllUsers(completion: @escaping (Result<[[String: String]], Error>) -> Void) {
        database.child("users").observe(.value, with: { snapshot in
            guard let value = snapshot.value as? [[String: String]] else {
                completion(.failure(DatabaseError.fatalError))
                return
            }
            completion(.success(value))
        })
    }
    
    public enum DatabaseError: Error {
        case fatalError
    }
}

// MARK: - Sending massege / conversation

extension DatabaseManager {
    
    public func getAllMessagesForConversation(with id: String, messageID: String, completion: @escaping (Result<[MessageModel], Error>) -> Void) {
        database.child("conversation_\(messageID)/messages").observe(.value, with: { snapshot in
            guard let value = snapshot.value as? [[String: Any]] else{
                completion(.failure(DatabaseError.fatalError))
                return
            }
            let messages: [MessageModel] = value.compactMap({ dictionary in
                guard let fromId = dictionary["fromId"] as? String,
                      let content = dictionary["message"] as? String,
                      let toId = dictionary["toId"] as? String,
                      let dateString = dictionary["date"] as? String,
                      let date = MessageListVC.dateFormatter.date(from: dateString) else {
                    return nil
                }
                return MessageModel(fromId: fromId,
                               toId: toId,
                               text: content,
                               sentDate: date)
            })
            completion(.success(messages))
        })
    }
}

