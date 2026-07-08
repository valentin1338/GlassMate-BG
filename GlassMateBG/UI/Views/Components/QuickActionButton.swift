import SwiftUI

struct QuickActionButton: View {
    let icon: String
    let label: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 6) {
                Image(systemName: icon)
                    .font(.system(size: 22, weight: .medium))
                Text(label)
                    .font(Theme.captionFont)
            }
            .foregroundStyle(Theme.cream)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 12)
            .background(Theme.surface)
            .overlay(
                RoundedRectangle(cornerRadius: Theme.smallCornerRadius)
                    .stroke(Theme.gold.opacity(0.12), lineWidth: 1)
            )
            .cornerRadius(Theme.smallCornerRadius)
        }
        .buttonStyle(.plain)
    }
}
