import Foundation
import Combine

@MainActor
final class SecureSettings: ObservableObject {
    static let shared = SecureSettings()
    
    @Published var moonshotAPIKey: String? {
        didSet { try? KeychainManager.shared.saveString(key: Keys.moonshotAPIKey, value: moonshotAPIKey ?? "") }
    }
    @Published var telegramBotToken: String? {
        didSet { try? KeychainManager.shared.saveString(key: Keys.telegramBotToken, value: telegramBotToken ?? "") }
    }
    @Published var telegramChatID: String? {
        didSet { try? KeychainManager.shared.saveString(key: Keys.telegramChatID, value: telegramChatID ?? "") }
    }
    
    @Published var visionModel: String = "moonshot-v1-8k-vision-preview"
    @Published var chatModel: String = "kimi-k2-0905-preview"
    @Published var ttsVoice: String = "bg-BG"
    @Published var ttsRate: Float = 0.5
    @Published var webhooks: [WebhookConfig] = []
    @Published var isFirstLaunch: Bool = true
    
    private let defaults = UserDefaults.standard
    
    private enum Keys {
        static let moonshotAPIKey = "moonshot_api_key"
        static let telegramBotToken = "telegram_bot_token"
        static let telegramChatID = "telegram_chat_id"
        static let visionModel = "vision_model"
        static let chatModel = "chat_model"
        static let ttsVoice = "tts_voice"
        static let ttsRate = "tts_rate"
        static let webhooks = "webhooks"
        static let isFirstLaunch = "is_first_launch"
    }
    
    init() {
        loadSettings()
    }
    
    private func loadSettings() {
        moonshotAPIKey = KeychainManager.shared.loadString(key: Keys.moonshotAPIKey)
        telegramBotToken = KeychainManager.shared.loadString(key: Keys.telegramBotToken)
        telegramChatID = KeychainManager.shared.loadString(key: Keys.telegramChatID)
        
        visionModel = defaults.string(forKey: Keys.visionModel) ?? "moonshot-v1-8k-vision-preview"
        chatModel = defaults.string(forKey: Keys.chatModel) ?? "kimi-k2-0905-preview"
        ttsVoice = defaults.string(forKey: Keys.ttsVoice) ?? "bg-BG"
        ttsRate = defaults.float(forKey: Keys.ttsRate)
        if ttsRate == 0 { ttsRate = 0.5 }
        
        if let data = defaults.data(forKey: Keys.webhooks),
           let decoded = try? JSONDecoder().decode([WebhookConfig].self, from: data) {
            webhooks = decoded
        }
        
        isFirstLaunch = defaults.object(forKey: Keys.isFirstLaunch) as? Bool ?? true
    }
    
    func saveSettings() {
        defaults.set(visionModel, forKey: Keys.visionModel)
        defaults.set(chatModel, forKey: Keys.chatModel)
        defaults.set(ttsVoice, forKey: Keys.ttsVoice)
        defaults.set(ttsRate, forKey: Keys.ttsRate)
        defaults.set(false, forKey: Keys.isFirstLaunch)
        
        if let data = try? JSONEncoder().encode(webhooks) {
            defaults.set(data, forKey: Keys.webhooks)
        }
    }
    
    func resetToDefaults() {
        moonshotAPIKey = nil
        telegramBotToken = nil
        telegramChatID = nil
        visionModel = "moonshot-v1-8k-vision-preview"
        chatModel = "kimi-k2-0905-preview"
        ttsVoice = "bg-BG"
        ttsRate = 0.5
        webhooks = []
        isFirstLaunch = true
        
        try? KeychainManager.shared.deleteAll()
        let keys = [Keys.visionModel, Keys.chatModel, Keys.ttsVoice, Keys.ttsRate, Keys.webhooks, Keys.isFirstLaunch]
        for key in keys {
            defaults.removeObject(forKey: key)
        }
    }
}
