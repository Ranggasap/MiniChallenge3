//
//  DynamicIslandChecker.swift
//  MiniChallenge3
//
//  Created by Vincent Saranang on 18/08/24.
//

import Foundation
import UIKit

struct DynamicIslandChecker{
    // mesti dimasukin ke MVVM biar bisa call function dibawah ini (skrng msh based contentview extension)
    // dynammic island top, bottom notch conditional
    static func getTopPadding() -> CGFloat {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let window = windowScene.windows.first else {
            return 20
        }
        return window.safeAreaInsets.top >= 51 ? 64 : 20
    }
    
    static func getBotPadding() -> CGFloat {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let window = windowScene.windows.first else {
            return 20
        }
        return window.safeAreaInsets.bottom >= 33 ? 34 : 20
    }
}
