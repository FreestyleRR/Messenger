//
//  TextFieldView.swift
//  Messenger
//
//  Created by Pavel Sharkov on 05.06.2022.
//

import UIKit

class TextFieldView: UITextField {
    var insetX: CGFloat = 15
    var insetY: CGFloat = 0

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }

    private func setup() {
        layer.masksToBounds = true
        layer.cornerRadius = 20
        autocorrectionType = .no
        autocapitalizationType = .none
        spellCheckingType = .no
    }
    
    func setPlaceholter(_ text: String) {
        placeholder = text
    }

    // placeholder position
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: insetX, dy: insetY)
    }

    // text position
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: insetX, dy: insetY)
    }

    // placeholdeeer position
    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: insetX, dy: insetY)
    }
}
