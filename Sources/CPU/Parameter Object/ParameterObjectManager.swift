import SwiftSyntax

class ParameterObjectManager: EnergyVisitable {
    
    func analyze(_ sourceFile: SourceFileSyntax, filePath: String) -> [WarningMessage] {
        let visitor = ParameterObjectVisitor(filePath: filePath)
        visitor.walk(sourceFile)
        
        return visitor.getViews()
    }
}
