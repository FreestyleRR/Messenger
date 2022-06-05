//
//  UIViewController.swift
//  Messenger
//
//  Created by Паша Шарков on 09.08.2021.
//

import Foundation
import UIKit

extension UIViewController {
    class var identifier: String {
        let name = String(describing: self)
        return name
    }
}
