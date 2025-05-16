import Foundation
import SwiftSyntax

class BlurManager: EnergyVisitable {
    
    private var views: [String] = []
    
    func analyze(_ sourceFile: SourceFileSyntax) {
        let modifierVisitor = BlurModifierVisitor(viewMode: .sourceAccurate)
        modifierVisitor.walk(sourceFile)
        let propertyVisitor = BlurPropertyVisitor(viewMode: .sourceAccurate)
        propertyVisitor.walk(sourceFile)
        
        if !modifierVisitor.getViews().isEmpty {
            print("Found SwiftUI blur: ")
            views.forEach { print("\($0)") }
        }
        
        if !propertyVisitor.getViews().isEmpty {
            print("Found UIKit blur: ")
            views.forEach { print("\($0)") }
        }
    }
    
    func getViews() -> [String] {
        views
    }
}
