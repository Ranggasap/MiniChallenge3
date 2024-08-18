//
//  FontExtension.swift
//  MiniChallenge3
//
//  Created by Vincent Saranang on 18/08/24.
//

import Foundation
import SwiftUI

extension Font {
    static func lt(size: CGFloat, weight: Font.Weight = .regular) -> Font {
        let fontName: String
        
        switch weight {
        case .black:
            fontName = "Lato-Black"
        case .bold:
            fontName = "Lato-Bold"
        case .heavy:
            fontName = "Lato-Heavy"
        case .light:
            fontName = "Lato-Light"
        case .medium:
            fontName = "Lato-Medium"
        case .semibold:
            fontName = "Lato-Semibold"
        case .thin:
            fontName = "Lato-Thin"
        default:
            fontName = "Lato-Regular"
        }
        
        return .custom(fontName, size: size)
    }
}
