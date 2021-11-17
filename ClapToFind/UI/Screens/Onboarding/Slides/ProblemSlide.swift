//
//  ProblemSlide.swift
//  ClapToFind
//
//  Created by Polina Prokopenko on 11/18/21.
//

import UIKit


class ProblemSlide: UICollectionViewCell {
    
    public static let identifier = "ProblemSlide"
    
    lazy var image = ImageView(image: .problem)
    lazy var heading = Label(style: .heading, "Can’t find your phone?")
    lazy var body = Label(style: .body, "Our app will help you!")
    
    lazy var stackView = StackView(axis: .vertical)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}


extension ProblemSlide {
    
    func setupView() {
        backgroundColor = .clear
        
        addSubview(stackView)
        stackView.addArrangedSubview(image)
        stackView.addArrangedSubview(heading)
        stackView.addArrangedSubview(body)
        
        stackView.setCustomSpacing(30, after: image)
        stackView.setCustomSpacing(10, after: heading)
        
        image.translatesAutoresizingMaskIntoConstraints = false
        heading.translatesAutoresizingMaskIntoConstraints = false
        body.translatesAutoresizingMaskIntoConstraints = false
        
        let constraints = [
            stackView.centerYAnchor.constraint(equalTo: centerYAnchor),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 25),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -25)
        ]
        
        NSLayoutConstraint.activate(constraints)
    }
    
}
