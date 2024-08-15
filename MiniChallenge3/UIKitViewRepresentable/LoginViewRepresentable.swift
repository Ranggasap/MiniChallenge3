//
//  LoginViewRepresentable.swift
//  MiniChallenge3
//
//  Created by Rangga Saputra on 15/08/24.
//
import SwiftUI

struct LoginViewControllerRepresentable: UIViewControllerRepresentable {
    
    func makeUIViewController(context: Context) -> some UIViewController {
        let loginViewController = LoginViewController()
        return loginViewController
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        return
    }
    
}
