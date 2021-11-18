//
//  OnboardingView.swift
//  ClapToFind
//
//  Created by Polina Prokopenko on 11/17/21.
//

import UIKit
import StoreKit


class OnboardingView: UIViewController {
    
    private let app = UIApplication.shared.delegate
    private var currentIndex: IndexPath = .init(index: 0)
    
    // MARK: UI elements
    
    // Gradient for background
    let gradient = Gradient()
    
    // Collection view + control
    lazy var pageControl    = PageControl()
    lazy var collectionView = CollectionView(
        delegate: self,
        dataSource: self
    )
    
    // Stack view
    lazy var stackView = StackView(axis: .horizontal)
    
    // Buttons
    lazy var closeButton           = Button(style: .close, nil)
    lazy var continueButton        = Button(style: ._continue, "Continue")
    lazy var termsOfUseButton      = Button(style: .link, "Terms of Use")
    lazy var privacyPolicyButton   = Button(style: .link, "Privacy Policy")
    lazy var restorePurchaseButton = Button(style: .link, "Restore Purchase")
    
    // Separators
    lazy var separatorOne = Label(style: .separator, nil)
    lazy var separatorTwo = Label(style: .separator, nil)
    
    // MARK: ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        gradient.setGradientBackground(view: view)
        setupView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    func rateApp() {
        SKStoreReviewController.requestReview()
    }
    
}


// MARK: Setup view
extension OnboardingView {
    
    func setupView() {
        
        
        closeButton.isHidden = true
        closeButton.layer.zPosition = 10
        closeButton.addTarget(self, action: #selector(closeOnboarding), for: .touchUpInside)
        
        // MARK: Go to next page
        continueButton.addTarget(self, action: #selector(nextPage), for: .touchUpInside)
        
        termsOfUseButton.addTarget(self, action: #selector(getTermsOfUse), for: .touchUpInside)
        privacyPolicyButton.addTarget(self, action: #selector(getPrivacyPolicy), for: .touchUpInside)
        restorePurchaseButton.addTarget(self, action: #selector(getRestorePurchase), for: .touchUpInside)
        
        // MARK: Register slides
        collectionView.register(ProblemSlide.self, forCellWithReuseIdentifier: ProblemSlide.identifier)
        collectionView.register(RatingSlide.self, forCellWithReuseIdentifier: RatingSlide.identifier)
        collectionView.register(ClapSlide.self, forCellWithReuseIdentifier: ClapSlide.identifier)
        collectionView.register(RingingPhoneSlide.self, forCellWithReuseIdentifier: RingingPhoneSlide.identifier)
        collectionView.register(SubscribeSlide.self, forCellWithReuseIdentifier: SubscribeSlide.identifier)
        
        
        
        view.addSubview(pageControl)
        view.addSubview(collectionView)
        view.addSubview(closeButton)
        view.addSubview(continueButton)
        view.addSubview(stackView)
        stackView.addArrangedSubview(termsOfUseButton)
        stackView.addArrangedSubview(separatorOne)
        stackView.addArrangedSubview(privacyPolicyButton)
        stackView.addArrangedSubview(separatorTwo)
        stackView.addArrangedSubview(restorePurchaseButton)
        
        let constraints = [
            
            // MARK: Page control
            pageControl.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            pageControl.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            pageControl.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            
            // MARK: Close button
            closeButton.topAnchor.constraint(equalTo: pageControl.bottomAnchor, constant: 20),
            closeButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            
            // MARK: Collection view
            collectionView.topAnchor.constraint(equalTo: pageControl.bottomAnchor, constant: 20),
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: continueButton.topAnchor, constant: -20),
            
            // MARK: Continue button
            continueButton.bottomAnchor.constraint(equalTo: stackView.topAnchor, constant: -15),
            continueButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            continueButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            
            // MARK: Stack view
            stackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -15),
            stackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20)
        ]
        
        NSLayoutConstraint.activate(constraints)
    }
    
}

// MARK: Button actions
extension OnboardingView {
    
    @objc func closeOnboarding() {
        guard let optionalWindow = app?.window else { return }
        guard let window = optionalWindow else { return }
        
        let vc = NavigationController(rootViewController: MainView())
        window.rootViewController = vc
        
        UIView.transition(with: window, duration: 0.3, options: .transitionCrossDissolve, animations: {}, completion: { completed in
            print("Close onboarding animation ends")
        })
        
        OnboardingManager.shared.isFirstLaunch = true
    }
    
    @objc func nextPage() {
        if currentIndex.row < 4 {
            collectionView.scrollToItem(at: IndexPath(arrayLiteral: 0, currentIndex.row + 1), at: .centeredHorizontally, animated: true)
        } else {
            closeOnboarding()
        }
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


// MARK: Collection view data source
extension OnboardingView: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        var slide: String

        switch indexPath.row {
        case 0:
            slide = ProblemSlide.identifier
        case 1:
            slide = RatingSlide.identifier
        case 2:
            slide = ClapSlide.identifier
        case 3:
            slide = RingingPhoneSlide.identifier
        case 4:
            slide = SubscribeSlide.identifier
        default:
            slide = ProblemSlide.identifier
        }
        let item = collectionView.dequeueReusableCell(withReuseIdentifier: slide, for: indexPath)
        return item
    }
    
}


// MARK: Collection view delegate
extension OnboardingView: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let itemWidth = collectionView.bounds.width
        let itemHeight = collectionView.bounds.height
        
        return CGSize(width: itemWidth, height: itemHeight)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        pageControl.set(
            progress: self.collectionView.indexPathsForVisibleItems.first!.item,
            animated: true
        )
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        pageControl.set(
            progress: indexPath.row,
            animated: true
        )
        
        if indexPath.row == 4 {
            closeButton.isHidden = false
        } else {
            closeButton.isHidden = true
        }
        
        if indexPath.row == 1 {
            rateApp()
        }
        
        currentIndex = indexPath
    }
    
}
