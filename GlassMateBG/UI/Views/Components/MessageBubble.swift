import SwiftUI

struct MessageBubble: View {
    let message: ChatMessage
    
    var body: some View {
        HStack {
            if message.role == .assistant {
                Spacer(minLength: 40)
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(message.content)
                    .font(Theme.bodyFont)
                    .foregroundStyle(message.role == .user ? Theme.background : Theme.cream)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 12)
                    .background(
                        message.role == .user ? Theme.gold : Theme.surfaceLight
                    )
                    .cornerRadius(18)
                
                if let toolCall = message.toolCall {
                    HStack(spacing: 4) {
                        Image(systemName: "bolt.fill")
                            .font(.caption2)
                        Text("\(toolCall.name)")
                            .font(Theme.smallFont)
                    }
                    .foregroundStyle(Theme.gold)
                    .padding(.horizontal, 16)
                }
            }
            
            if message.role == .user {
                Spacer(minLength: 40)
            }
        }
    }
}
