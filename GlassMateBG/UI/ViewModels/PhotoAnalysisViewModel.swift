import Foundation
import UIKit

@MainActor
final class PhotoAnalysisViewModel: ObservableObject {
    enum AnalysisMode {
        case describe, ocr, translate
    }
    
    @Published var selectedImage: UIImage?
    @Published var resultText = ""
    @Published var mode: AnalysisMode = .describe
    @Published var isAnalyzing = false
    
    func analyze() {
        isAnalyzing = true
        resultText = "Анализирам..."
        
        // TODO: Integrate with Vision module
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) { [weak self] in
            guard let self = self else { return }
            switch self.mode {
            case .describe:
                self.resultText = "На снимката се вижда... (свържете Moonshot API ключ за реален анализ)"
            case .ocr:
                self.resultText = "Разпознат текст: ... (свържете Moonshot API ключ за OCR)"
            case .translate:
                self.resultText = "Превод: ... (свържете Moonshot API ключ за превод)"
            }
            self.isAnalyzing = false
        }
    }
    
    func selectLatestPhoto() async {
        // TODO: Fetch from PhotoKit
    }
}
