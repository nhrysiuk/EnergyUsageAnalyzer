import SwiftSyntax

class ParameterObjectRule: EnergyRule {
    
    let identifier = "parameter_rule"
    
    func analyze(_ sourceFile: SourceFileSyntax, filePath: String) -> [WarningMessage] {
        let visitor = ParameterObjectVisitor(filePath: filePath)
        visitor.walk(sourceFile)
        
        return visitor.getViews()
    }
}
