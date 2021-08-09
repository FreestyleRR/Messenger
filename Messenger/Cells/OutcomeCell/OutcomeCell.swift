//
//  OutcomeCell.swift
//  Messenger
//
//  Created by Паша Шарков on 03.08.2021.
//

import UIKit

class OutcomeCell: UITableViewCell {
    
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var messageContainer: UIView!
    
    static let reuseId = "OutcomeCell"
    
    
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

extension OutcomeCell {
    func configure(with message: MessageModel) {
        messageLabel.text = message.text
    }
}
