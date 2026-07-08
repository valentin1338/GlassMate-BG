import Foundation

struct MoonshotChatRequest: Codable, Sendable {
    let model: String
    let messages: [MoonshotMessage]
    let tools: [ToolDefinition]?
}

struct MoonshotMessage: Codable, Sendable {
    let role: String
    let content: String
}

struct MoonshotVisionChatRequest: Codable, Sendable {
    let model: String
    let messages: [VisionMessage]
}

struct VisionMessage: Codable, Sendable {
    let role: String
    let content: [VisionContentPart]
}

enum VisionContentPart: Codable, Sendable {
    case text(String)
    case imageUrl(ImageUrl)
    
    struct ImageUrl: Codable, Sendable {
        let url: String
    }
    
    enum CodingKeys: String, CodingKey {
        case type, text, imageUrl
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        switch self {
        case .text(let value):
            try container.encode("text", forKey: .type)
            try container.encode(value, forKey: .text)
        case .imageUrl(let value):
            try container.encode("image_url", forKey: .type)
            try container.encode(value, forKey: .imageUrl)
        }
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let type = try container.decode(String.self, forKey: .type)
        switch type {
        case "text":
            let value = try container.decode(String.self, forKey: .text)
            self = .text(value)
        case "image_url":
            let value = try container.decode(ImageUrl.self, forKey: .imageUrl)
            self = .imageUrl(value)
        default:
            throw DecodingError.dataCorruptedError(forKey: .type, in: container, debugDescription: "Unknown content type")
        }
    }
}

struct MoonshotChatResponse: Decodable, Sendable {
    let choices: [Choice]
    let usage: Usage?
    
    struct Choice: Decodable, Sendable {
        let message: ResponseMessage
        let finishReason: String?
    }
    
    struct ResponseMessage: Decodable, Sendable {
        let role: String
        let content: String?
        let toolCalls: [ToolCallResponse]?
    }
    
    struct ToolCallResponse: Decodable, Sendable {
        let id: String
        let type: String
        let function: FunctionCall
    }
    
    struct FunctionCall: Decodable, Sendable {
        let name: String
        let arguments: String
    }
    
    struct Usage: Decodable, Sendable {
        let promptTokens: Int
        let completionTokens: Int
        let totalTokens: Int
    }
}

struct ChatResponse: Sendable {
    let message: ChatMessage
    let toolCalls: [ToolCall]?
}

enum MoonshotAPIError: Error, LocalizedError, Sendable {
    case missingAPIKey
    case invalidURL
    case networkError(Error)
    case httpError(Int, String)
    case decodingError(Error)
    case noChoices
    case invalidImageData
    
    var errorDescription: String? {
        switch self {
        case .missingAPIKey:
            return "Moonshot API ключът не е настроен. Отворете Настройки и въведете вашия API ключ."
        case .invalidURL:
            return "Невалиден API URL."
        case .networkError:
            return "Проблем с мрежовата връзка. Проверете интернет връзката си."
        case .httpError(let code, let message):
            return "API грешка (\(code)): \(message)"
        case .decodingError:
            return "Грешка при обработка на отговора от сървъра."
        case .noChoices:
            return "Няма отговор от AI модела."
        case .invalidImageData:
            return "Невалидни изображение данни."
        }
    }
}
