import Foundation
import Combine
import AVFoundation
import Speech

enum VoiceError: Error, LocalizedError, Sendable {
    case microphonePermissionDenied
    case speechRecognitionDenied
    case notAuthorized
    case audioSessionFailed
    case recognitionFailed
    case ttsFailed
    
    var errorDescription: String? {
        switch self {
        case .microphonePermissionDenied:
            return "Няма разрешение за микрофона. Проверете Settings."
        case .speechRecognitionDenied:
            return "Разпознаването на реч не е разрешено."
        case .notAuthorized:
            return "Необходими са разрешения за микрофон и разпознаване на реч."
        case .audioSessionFailed:
            return "Грешка при аудио сесията."
        case .recognitionFailed:
            return "Грешка при разпознаване на речта."
        case .ttsFailed:
            return "Грешка при гласовия синтез."
        }
    }
}

@MainActor
final class VoiceManager: ObservableObject {
    @Published var isListening = false
    @Published var transcript = ""
    @Published var error: VoiceError?
    @Published var isSpeaking = false
    
    var onTranscriptFinalized: ((String) -> Void)?
    
    private let speechRecognizer: SpeechRecognizer
    private let ttsEngine: TTSEngine
    private let remoteCommandHandler: RemoteCommandHandler
    private let audioSessionManager = AudioSessionManager.shared
    
    init(container: AppContainer) {
        speechRecognizer = SpeechRecognizer()
        ttsEngine = TTSEngine()
        remoteCommandHandler = RemoteCommandHandler()
        
        setupCallbacks()
    }
    
    private func setupCallbacks() {
        speechRecognizer.onResult = { [weak self] text, isFinal in
            Task { @MainActor in
                self?.transcript = text
                if isFinal {
                    self?.isListening = false
                    self?.transcript = ""
                    self?.onTranscriptFinalized?(text)
                }
            }
        }
        
        speechRecognizer.onError = { [weak self] _ in
            Task { @MainActor in
                self?.error = .recognitionFailed
                self?.isListening = false
            }
        }
        
        remoteCommandHandler.onPlayPause = { [weak self] in
            Task { @MainActor in
                self?.toggleListening()
            }
        }
    }
    
    func requestPermissions() async -> Bool {
        let micGranted = await audioSessionManager.requestMicrophonePermission()
        let speechGranted = await speechRecognizer.requestAuthorization()
        return micGranted && speechGranted
    }
    
    func startListening() async throws {
        guard !isListening else { return }
        
        let hasPermissions = await requestPermissions()
        guard hasPermissions else {
            throw VoiceError.notAuthorized
        }
        
        try audioSessionManager.configureForBluetoothHFP()
        transcript = ""
        isListening = true
        
        do {
            try await speechRecognizer.startListening()
        } catch {
            isListening = false
            throw VoiceError.recognitionFailed
        }
    }
    
    func stopListening() async {
        await speechRecognizer.stopListening()
        isListening = false
    }
    
    func toggleListening() {
        Task {
            if isListening {
                await stopListening()
            } else {
                try? await startListening()
            }
        }
    }
    
    func speak(_ text: String) async {
        guard !text.isEmpty else { return }
        isSpeaking = true
        await ttsEngine.speak(text)
        isSpeaking = false
    }
    
    func stopSpeaking() {
        ttsEngine.stop()
        isSpeaking = false
    }
    
    deinit {
        remoteCommandHandler.disable()
        audioSessionManager.deactivate()
    }
}
