import Foundation
import AVFoundation

actor AudioSessionManager {
    static let shared = AudioSessionManager()
    
    private var isConfigured = false
    
    func configureForBluetoothHFP() throws {
        let session = AVAudioSession.sharedInstance()
        try session.setCategory(
            .playAndRecord,
            mode: .default,
            options: [.allowBluetoothHFP, .allowBluetooth, .defaultToSpeaker]
        )
        try session.setActive(true)
        isConfigured = true
    }
    
    func configureForPlayback() throws {
        let session = AVAudioSession.sharedInstance()
        try session.setCategory(.playback, mode: .default, options: [.allowBluetoothHFP, .allowBluetooth])
        try session.setActive(true)
    }
    
    func requestMicrophonePermission() async -> Bool {
        await withCheckedContinuation { continuation in
            AVAudioSession.sharedInstance().requestRecordPermission { granted in
                continuation.resume(returning: granted)
            }
        }
    }
    
    func deactivate() {
        isConfigured = false
        try? AVAudioSession.sharedInstance().setActive(false)
    }
    
    var isActive: Bool { isConfigured }
}
