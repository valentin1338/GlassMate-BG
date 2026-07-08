import Foundation
import Speech
import AVFoundation

enum SpeechError: Error, LocalizedError, Sendable {
    case notAuthorized
    case unavailable
    case recognitionFailed(String)
    case audioEngineFailed
    
    var errorDescription: String? {
        switch self {
        case .notAuthorized: return "Няма разрешение за разпознаване на реч."
        case .unavailable: return "Разпознаването на реч не е налично."
        case .recognitionFailed(let msg): return "Грешка при разпознаване: \(msg)"
        case .audioEngineFailed: return "Грешка в аудио двигателя."
        }
    }
}

actor SpeechRecognizer {
    private var recognitionTask: SFSpeechRecognitionTask?
    private let audioEngine = AVAudioEngine()
    private let speechRecognizer: SFSpeechRecognizer?
    
    var onResult: ((String, Bool) -> Void)?
    var onError: ((Error) -> Void)?
    
    init(locale: Locale = Locale(identifier: "bg-BG")) {
        speechRecognizer = SFSpeechRecognizer(locale: locale)
        speechRecognizer?.delegate = self
    }
    
    func requestAuthorization() async -> Bool {
        await withCheckedContinuation { continuation in
            SFSpeechRecognizer.requestAuthorization { status in
                continuation.resume(returning: status == .authorized)
            }
        }
    }
    
    func startListening() async throws {
        guard let recognizer = speechRecognizer, recognizer.isAvailable else {
            throw SpeechError.unavailable
        }
        
        try configureAudioSession()
        
        let request = SFSpeechAudioBufferRecognitionRequest()
        request.requiresOnDeviceRecognition = false
        request.shouldReportPartialResults = true
        
        let inputNode = audioEngine.inputNode
        let recordingFormat = inputNode.outputFormat(forBus: 0)
        
        inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { buffer, _ in
            request.append(buffer)
        }
        
        audioEngine.prepare()
        try audioEngine.start()
        
        recognitionTask = recognizer.recognitionTask(with: request) { [weak self] result, error in
            guard let result = result else {
                if let error = error {
                    Task { await self?.onError?(error) }
                }
                return
            }
            let transcript = result.bestTranscription.formattedString
            let isFinal = result.isFinal
            Task { await self?.onResult?(transcript, isFinal) }
            
            if isFinal {
                Task { await self?.stopListening() }
            }
        }
    }
    
    func stopListening() {
        audioEngine.stop()
        audioEngine.inputNode.removeTap(onBus: 0)
        recognitionTask?.cancel()
        recognitionTask = nil
    }
    
    private func configureAudioSession() throws {
        let session = AVAudioSession.sharedInstance()
        try session.setCategory(.playAndRecord, mode: .default, options: [.allowBluetoothHFP, .defaultToSpeaker])
        try session.setActive(true)
    }
    
    func isAvailable() -> Bool {
        speechRecognizer?.isAvailable ?? false
    }
}

extension SpeechRecognizer: @preconcurrency SFSpeechRecognizerDelegate {
    nonisolated func speechRecognizer(_ speechRecognizer: SFSpeechRecognizer, availabilityDidChange available: Bool) {
        // Handle availability changes
    }
}
