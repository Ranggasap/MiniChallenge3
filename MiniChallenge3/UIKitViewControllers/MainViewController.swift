//
//  MainViewController.swift
//  MiniChallenge3
//
//  Created by Rangga Saputra on 15/08/24.
//

import UIKit

class MainViewController: UIViewController {
    
    
    let dandenionText = ChatBoxView(text: "How was your day? Keep your head high, knowing that you have the power within you to face any challenge")
    
    let containerViewButton = UIView()
    
    let autoRecordText = CustomLabelRegular(textAlignment: .center, fontColor: .systemGray)

    let callToActionButton = CustomButton(backgroundColor: UIColor(named: "ButtonStartRecordBackgroundColor")!, title: "Start Record", titleColor: .white, borderColor: UIColor(named: "ButtonStartRecordBackgroundColor")!)
    
    private var isAutoRecordOn: Bool = false {
        didSet{
            print(isAutoRecordOn)
        }
    }
    
    let autoRecordToggleButton = CustomSwitchButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setBackground()
        
        configureContainerViewBottomAction()
        
        configureCallToActionButton()
        configureViewController()
        configureAutoRecordToggleButton()
        configureTextBox()
    }
    
    func configureContainerViewBottomAction(){
        containerViewButton.backgroundColor = .white
        containerViewButton.translatesAutoresizingMaskIntoConstraints = false
        containerViewButton.layer.cornerRadius = 15
        containerViewButton.layer.masksToBounds = true
        view.addSubview(containerViewButton)
    }
    
    func configureViewController() {
        self.title = "Hi, Rangga"
        let textAttributes = [NSAttributedString.Key.foregroundColor:UIColor.white]
        navigationController?.navigationBar.largeTitleTextAttributes = textAttributes
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    func configureTextBox() {
        view.addSubview(dandenionText)
        
        dandenionText.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            dandenionText.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32),
            dandenionText.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32),
            dandenionText.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
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
    
    
    func configureAutoRecordToggleButton() {
        view.addSubview(autoRecordToggleButton)
        autoRecordToggleButton.translatesAutoresizingMaskIntoConstraints = false
        autoRecordToggleButton.setOn(isAutoRecordOn, animated: true)
        autoRecordToggleButton.addTarget(self, action: #selector(autoRecordToggleChanged(_:)), for: .valueChanged)
        
        view.addSubview(autoRecordText)
        autoRecordText.text = "Auto Record"
        
        
        NSLayoutConstraint.activate([
            autoRecordToggleButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32),
            autoRecordToggleButton.bottomAnchor.constraint(equalTo: callToActionButton.topAnchor, constant: -25),
            
            autoRecordText.trailingAnchor.constraint(equalTo: autoRecordToggleButton.leadingAnchor, constant: -10),
            autoRecordText.topAnchor.constraint(equalTo: autoRecordToggleButton.topAnchor),
            autoRecordText.bottomAnchor.constraint(equalTo: autoRecordToggleButton.bottomAnchor),
            
            containerViewButton.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            containerViewButton.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            containerViewButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0),
            containerViewButton.topAnchor.constraint(equalTo: autoRecordToggleButton.topAnchor, constant: -24)
        ])
    }
    
    
    func configureCallToActionButton() {
        view.addSubview(callToActionButton)
        NSLayoutConstraint.activate([
            callToActionButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 0),
            callToActionButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32),
            callToActionButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32),
            callToActionButton.heightAnchor.constraint(equalToConstant: 62)
        ])
    }
    
    @objc func autoRecordToggleChanged(_ sender: UISwitch){
        if sender.isOn {
           
        } else {
       
        }
    }
    
    @objc func navigateToReportPage() {
        let reportViewController = ReportViewController()
        
        self.navigationController?.pushViewController(reportViewController, animated: true)
    }

}
