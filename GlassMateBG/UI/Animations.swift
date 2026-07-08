import SwiftUI

extension Animation {
    static let pulse = Animation.easeInOut(duration: 1.2).repeatForever(autoreverses: true)
    static let springy = Animation.spring(response: 0.4, dampingFraction: 0.6)
    static let smooth = Animation.easeInOut(duration: 0.3)
    static let bouncy = Animation.spring(response: 0.5, dampingFraction: 0.5)
}

struct PulsingScale: ViewModifier {
    let active: Bool
    @State private var isPulsing = false
    
    func body(content: Content) -> some View {
        content
            .scaleEffect(isPulsing && active ? 1.08 : 1.0)
            .opacity(isPulsing && active ? 0.85 : 1.0)
            .animation(active ? Animation.easeInOut(duration: 1.2).repeatForever(autoreverses: true) : .default, value: isPulsing)
            .onAppear { isPulsing = active }
            .onChange(of: active) { isPulsing = $0 }
    }
}

struct FadeIn: ViewModifier {
    let delay: Double
    @State private var isVisible = false
    
    func body(content: Content) -> some View {
        content
            .opacity(isVisible ? 1 : 0)
            .offset(y: isVisible ? 0 : 10)
            .animation(.smooth.delay(delay), value: isVisible)
            .onAppear { isVisible = true }
    }
}

extension View {
    func pulsing(active: Bool) -> some View {
        modifier(PulsingScale(active: active))
    }
    
    func fadeIn(delay: Double = 0) -> some View {
        modifier(FadeIn(delay: delay))
    }
}
