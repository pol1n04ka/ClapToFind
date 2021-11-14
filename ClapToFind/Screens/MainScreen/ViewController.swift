//
//  ViewController.swift
//  ClapToFind
//
//  Created by Polina Prokopenko on 11/11/21.
//

import UIKit
import RxSwift
import RxRelay
import AVFoundation


class ViewController: UIViewController {
    
    // MARK: Variables for audio recognition
    private var audioInputManager: AudioInputManager!
    private var soundRecognizer: SoundRecognition!
    private var bufferSize: Int = 0
    private var probabilities: [Float32] = []
    
    // MARK: Variable for check audio
    private var isClap = BehaviorRelay<Bool>(value: false)
    
    // MARK: Variable for player instance
    private var audioPlayer: AVAudioPlayer!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        _ = isClap.subscribe { event in
            guard let value = event.element else { return }
            
            if value == true {
                self.label.text = "It's clap!"
                self.playSound()
            } else {
                self.label.text = "No clap recognized..."
            }
        }
        
        setupView()
        
        soundRecognizer = SoundRecognition(
            modelFileName: "soundclassifier_with_metadata",
            delegate: self
        )
        
        startAudioRecognition()
    }
    
    // MARK: UI elements
    lazy var label: UILabel = {
        let l = UILabel()
        
        l.sizeToFit()
        l.textColor = .black
        l.translatesAutoresizingMaskIntoConstraints = false
        l.text = "Something"
        l.textAlignment = .center
        
        return l
    }()
    
    lazy var progress: UIProgressView = {
        let p = UIProgressView()
        
        p.translatesAutoresizingMaskIntoConstraints = false
        
        return p
    }()

}


// MARK: Setup UI
extension ViewController {
    
    /// Setting UI
    private func setupView() {
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        
        
        view.addSubview(label)
        view.addSubview(progress)
        
        let constraints = [
            label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            progress.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 20),
            progress.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 30),
            progress.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -30)
        ]
        
        NSLayoutConstraint.activate(constraints)
    }
    
}


// MARK: Start sound recognition
extension ViewController {
    
    /// Turning microphone on and starts sound recognition
    private func startAudioRecognition() {
        audioInputManager = AudioInputManager(sampleRate: soundRecognizer.sampleRate)
        audioInputManager.delegate = self
        
        bufferSize = audioInputManager.bufferSize
        
        audioInputManager.checkPermissionAndStartTappingMicrophone()
    }
    
    /// Starts model with input buffer
    private func runModel(inputBuffer: [Int16]) {
        soundRecognizer.start(inputBuffer: inputBuffer)
    }
    
}

// MARK: Play sound
extension ViewController: AVAudioPlayerDelegate {
    
    /// Play okey sound on recognize clap
    private func playSound() {
        let url = Bundle.main.path(forResource: "okey2", ofType: "mp3")
        
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: URL(string: url!)!)
            audioInputManager.setListenOrPlayMode(false)
            
            guard let player = audioPlayer else { return }

            player.delegate = self
            player.prepareToPlay()
            player.volume = 1.0
            player.play()
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        audioInputManager.setListenOrPlayMode(true)
    }
    
}


// MARK: Audio manager delegate
extension ViewController: AudioInputManagerDelegate {
    
    // If user don't get permission to use microphone
    func audioInputManagerDidFailToAchievePermission(_ audioManager: AudioInputManager) {
//        let alertController = UIAlertController(
//            title: "Microphone permissions denied",
//            message: "Microphone permissions have been denied for this app. You can change this by going to Settings",
//            preferredStyle: .alert
//        )
//
//        let cancelButton = UIAlertAction(
//            title: "Cancel",
//            style: .cancel,
//            handler: nil
//        )
//
//        let settingsAction = UIAlertAction(
//            title: "Settings",
//            style: .default
//        ) { _ in
//            UIApplication.shared.open(
//                URL(string: UIApplication.openSettingsURLString)!,
//                options: [:],
//                completionHandler: nil)
//        }
//
//        alertController.addAction(cancelButton)
//        alertController.addAction(settingsAction)
//
//        self.present(alertController, animated: true, completion: nil)
//
        print("Can't use microphone")
    }
    
    func audioInputManager(
        _ audioManager: AudioInputManager,
        didCaptureChannelData channelData: [Int16]
    ) {
        let sampleRate = soundRecognizer.sampleRate
        self.runModel(inputBuffer: Array(channelData[0..<sampleRate]))
        self.runModel(inputBuffer: Array(channelData[sampleRate..<bufferSize]))
    }
    
}


// MARK: Sound recognition delegate
extension ViewController: SoundRecognitionDelegate {
    
    func soundRecognition(
        _ soundRecognition: SoundRecognition,
        didInterpreterProbabilities probabilities: [Float32]
    ) {
        self.probabilities = probabilities
        
        DispatchQueue.main.async {
            if self.probabilities[2] > 0.9 {
                if self.isClap.value == false {
                    self.isClap.accept(true)
                }
            } else {
                if self.isClap.value == true {
                    self.isClap.accept(false)
                }
            }
            
            UIView.animate(withDuration: 0.2) {
                self.progress.setProgress(self.probabilities[2], animated: true)
            }
        }
    }
    
}
