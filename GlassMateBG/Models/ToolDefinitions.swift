import Foundation

struct ToolDefinition: Codable, Sendable {
    let type: String = "function"
    let function: FunctionDefinition
}

struct FunctionDefinition: Codable, Sendable {
    let name: String
    let description: String
    let parameters: FunctionParameters
}

struct FunctionParameters: Codable, Sendable {
    let type: String = "object"
    let properties: [String: ParameterProperty]
    let required: [String]
}

struct ParameterProperty: Codable, Sendable {
    let type: String
    let description: String
}

enum ToolDefinitions {
    static let all: [ToolDefinition] = [
        triggerMakeWebhook,
        sendTelegram,
        addNote,
        createReminder
    ]
    
    static let triggerMakeWebhook = ToolDefinition(
        function: FunctionDefinition(
            name: "trigger_make_webhook",
            description: "Изпраща HTTP заявка към дефиниран webhook в Make.com или подобна услуга.",
            parameters: FunctionParameters(
                properties: [
                    "name": ParameterProperty(type: "string", description: "Име на webhook-а"),
                    "payload": ParameterProperty(type: "string", description: "JSON payload")
                ],
                required: ["name", "payload"]
            )
        )
    )
    
    static let sendTelegram = ToolDefinition(
        function: FunctionDefinition(
            name: "send_telegram",
            description: "Изпраща съобщение в Telegram чат.",
            parameters: FunctionParameters(
                properties: [
                    "message": ParameterProperty(type: "string", description: "Текст на съобщението")
                ],
                required: ["message"]
            )
        )
    )
    
    static let addNote = ToolDefinition(
        function: FunctionDefinition(
            name: "add_note",
            description: "Добавя локална бележка.",
            parameters: FunctionParameters(
                properties: [
                    "text": ParameterProperty(type: "string", description: "Съдържание на бележката")
                ],
                required: ["text"]
            )
        )
    )
    
    static let createReminder = ToolDefinition(
        function: FunctionDefinition(
            name: "create_reminder",
            description: "Създава локално напомняне.",
            parameters: FunctionParameters(
                properties: [
                    "text": ParameterProperty(type: "string", description: "Текст на напомнянето"),
                    "minutes": ParameterProperty(type: "integer", description: "След колко минути")
                ],
                required: ["text", "minutes"]
            )
        )
    )
}
