//
//  OnboardingManager.swift
//  ClapToFind
//
//  Created by Polina Prokopenko on 11/18/21.
//

import Foundation


class OnboardingManager {
    
    static let shared = OnboardingManager()
    
    var isFirstLaunch: Bool {
        get {
            !UserDefaults.standard.bool(forKey: #function)
        } set {
            UserDefaults.standard.setValue(newValue, forKey: #function)
        }
    }
    
}
