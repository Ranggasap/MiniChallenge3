//
//  CustomButton.swift
//  MiniChallenge3
//
//  Created by Rangga Saputra on 15/08/24.
//

import UIKit

class CustomButton: UIButton {

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(backgroundColor: UIColor, title: String, titleColor: UIColor ,borderColor: UIColor){
        super.init(frame: .zero)
        self.backgroundColor = backgroundColor
        self.setTitle(title, for: .normal)
        setTitleColor(titleColor, for: .normal)
        self.layer.borderColor = borderColor.cgColor
        self.layer.borderWidth = 2
        configure()
    }
    
    private func configure() {
        layer.cornerRadius = 10
        titleLabel?.font = UIFont.preferredFont(forTextStyle: .headline)
        translatesAutoresizingMaskIntoConstraints = false
    }
    
}
