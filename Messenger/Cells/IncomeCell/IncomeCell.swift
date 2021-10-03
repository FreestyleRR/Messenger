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
    
    static let reuseId = "IncomeCell"
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        messageContainer.layer.cornerRadius = 10
    }
}

extension IncomeCell {
    func configure(with message: MessageModel) {
        messageLabel.text = message.text
    }
}
