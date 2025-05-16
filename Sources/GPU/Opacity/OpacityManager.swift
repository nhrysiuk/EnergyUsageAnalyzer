import Foundation
import SwiftSyntax

class OpacityManager: EnergyVisitable {
    
    private var views: [String] = []
    
    func analyze(_ sourceFile: SourceFileSyntax) {
        let modifierVisitor = OpacityModifierVisitor(viewMode: .sourceAccurate)
        modifierVisitor.walk(sourceFile)
        let propertyVisitor = AlphaPropertyVisitor(viewMode: .sourceAccurate)
        propertyVisitor.walk(sourceFile)
        
        if !modifierVisitor.getViews().isEmpty {
            print("Found SwiftUI opacity: ")
            views.forEach { print("\($0)") }
        }
        
        if !propertyVisitor.getViews().isEmpty {
            print("Found UIKit opacity: ")
            views.forEach { print("\($0)") }
        }
    }
    
    func getViews() -> [String] {
        views
    }
}
