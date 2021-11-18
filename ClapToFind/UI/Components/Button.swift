//
//  Button.swift
//  ClapToFind
//
//  Created by Polina Prokopenko on 11/17/21.
//

import UIKit


public class Button: UIButton {
    
    enum ButtonStyle {
        case _continue
        case link
        case settings
        case close
    }
    
    init(style: ButtonStyle, _ text: String?) {
        super.init(frame: .zero)
        
        translatesAutoresizingMaskIntoConstraints = false
        sizeToFit()
        
        switch style {
        case ._continue:
            setTitle(text, for: .normal)
            setTitleColor(UIColor(named: "ButtonTextColor"), for: .normal)
            backgroundColor = UIColor(named: "ButtonColor")
            heightAnchor.constraint(equalToConstant: 48).isActive = true
            layer.cornerRadius = 12
        case .link:
            setTitle(text, for: .normal)
            setTitleColor(.white, for: .normal)
            titleLabel?.font = UIFont(name: "Quicksand-Medium", size: 13)!
        case .settings:
            setImage(UIImage(named: "SettingsIcon"), for: .normal)
            heightAnchor.constraint(equalToConstant: 25).isActive = true
            widthAnchor.constraint(equalToConstant: 25).isActive = true
        case .close:
            setImage(UIImage(named: "ExitIcon"), for: .normal)
            heightAnchor.constraint(equalToConstant: 25).isActive = true
            widthAnchor.constraint(equalToConstant: 25).isActive = true
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

