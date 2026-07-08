import SwiftUI

struct SettingsView: View {
    @StateObject private var viewModel = SettingsViewModel()
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            ZStack {
                Theme.background.ignoresSafeArea()
                
                List {
                    // Moonshot API Section
                    Section {
                        SecureField("Moonshot API Key", text: $viewModel.apiKey)
                            .textContentType(.password)
                        Picker("Chat модел", selection: $viewModel.chatModel) {
                            Text("kimi-k2-0905-preview").tag("kimi-k2-0905-preview")
                        }
                        Picker("Vision модел", selection: $viewModel.visionModel) {
                            Text("moonshot-v1-8k-vision-preview").tag("moonshot-v1-8k-vision-preview")
                        }
                    } header: {
                        Text("Moonshot AI")
                            .foregroundStyle(Theme.gold)
                    }
                    .listRowBackground(Theme.surface)
                    
                    // Telegram Section
                    Section {
                        SecureField("Telegram Bot Token", text: $viewModel.telegramToken)
                        TextField("Telegram Chat ID", text: $viewModel.telegramChatID)
                            .keyboardType(.numberPad)
                    } header: {
                        Text("Telegram")
                            .foregroundStyle(Theme.gold)
                    }
                    .listRowBackground(Theme.surface)
                    
                    // Webhooks Section
                    Section {
                        ForEach($viewModel.webhooks) { $webhook in
                            VStack(alignment: .leading) {
                                TextField("Име", text: $webhook.name)
                                TextField("URL", text: $webhook.url)
                                    .keyboardType(.URL)
                            }
                        }
                        .onDelete(perform: viewModel.deleteWebhook)
                        
                        Button("Добави webhook") {
                            viewModel.addWebhook()
                        }
                        .foregroundStyle(Theme.gold)
                    } header: {
                        Text("Make Webhooks")
                            .foregroundStyle(Theme.gold)
                    }
                    .listRowBackground(Theme.surface)
                    
                    // TTS Section
                    Section {
                        Slider(value: $viewModel.ttsRate, in: 0.2...0.8, step: 0.05) {
                            Text("Скорост на говора")
                        }
                        Text("Скорост: \(Int(viewModel.ttsRate * 100))%")
                            .font(Theme.captionFont)
                            .foregroundStyle(Theme.creamMuted)
                    } header: {
                        Text("Гласов асистент")
                            .foregroundStyle(Theme.gold)
                    }
                    .listRowBackground(Theme.surface)
                    
                    // Actions
                    Section {
                        Button("Изчисти историята", role: .destructive) {
                            viewModel.clearHistory()
                        }
                        .foregroundStyle(Theme.error)
                        
                        Button("Експортирай бележки") {
                            viewModel.exportNotes()
                        }
                        .foregroundStyle(Theme.gold)
                    }
                    .listRowBackground(Theme.surface)
                }
                .scrollContentBackground(.hidden)
                .background(Theme.background)
            }
            .navigationTitle("Настройки")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Готово") {
                        viewModel.saveSettings()
                        dismiss()
                    }
                    .foregroundStyle(Theme.gold)
                }
            }
        }
        .preferredColorScheme(.dark)
    }
}
