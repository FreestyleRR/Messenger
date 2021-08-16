//
//  FriendListViewModel.swift
//  Messenger
//
//  Created by Паша Шарков on 09.08.2021.
//

import Foundation
import UIKit

protocol FriendListViewModelType {
    
//    func registerCells(for tableView: UITableView)
//    func getNumberOfRows() -> Int
//    func cellForTableView(tableView: UITableView, atIndexPath indexPath: IndexPath, delegate: UIViewController) -> UITableViewCell
//    func getRowIndex(from id: Int) -> Int
    
}

class FriendListViewModel: FriendListViewModelType {
    
    fileprivate let coordinator: FriendListCoordinatorType
    
    init(_ coordinator: FriendListCoordinatorType, serviceHolder: ServiceHolder) {
        self.coordinator = coordinator
    }
    
    deinit {
        print("ReadingListViewModel - deinit")
    }
    
}

extension FriendListViewModel {
    
//    func registerCells(for tableView: UITableView) {
//        <#code#>
//    }
//
//    func getNumberOfRows() -> Int {
//        <#code#>
//    }
//
//    func cellForTableView(tableView: UITableView, atIndexPath indexPath: IndexPath, delegate: UIViewController) -> UITableViewCell {
//        <#code#>
//    }
//
//    func getRowIndex(from id: Int) -> Int {
//        <#code#>
//    }
}
