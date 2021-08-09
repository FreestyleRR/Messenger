//
//  UIStoryboardExtencion.swift
//  Messenger
//
//  Created by Паша Шарков on 09.08.2021.
//

import UIKit

struct Storyboard {
    static let launch = UIStoryboard(name: "LaunchScreen", bundle: nil)
    static let login = UIStoryboard(name: "Login", bundle: nil)
    static let friendList = UIStoryboard(name: "FriendList", bundle: nil)
    static let messageList = UIStoryboard(name: "MessageList", bundle: nil)
}

protocol StoryboardIdentifiable {
    static var storyboardIdentifier: String { get }
}

extension StoryboardIdentifiable where Self: UIViewController {
    static var storyboardIdentifier: String {
        return String(describing: self.self)
    }
}

extension UIStoryboard {
    
    func controller<T: UIViewController>(withClass: T.Type) -> T? {
        let identifier = withClass.identifier
        return instantiateViewController(withIdentifier: identifier) as? T
    }
    
    func instantiateViewController<T: StoryboardIdentifiable>() -> T? {
        return instantiateViewController(withIdentifier: T.storyboardIdentifier) as? T
    }
}

extension UIViewController: StoryboardIdentifiable { }
