import Foundation
import SwiftSyntax

class InlineMethodCoordinator: EnergyCoordinator {
    
    let identifier = "inline_method_rule"
    
    func analyze(_ sourceFile: SourceFileSyntax, filePath: String) -> [WarningMessage] {
        let callVisitor = InlineMethodCallVisitor(filePath: filePath)
        callVisitor.walk(sourceFile)
        
        let definitionVisitor = InlineMethodDefinitionVisitor(viewMode: .sourceAccurate)
        definitionVisitor.walk(sourceFile)
        
        let callNames = callVisitor.getViews()
        let defNames = definitionVisitor.getNames()
        
        return callNames.filter { defNames.contains($0.0) }.map { $0.2 }
    }
}

