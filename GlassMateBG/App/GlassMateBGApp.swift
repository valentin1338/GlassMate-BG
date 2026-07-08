import SwiftUI

@main
struct GlassMateBGApp: App {
    @StateObject private var container = AppContainer()
    
    var body: some Scene {
        WindowGroup {
            MainView()
                .environmentObject(container)
                .preferredColorScheme(.dark)
        }
    }
}
