//
//  StackView.swift
//  ClapToFind
//
//  Created by Polina Prokopenko on 11/18/21.
//

import UIKit


public class StackView: UIStackView {
    
    enum StackViewAxis {
        case horizontal
        case vertical
    }
    
    init(axis: StackViewAxis) {
        super.init(frame: .zero)
        
        translatesAutoresizingMaskIntoConstraints = false
        
        switch axis {
        case .horizontal:
            self.axis    = .horizontal
            distribution = .fillProportionally
        case .vertical:
            self.axis = .vertical
        }
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
