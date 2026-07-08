import SwiftUI

struct WaveformView: View {
    @Binding var isAnimating: Bool
    var color: Color = Theme.gold
    
    @State private var phase: CGFloat = 0
    @State private var timer: Timer? = nil
    
    var body: some View {
        Canvas { context, size in
            let barCount = 20
            let barWidth = size.width / CGFloat(barCount * 2)
            let maxBarHeight = size.height * 0.8
            
            for i in 0..<barCount {
                let x = CGFloat(i * 2 + 1) * barWidth
                let normalizedIndex = CGFloat(i) / CGFloat(barCount)
                let wave = sin(normalizedIndex * .pi * 4 + phase)
                let barHeight = maxBarHeight * (0.2 + 0.8 * abs(wave))
                let y = (size.height - barHeight) / 2
                
                let rect = CGRect(x: x - barWidth / 2, y: y, width: barWidth, height: barHeight)
                let path = RoundedRectangle(cornerRadius: barWidth / 2).path(in: rect)
                context.fill(path, with: .color(color.opacity(0.5 + 0.5 * abs(wave))))
            }
        }
        .onAppear {
            if isAnimating { startAnimation() }
        }
        .onChange(of: isAnimating) { animating in
            if animating { startAnimation() } else { stopAnimation() }
        }
        .onDisappear { stopAnimation() }
    }
    
    private func startAnimation() {
        timer = Timer.scheduledTimer(withTimeInterval: 0.05, repeats: true) { _ in
            phase += .pi / 8
        }
    }
    
    private func stopAnimation() {
        timer?.invalidate()
        timer = nil
    }
}
