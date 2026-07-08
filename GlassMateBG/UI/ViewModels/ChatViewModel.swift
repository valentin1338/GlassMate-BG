import Foundation

@MainActor
final class ChatViewModel: ObservableObject {
    @Published var messages: [ChatMessage] = []
    @Published var inputText = ""
    @Published var isLoading = false
    
    func sendMessage() {
        guard !inputText.isEmpty else { return }
        let userMessage = ChatMessage(
            id: UUID(),
            role: .user,
            content: inputText,
            timestamp: Date(),
            attachments: nil,
            toolCall: nil
        )
        messages.append(userMessage)
        inputText = ""
        isLoading = true
        
        // TODO: Integrate with Moonshot API
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
            guard let self = self else { return }
            let assistantMessage = ChatMessage(
                id: UUID(),
                role: .assistant,
                content: "Това е примерен отговор от GlassMate. Свържете Moonshot API ключ в настройките за реални отговори.",
                timestamp: Date(),
                attachments: nil,
                toolCall: nil
            )
            self.messages.append(assistantMessage)
            self.isLoading = false
        }
    }
}
