//
//  SoundRecognition.swift
//  ClapToFind
//
//  Created by Polina Prokopenko on 11/11/21.
//

import Foundation
import TensorFlowLite


public protocol SoundRecognitionDelegate: AnyObject {
    func soundRecognition(_ soundRecognition: SoundRecognition, didInterpreterProbabilities probabilities: [Float32])
}


/// Performs classification on sound.
/// The API supports models which accept sound input via `Int16` sound buffer and one classification output tensor.
/// The output of the recognition is emitted as delegation.
public class SoundRecognition {
    
    // Code for sound recognition
    
    // MARK: Constants
    private let modelFileName: String
    private let modelFileExtension: String
    private let labelFileName: String
    private let labelFileExtension: String
    private let audioBufferInputTensorIndex: Int = 0
    
    // MARK: Variables
    public weak var delegate: SoundRecognitionDelegate?
    
    /// Sample rate for input sound buffer. Caution: generally this value is a bit less than 1 second's audio sample.
    private(set) var sampleRate = 0
    /// Lable names described in the lable file
    private(set) var labelNames: [String] = []
    private var interpreter: Interpreter!
    
    public init(modelFileName: String,
                modelFileExtension: String = "tflite",
                labelFileName: String = "labels",
                labelFileExtension: String = "txt",
                delegate: SoundRecognitionDelegate? = nil) {
        self.modelFileName = modelFileName
        self.modelFileExtension = modelFileExtension
        self.labelFileName = labelFileName
        self.labelFileExtension = labelFileExtension
        self.delegate = delegate
        
        // setup interpreter here
        setupInterpreter()
    }
    
    /// Invokes the `Interpreter` and processes and returns the inference results.
    public func start(inputBuffer: [Int16]) {
        
    }
    
    // MARK: Private methods
    private func setupInterpreter() {
        
    }
    
    private func loadLabels() -> [String] {
        
    }
    
    /// Creates a new buffer by copying the buffer pointer of the given `Int16` array.
    private func int16ArrayToData(_ buffer: [Int16]) -> Data {
        
    }
    
    /// Creates a new array from the bytes of the given unsafe data.
    /// - Returns: `nil` if `unsafeData.count` is not a multiple of `MemoryLayout<Float>.stride`.
    private func dataToFloatArray() -> [Float]? {
        
    }
    
}
