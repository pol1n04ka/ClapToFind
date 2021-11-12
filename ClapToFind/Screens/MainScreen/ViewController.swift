//
//  ViewController.swift
//  ClapToFind
//
//  Created by Polina Prokopenko on 11/11/21.
//

import UIKit

class ViewController: UIViewController {
    
    // MARK: Variables for audio recognition
    private var audioInputManager: AudioInputManager!
    private var soundRecognizer: SoundRecognition!
    private var bufferSize: Int = 0
    private var probabilities: [Float32] = []
    
    private var isClap = false

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        
        soundRecognizer = SoundRecognition(modelFileName: "sound_classification", delegate: self)
        
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
    
    func setupView() {
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
    
    private func startAudioRecognition() {
        audioInputManager = AudioInputManager(sampleRate: soundRecognizer.sampleRate)
        audioInputManager.delegate = self
        
        bufferSize = audioInputManager.bufferSize
        
        audioInputManager.checkPermissionAndStartTappingMicrophone()
    }
    
    private func runModel(inputBuffer: [Int16]) {
        soundRecognizer.start(inputBuffer: inputBuffer)
    }
    
}

// MARK: Audio manager delegate
extension ViewController: AudioInputManagerDelegate {
    
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
        
        print("Пиздец")
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

extension ViewController: SoundRecognitionDelegate {
    
    func soundRecognition(
        _ soundRecognition: SoundRecognition,
        didInterpreterProbabilities probabilities: [Float32]
    ) {
        self.probabilities = probabilities
        
        DispatchQueue.main.async {
//            self.label.text = self.soundRecognizer.labelNames[2]
            
            self.label.text = String(self.probabilities[2])
            
            if self.probabilities[2] > 0.9 {
                print(self.probabilities[2])
            }
            
            UIView.animate(withDuration: 0.4) {
                self.progress.setProgress(self.probabilities[2], animated: true)
            }
        }
    }
    
}

