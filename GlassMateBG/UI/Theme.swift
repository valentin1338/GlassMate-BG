import SwiftUI

enum Theme {
    static let background = Color(hex: "#070706")
    static let surface = Color(hex: "#1A1917")
    static let surfaceLight = Color(hex: "#2A2926")
    static let surfaceBorder = Color(hex: "#3A3936")
    static let gold = Color(hex: "#D4A853")
    static let goldLight = Color(hex: "#E8C87A")
    static let goldDim = Color(hex: "#8B7340")
    static let goldGlow = Color(hex: "#D4A853").opacity(0.3)
    static let cream = Color(hex: "#F0E8D8")
    static let creamMuted = Color(hex: "#A09888")
    static let creamDark = Color(hex: "#706860")
    static let error = Color(hex: "#E05A5A")
    static let success = Color(hex: "#5AE08A")
    static let warning = Color(hex: "#E0A85A")
    
    static let titleFont = Font.system(size: 28, weight: .bold, design: .rounded)
    static let headlineFont = Font.system(size: 20, weight: .semibold, design: .rounded)
    static let bodyFont = Font.system(size: 16, weight: .regular, design: .default)
    static let captionFont = Font.system(size: 13, weight: .medium, design: .default)
    static let smallFont = Font.system(size: 11, weight: .medium, design: .default)
    
    static let padding: CGFloat = 20
    static let smallPadding: CGFloat = 12
    static let cornerRadius: CGFloat = 16
    static let smallCornerRadius: CGFloat = 12
    static let buttonSize: CGFloat = 100
    static let iconSize: CGFloat = 24
}

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3:
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6:
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8:
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(.sRGB, red: Double(r) / 255, green: Double(g) / 255, blue: Double(b) / 255, opacity: Double(a) / 255)
    }
}

extension View {
    func glassCard() -> some View {
        self
            .padding(Theme.padding)
            .background(
                RoundedRectangle(cornerRadius: Theme.cornerRadius)
                    .fill(Theme.surface)
                    .overlay(
                        RoundedRectangle(cornerRadius: Theme.cornerRadius)
                            .stroke(Theme.gold.opacity(0.08), lineWidth: 1)
                    )
            )
    }
    
    func glassButton() -> some View {
        self
            .padding(.horizontal, Theme.padding)
            .padding(.vertical, 14)
            .background(
                RoundedRectangle(cornerRadius: Theme.smallCornerRadius)
                    .fill(Theme.surface)
                    .overlay(
                        RoundedRectangle(cornerRadius: Theme.smallCornerRadius)
                            .stroke(Theme.gold.opacity(0.15), lineWidth: 1)
                    )
            )
    }
}
