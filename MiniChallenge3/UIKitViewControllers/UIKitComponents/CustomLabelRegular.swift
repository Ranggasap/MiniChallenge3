//
//  CustomLabelRegular.swift
//  MiniChallenge3
//
//  Created by Rangga Saputra on 15/08/24.
//

import UIKit

class CustomLabelRegular: UILabel {

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(textAlignment: NSTextAlignment, fontColor: UIColor){
        super.init(frame: .zero)
        self.textAlignment = textAlignment
        self.textColor = fontColor
        configure()
    }
    
    private func configure() {
        adjustsFontSizeToFitWidth = true
        minimumScaleFactor = 0.90
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    func setTextWithLineSpacing(_ text: String, lineSpacing: CGFloat) {
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.lineSpacing = lineSpacing
            paragraphStyle.alignment = textAlignment
            
            let attributedText = NSAttributedString(
                string: text,
                attributes: [
                    .paragraphStyle: paragraphStyle,
                    .foregroundColor: textColor as Any
                ]
            )
            
            self.attributedText = attributedText
        }

}
