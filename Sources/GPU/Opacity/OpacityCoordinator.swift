import Foundation
import SwiftSyntax

class OpacityCoordinator: EnergyCoordinator {
    
    let identifier = "opacity_rule"
    
    func analyze(_ sourceFile: SourceFileSyntax, filePath: String) -> [WarningMessage] {
        let modifierVisitor = OpacityModifierVisitor(filePath: filePath)
        modifierVisitor.walk(sourceFile)
        let propertyVisitor = AlphaPropertyVisitor(filePath: filePath)
        propertyVisitor.walk(sourceFile)
        
        let modifierWarnings = modifierVisitor.getViews()
        let propertyWarnings = propertyVisitor.getViews()
        
        return modifierWarnings + propertyWarnings
    }
}
