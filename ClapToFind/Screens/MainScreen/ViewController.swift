//
//  ViewController.swift
//  ClapToFind
//
//  Created by Polina Prokopenko on 11/11/21.
//

import UIKit

class ViewController: UIViewController {
    
    lazy var label: UILabel = {
        let l = UILabel()
        
        l.sizeToFit()
        l.textColor = .black
        l.translatesAutoresizingMaskIntoConstraints = false
        l.text = "Something"
        l.textAlignment = .center
        
        return l
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        
        
        view.addSubview(label)
        
        let constraints = [
            label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ]
        
        NSLayoutConstraint.activate(constraints)
    }

}

