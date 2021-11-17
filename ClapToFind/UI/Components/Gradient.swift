//
//  Gradient.swift
//  ClapToFind
//
//  Created by Polina Prokopenko on 11/17/21.
//

import UIKit


public class Gradient {
    
    private let gradient: CAGradientLayer!
    
    public func setGradientBackground(view: UIView) {
        let backgroundLayer = self.gradient
        backgroundLayer?.frame = view.frame
        view.layer.insertSublayer(backgroundLayer!, at: 0)
    }
    
    init() {
        let topColor = UIColor(named: "GradientTopColor")!.cgColor
        let bottomColor = UIColor(named: "GradientBottomColor")!.cgColor
        
        self.gradient = CAGradientLayer()
        self.gradient.colors = [topColor, bottomColor]
        self.gradient.locations = [0.0, 1.0]
    }
    
}
