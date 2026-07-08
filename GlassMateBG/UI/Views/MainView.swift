import SwiftUI

struct MainView: View {
    @EnvironmentObject private var container: AppContainer
    @StateObject private var viewModel = MainViewModel()
    @State private var showingSettings = false
    @State private var showingHistory = false
    @State private var showingChat = false
    
    var body: some View {
        ZStack {
            Theme.background.ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Header
                HStack {
                    Text("GlassMate")
                        .font(Theme.titleFont)
                        .foregroundStyle(Theme.gold)
                    Spacer()
                    Button(action: { showingHistory = true }) {
                        Image(systemName: "clock.arrow.circlepath")
                            .font(.title2)
                            .foregroundStyle(Theme.cream)
                    }
                    Button(action: { showingSettings = true }) {
                        Image(systemName: "gear")
                            .font(.title2)
                            .foregroundStyle(Theme.cream)
                    }
                }
                .padding(.horizontal)
                .padding(.top, 8)
                
                Spacer()
                
                // Main Pulsing Button
                PulsingButton(
                    isActive: viewModel.isListening,
                    action: { viewModel.toggleListening() }
                )
                .frame(height: 200)
                
                // Status text
                Text(viewModel.statusText)
                    .font(Theme.captionFont)
                    .foregroundStyle(Theme.creamMuted)
                    .padding(.top, 16)
                
                // Live transcript
                if !viewModel.transcript.isEmpty {
                    ScrollView {
                        Text(viewModel.transcript)
                            .font(Theme.bodyFont)
                            .foregroundStyle(Theme.cream)
                            .multilineTextAlignment(.center)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Theme.surface)
                            .cornerRadius(Theme.cornerRadius)
                            .padding(.horizontal)
                    }
                    .frame(maxHeight: 150)
                    .transition(.move(edge: .bottom).combined(with: .opacity))
                }
                
                // Waveform animation when listening
                if viewModel.isListening {
                    WaveformView(isAnimating: .constant(true))
                        .frame(height: 40)
                        .padding(.horizontal, 40)
                        .transition(.opacity)
                }
                
                Spacer()
                
                // Quick actions
                HStack(spacing: 20) {
                    QuickActionButton(icon: "photo", label: "Снимка") {
                        viewModel.analyzeLastPhoto()
                    }
                    QuickActionButton(icon: "doc.text", label: "Бележка") {
                        viewModel.addQuickNote()
                    }
                    QuickActionButton(icon: "sun.max", label: "Деня") {
                        viewModel.summarizeDay()
                    }
                }
                .padding(.horizontal)
                .padding(.bottom, 32)
            }
        }
        .sheet(isPresented: $showingSettings) {
            SettingsView()
        }
        .sheet(isPresented: $showingHistory) {
            HistoryView()
        }
        .sheet(isPresented: $showingChat) {
            ChatView()
        }
    }
}
