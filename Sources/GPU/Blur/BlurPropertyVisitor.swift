import SwiftSyntax

class BlurPropertyVisitor: SyntaxVisitor {
    
    private var blurEffects: [String] = []
    private var blurViews: [String] = []
    private var addSubviewCalls: [String] = []
    
    override func visit(_ node: VariableDeclSyntax) -> SyntaxVisitorContinueKind {
        if let initializer = node.bindings.first?.initializer?.value.as(FunctionCallExprSyntax.self),
           let type = initializer.calledExpression.as(DeclReferenceExprSyntax.self),
           type.baseName.text == "UIBlurEffect" {
            if let binding = node.bindings.first?.pattern.as(IdentifierPatternSyntax.self) {
                blurEffects.append(binding.identifier.text)
            }
        }
        
        if let initializer = node.bindings.first?.initializer?.value.as(FunctionCallExprSyntax.self),
           let type = initializer.calledExpression.as(DeclReferenceExprSyntax.self),
           type.baseName.text == "UIVisualEffectView",
           let binding = node.bindings.first?.pattern.as(IdentifierPatternSyntax.self),
           let argument = initializer.arguments.first,
           blurEffects.contains(argument.expression.description) {
            blurViews.append(binding.identifier.text)
        }
        return .visitChildren
    }
    
    override func visit(_ node: FunctionCallExprSyntax) -> SyntaxVisitorContinueKind {
        if let memberAccess = node.calledExpression.as(MemberAccessExprSyntax.self),
           memberAccess.declName.baseName.text == "addSubview",
           let argument = node.arguments.first?.expression.as(DeclReferenceExprSyntax.self),
           blurViews.contains(argument.baseName.text) {
            addSubviewCalls.append(node.description)
        }
        return .visitChildren
    }
    
    func getBlurEffects() -> [String] {
        return blurEffects
    }
    
    func getBlurViews() -> [String] {
        return blurViews
    }
    
    func getViews() -> [String] {
        return addSubviewCalls
    }
}
