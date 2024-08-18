//
//  CustomToggleButton.swift
//  MiniChallenge3
//
//  Created by Rangga Saputra on 15/08/24.
//

import UIKit

protocol ToggleButtonDelegate: AnyObject {
    func toggleButtonDidChangeState(_ toggleButton: CustomToggleButton, isOn: Bool)
}

class CustomToggleButton: UIButton {
    
    private(set) var isOn: Bool = false {
        didSet {
            updateAppearance()
        }
    }
    
    private let circleView = UIView()
    private var circleLeadingConstraint: NSLayoutConstraint?
    
    weak var delegate: ToggleButtonDelegate?

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        addTarget(self, action: #selector(toggle), for: .touchUpInside)
        
        backgroundColor = .systemGray
        
        circleView.backgroundColor = .white
        circleView.layer.cornerRadius = 15
        circleView.clipsToBounds = true
        addSubview(circleView)
        
        circleView.translatesAutoresizingMaskIntoConstraints = false
        circleLeadingConstraint = circleView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 5)
        NSLayoutConstraint.activate([
            circleLeadingConstraint!,
            circleView.heightAnchor.constraint(equalToConstant: 30),
            circleView.widthAnchor.constraint(equalToConstant: 30),
            circleView.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
        
        updateAppearance()
        
    }
    
    @objc private func toggle(){
        isOn.toggle()
        delegate?.toggleButtonDidChangeState(self, isOn: isOn)
    }
    
    private func updateAppearance() {
        UIView.animate(withDuration: 0.3){
            self.backgroundColor = self.isOn ? UIColor(named: "ButtonStartRecordBackgroundColor"): .systemGray
            let circleLeadingConstraint = self.isOn ? (self.frame.width - 35) : 5
            
            self.circleLeadingConstraint?.constant = circleLeadingConstraint
            
            self.layoutIfNeeded()
        }
        
    }
    
}
