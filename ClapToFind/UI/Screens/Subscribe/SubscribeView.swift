//
//  SubscribeView.swift
//  ClapToFind
//
//  Created by Polina Prokopenko on 11/17/21.
//

import UIKit


class SubscribeView: UIViewController {
    
    // MARK: UI elements
    
    let gradient = Gradient()
    
    lazy var closeButton = Button(style: .close, nil)
    
    lazy var image   = ImageView(image: .clappingAndPhone)
    lazy var heading = Label(style: .heading, "Clap To Find")
    lazy var body    = Label(style: .body, "Subscribe to unlock all the features, just $9.99/week")
    
    lazy var continueButton = Button(style: ._continue, "Continue")
    
    lazy var termsOfUseButton = Button(style: .link, "Terms of Use")
    lazy var privacyPolicyButton = Button(style: .link, "Privacy Policy")
    lazy var restorePurchaseButton = Button(style: .link, "Restore Purchase")
    
    lazy var separatorOne = Label(style: .separator, nil)
    lazy var separatorTwo = Label(style: .separator, nil)
    
    lazy var stackViewForContent = StackView(axis: .vertical)
    lazy var stackViewForLinks   = StackView(axis: .horizontal)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        gradient.setGradientBackground(view: view)
        setupView()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
}


// MARK: Button actions
extension SubscribeView {
    
    @objc func closeView() {
        print("Close view")
    }
    
    @objc func getSubscribe() {
        print("Get subscribe")
    }
    
    @objc func getTermsOfUse() {
        print("Terms of use")
        
        let url = URL(string: "https://www.google.com/")
        UIApplication.shared.open(url!, options: [:], completionHandler: nil)
    }
    
    @objc func getPrivacyPolicy() {
        print("Privacy policy")
        
        let url = URL(string: "https://www.google.com/")
        UIApplication.shared.open(url!, options: [:], completionHandler: nil)
    }
    
    @objc func getRestorePurchase() {
        print("Restore purchase")
        
        let url = URL(string: "https://www.google.com/")
        UIApplication.shared.open(url!, options: [:], completionHandler: nil)
    }
    
}


// MARK: Setup view
extension SubscribeView {
    
    func setupView() {
        closeButton.addTarget(self, action: #selector(closeView), for: .touchUpInside)
        continueButton.addTarget(self, action: #selector(getSubscribe), for: .touchUpInside)
        
        termsOfUseButton.addTarget(self, action: #selector(getTermsOfUse), for: .touchUpInside)
        privacyPolicyButton.addTarget(self, action: #selector(getPrivacyPolicy), for: .touchUpInside)
        restorePurchaseButton.addTarget(self, action: #selector(getRestorePurchase), for: .touchUpInside)
        
        view.translatesAutoresizingMaskIntoConstraints = false
        
        closeButton.layer.zPosition = 10
        view.addSubview(closeButton)
        
        view.addSubview(stackViewForContent)
        stackViewForContent.addArrangedSubview(image)
        stackViewForContent.addArrangedSubview(heading)
        stackViewForContent.addArrangedSubview(body)
        
        stackViewForContent.setCustomSpacing(10, after: image)
        stackViewForContent.setCustomSpacing(10, after: heading)
        
        view.addSubview(continueButton)
        
        view.addSubview(stackViewForLinks)
        stackViewForLinks.addArrangedSubview(termsOfUseButton)
        stackViewForLinks.addArrangedSubview(separatorOne)
        stackViewForLinks.addArrangedSubview(privacyPolicyButton)
        stackViewForLinks.addArrangedSubview(separatorTwo)
        stackViewForLinks.addArrangedSubview(restorePurchaseButton)
        
        let constraints = [
            closeButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 25),
            closeButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 25),
            
            stackViewForContent.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            stackViewForContent.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 25),
            stackViewForContent.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -25),
            
            continueButton.bottomAnchor.constraint(equalTo: stackViewForLinks.topAnchor, constant: -15),
            continueButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 25),
            continueButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -25),
            
            stackViewForLinks.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10),
            stackViewForLinks.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            stackViewForLinks.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
        ]
        
        NSLayoutConstraint.activate(constraints)
    }
    
}
