import Foundation
import SwiftSyntax

class ShadowManager: EnergyVisitable {
    
    private var views: [String] = []
    
    func analyze(_ sourceFile: SourceFileSyntax) {
        let modifierVisitor = ShadowModifierVisitor(viewMode: .sourceAccurate)
        modifierVisitor.walk(sourceFile)
        let propertyVisitor = ShadowPropertyVisitor(viewMode: .sourceAccurate)
        propertyVisitor.walk(sourceFile)
        
        if !modifierVisitor.getViews().isEmpty {
            print("Found SwiftUI shadow: ")
            views.forEach { print("\($0)") }
        }
        
        if !propertyVisitor.getViews().isEmpty {
            print("Found UIKit shadow: ")
            views.forEach { print("\($0)") }
        }
    }
    
    func getViews() -> [String] {
        views
    }
}
