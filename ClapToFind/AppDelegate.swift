//
//  AppDelegate.swift
//  ClapToFind
//
//  Created by Polina Prokopenko on 11/11/21.
//

import UIKit
import CoreData

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        window = UIWindow(frame: UIScreen.main.bounds)
        
        if OnboardingManager.shared.isFirstLaunch {
            window?.rootViewController = OnboardingView()
        } else {
            window?.rootViewController = NavigationController(rootViewController: MainView())
        }
        
//        window?.rootViewController = SubscribeView()
        
        window?.makeKeyAndVisible()
        
        return true
    }

}


