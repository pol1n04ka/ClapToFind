//
//  AudioInputManager.swift
//  ClapToFind
//
//  Created by Polina Prokopenko on 11/11/21.
//

import Foundation
import AVFAudio


public protocol AudioInputManagerDelegate: AnyObject {
    func audioInputManagerDidFailToAchievePermission(_ audioManager: AudioInputManager)
    func audioInputManager(_ audioManager: AudioInputManager, didCaptureChannelData: [Int16])
}


public class AudioInputManager {
    
    // Code for get audio stream from microphone
    
    public let bufferSize: Int
    
    private let sampleRate: Int
    private let conversionQueue = DispatchQueue(label: "conversionQueue")
    
    public weak var delegate: AudioInputManagerDelegate?
    private let audioEngine = AVAudioEngine()
    
    public init(sampleRate: Int) {
        self.sampleRate = sampleRate
        self.bufferSize = sampleRate * 2
    }
    
    public func checkPermissionAndStartTappingMicrophone() {
        switch AVAudioSession.sharedInstance().recordPermission {
        case .granted:
            break
        case .undetermined:
            break
        case .denied:
            break
        @unknown default:
            break
        }
    }
    
    public func requestPermissions() {
        AVAudioSession.sharedInstance().requestRecordPermission { granted in
            
        }
    }
    
    public func startTappingMicrophone() {
        
    }
    
}
