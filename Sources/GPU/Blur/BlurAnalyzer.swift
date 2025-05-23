import Foundation
import SwiftSyntax

class BlurAnalyzer: EnergyAnalyzer {
    
    let identifier = "blur_rule"
    
    func analyze(_ sourceFile: SourceFileSyntax, filePath: String) -> [WarningMessage] {
        let modifierVisitor = BlurModifierVisitor(filePath: filePath)
        modifierVisitor.walk(sourceFile)
        let propertyVisitor = BlurPropertyVisitor(filePath: filePath)
        propertyVisitor.walk(sourceFile)
        
        let modifierWarnings = modifierVisitor.getViews()
        let propertyWarnings = propertyVisitor.getViews()
        
        return modifierWarnings + propertyWarnings
    }
}
