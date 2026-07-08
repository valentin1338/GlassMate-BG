import Foundation
import SwiftUI

enum AppRoute: Hashable {
    case main
    case chat
    case settings
    case history
    case photoAnalysis
}

@MainActor
final class AppCoordinator: ObservableObject {
    @Published var path = NavigationPath()
    @Published var presentedSheet: AppRoute?
    
    func navigate(to route: AppRoute) {
        path.append(route)
    }
    
    func present(_ route: AppRoute) {
        presentedSheet = route
    }
    
    func dismissSheet() {
        presentedSheet = nil
    }
    
    func pop() {
        guard !path.isEmpty else { return }
        path.removeLast()
    }
    
    func popToRoot() {
        path.removeLast(path.count)
    }
}
