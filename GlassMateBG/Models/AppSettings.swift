import Foundation

struct AppSettings: Codable, Sendable {
    var moonshotAPIKey: String = ""
    var visionModel: String = "moonshot-v1-8k-vision-preview"
    var chatModel: String = "kimi-k2-0905-preview"
    var telegramBotToken: String? = nil
    var telegramChatID: String? = nil
    var webhooks: [WebhookConfig] = []
    var ttsVoice: String = "bg-BG"
    var ttsRate: Float = 0.5
    var isFirstLaunch: Bool = true
}

struct WebhookConfig: Identifiable, Codable, Sendable {
    let id: UUID
    var name: String
    var url: String
    
    init(id: UUID = UUID(), name: String, url: String) {
        self.id = id
        self.name = name
        self.url = url
    }
}
