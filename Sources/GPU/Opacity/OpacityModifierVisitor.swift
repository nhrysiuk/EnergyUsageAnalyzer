import SwiftSyntax

class OpacityModifierVisitor: SyntaxVisitor {
    
    private var views: [String] = []
    
    override func visit(_ node: FunctionCallExprSyntax) -> SyntaxVisitorContinueKind {
        if let memberAccess = node.calledExpression.as(MemberAccessExprSyntax.self),
           memberAccess.declName.baseName.text == "opacity",
           let arguments = node.arguments.first?.expression.as(FloatLiteralExprSyntax.self),
           let opacityValue = Double(arguments.literal.text),
           opacityValue > 0.0 && opacityValue < 1.0 {
            
            views.append(node.description.trimmingCharacters(in: .whitespacesAndNewlines))
        }
        return .visitChildren
    }
    
    func getViews() -> [String] {
        return views
    }
}
