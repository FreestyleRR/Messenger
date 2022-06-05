//
//  IncomeCell.swift
//  Messenger
//
//  Created by Sergey Паша Шарков on 03.08.2021.
//

import UIKit

class IncomeCell: UITableViewCell {

    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var messageContainer: UIView!
    @IBOutlet var timeLabel: UILabel!
    
    static let reuseId = "IncomeCell"
    
    override func layoutSubviews() {
        super.layoutSubviews()
        messageContainer.layer.cornerRadius = 18
    }
    
    func configure(with model: MessageModel) {
        messageLabel.text = model.text
        
        let date = model.sentDate.components(separatedBy: " ")
        if date.count == 2 {
            timeLabel.text = date[1]
        }
    }
}
