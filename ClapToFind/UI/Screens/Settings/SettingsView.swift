//
//  SettingsView.swift
//  ClapToFind
//
//  Created by Polina Prokopenko on 11/17/21.
//

import UIKit
import TOInsetGroupedTableView


class SettingsView: UIViewController {
    
    let tableViewItems = ["Share this app", "Privacy policy", "Terms of use", "Support"]
    
    // MARK: UI elements
    
    // Gradient for background
    let gradient = Gradient()
    
    lazy var tableView = InsetGroupedTableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Settings"
        navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationBar.barTintColor = UIColor(named: "GradientTopColor")!.withAlphaComponent(0.5)
        navigationController?.navigationBar.isTranslucent = true
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
        
        gradient.setGradientBackground(view: view)
        setupView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        navigationController?.navigationBar.isHidden = false
        
        UIView.transition(with: self.navigationController!.navigationBar, duration: 0.1, options: .transitionCrossDissolve, animations: {}, completion: { _ in })
    }
    
}


extension SettingsView {
    
    func setupView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .clear
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        view.addSubview(tableView)
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        let constraints = [
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ]
        
        NSLayoutConstraint.activate(constraints)
    }
    
}


extension SettingsView: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableViewItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        cell.textLabel?.text = tableViewItems[indexPath.row]
        cell.textLabel?.textColor = .white
        cell.backgroundColor = .white.withAlphaComponent(0.2)
        
        let bgView = UIView()
        bgView.backgroundColor = .white.withAlphaComponent(0.3)
        
        cell.selectedBackgroundView = bgView
        
        cell.tintColor = .white
        let image = UIImage(named:"Chevron")?.withRenderingMode(.alwaysTemplate)
        if let width = image?.size.width, let height = image?.size.height {
            let disclosureImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: width, height: height))
            disclosureImageView.image = image
            cell.accessoryView = disclosureImageView
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let url = URL(string: "https://www.google.com/")
        UIApplication.shared.open(url!, options: [:], completionHandler: nil)
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}
