import SwiftUI

struct PulsingButton: View {
    let isActive: Bool
    let action: () -> Void
    
    @State private var pulseScale: CGFloat = 1.0
    @State private var pulseOpacity: Double = 1.0
    @State private var ringScale: CGFloat = 1.0
    @State private var ringOpacity: Double = 0.6
    
    var body: some View {
        Button(action: action) {
            ZStack {
                // Outer pulse rings when active
                if isActive {
                    Circle()
                        .stroke(Theme.gold.opacity(0.25), lineWidth: 2)
                        .scaleEffect(ringScale)
                        .opacity(ringOpacity)
                    
                    Circle()
                        .stroke(Theme.gold.opacity(0.15), lineWidth: 1)
                        .scaleEffect(ringScale * 0.8)
                        .opacity(ringOpacity * 0.7)
                }
                
                // Main button circle
                Circle()
                    .fill(
                        RadialGradient(
                            gradient: Gradient(colors: [
                                isActive ? Theme.goldLight : Theme.gold,
                                isActive ? Theme.gold : Theme.goldDim
                            ]),
                            center: .center,
                            startRadius: 10,
                            endRadius: 55
                        )
                    )
                    .frame(width: Theme.buttonSize, height: Theme.buttonSize)
                    .shadow(
                        color: Theme.gold.opacity(isActive ? 0.6 : 0.35),
                        radius: isActive ? 30 : 18,
                        x: 0, y: 0
                    )
                    .scaleEffect(pulseScale)
                
                // Icon
                Image(systemName: isActive ? "waveform" : "mic.fill")
                    .font(.system(size: 32, weight: .medium))
                    .foregroundStyle(Theme.background)
                    .scaleEffect(pulseScale)
            }
        }
        .buttonStyle(.plain)
        .onAppear { updateAnimation() }
        .onChange(of: isActive) { _ in updateAnimation() }
    }
    
    private func updateAnimation() {
        if isActive {
            withAnimation(.easeInOut(duration: 1.2).repeatForever(autoreverses: true)) {
                pulseScale = 1.06
                pulseOpacity = 0.9
            }
            withAnimation(.easeInOut(duration: 1.5).repeatForever(autoreverses: false)) {
                ringScale = 1.5
                ringOpacity = 0.0
            }
        } else {
            pulseScale = 1.0
            pulseOpacity = 1.0
            ringScale = 1.0
            ringOpacity = 0.6
        }
    }
}
