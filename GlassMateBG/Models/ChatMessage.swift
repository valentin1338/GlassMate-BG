import Foundation

enum MessageRole: String, Codable, Sendable {
    case user, assistant, system
}

enum AttachmentType: String, Codable, Sendable {
    case image, videoFrame
}

struct Attachment: Codable, Sendable {
    let type: AttachmentType
    let base64Data: String
    let description: String?
}

struct ChatMessage: Identifiable, Codable, Sendable {
    let id: UUID
    let role: MessageRole
    let content: String
    let timestamp: Date
    let attachments: [Attachment]?
    let toolCall: ToolCall?
    
    init(
        id: UUID = UUID(),
        role: MessageRole,
        content: String,
        timestamp: Date = Date(),
        attachments: [Attachment]? = nil,
        toolCall: ToolCall? = nil
    ) {
        self.id = id
        self.role = role
        self.content = content
        self.timestamp = timestamp
        self.attachments = attachments
        self.toolCall = toolCall
    }
}

struct ToolCall: Codable, Sendable {
    let id: String
    let name: String
    let arguments: [String: String]
    
    init(id: String, name: String, arguments: [String: String]) {
        self.id = id
        self.name = name
        self.arguments = arguments
    }
}
