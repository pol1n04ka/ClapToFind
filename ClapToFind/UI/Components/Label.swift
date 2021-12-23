//
//  Label.swift
//  ClapToFind
//
//  Created by Polina Prokopenko on 11/17/21.
//

import UIKit


public class Label: UILabel {
    
    public enum LabelStyle {
        case heading
        case body
        case separator
    }
    
    init(style: LabelStyle, _ text: String?) {
        super.init(frame: .zero)
        
        sizeToFit()
        
        textColor     = .white
        textAlignment = .center
        self.text     = text
        
        translatesAutoresizingMaskIntoConstraints = false
        
        switch style {
        case .heading:
            font          = UIFont(name: "Quicksand-Bold", size: 19)
            numberOfLines = 0
        case .body:
            font          = UIFont(name: "Quicksand-Medium", size: 16)
            numberOfLines = 0
        case .separator:
            font      = UIFont(name: "Quicksand-Medium", size: 13)
            self.text = "|"
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
