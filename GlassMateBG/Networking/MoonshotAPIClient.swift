import Foundation

actor MoonshotAPIClient {
    private let baseURL = "https://api.moonshot.ai/v1/chat/completions"
    private let settings: SecureSettings
    private let session: URLSession
    
    init(settings: SecureSettings) {
        self.settings = settings
        let config = URLSessionConfiguration.default
        config.timeoutIntervalForRequest = 60
        config.timeoutIntervalForResource = 120
        self.session = URLSession(configuration: config)
    }
    
    func chat(messages: [ChatMessage], tools: [ToolDefinition]? = nil) async throws -> ChatResponse {
        guard let apiKey = await settings.moonshotAPIKey, !apiKey.isEmpty else {
            throw MoonshotAPIError.missingAPIKey
        }
        
        guard let url = URL(string: baseURL) else {
            throw MoonshotAPIError.invalidURL
        }
        
        let chatModel = await settings.chatModel
        var requestMessages = [MoonshotMessage]()
        requestMessages.append(MoonshotMessage(
            role: "system",
            content: "Ти си GlassMate — гласов AI асистент за Ray-Ban Meta очила. Отговаряй на български език. Бъди кратък, ясен и полезен. Ако потребителят поиска действие, което можеш да изпълниш чрез tool, използвай съответния tool."
        ))
        
        for msg in messages {
            requestMessages.append(MoonshotMessage(
                role: msg.role.rawValue,
                content: msg.content
            ))
        }
        
        let body = MoonshotChatRequest(
            model: chatModel,
            messages: requestMessages,
            tools: tools
        )
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        
        let encoder = JSONEncoder()
        encoder.keyEncodingStrategy = .convertToSnakeCase
        request.httpBody = try encoder.encode(body)
        
        let (data, response) = try await session.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw MoonshotAPIError.networkError(URLError(.badServerResponse))
        }
        
        guard (200...299).contains(httpResponse.statusCode) else {
            let message = String(data: data, encoding: .utf8) ?? "Unknown error"
            throw MoonshotAPIError.httpError(httpResponse.statusCode, message)
        }
        
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        let chatResponse = try decoder.decode(MoonshotChatResponse.self, from: data)
        
        guard let choice = chatResponse.choices.first else {
            throw MoonshotAPIError.noChoices
        }
        
        let toolCalls = choice.message.toolCalls?.map { tc in
            ToolCall(
                id: tc.id,
                name: tc.function.name,
                arguments: (try? JSONSerialization.jsonObject(
                    with: tc.function.arguments.data(using: .utf8) ?? Data()
                ) as? [String: String]) ?? [:]
            )
        }
        
        let message = ChatMessage(
            role: .assistant,
            content: choice.message.content ?? "",
            toolCall: toolCalls?.first
        )
        
        return ChatResponse(message: message, toolCalls: toolCalls)
    }
    
    func visionChat(imageBase64: String, prompt: String = "Опиши какво виждаш на тази снимка на български език.") async throws -> String {
        guard let apiKey = await settings.moonshotAPIKey, !apiKey.isEmpty else {
            throw MoonshotAPIError.missingAPIKey
        }
        
        guard let url = URL(string: baseURL) else {
            throw MoonshotAPIError.invalidURL
        }
        
        let visionModel = await settings.visionModel
        let content: [VisionContentPart] = [
            .text(prompt),
            .imageUrl(VisionContentPart.ImageUrl(url: "data:image/jpeg;base64,\(imageBase64)"))
        ]
        
        let body = MoonshotVisionChatRequest(
            model: visionModel,
            messages: [VisionMessage(role: "user", content: content)]
        )
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        
        let encoder = JSONEncoder()
        request.httpBody = try encoder.encode(body)
        
        let (data, response) = try await session.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse,
              (200...299).contains(httpResponse.statusCode) else {
            let statusCode = (response as? HTTPURLResponse)?.statusCode ?? 0
            let message = String(data: data, encoding: .utf8) ?? "Unknown"
            throw MoonshotAPIError.httpError(statusCode, message)
        }
        
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        let chatResponse = try decoder.decode(MoonshotChatResponse.self, from: data)
        
        guard let choice = chatResponse.choices.first else {
            throw MoonshotAPIError.noChoices
        }
        
        return choice.message.content ?? "Не мога да анализирам изображението."
    }
}
