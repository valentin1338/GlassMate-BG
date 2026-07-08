import Foundation

@MainActor
final class HistoryViewModel: ObservableObject {
    @Published var messages: [ChatMessage] = []
    
    func formatDate(_ date: Date) -> String {
        let formatter = RelativeDateTimeFormatter()
        formatter.locale = Locale(identifier: "bg_BG")
        return formatter.localizedString(for: date, relativeTo: Date())
    }
    
    func groupedMessages() -> [(String, [ChatMessage])] {
        let calendar = Calendar.current
        let grouped = Dictionary(grouping: messages) { msg in
            if calendar.isDateInToday(msg.timestamp) { return "Днес" }
            if calendar.isDateInYesterday(msg.timestamp) { return "Вчера" }
            let formatter = DateFormatter()
            formatter.locale = Locale(identifier: "bg_BG")
            formatter.dateStyle = .medium
            return formatter.string(from: msg.timestamp)
        }
        return grouped.sorted { $0.key > $1.key }
    }
}
