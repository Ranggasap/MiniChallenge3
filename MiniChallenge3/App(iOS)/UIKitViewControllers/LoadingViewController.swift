//
//  LoadingViewController.swift
//  MiniChallenge3
//
//  Created by Rangga Saputra on 19/08/24.
//

import UIKit

class LoadingViewController: UIViewController {
    
    let deerHorn = UIImageView(image: UIImage(named: "DeerHorn"))
    let donutBited1 = UIImageView(image: UIImage(named: "DonutBited"))
    let donutBited2 = UIImageView(image: UIImage(named: "DonutBited"))
    let donutBited3 = UIImageView(image: UIImage(named: "DonutBited"))
    let donutBited4 = UIImageView(image: UIImage(named: "DonutBited"))

    override func viewDidLoad() {
        super.viewDidLoad()
        configureBackground()
        animateDonutsAndDeerHorn()
    }
    
    func animateDonutsAndDeerHorn() {
        let donutBitedViews = [donutBited1, donutBited2, donutBited3, donutBited4]
        
        // Spring animation for donutBited views
        for (index, donutView) in donutBitedViews.enumerated() {
            donutView.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
            UIView.animate(withDuration: 1.0,
                           delay: Double(index) * 0.2,
                           usingSpringWithDamping: 0.5,
                           initialSpringVelocity: 0.3,
                           options: .curveEaseInOut,
                           animations: {
                               donutView.transform = .identity
                           }, completion: nil)
        }
        
        deerHorn.transform = CGAffineTransform(scaleX: 0.0, y: 0.0)
            
        // Animation to show deerHorn with a spring effect after 3 seconds
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            UIView.animate(withDuration: 1.0,
                           delay: 0,
                           usingSpringWithDamping: 0.5,
                           initialSpringVelocity: 0.3,
                           options: .curveEaseInOut,
                           animations: {
                               self.deerHorn.transform = .identity
                           }, completion: nil)
        }
    }

    func configureBackground(){
        
        view.addSubview(deerHorn)
        view.addSubview(donutBited1)
        view.addSubview(donutBited2)
        view.addSubview(donutBited3)
        view.addSubview(donutBited4)
        
        donutBited1.contentMode = .scaleAspectFit
        donutBited2.contentMode = .scaleAspectFit
        donutBited3.contentMode = .scaleAspectFit
        donutBited4.contentMode = .scaleAspectFit
        
        donutBited1.translatesAutoresizingMaskIntoConstraints = false
        donutBited2.translatesAutoresizingMaskIntoConstraints = false
        donutBited3.translatesAutoresizingMaskIntoConstraints = false
        donutBited4.translatesAutoresizingMaskIntoConstraints = false
        deerHorn.translatesAutoresizingMaskIntoConstraints = false
        
        view.backgroundColor = UIColor(named: "ButtonColor3")
        
        NSLayoutConstraint.activate([
            deerHorn.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: -20),
            deerHorn.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            donutBited1.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            donutBited1.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            donutBited1.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 1.6),
            donutBited1.heightAnchor.constraint(equalTo: donutBited1.widthAnchor),
            
            donutBited2.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            donutBited2.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            donutBited2.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 1.35),
            donutBited2.heightAnchor.constraint(equalTo: donutBited2.widthAnchor),
            
            donutBited3.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            donutBited3.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            donutBited3.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 1),
            donutBited3.heightAnchor.constraint(equalTo: donutBited3.widthAnchor),
            
            donutBited4.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            donutBited4.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            donutBited4.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.75),
            donutBited4.heightAnchor.constraint(equalTo: donutBited4.widthAnchor),
            
        ])
        
    }

}
