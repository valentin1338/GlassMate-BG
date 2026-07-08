import Foundation
import Combine

@MainActor
final class MainViewModel: ObservableObject {
    @Published var isListening = false
    @Published var transcript = ""
    @Published var statusText = "Докоснете рамката на очилата или бутона"
    @Published var isAnalyzing = false
    
    func toggleListening() {
        isListening.toggle()
        statusText = isListening ? "Слушам..." : "Докоснете рамката на очилата"
        if !isListening { transcript = "" }
    }
    
    func updateTranscript(_ text: String) {
        transcript = text
    }
    
    func analyzeLastPhoto() {
        statusText = "Анализ на последната снимка..."
        isAnalyzing = true
        // Actual implementation would call Vision module
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) { [weak self] in
            self?.isAnalyzing = false
            self?.statusText = "Докоснете рамката на очилата или бутона"
        }
    }
    
    func addQuickNote() {
        statusText = "Добавяне на бележка..."
    }
    
    func summarizeDay() {
        statusText = "Обобщавам деня..."
    }
}
