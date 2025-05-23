import SwiftSyntax

class OpacityModifierVisitor: SyntaxVisitor {
    
    private var warnings: [WarningMessage] = []
    private let filePath: String
    
    init(filePath: String) {
        self.filePath = filePath
        super.init(viewMode: .all)
    }
    
    override func visit(_ node: FunctionCallExprSyntax) -> SyntaxVisitorContinueKind {
        if let memberAccess = node.calledExpression.as(MemberAccessExprSyntax.self),
           memberAccess.declName.baseName.text == "opacity",
           let arguments = node.arguments.first?.expression.as(FloatLiteralExprSyntax.self),
           let opacityValue = Double(arguments.literal.text),
           opacityValue > 0.0 && opacityValue < 1.0 {
            
            let location = memberAccess.startLocation(converter: SourceLocationConverter(fileName: filePath, tree: memberAccess.root))
            let warningMessage = WarningMessage(filePath: filePath, line: location.line, column: location.column, message: "Found opacity usage, consider avoiding it (opacity_rule)")
            
            warnings.append(warningMessage)
        }
        
        return .visitChildren
    }
    
    func getViews() -> [WarningMessage] {
        return warnings
    }
}
