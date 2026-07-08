import Foundation
import SwiftUI

@MainActor
final class AppContainer: ObservableObject {
    let settings = SecureSettings.shared
    let coordinator = AppCoordinator()
    
    lazy var moonshotAPI: MoonshotAPIClient = {
        MoonshotAPIClient(settings: settings)
    }()
    
    lazy var voiceManager: VoiceManager = {
        VoiceManager(container: self)
    }()
    
    lazy var photoKitManager: PhotoKitManager = {
        PhotoKitManager()
    }()
    
    lazy var ocrEngine: OCREngine = {
        OCREngine()
    }()
    
    lazy var visionAnalyzer: VisionAnalyzer = {
        VisionAnalyzer(apiClient: moonshotAPI)
    }()
    
    lazy var videoFrameExtractor: VideoFrameExtractor = {
        VideoFrameExtractor()
    }()
    
    lazy var toolRegistry: ToolRegistry = {
        ToolRegistry(settings: settings)
    }()
    
    lazy var memoryStore: MemoryStore = {
        MemoryStore()
    }()
    
    lazy var agentManager: AgentManager = {
        AgentManager(
            toolRegistry: toolRegistry,
            memoryStore: memoryStore,
            moonshotAPI: moonshotAPI,
            settings: settings
        )
    }()
    
    lazy var reminderManager: ReminderManager = {
        ReminderManager()
    }()
    
    lazy var noteManager: NoteManager = {
        NoteManager()
    }()
    
    nonisolated init() {}
}
