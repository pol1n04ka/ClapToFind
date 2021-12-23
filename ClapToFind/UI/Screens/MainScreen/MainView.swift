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


class MainView: UIViewController {
    
    // MARK: UI elements
    let gradient = Gradient()
    
    lazy var image          = ImageView(image: .clappingAndPhone)
    lazy var headingLabel   = Label(style: .heading, "Clap To Find")
    lazy var label          = Label(style: .body, "Put your device to sleep and quickly clap one-two times, the device will ring.")
    lazy var settingsButton = Button(style: .settings, nil)
    
    // MARK: Variables for audio recognition
    private var audioInputManager: AudioInputManager!
    private var soundRecognizer:   SoundRecognition!
    private var bufferSize:        Int = 0
    private var probabilities:     [Float32] = []
    
    // MARK: Variable for check audio
    private var isClap = BehaviorRelay<Bool>(value: false)
    
    // MARK: Variable for player instance
    private var audioPlayer: AVAudioPlayer!

    // MARK: ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        gradient.setGradientBackground(view: view)
        setupView()
        
        bindIsClap()
        
        soundRecognizer = SoundRecognition(
            modelFileName: "soundclassifier_with_metadata",
            delegate: self
        )
    }
    
    // MARK: ViewDidAppear
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        if audioInputManager == nil {
            startAudioRecognition()
            audioInputManager.setListenOrPlayMode(true)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        navigationController?.navigationBar.isHidden = true
        
        UIView.transition(with: self.navigationController!.navigationBar, duration: 0.1, options: .transitionCrossDissolve, animations: {}, completion: { _ in })
        
        updateViewConstraints()
    }
    
}


// MARK: Setup UI
extension MainView {
    
    /// Setting UI
    private func setupView() {
        settingsButton.layer.zPosition = 10
        settingsButton.addTarget(self, action: #selector(openSettings), for: .touchUpInside)
        
        view.addSubview(image)
        view.addSubview(headingLabel)
        view.addSubview(label)
        view.addSubview(settingsButton)
        
        let constraints = [
            image.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            image.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -40),
            
            headingLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            headingLabel.topAnchor.constraint(equalTo: image.bottomAnchor, constant: 10),
            
            label.topAnchor.constraint(equalTo: headingLabel.bottomAnchor, constant: 10),
            label.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            label.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            
            settingsButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            settingsButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20)
        ]
        
        NSLayoutConstraint.activate(constraints)
    }
    
}


// MARK: Settings button action
extension MainView {
    
    @objc func openSettings() {
        navigationController?.pushViewController(SettingsView(), animated: true)
    }
    
}


// MARK: Start sound recognition
extension MainView {
    
    /// Binds isClap observable to view
    private func bindIsClap() {
        _ = isClap.subscribe { event in
            guard let value = event.element else { return }
            
            if value == true {
                self.playSound()
            }
        }
    }
    
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
extension MainView: AVAudioPlayerDelegate {
    
    /// Play okey sound on recognize clap
    private func playSound() {
        let url = Bundle.main.path(forResource: "okey", ofType: "mp3")
        
        do {
            audioInputManager.setListenOrPlayMode(false)
            audioPlayer = try AVAudioPlayer(contentsOf: URL(string: url!)!)
            
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
        self.audioInputManager.audioEngine.stop()
        self.audioInputManager.setListenOrPlayMode(true)
        self.startAudioRecognition()
    }
    
}


// MARK: Audio manager delegate
extension MainView: AudioInputManagerDelegate {
    
    // If user don't get permission to use microphone
    func audioInputManagerDidFailToAchievePermission(_ audioManager: AudioInputManager) {
        let alertController = UIAlertController(
            title: "Microphone permissions denied",
            message: "Microphone permissions have been denied for this app. You can change this by going to Settings",
            preferredStyle: .alert
        )

        let cancelButton = UIAlertAction(
            title: "Cancel",
            style: .cancel,
            handler: nil
        )

        let settingsAction = UIAlertAction(
            title: "Settings",
            style: .default
        ) { _ in
            UIApplication.shared.open(
                URL(string: UIApplication.openSettingsURLString)!,
                options: [:],
                completionHandler: nil)
        }

        alertController.addAction(cancelButton)
        alertController.addAction(settingsAction)

        self.present(alertController, animated: true, completion: nil)
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
extension MainView: SoundRecognitionDelegate {
    
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
        }
    }
    
}
