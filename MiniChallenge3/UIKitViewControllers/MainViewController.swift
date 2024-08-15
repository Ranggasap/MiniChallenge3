//
//  MainViewController.swift
//  MiniChallenge3
//
//  Created by Rangga Saputra on 15/08/24.
//

import UIKit

class MainViewController: UIViewController {

    let callToActionButton = CustomButton(backgroundColor: UIColor(named: "ButtonStartRecordBackgroundColor")!, title: "Start Record", titleColor: .white, borderColor: UIColor(named: "ButtonStartRecordBackgroundColor")!)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setBackground()
        configureCallToActionButton()
        configureViewController()
        
    }
    
    func configureViewController() {
        self.title = "Hi, Rangga"
        let textAttributes = [NSAttributedString.Key.foregroundColor:UIColor.white]
        navigationController?.navigationBar.largeTitleTextAttributes = textAttributes
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    func setBackground() {
        let backgroundView = UIView()
        backgroundView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(backgroundView)
        view.sendSubviewToBack(backgroundView)
        
        NSLayoutConstraint.activate([
            backgroundView.topAnchor.constraint(equalTo: view.topAnchor),
            backgroundView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgroundView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            backgroundView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
    }
    
    func configureCallToActionButton() {
        view.addSubview(callToActionButton)
        NSLayoutConstraint.activate([
            callToActionButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0),
            callToActionButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32),
            callToActionButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32),
            callToActionButton.heightAnchor.constraint(equalToConstant: 62)
        ])
    }

}
