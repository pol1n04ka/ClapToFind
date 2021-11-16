//
//  AudioInputManager.swift
//  ClapToFind
//
//  Created by Polina Prokopenko on 11/11/21.
//

import Foundation
import AVFoundation


public protocol AudioInputManagerDelegate: AnyObject {
    func audioInputManagerDidFailToAchievePermission(_ audioManager: AudioInputManager)
    func audioInputManager(_ audioManager: AudioInputManager, didCaptureChannelData channelData: [Int16])
}


/// Class for get sound stream from microphone
public class AudioInputManager {
    
    // MARK: Constants
    public let bufferSize: Int
    private let sampleRate: Int
    private let conversionQueue = DispatchQueue(label: "conversionQueue")
    
    // MARK: Variables
    public weak var delegate: AudioInputManagerDelegate?
    public let audioEngine = AVAudioEngine()
    
    // MARK: Methods
    public init(sampleRate: Int) {
        self.sampleRate = sampleRate
        self.bufferSize = sampleRate * 2
    }
    
    public func checkPermissionAndStartTappingMicrophone() {
        switch AVAudioSession.sharedInstance().recordPermission {
        case .granted:
            startTappingMicrophone()
        case .undetermined:
            requestPermissions()
        case .denied:
            requestPermissions()
        @unknown default:
            fatalError()
        }
    }
    
    public func requestPermissions() {
        AVAudioSession.sharedInstance().requestRecordPermission { granted in
            if granted {
                self.startTappingMicrophone()
            } else {
                self.checkPermissionAndStartTappingMicrophone()
            }
        }
    }
    
    /// Changes category of audio session for record or play sound
    ///  ```
    ///  true // record mode
    ///  false // play mode
    public func setListenOrPlayMode(_ modeToSet: Bool) {
        let mode: AVAudioSession.Category
        let options: AVAudioSession.CategoryOptions
    
        switch modeToSet {
        case true:
            mode = .playAndRecord
            options = [.mixWithOthers]
            print("Setting category to record")
        case false:
            mode = .playAndRecord
            options = [.defaultToSpeaker]
            print("Setting category to playback")
        }
        
        do {
            try AVAudioSession.sharedInstance().setCategory(mode, options: options)
            try AVAudioSession.sharedInstance().setActive(true, options: .notifyOthersOnDeactivation)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    public func startTappingMicrophone() {
        let inputNode = audioEngine.inputNode
        let inputFormat = inputNode.outputFormat(forBus: 0)
        
        guard let recordingFormat = AVAudioFormat(
            commonFormat: .pcmFormatInt16,
            sampleRate: Double(sampleRate),
            channels: 1,
            interleaved: true
        ), let formatConverter = AVAudioConverter(
            from: inputFormat,
            to: recordingFormat
        ) else { return }
        
        inputNode.installTap(onBus: 0,
                             bufferSize: AVAudioFrameCount(bufferSize),
                             format: inputFormat) { buffer, _ in
            self.conversionQueue.async {
                guard let pcmBuffer = AVAudioPCMBuffer(
                    pcmFormat: recordingFormat,
                    frameCapacity: AVAudioFrameCount(recordingFormat.sampleRate * 2.0)
                ) else { return }
                
                var error: NSError?
                let inputBlock: AVAudioConverterInputBlock = { _, outStatus in
                    outStatus.pointee = AVAudioConverterInputStatus.haveData
                    return buffer
                }
                
                formatConverter.convert(to: pcmBuffer, error: &error, withInputFrom: inputBlock)
                
                if let error = error {
                    print(error.localizedDescription)
                    return
                }
                
                if let channelData = pcmBuffer.int16ChannelData {
                    let channelDataValue = channelData.pointee
                    let channelDataValueArray = stride(
                        from: 0,
                        through: Int(pcmBuffer.frameLength),
                        by: buffer.stride
                    ).map { channelDataValue[$0] }
                    
                    self.delegate?.audioInputManager(self, didCaptureChannelData: channelDataValueArray)
                }
            }
        }
        
        audioEngine.prepare()
        do {
            try audioEngine.start()
        } catch {
            print(error.localizedDescription)
        }
    }
    
}
