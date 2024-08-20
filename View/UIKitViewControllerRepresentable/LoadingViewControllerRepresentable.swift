//
//  LoadingViewControllerRepresentable.swift
//  MiniChallenge3
//
//  Created by Rangga Saputra on 20/08/24.
//

import SwiftUI

struct LoadingViewControllerRepresentable: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> some UIViewController {
        let loadingViewController = LoadingViewController()
        return loadingViewController
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        return
    }
}
