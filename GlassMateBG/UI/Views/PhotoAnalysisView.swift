import SwiftUI

struct PhotoAnalysisView: View {
    @StateObject private var viewModel = PhotoAnalysisViewModel()
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            ZStack {
                Theme.background.ignoresSafeArea()
                
                VStack(spacing: 16) {
                    if let image = viewModel.selectedImage {
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFit()
                            .cornerRadius(Theme.cornerRadius)
                            .padding(.horizontal)
                    }
                    
                    // Mode selector
                    HStack(spacing: 12) {
                        AnalysisModeButton(title: "Опиши", icon: "eye.fill", isSelected: viewModel.mode == .describe) {
                            viewModel.mode = .describe
                        }
                        AnalysisModeButton(title: "Прочети текст", icon: "text.viewfinder", isSelected: viewModel.mode == .ocr) {
                            viewModel.mode = .ocr
                        }
                        AnalysisModeButton(title: "Преведи", icon: "character.book.closed.fill", isSelected: viewModel.mode == .translate) {
                            viewModel.mode = .translate
                        }
                    }
                    .padding(.horizontal)
                    
                    // Result
                    if !viewModel.resultText.isEmpty {
                        GlassCard {
                            VStack(alignment: .leading, spacing: 8) {
                                Text(viewModel.resultText)
                                    .font(Theme.bodyFont)
                                    .foregroundStyle(Theme.cream)
                            }
                        }
                        .padding(.horizontal)
                    }
                    
                    Spacer()
                    
                    Button("Анализирай") {
                        viewModel.analyze()
                    }
                    .buttonStyle(GoldButtonStyle())
                    .padding(.horizontal)
                    .padding(.bottom, 32)
                }
            }
            .navigationTitle("Анализ на снимка")
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

struct AnalysisModeButton: View {
    let title: String
    let icon: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 6) {
                Image(systemName: icon)
                    .font(.system(size: 22))
                Text(title)
                    .font(Theme.captionFont)
            }
            .foregroundStyle(isSelected ? Theme.background : Theme.cream)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 12)
            .background(isSelected ? Theme.gold : Theme.surface)
            .cornerRadius(12)
        }
        .buttonStyle(.plain)
    }
}

struct GoldButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(Theme.headlineFont)
            .foregroundStyle(Theme.background)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 16)
            .background(Theme.gold)
            .cornerRadius(Theme.cornerRadius)
            .scaleEffect(configuration.isPressed ? 0.96 : 1.0)
            .animation(.springy, value: configuration.isPressed)
    }
}
