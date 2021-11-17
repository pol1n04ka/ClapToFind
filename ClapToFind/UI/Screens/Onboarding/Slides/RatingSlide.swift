//
//  RatingSlide.swift
//  ClapToFind
//
//  Created by Polina Prokopenko on 11/18/21.
//

import UIKit


class RatingSlide: UICollectionViewCell {
    
    public static let identifier = "RatingSlide"
    
    lazy var image = ImageView(image: .rating)
    lazy var heading = Label(style: .heading, "Help us to improve our app! ")
    lazy var body = Label(style: .body, "We want our application to be useful to you")
    
    lazy var stackView = StackView(axis: .vertical)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}


extension RatingSlide {
    
    func setupView() {
        backgroundColor = .clear
        
        addSubview(stackView)
        stackView.addArrangedSubview(image)
        stackView.addArrangedSubview(heading)
        stackView.addArrangedSubview(body)
        
        stackView.setCustomSpacing(30, after: image)
        stackView.setCustomSpacing(10, after: heading)
        
        let constraints = [
            stackView.centerYAnchor.constraint(equalTo: centerYAnchor),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 25),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -25)
        ]
        
        NSLayoutConstraint.activate(constraints)
    }
    
}
