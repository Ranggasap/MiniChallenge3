//
//  MainViewControllerRepresentable.swift
//  MiniChallenge3
//
//  Created by Rangga Saputra on 15/08/24.
//

import SwiftUI

struct MainViewControllerRepresentable: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> UINavigationController {
        let mainViewController = MainViewController()
        let navigationController = UINavigationController(rootViewController: mainViewController)
        return navigationController
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        return
    }
}
