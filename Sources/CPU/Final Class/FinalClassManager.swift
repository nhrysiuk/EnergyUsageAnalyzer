import SwiftSyntax

class FinalClassManager: EnergyVisitable {
    
    func analyze(_ sourceFile: SourceFileSyntax, filePath: String) -> [WarningMessage] {
        let visitor = FinalClassVisitor(filePath: filePath)
        visitor.walk(sourceFile)
        
        return visitor.getViews()
    }
}
