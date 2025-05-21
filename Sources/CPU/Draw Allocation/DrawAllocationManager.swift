import SwiftSyntax

class DrawAllocationManager: EnergyVisitable {
    
    func analyze(_ sourceFile: SourceFileSyntax, filePath: String) -> [WarningMessage] {
        let visitor = DrawAllocationVisitor(filePath: filePath)
        visitor.walk(sourceFile)
        
        return visitor.getViews()
    }
}
