import Foundation
import AVFoundation

enum TTSError: Error, LocalizedError, Sendable {
    case noVoiceAvailable
    case synthesisFailed
    
    var errorDescription: String? {
        switch self {
        case .noVoiceAvailable: return "Няма наличен български глас за синтез."
        case .synthesisFailed: return "Грешка при синтез на реч."
        }
    }
}

actor TTSEngine {
    private let synthesizer = AVSpeechSynthesizer()
    
    var onStart: (() -> Void)?
    var onFinish: (() -> Void)?
    
    func speak(_ text: String, language: String = "bg-BG", rate: Float = 0.5) async {
        guard !text.isEmpty else { return }
        
        let utterance = AVSpeechUtterance(string: text)
        utterance.voice = bestVoice(for: language)
        utterance.rate = rate
        utterance.pitchMultiplier = 1.0
        utterance.volume = 1.0
        
        await withCheckedContinuation { continuation in
            let delegate = TTSDelegate {
                continuation.resume()
            }
            synthesizer.delegate = delegate
            synthesizer.speak(utterance)
        }
    }
    
    func stop() {
        synthesizer.stopSpeaking(at: .immediate)
    }
    
    func isSpeaking() -> Bool {
        synthesizer.isSpeaking
    }
    
    func getAvailableVoices(for language: String = "bg-BG") -> [AVSpeechSynthesisVoice] {
        AVSpeechSynthesisVoice.speechVoices().filter { $0.language.hasPrefix(language) }
    }
    
    private func bestVoice(for language: String) -> AVSpeechSynthesisVoice? {
        let voices = getAvailableVoices(for: language)
        return voices.first(where: { $0.quality == .enhanced })
            ?? voices.first(where: { $0.quality == .default })
            ?? AVSpeechSynthesisVoice(language: language)
    }
}

private class TTSDelegate: NSObject, AVSpeechSynthesizerDelegate {
    let completion: () -> Void
    
    init(_ completion: @escaping () -> Void) {
        self.completion = completion
    }
    
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didFinish utterance: AVSpeechUtterance) {
        completion()
    }
    
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didCancel utterance: AVSpeechUtterance) {
        completion()
    }
}
