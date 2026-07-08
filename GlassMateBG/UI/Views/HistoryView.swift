import SwiftUI

struct HistoryView: View {
    @StateObject private var viewModel = HistoryViewModel()
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            ZStack {
                Theme.background.ignoresSafeArea()
                
                List {
                    ForEach(viewModel.messages) { message in
                        HStack {
                            Circle()
                                .fill(message.role == .user ? Theme.gold : Theme.success)
                                .frame(width: 8, height: 8)
                            
                            VStack(alignment: .leading, spacing: 4) {
                                Text(message.content)
                                    .font(Theme.bodyFont)
                                    .foregroundStyle(Theme.cream)
                                    .lineLimit(2)
                                
                                Text(viewModel.formatDate(message.timestamp))
                                    .font(Theme.captionFont)
                                    .foregroundStyle(Theme.creamMuted)
                            }
                        }
                        .padding(.vertical, 4)
                        .listRowBackground(Theme.surface)
                    }
                }
                .scrollContentBackground(.hidden)
                .background(Theme.background)
            }
            .navigationTitle("История")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Готово") { dismiss() }
                        .foregroundStyle(Theme.gold)
                }
            }
        }
        .preferredColorScheme(.dark)
    }
}
