//
//  ChatBoxView.swift
//  MiniChallenge3
//
//  Created by Rangga Saputra on 16/08/24.
//

import UIKit

class ChatBoxView: UIView {

    private let messageLabel = CustomLabelRegular(textAlignment: .left, fontColor: .label)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(text: String) {
        super.init(frame: .zero)
        messageLabel.setTextWithLineSpacing(text, lineSpacing: 8)
        configure()
    }
    
    func configure() {
        self.backgroundColor = .systemBackground
        self.layer.cornerRadius = 15
        self.layer.masksToBounds = true
        messageLabel.numberOfLines = 0
        
        addSubview(messageLabel)
        
        let horizontalPadding: CGFloat = 12
        let verticalPadding: CGFloat = 8
        NSLayoutConstraint.activate([
            messageLabel.topAnchor.constraint(equalTo: topAnchor, constant: verticalPadding),
            messageLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: horizontalPadding),
            messageLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -verticalPadding),
            messageLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -horizontalPadding)
        ])
    }
    
}
