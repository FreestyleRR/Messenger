//
//  Data.swift
//  Messenger
//
//  Created by Паша Шарков on 08.09.2021.
//

import Foundation


class Data {
    
    public static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .long
        formatter.locale = .current
        return formatter
    }()
    
}
