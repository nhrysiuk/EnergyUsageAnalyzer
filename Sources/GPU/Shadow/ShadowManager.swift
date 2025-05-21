import Foundation
import SwiftSyntax

class ShadowManager: EnergyVisitable {
    
    private var views: [String] = []
    
    func analyze(_ sourceFile: SourceFileSyntax, filePath: String) -> [WarningMessage] {
        let modifierVisitor = ShadowModifierVisitor(filePath: filePath)
        modifierVisitor.walk(sourceFile)
        let propertyVisitor = ShadowPropertyVisitor(filePath: filePath)
        propertyVisitor.walk(sourceFile)
        
        let modifierWarnings = modifierVisitor.getViews()
        let propertyWarnings = propertyVisitor.getViews()
        
        return modifierWarnings + propertyWarnings
    }
}
