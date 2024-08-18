//
//  CustomSwitchButton.swift
//  MiniChallenge3
//
//  Created by Rangga Saputra on 18/08/24.
//

import UIKit

class CustomSwitchButton: UISwitch {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(valueBool: Bool){
        super.init(frame: .zero)
        self.setOn(valueBool, animated: true)
        configure()
    }
    
    func configure() {
        self.translatesAutoresizingMaskIntoConstraints = false
    }
    
    @objc func updateSwitch() {
        
    }
    
}
