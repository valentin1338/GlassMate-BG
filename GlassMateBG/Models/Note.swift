import Foundation

struct Note: Identifiable, Codable, Sendable {
    let id: UUID
    var text: String
    let createdAt: Date
    var tags: [String]
    
    init(
        id: UUID = UUID(),
        text: String,
        createdAt: Date = Date(),
        tags: [String] = []
    ) {
        self.id = id
        self.text = text
        self.createdAt = createdAt
        self.tags = tags
    }
}
