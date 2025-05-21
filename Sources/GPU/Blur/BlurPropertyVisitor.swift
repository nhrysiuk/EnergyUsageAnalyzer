import SwiftSyntax

class BlurPropertyVisitor: SyntaxVisitor {
    
    private var blurEffects: [String] = []
    private var blurViews: [String] = []
    private var warnings: [WarningMessage] = []
    private let filePath: String
    
    init(filePath: String) {
        self.filePath = filePath
        super.init(viewMode: .all)
    }
    
    override func visit(_ node: VariableDeclSyntax) -> SyntaxVisitorContinueKind {
        if let initializer = node.bindings.first?.initializer?.value.as(FunctionCallExprSyntax.self),
           let type = initializer.calledExpression.as(DeclReferenceExprSyntax.self),
           type.baseName.text == "UIBlurEffect" {
            if let binding = node.bindings.first?.pattern.as(IdentifierPatternSyntax.self) {
                blurEffects.append(binding.identifier.text.trimmingCharacters(in: .whitespacesAndNewlines))
            }
        }
        
        if let initializer = node.bindings.first?.initializer?.value.as(FunctionCallExprSyntax.self),
           let type = initializer.calledExpression.as(DeclReferenceExprSyntax.self),
           type.baseName.text == "UIVisualEffectView",
           let binding = node.bindings.first?.pattern.as(IdentifierPatternSyntax.self),
           let argument = initializer.arguments.first,
           blurEffects.contains(argument.expression.description) {
            blurViews.append(binding.identifier.text.trimmingCharacters(in: .whitespacesAndNewlines))
        }
        return .visitChildren
    }
    
    override func visit(_ node: FunctionCallExprSyntax) -> SyntaxVisitorContinueKind {
        if let memberAccess = node.calledExpression.as(MemberAccessExprSyntax.self),
           memberAccess.declName.baseName.text == "addSubview",
           let argument = node.arguments.first?.expression.as(DeclReferenceExprSyntax.self),
           blurViews.contains(argument.baseName.text) {
            let location = node.startLocation(converter: SourceLocationConverter(fileName: filePath, tree: node.root))
            let warningMessage = WarningMessage(filePath: filePath, line: location.line, column: location.column, message: "Found blur, consider avoiding it")
            
            warnings.append(warningMessage)
        }
        return .visitChildren
    }
    
    func getViews() -> [WarningMessage] {
        warnings
    }
}
