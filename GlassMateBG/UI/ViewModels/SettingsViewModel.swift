import Foundation

@MainActor
final class SettingsViewModel: ObservableObject {
    @Published var apiKey = ""
    @Published var chatModel = "kimi-k2-0905-preview"
    @Published var visionModel = "moonshot-v1-8k-vision-preview"
    @Published var telegramToken = ""
    @Published var telegramChatID = ""
    @Published var webhooks: [WebhookConfig] = []
    @Published var ttsRate: Float = 0.5
    
    private let settings = SecureSettings.shared
    
    init() {
        apiKey = settings.moonshotAPIKey ?? ""
        telegramToken = settings.telegramBotToken ?? ""
        telegramChatID = settings.telegramChatID ?? ""
        ttsRate = settings.ttsRate
        webhooks = settings.webhooks
    }
    
    func saveSettings() {
        settings.moonshotAPIKey = apiKey.isEmpty ? nil : apiKey
        settings.telegramBotToken = telegramToken.isEmpty ? nil : telegramToken
        settings.telegramChatID = telegramChatID.isEmpty ? nil : telegramChatID
        settings.ttsRate = ttsRate
        settings.webhooks = webhooks
        settings.saveSettings()
    }
    
    func addWebhook() {
        webhooks.append(WebhookConfig(id: UUID(), name: "", url: ""))
    }
    
    func deleteWebhook(at offsets: IndexSet) {
        webhooks.remove(atOffsets: offsets)
    }
    
    func clearHistory() {
        // Clear chat history from MemoryStore
    }
    
    func exportNotes() {
        // Export notes
    }
}
