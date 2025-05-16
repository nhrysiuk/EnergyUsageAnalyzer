import Foundation
import SwiftSyntax

class OpacityManager: EnergyVisitable {
    
    func analyze(_ sourceFile: SourceFileSyntax) {
        let modifierVisitor = OpacityModifierVisitor(viewMode: .sourceAccurate)
        modifierVisitor.walk(sourceFile)
        let propertyVisitor = AlphaPropertyVisitor(viewMode: .sourceAccurate)
        propertyVisitor.walk(sourceFile)
        
        if !modifierVisitor.getViews().isEmpty {
            print("\nFound SwiftUI opacity: ")
            modifierVisitor.getViews().forEach { print("\($0)") }
        }
        
        if !propertyVisitor.getViews().isEmpty {
            print("\nFound UIKit opacity: ")
            propertyVisitor.getViews().forEach { print("\($0)") }
        }
    }
}
