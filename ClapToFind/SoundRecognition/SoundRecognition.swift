//
//  SoundRecognition.swift
//  ClapToFind
//
//  Created by Polina Prokopenko on 11/11/21.
//

import Foundation
import TensorFlowLite


public protocol SoundRecognitionDelegate: AnyObject {
    func soundRecognition(
        _ soundRecognition: SoundRecognition,
        didInterpreterProbabilities probabilities: [Float32]
    )
}


/// Class for recognize clap sound from audio stream
public class SoundRecognition {
    
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
    
    public init(
        modelFileName: String,
        modelFileExtension: String = "tflite",
        labelFileName: String = "labels",
        labelFileExtension: String = "txt",
        delegate: SoundRecognitionDelegate? = nil
    ) {
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
        let outputTensor: Tensor
        do {
            let audioBufferData = int16ArrayToData(inputBuffer)
            try interpreter.copy(audioBufferData, toInputAt: audioBufferInputTensorIndex)
            try interpreter.invoke()
            
            outputTensor = try interpreter.output(at: 0)
        } catch let error {
            print("[FAIL] Failed to invoke interpreter.\nError: \(error.localizedDescription)")
            return
        }
        
        let probabilities = dataToFloatArray(outputTensor.data) ?? []
        delegate?.soundRecognition(self, didInterpreterProbabilities: probabilities)
    }
    
    // MARK: Private methods
    private func setupInterpreter() {
        guard let modelPath = Bundle.main.path(
            forResource: modelFileName,
            ofType: modelFileExtension
        ) else { return }
        
        do {
            interpreter = try Interpreter(modelPath: modelPath)
            
            try interpreter.allocateTensors()
            let inputShape = try interpreter.input(at: 0).shape
            sampleRate = inputShape.dimensions[1]
            
            try interpreter.invoke()
            
            labelNames = loadLabels()
        } catch {
            print("[FAIL] Failed to create the interpreter.\nError: \(error.localizedDescription)")
            return
        }
    }
    
    private func loadLabels() -> [String] {
        guard let labelPath = Bundle.main.path(
            forResource: labelFileName,
            ofType: labelFileExtension
        ) else { return [] }
        
        var content = ""
        do {
            content = try String(contentsOfFile: labelPath, encoding: .utf8)
            let labels = content.components(separatedBy: "\n")
                .filter { !$0.isEmpty }
                .compactMap { line -> String in
                    let splitPair = line.components(separatedBy: " ")
                    let label = splitPair[1]
                    let titleCasedLabel = label.components(separatedBy: "_")
                        .compactMap { $0.capitalized }
                        .joined(separator: " ")
                    return titleCasedLabel
                }
            return labels
        } catch {
            print("[FAIL] Failed to load label content: '\(content)'.\nError: \(error.localizedDescription)")
            return []
        }
    }
    
    /// Creates a new buffer by copying the buffer pointer of the given `Int16` array.
    private func int16ArrayToData(_ buffer: [Int16]) -> Data {
        let floatData = buffer.map { Float($0) / Float(Int16.max) }
        return floatData.withUnsafeBufferPointer(Data.init)
    }
    
    /// Creates a new array from the bytes of the given unsafe data.
    /// - Returns: `nil` if `unsafeData.count` is not a multiple of `MemoryLayout<Float>.stride`.
    private func dataToFloatArray(_ data: Data) -> [Float]? {
        guard data.count % MemoryLayout<Float>.stride == 0 else { return nil }
        
        #if swift(>=5.0)
        return data.withUnsafeBytes { .init($0.bindMemory(to: Float.self)) }
        #else
        return data.withUnsafeBytes {
                    .init(UnsafeBufferPointer<Float>(
                        start: $0,
                        count: unsafeData.count / MemoryLayout<Element>.stride
                    ))
        }
        #endif // swift(>=5.0)
    }
    
}
